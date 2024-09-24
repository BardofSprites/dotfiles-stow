(require 'asdf)

(asdf:load-system :uiop)

(defun start-study (time)
  (let ((command (format nil "sowon ~am -e" time)))
    (uiop:run-program command)))

(defun start-break (break-time)
  (let ((command (format nil "sowon ~am -e" break-time)))
    (uiop:run-program command)))

(defun work-loop (session-count study-time break-time)
  (let ((notify-start "notify-send 'Starting work session'")
        (notify-session
          (lambda (session-number)
            (uiop:run-program (format nil "notify-send 'Work session over [~a/~a]. Breaktime, get some tea and stretch'"
                                      session-number session-count)))))
    (loop for i from 1 to session-count do
      (uiop:run-program notify-start)
      (start-study study-time)
      (unless (= i session-count)
        (funcall notify-session i)
        (start-break break-time)
        ))
    (uiop:run-program "notify-send 'WORK TIME IS OVER!!!!'")))

(defun main ()
  (let* ((args (uiop:command-line-arguments))
         (study-time (nth 0 args))
         (break-time (nth 1 args))
         (session-count (parse-integer (nth 2 args))))
    (work-loop session-count study-time break-time)))

(sb-ext:save-lisp-and-die "study"
                          :executable t
                          :toplevel #'main)
