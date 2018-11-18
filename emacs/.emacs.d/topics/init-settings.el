(use-package simple
  :init
  (defadvice keyboard-escape-quit (around my-keyboard-escape-quit activate)
    "When called, do not close windows."
    (let (orig-one-window-p)
      (fset 'orig-one-window-p (symbol-function 'one-window-p))
      (fset 'one-window-p (lambda (&optional nomini all-frames) t))
      (unwind-protect
          ad-do-it
        (fset 'one-window-p (symbol-function 'orig-one-window-p)))))

  (defadvice kill-region (before slick-cut activate compile)
    "When called interactively with no active region, kill a single line instead."
    (interactive
     (if mark-active
         (list (region-beginning) (region-end))
       (list (line-beginning-position) (line-beginning-position 2)))))

  (defadvice delete-region (before slick-cut activate compile)
    "When called interactively with no active region, delete a single line instead."
    (interactive
     (if mark-active
         (list (region-beginning) (region-end))
       (list (line-beginning-position) (line-beginning-position 2)))))

  (defadvice kill-ring-save (before slick-copy activate compile)
    "When called interactively with no active region, copy a single line instead."
    (interactive
     (if mark-active
         (list (region-beginning) (region-end))
       (message "Copied line")
       (list (line-beginning-position) (line-beginning-position 2)))))

  (defadvice comment-or-uncomment-region (before mark-whole-line activate compile)
    "When called interactively with no active region, toggle a single line instead."
    (interactive
     (if mark-active
         (list (region-beginning) (region-end))
       (list (line-beginning-position) (line-beginning-position 2)))))

  (setq
   load-prefer-newer t                      ; prefer newer .el over .elc
   kill-ring-max 5000                       ; truncate kill ring at 5000 entries
   mark-ring-max 5000                       ; truncate mark ring at 5000 entries
   track-eol nil                            ; cursor doesn't track end-of-line
   mouse-yank-at-point t                    ; paste at cursor position
   sentence-end-double-space nil            ; sentences end with one space
   truncate-partial-width-windows nil       ; don't truncate long lines
   column-number-mode t)                     ; show column number in the mode-line

  (setq-default
   indicate-empty-lines t                   ; show empty lines
   indent-tabs-mode nil                     ; use spaces instead of tabs
   tab-width 4)                             ; tab length

  :config
  ;; app
  (if (display-graphic-p)
      (progn (tool-bar-mode -1)                  ; no toolbar
             (menu-bar-mode -1))))                  ; no menubar


;; `paren' highlights matching parenthesis pairs
(use-package paren
  :init
  (setq blink-matching-paren-distance nil)        ; no blinking parenthesis
  :config
  (show-paren-mode t))

;; `icomplete' provides minibuffer completion
(use-package icomplete
  :init
  (use-package minibuffer
    :init
    (setq read-buffer-completion-ignore-case t)    ; ignore case when completing buffer names
    :config
    (setq read-file-name-completion-ignore-case t)) ; ignore case when completing file names

  :config
  (icomplete-mode t))

;; `hl-line' highlights the current line
  (use-package hl-line
    :config
    (global-hl-line-mode t))

;; modifying text replaces the region
(use-package delsel
  :config
  (delete-selection-mode t))

(use-package scroll-bar
  :if (display-graphic-p)
  :init
  (setq scroll-preserve-screen-position t) ; scroll without moving cursor
  :config
  (set-scroll-bar-mode 'right)        ; set scrollbar right
  (scroll-bar-mode -1))                ; disable scrollbar

(use-package mwheel
  :if (display-graphic-p)
  :config
  (mouse-wheel-mode nil))           ; mouse-wheel disabled

(use-package vc-hooks
  :config
  (setq vc-follow-symlinks t))                     ; follow symlinks to their targets

(use-package frame
  :init
  (add-to-list 'default-frame-alist '(alpha . (98 . 85)))
  :config
  (blink-cursor-mode -1)                     ; no blinking cursor
  (set-frame-parameter (selected-frame) 'alpha '(98 . 85)))

(use-package files
  :init
  (defvar delete-trailing-on-save t)        ; delete trailing whitespaces on save

  :hook
  (before-save-hook . (lambda () (when delete-trailing-on-save
                                   (delete-trailing-whitespace))))

  :config
  (setq require-final-newline t))                  ; add newline at the end of every file

(use-package subr
  :init
  (provide 'subr)
  :config
  (defalias 'yes-or-no-p 'y-or-n-p))         ; y/n instead of yes/no


(provide 'init-settings)
