(in-package :stumpwm)

(defparameter *reload-mode-line-p* nil)

(defparameter *menu-prompt* "Select theme:")

(defvar *themes* (make-hash-table :test 'equal))

(defmacro define-theme (name &body body)
  `(setf (gethash ,name *themes*) #'(lambda () ,@body)))

(defun select-from-themes-menu ()
  (when-let* ((items (hash-table-keys *themes*))
              (item (select-from-menu (current-screen) items *menu-prompt*)))
    (gethash (car item) *themes*)))

(defun reloads ()
  (update-color-map (current-screen))
  (when *reload-mode-line-p*
    (mode-line)
    (mode-line)))

(defun themes-menu ()
  (when-let (theme (select-from-themes-menu))
    (funcall theme)
    (reloads)))

(define-theme "Ef Autumn"
  (set-fg-color "#cfbcba")
  (set-bg-color "#0f0e06")
  (set-focus-color "#692a12")
  (set-unfocus-color "#36322f")
  (setf *mode-line-background-color* "#0f0e06"
        *mode-line-foreground-color* "#cfbcba")
  )

(define-theme "Ef Bio"

  (set-fg-color "#cfdfd5")
  (set-bg-color "#111111")
  (set-focus-color "#00552f")
  (set-unfocus-color "#2a3644")
  (setf *mode-line-background-color* "#111111"
        *mode-line-foreground-color* "#cfdfd5")
  )

(define-theme "Gruber Darker"

  (set-fg-color "#e4e4e4")
  (set-bg-color "#181818")
  (set-focus-color "#cc8c3c")
  (set-unfocus-color "#282828")
  (setf *mode-line-background-color* "#181818"
        *mode-line-foreground-color* "#e4e4e4")
  )

(define-theme "Gruvbox"

  (set-fg-color "#ebdbb2")
  (set-bg-color "#1d2021")
  (set-focus-color "#b8bb26")
  (set-unfocus-color "#83a598")
  (setf *mode-line-background-color* "#1d2021"
        *mode-line-foreground-color* "#ebdbb2")
  )

(defcommand theme () () (themes-menu))

(setq *startup-message* (format nil "^bWelcome Home!!!"))

(setf *message-window-padding* 4
      *message-window-y-padding* 4
      *message-window-gravity* :center)

(setf *input-window-gravity* :center)

;;;; Fonts
(ql:quickload "clx-truetype")
(pushnew (concat (getenv "HOME")
                 "/.local/share/fonts/")
         xft:*font-dirs* :test #'string=)
(xft:cache-fonts)

(let ((parent-font "Iosevka Comfy"))
  (when (find parent-font (the list (clx-truetype:get-font-families))
              :test #'string=)
    (load-module "ttf-fonts")
    (set-font `(,(make-instance 'xft:font
                                :family "Iosevka Comfy"
                                :subfamily "Regular"
                                :size 12
                                :antialias t)))
    (mode-line)))
