(ql:quickload "cl-ppcre")

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

(defun parse-recent-done-items (lines)
  "Parse the list of lines and return the three most recent DONE items without ** and tags."
  (let ((done-items '())
        (count 0))
    (dolist (line (reverse lines))
      (when (and (search "DONE" line) (<= count 2))
        (push (subseq line 5) done-items) ; Remove the first 5 characters to remove "** DONE "
        (incf count)
        (when (= count 3)
          (return done-items))))))

(defun remove-whitespace-around-tags (items)
  "Remove whitespace around tags in each item."
  (loop for item in items
        collect (replace-regexp-in-string "\\s-*:\\(.*?\\):" ":\\1:" item)))

(defun return-recent-done-items ()
  "Reads the file and returns the three most recent DONE items without ** and tags."
  (let ((lines (uiop:read-file-lines *todo-archive-file*)))
    (let ((done-items (parse-recent-done-items lines)))
      (remove-whitespace-around-tags done-items))))
