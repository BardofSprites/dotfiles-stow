(in-package :stumpwm)

;;;; Groups
(grename "home")
(gnew "alt")

;;;; Window Format
(setf *window-format* "%s%n%30t"
      *window-border-style* :tight
      *normal-border-width* 5
      *maxsize-border-width* 5
      )

;;;; Gaps
(load-module "swm-gaps")
(setq swm-gaps:*gaps-on* t)

;;; Focus
(load-module "beckon")
(defmacro with-focus-lost (&body body)
  "Make sure WIN is on the top level while the body is running and
restore it's always-on-top state afterwords"
  `(progn (banish)
          ,@body
          (when (current-window)
            (beckon:beckon))))
;;; Splits
(defcommand hsplit-and-focus () ()
  "create a new frame on the right and focus it."
  (with-focus-lost
      (hsplit)
    (move-focus :right)))

(defcommand vsplit-and-focus () ()
  "create a new frame below and focus it."
  (with-focus-lost
      (vsplit)
    (move-focus :down)))
