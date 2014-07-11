(require 'ido)
;; (ido-mode t)
;; #START org.el
(setq ido-everywhere t)
(setq ido-max-directory-size 100000)
(ido-mode (quote both))
;; use the current window when visiting files and buffers with IDO
(setq ido-default-file-method 'selected-window)
(setq ido-default-buffer-method 'selected-window)
;; #END org.el

