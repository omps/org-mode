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

;; org-agenda files
(setq org-agenda-files "~/org")

;; org mode global TODO keywords.
(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
	      (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
	      ("NEXT" :foreground "blue" :weight bold)
	      ("DONE" :foreground "forest green" :weight bold)
	      ("WAITING" :foreground "orange" :weight bold)
	      ("HOLD" :foreground "magenta" :weight bold)
	      ("CANCELLED" :foreground "forest green" :weight bold)
	      ("PHONE" :foreground "forest green" :weight bold)
	      ("MEETING" :foreground "forest green" :weight bold))))

;; if the tasks has subtasks with TODO keywords then the task is a project. one subtask of the project should have a NEXT keyword, else the project would be in stuck state.

(setq org-use-fast-todo-selection t) ;; changing tasks state is done with C-c C-t KEY
;; allows changing todo state with Shift-left and Shift-right skipping all the normal processing when entering or leaving a todo state. This cycles through the todo-states but skips setting timestamps and entering notes which is convinent when fixing the status of an entry.
(setq org-treat-S-cursor-todo-selection-as-state-change nil)

;; TODO state triggers (adding and removing tags automatically).
(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
	      ("WAITING" ("WAITING" . t))
	      ("HOLD" ("WAITING") ("HOLD" . t))
	      (done ("WAITING")("HOLD"))
	      ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
	      ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
	      ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))

;; Capture templates
(setq-org-default-notes-file "~/org/refile.org")

;; C-c c to capture
;; capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
(setq org-capture-templates
      (quote (("t" "todo" entry (file "~/org/refile.org")
	       "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
	      ("r" "respond" entry (file "~/org/refile.org")
	       "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
	      ("n" "note" entry (file "~/org/refile.org")
	       "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
	      ("j" "Journal" entry (file+datetree "~/org/diary.org")
	       "* %?\n%U\n" :clock-in t :clock-resume t)
	      ("w" "org-protocol" entry (file "~/org/refile.org")
	       "* TODO Review %c\n%U\n" :immediate-finish t)
	      ("m" "Meeting" entry (file "~/org/refile.org")
	       "* MEETING WITH %? :MEETING:\n%U" :clock-in t :clock-resume t)
	      ("p" "Phone Call" entry (file "~/org/refile.org")
	       "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
	      ("h" "Habit" entry (file "~/org/refile.org")
	       "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"<%Y-%m-%d %a .+1d/3d>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))
