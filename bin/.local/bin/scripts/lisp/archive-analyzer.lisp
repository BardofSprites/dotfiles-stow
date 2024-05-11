(defvar *todo-archive-file* "~/Notes/denote/archive.org")

(defun parse-todo-states (lines)
  "Parse the list of lines and count the occurrences of DONE and KILLED states."
  (let ((done-count 0)
        (killed-count 0))
    (loop for line in lines
          do
          (when (search " DONE " line)
            (incf done-count))
          (when (search " KILLED " line)
            (incf killed-count)))
    (let* ((total (+ done-count killed-count))
           (done-percent (format nil "~,1f" (* 100 (/ done-count (float total)))))
           (killed-percent (format nil "~,1f" (* 100 (/ killed-count (float total))))))
      (list :done (list done-count (concatenate 'string done-percent "%"))
            :killed (list killed-count (concatenate 'string killed-percent "%"))))))

(defun return-count ()
  "Reads the file and returns counts of DONE and KILLED states along with percentages."
  (let ((lines (uiop:read-file-lines *todo-archive-file*)))
    (parse-todo-states lines)))

(defun print-count ()
  "Helper function for printing out the results of RETURN-COUNT"
  (format nil "Stuff here: ~{~A~^, ~}" (return-count)))

(print-count)
