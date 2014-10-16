; -*- mode: lisp -*-
;; keep track of loading time
(defconst emacs-start-time (current-time))
;;(require use-package)
(setq user-full-name "Om Prakash Singh"
      user-mail-address "ompnix@gmail.com")

;; emacs initialization
(setq ring-bell-function (lambda()))
(setq inhibit-splash-screen t
      initial-major-mode 'fundamental-mode);; removes the emacs splash screen and loads scratch buffer

; settings from http://p.writequit.org/org/settings.html#sec-1-1-2-1
; Always use UTF-8 anything else is insanity.
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)

; sytax highlighting for all buffers
(global-font-lock-mode t)
; Don't warn me for bigger file unless they are 25 MB
; (setq large-file-warning-threshold (* 25 1024 1024))

; Disable the current buffers mark.
(transient-mark-mode t)
(visual-line-mode t)

; turn of all kind of modes, no menubar, toolbar.
 (menu-bar-mode -1)
 (when (window-system)
   (set-scroll-bar-mode 'nil)
   (mouse-wheel-mode t)
   (tooltip-mode -1))
 (tool-bar-mode -1)
 (blink-cursor-mode -1)

; turn on line numbers and column numbers
; (line-number-mode 1)
; (column-number-mode 1)

; set yes to y
(defalias 'yes-or-no-p 'y-or-n-p)

; move around wrapped lines
(setq line-move-visual t)

; Hide the mouse while typing
 (setq make-pointer-invisible t)

; split windows a bit better
(setq split-height-threshold nil)
(setq split-width-threshold 180)

;; ; eshell settings
;; (use-package eshell
;; 	     :config
;; 	     (progn
;; 	       (defalias 'emacs 'find-file)
;; 	       (setenv "TERM" "xterm-256color")
;; 	       (setenv "PAGER" "less")
;; 	       (use-package esh-opt
;; 			    :config
;; 			    (progn
;; 			      ;; (set-face-attribute 'eshell-prompt nil :foreground "turquoisel")
;; 			      (use-package em-cmpl)
;; 			      (use-package em-prompt)
;; 			      (use-package em-term)))))

;; ;; spellcheck and flyspell mode
;; (setq-default ispell-program-name "aspell")
;; (setq-ispell-personal-dictionary "~/.flydict"
;; 				 ispell-extra-args '("--sug-mode=ultra" "--ignore=3"))
;; (add-to-list 'ispell-skip-region-alist '("[^\000-377]+"))

;; ; flyspell

;; (use-package flyspell
;; 	     :config
;; 	     (define-key flyspell-mode-map (kbd "M-n") 'flyspell-goto-next-error)
;; 	     (define-eky flyspell-mode-map (kbd "M-.") 'ispell-word))

;; ; twittering mode
;; (use-package twittering-mode
;; 	     :defer t
;; 	     :config
;; 	     (progn
;; 	     (setq twittering-icon-mode t
;; 		   twittering-use-master-password t)))

;; (require 'twittering-mode)
(setq twittering-use-master-password t)
(setq twittering-cert-file "/etc/ssl/certs/ca-certificates.crt")

(setq erc-hide-list '("JOIN" "PART" "QUIT"))
;; (when window-system
;;   (custom-set-:foreground "dim gray" :strike-through nil))))
;;    '(org-done ((t (:foreground "PaleGreen" :weight normal :strike-through t))))
;;    '(org-clock-overlay ((t (:background "SkyBlue4" :foreground "black"))))
;;    '(org-headline-done ((((class color) (min-colors 16) (background dark)) (:foreground "LightSalmon" :strike-through t))))
;;    '(outline-1 ((t (:inherit font-lock-function-name-face :foreground "cornflower blue"))))))
