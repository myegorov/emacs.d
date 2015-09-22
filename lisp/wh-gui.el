;; Keybindings.
(global-set-key (kbd "s-=") 'text-scale-increase)
(global-set-key (kbd "s--") 'text-scale-decrease)
(global-set-key (kbd "s-n") 'make-frame)

;; Font size in 1/10pt (140 = 14 pt).
(set-face-attribute 'default nil :height 140)

;; Default font.
(set-default-font "Hack")

;; Fringe.
(setq-default left-fringe-width 16)

;; Left Option is Meta, right Option doesn't do anything in Emacs (so it can be
;; used for accented letters and such).
(when (eq system-type 'darwin)
  (setq mac-option-key-is-meta t
        mac-right-option-modifier nil))

(provide 'wh-gui)