(defun bard/disable-all-themes ()
  "Disable all active themes."
  (dolist (i custom-enabled-themes)
    (disable-theme i)))

(bard/disable-all-themes)

(setq selected-emacs-theme (car command-line-args-left))

(load-theme (intern selected-emacs-theme) t)
