; -*- mode: elisp -*-

(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))
(require 'org)
;; dropbox and mobileorg specific configuration
;; set the location of org files on the local system.
(setq org-directory "~/org")
;; name of the file where new notes will be stored.
(setq org-mobile-inbox-for-pull "~/org/flagged.org")
;; Dropbox root directory
(setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")
;; org-mobile-push will copy your org files to the dropbox area.
;; org-mobile-pull to integrate the changes done on your mobile device.

