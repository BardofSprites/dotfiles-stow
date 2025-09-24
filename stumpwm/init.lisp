(in-package :stumpwm)

;;;; Modules

;;;; REPL
(ql:quickload :slynk)

;; do prefix ; (keybind), type slynk, enter port num, sly-connect with
;; correct port num
(defcommand slynk (port) ((:string "Port number: "))
  (sb-thread:make-thread
   (lambda ()
     (slynk:create-server :port (parse-integer port) :dont-close t))
   :name "slynk-manual"))

(setq *mouse-focus-policy* :sloppy
      *float-window-modifier* :super)

(load "~/.stumpwm.d/keybinds.lisp")
(load "~/.stumpwm.d/window.lisp")
(load "~/.stumpwm.d/style.lisp")
(load "~/.stumpwm.d/modeline.lisp")
