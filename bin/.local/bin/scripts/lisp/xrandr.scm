(use gauche.process)
(use srfi-1) ;; string splitting

(define (xrandr-connected-outputs)
  (let* ((lines (process-output->string-list '("xrandr" "--query") :error :exit-code))
         (outputs
          (filter-map
           (lambda (line)
             (let ((words (string-split line #\space)))
               (and (>= (length words) 2)
                    (string=? (list-ref words 1) "connected")
                    (list-ref words 0))))
           lines)))
    outputs))
