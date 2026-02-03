(define (dmenu-prompt options :optional (prompt "Prompt:"))
  (let* ((dmenu-cmd '("dmenu" "-p"))
         (full-cmd (append dmenu-cmd (list prompt)))
         (process (run-process full-cmd
                               :input :pipe   ; Pipe stdin to dmenu
                               :output :pipe  ; Capture dmenu's stdout
                               :error :inherit
                               :wait #f))
         (input-port (process-input process))
         (output-port (process-output process)))

    ;; Write the options to dmenu's stdin
    (for-each (lambda (item) (format input-port "~a~%" item)) options)
    (close-output-port input-port)

    ;; Read the selected line
    (let ((selection (read-line output-port)))
      (process-wait process)
      (close-input-port output-port)

      (if (eof-object? selection)
          #f
          selection))))

(define (prompt-dispatch options :optional (title "Select:"))
  ;; Options must be in quasi quoted list
  ;; Example:
  ;; (prompt-dispatch
  ;;  `(("action1" . "return string")
  ;;    ("action2" . ,(exectute-function "arguments"))
  ;;    ("action3" . (run-a-command "with arguments"))))
  (let* ((labels (map car options))
         (choice (dmenu-prompt labels title))
         (entry  (assoc choice options)))
    (and entry
         (let ((action (cdr entry)))
           (cond
             ((procedure? action) ;; eval if function ,(function args)
              (action))
             ((list? action) ;; regular list becomes process (command "args")
              (run-process action))
             ((string? action) ;; return string
              action)
             (else action))))))
