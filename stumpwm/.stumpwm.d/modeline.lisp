(in-package :stumpwm)

;; mode line on all heads
(dolist (h (screen-heads (current-screen)))
  (enable-mode-line (current-screen) h t))
