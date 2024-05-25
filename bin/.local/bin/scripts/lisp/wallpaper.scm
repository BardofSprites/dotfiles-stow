(use gauche.process)

(define (get-input prompt options)
  (sys-system (string-append "echo -e \"" options "\" | dmenu -p" prompt)))

(define (get-input prompt chooseable-options)
  (do-pipeline '((echo -e "\"" chooseable-options "\"")
                 (dmenu -p "\"" prompt "\""))))

(define (main)
  (let* ((wallpaper-dirs (string-append (sys-getenv "HOME") "/Pictures/wallpaper/\n"
                                        (sys-getenv "HOME") "/Pictures/Anime-Wallpaper/"))
         (selected-dir (get-input "Select directory: " wallpaper-dirs))
         (choose-wallpaper (sys-system (string-append "nsxiv -t -r -o " selected-dir)))
         (image-mode-options "Tiled\nZoom Filled\nCentered")
         (selected-image-mode (get-input "Select Display Mode: " image-mode-options)))
    (set-wallpaper selected-directory selected-image-mode)
    (print "Wallpaper set successfully.")))

(define (set-wallpaper wallpaper mode)
  (case mode
    (("Tiled") (sys-system (string-append "feh --bg-tile " wallpaper)))
    (("Zoom Filled") (sys-system (string-append "feh --bg-fill " wallpaper)))
    (("Centered") (sys-system (string-append "feh --bg-center " wallpaper)))
    (else (print "Invalid option selected.") (exit 1))))

(define (set-wallpaper wallpaper mode)
  (case mode
    (("Tiled") (sys-system (string-append "fe")))))

(define (main)
  (let* ((wallpaper-dirs (string-append (sys-getenv "HOME") "/Pictures/wallpaper/\n"
                                        (sys-getenv "HOME") "/Pictures/Anime-Wallpaper/"))
         (image-mode-options "Tiled\nZoom Filled\nCentered")
         (selected-dir (get-input "Select directory: " wallpaper-dirs))
         (selected-image-mode (get-input "Select Display Mode: " image-mode-options)))
    ))

(main)
