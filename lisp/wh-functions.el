;; Non interactive functions.

(defun wh/under-tmux-p ()
  "Returns non-nil if the current Emacs instance is running under tmux."
  (and (not (display-graphic-p)) (getenv "TMUX")))

(defun wh/toggle-tmux-status-bar (hide?)
  "Hides the tmux status bar if `HIDE?' is non-nil, otherwise shows it."
  (if (wh/under-tmux-p)
      (shell-command (if hide? "tmux set status off" "tmux set status on"))
    (message "Emacs is not running under tmux")))

(defun wh/magit-status-buffer-switch-function (buf)
  "Open the the Magit status in another frame if there's one.

If there's only one frame, then use the function that magit uses by default."
  (if (= 1 (length (frame-list)))
      (funcall (eval (car (get 'magit-status-buffer-switch-function 'standard-value))) buf)
    (select-frame-set-input-focus (next-frame))
    (switch-to-buffer buf)))

(defun wh/load-theme (&rest args)
  "Load a random theme from a list of themes if under a GUI, otherwise load
  a nice term theme."
  (if (display-graphic-p)
      (let* ((gui-themes (plist-get args :gui-themes))
             (random-index (random (length gui-themes)))
             (random-theme (nth random-index gui-themes)))
        (load-theme random-theme t))
    (load-theme (plist-get args :term-theme) t)))


;; Interactive functions.

(defun wh/edit-init-file ()
  "Edit the init file, usually ~/.emacs.d/init.el."
  (interactive)
  (find-file (or user-init-file "")))

(defun wh/edit-notes-file ()
  "Edit the 'Notes' file in Dropbox."
  (interactive)
  (let ((file (expand-file-name "~/Dropbox/Notes/h.md")))
    (if (file-exists-p file)
        (find-file file)
      (message "File %s not found" file))))

(defun wh/newline-and-indent-like-previous-line ()
  "Create a newline and indent at the same level of the previous line."
  (interactive)
  (newline)
  (indent-relative-maybe))

(defun wh/split-window-and-focus-new ()
  "Splits the window horizontally  and focus the new one."
  (interactive)
  (split-window-horizontally)
  (other-window 1))

(defun wh/eval-surrounding-sexp ()
  "Eval the sexp which surrounds the current point."
  (interactive)
  (save-excursion
    (up-list)
    (eval-last-sexp nil)))

(defun wh/create-bash-script (name)
  "Create a bash script in ~/bin.

The script will be called `NAME'. A bash shebang will be inserted on the first
line and the script will be made executable for the user."
  (interactive "sName: ")
  (let ((path (concat "~/bin/" name)))
    (find-file path)
    (insert "#!/bin/bash\n\n\n")
    (end-of-buffer)
    (save-buffer)
    (shell-script-mode)
    (shell-command (format "chmod u+x %s" path))))

(defun wh/projectile-open-todo ()
  "Open TODO.md in the root of the (projectile) project if such file exists."
  (interactive)
  (let ((file (concat (projectile-project-root) "TODO.md")))
    (if (file-exists-p file)
        (find-file file)
      (when (y-or-n-p "TODO.md does not exist. Create one?")
        (find-file file)))))

(defun wh/package-uninstall (pkg)
  "Uninstall `PKG'. Interactively, it prompts for the package name."
  (interactive
   (list (completing-read "Package to uninstall: " (mapcar #'car package-alist))))
  (let* ((pkg (intern pkg))
         (pkg-desc (car (last (assoc pkg package-alist)))))
    (package-delete pkg-desc)))

(defun wh/alchemist-new-exs-buffer ()
  "Create a scratch buffer in Elixir mode."
  (interactive)
  (switch-to-buffer "*elixir scratch*")
  (elixir-mode)
  (alchemist-mode))

(provide 'wh-functions)
