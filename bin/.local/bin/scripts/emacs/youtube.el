(defun play-video-from-clipboard ()
  "Play a video from the clipboard using mpv."
  (interactive)
  (let ((clipboard-contents (shell-command-to-string "xclip -o -selection clipboard")))
    (if (string-empty-p clipboard-contents)
        (message "Clipboard is empty.")
      (let ((python-env "~/.pyvenv/bin/activate"))
        (shell-command (format "source %s && mpv %s" python-env clipboard-contents))))))

(global-set-key (kbd "C-c p") 'play-video-from-clipboard)
