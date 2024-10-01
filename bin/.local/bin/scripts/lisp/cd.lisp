(require 'asdf)

(asdf:load-system :uiop)

(defun read-playlist (path)
  (if (probe-file (uiop:native-namestring path))
      (progn
        (format t "File exists")
        (uiop:read-file-lines path))
    (progn
      (format t "Playlist file doesn't exist: ~a~%" (uiop:native-namestring))
      (return-from read-playlist nil))))

(defun move-files ()
  (ensure-directories-exist ()))
