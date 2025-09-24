(in-package :stumpwm)

;; Remove default binds
(defvar *gross-default-binds*
  (list "c" "C-c" "e" "C-e" "d" "C-d" "SPC"
        "i" "f" "C-k" "w" "C-w" "a" "C-a"
        "C-t" "o" "TAB" "F" "C-h" "v"
        "#" "m" "C-m" "l" "C-l" "G" "C-N"
        "A" "X" "C-SPC" "I" "r" "W" "+"
        "RET" "C-RET" "C-0" "C-1" "C-2"
        "C-3" "C-4" "C-5" "C-6" "C-7" "\""
        "C-8" "C-9" "0" "1" "2" "3" "4"
        "5" "6" "7" "8" "9"))

;; yuck!
(dolist (bind *gross-default-binds*)
  (undefine-key *root-map* (kbd bind)))

(set-prefix-key (kbd "s-z"))
(define-key *top-map* (kbd "s-q") "delete")

;; programs
(define-key *top-map* (kbd "s-d") "exec dmenu_run")
(define-key *top-map* (kbd "s-RET") "exec st")
(define-key *top-map* (kbd "s-e") "emacs")
(define-key *top-map* (kbd "s-n") "exec emacsclient -c")
(define-key *top-map* (kbd "s-N") "exec emacs-launcher")
(define-key *top-map* (kbd "Print") "exec maimpick")
(define-key *top-map* (kbd "s-X") "exec sysact")
(define-key *top-map* (kbd "s-p") "exec st -e alsamixer")
(define-key *top-map* (kbd "s-w") "exec librewolf-bin")

;; media
(define-key *top-map* (kbd "XF86AudioPlay") "exec playerctl play")
(define-key *top-map* (kbd "s-P") "exec playerctl pause")
(define-key *top-map* (kbd "XF86AudioPause") "exec playerctl pause")
(define-key *top-map* (kbd "XF86AudioNext") "exec playerctl next")
(define-key *top-map* (kbd "XF86AudioPrev") "exec playerctl previous")
(define-key *top-map* (kbd "XF86AudioRaiseVolume") "exec pactl set-sink-volume @DEFAULT_SINK@ +5%")
(define-key *top-map* (kbd "XF86AudioLowerVolume") "exec pactl set-sink-volume @DEFAULT_SINK@ -5%")
(define-key *top-map* (kbd "XF86AudioMute") "exec pactl set-sink-mute @DEFAULT_SINK@ toggle")


;; moving around
(define-key *top-map* (kbd "s-h") "move-focus left")
(define-key *top-map* (kbd "s-j") "move-focus down")
(define-key *top-map* (kbd "s-k") "move-focus up")
(define-key *top-map* (kbd "s-l") "move-focus right")
(define-key *top-map* (kbd "s-H") "move-window left")
(define-key *top-map* (kbd "s-J") "move-window down")
(define-key *top-map* (kbd "s-K") "move-window up")
(define-key *top-map* (kbd "s-L") "move-window right")

;; frame movement
(define-key *root-map* (kbd "v") "hsplit")
(define-key *root-map* (kbd "s") "vsplit")
(define-key *root-map* (kbd "d") "remove-split")
(define-key *root-map* (kbd "V") "hsplit-and-focus")
(define-key *root-map* (kbd "S") "vsplit-and-focus")
(define-key *top-map* (kbd "s-Tab") "next-in-frame")
(define-key *top-map* (kbd "s-ISO_Left_Tab") "prev-in-frame")
(define-key *top-map* (kbd "s-o") "other-in-frame")
(define-key *top-map* (kbd "s-O") "other")
(define-key *top-map* (kbd "s-W") "frame-windowlist")

;; group movement keybinds
(define-key *top-map* (kbd "s-1") "gselect 1")
(define-key *top-map* (kbd "s-2") "gselect 2")
(define-key *top-map* (kbd "s-3") "gselect 3")
(define-key *top-map* (kbd "s-4") "gselect 4")
(define-key *top-map* (kbd "s-5") "gselect 5")
(define-key *top-map* (kbd "s-6") "gselect 6")
(define-key *top-map* (kbd "s-7") "gselect 7")
(define-key *top-map* (kbd "s-8") "gselect 8")
(define-key *top-map* (kbd "s-9") "gselect 9")
(define-key *top-map* (kbd "s-0") "gselect 10")

;; group shifting
(define-key *top-map* (kbd "s-S-1") "gmove 1")
(define-key *top-map* (kbd "s-S-2") "gmove 2")
(define-key *top-map* (kbd "s-S-3") "gmove 3")
(define-key *top-map* (kbd "s-S-4") "gmove 4")
(define-key *top-map* (kbd "s-S-5") "gmove 5")
(define-key *top-map* (kbd "s-S-6") "gmove 6")
(define-key *top-map* (kbd "s-S-7") "gmove 7")
(define-key *top-map* (kbd "s-S-8") "gmove 8")
(define-key *top-map* (kbd "s-S-9") "gmove 9")
(define-key *top-map* (kbd "s-S-0") "gmove 10")
