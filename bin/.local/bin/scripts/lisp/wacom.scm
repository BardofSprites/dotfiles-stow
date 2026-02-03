#!/usr/bin/env gosh

(use gauche.process)
(use srfi-1)

(load "~/.local/bin/scripts/lisp/dmenu.scm")

(define (find-id)
  (let ((out (process-output->string '(xsetwacom --list devices))))
    (let loop ((lines (string-split out #\newline)))
      (cond
        ((null? lines) #f)
        ((rxmatch #/^Wacom.*STYLUS.*id:\s*(\d+)/i (car lines))
         => (lambda (m) (rxmatch-substring m 1)))
        (else (loop (cdr lines)))))))

(define (monitor-prompt)
  (prompt-dispatch
   `(("Main"    . "1920x1080+0+0")
     ("Side"    . "1920x1080+1920+0")
     ("Desktop" . "desktop"))
   "Monitor range: "))

(define (set-range)
  (let* ((range (monitor-prompt))
         (id (find-id)))
    (run-process (list "xsetwacom" "set" id "MapToOutput" range))))

(set-range)
