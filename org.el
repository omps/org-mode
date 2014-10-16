; -*- mode: lisp -*-
;; based on http://doc.norang.ca/org-mode.html

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
(setq org-agenda-files '("~/org"))

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
(setq org-default-notes-file "~/org/refile.org")

;; C-c c to capture
;; capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
(setq org-capture-templates
      (quote (("t" "todo" entry (file "~/org/refile.org")
	       "* TODO %? \n%U\n%a\n" :clock-in t :clock-resume t)
	      ("r" "respond" entry (file "~/org/refile.org")
	       "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
	      ("n" "note" entry (file "~/org/refile.org")
	       "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
	      ("j" "Journal" entry (file+datetree "~/org/diary.org")
	       "* %? \n%U\n" :clock-in t :clock-resume t)
	      ("w" "org-protocol" entry (file "~/org/refile.org")
	       "* TODO Review %c\n%U\n" :immediate-finish t)
	      ("m" "Meeting" entry (file "~/org/refile.org")
	       "* MEETING WITH %? :MEETING:\n%U" :clock-in t :clock-resume t)
	      ("p" "Phone Call" entry (file "~/org/refile.org")
	       "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
	      ("h" "Habit" entry (file "~/org/refile.org")
	       "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"<%Y-%m-%d %a .+1d/3d>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))

;; Remove empty drawers where the clock in and clock-out is set to zero
(defun omps/remove-empty-drawer-on-clock-out ()
  (interactive)
  (save-excursion
    (beginning-of-line 0)
    (org-remove-empty-drawer-at "LOGBOOK" (point))))

(add-hook 'org-clock-out-hook 'omps/remove-empty-drawer-on-clock-out 'append)

;; Refiling tasks
;; Targets include this file and any file contributing to the agenfa - up to 9 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 9)
				 (org-agenda-files :maxlevel . 9))))

;; use full outline paths for refile targets - file using IDO
(setq org-refile-use-outline-path t)

;; targets complete directly with IDO
(setq org-outline-path-complete-in-steps nil)

; Allow refile to create parent task with confirmation
(setq org-refile-allow-creating-parent-nodes (quote confirm))

; Use IDO for both buffer and file completion and ido-everywhere to t
(setq org-completion-use-ido t)
;; further configuration is added to ido.el

; use current window for indirect buffer display
(setq org-indirect-buffer-dispay 'current-window)

; exclude done tasks from refile targets.
(defun omps/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets."
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))

(setq org-refile-target-verify-function 'omps/verify-refile-target) ; to refile task to my todo.org file under Finances heading, Just put the cursor on the task hit C-c C-w and enter nor C-SPC sys RET and its done. IDO completion is awesome.

;; Do not dim blocked tasks
(setq org-agenda-dim-blocked-tasks nil)

;; Compact the block agenda view
(setq org-agenda-compact-blocks t)

;; custom agenda command definitions
(setq org-agenda-custom-commands
      (quote (("N" "Notes" tag "NOTE"
	       ((org-agenda-overriding-header "Notes")
		(org-tags-match-list-sublevels t)))
	      ("h" "Habits" tags-todo "STYLE=\"habit\""
	       ((org-agenda-overriding-header "Habits")
		(org-agenda-sorting-strategy
		 '(todo-state-down effort-up category-keep))))
	      (" " "Agenda"
	       ((agenda "" nil)
		(tags "REFILE"
		      ((org-agenda-overriding-header "Tasks to Refile")
		       (org-tags-match-list-sublevels nil)))
		(tags-todo "-CANCELLED/!"
			   ((org-agenda-overriding-header "Stuck Projects")
			    (org-agenda-skip-function 'omps/skip-non-stuck-projects)
			    (org-agenda-sorting-strategy
			     '(category-keep))))
		(tags-todo "-HOLD-CANCELLED/!"
			   ((org-agenda-overriding-header "Projects")
			    (org-agenda-skip-function 'omps/skip-non-projects)
			    (org-tags-match-list-sublevels 'indented)
			    (org-agenda-sorting-strategy
			     '(category-keep))))
		(tags-todo "-CANCELLED/!NEXT"
			   ((org-agenda-overiding-header (concat "Project Next Tasks"
								 (if omps/hide-scheduled-and-waiting-next-tasks
								     ""
								   " (including WAITING and SCHEDULED tasks)")))
			    (org-agenda-skip-function 'omps/skip-project-and-habits-and-single-tasks)
			    (org-tags-match-list-sublevels t)
			    (org-agenda-todo-ignore-scheduled omps/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-todo-ignore-deadlines omps/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-todo-ignore-with-date omps/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-sorting-strategy
			     '(todo-state-down effort-up category-keep))))
		(tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
			   ((org-agenda-overriding-header (concat "Project Subtasks"
								  (if omps/hide-scheduled-and-waiting-next-tasks
								      ""
								    " (including WAITING and SCHEDULED tasks)")))
			    (org-agenda-skip-function 'omps/skip-non-project-tasks)
			    (org-agenda-todo-ignore-scheduled omps/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-todo-ignore-deadlines omps/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-todo-ignore-with-date omps/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-sorting-strategy
			     '(category-keep))))
		(tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
			   ((org-agenda-overriding-header (concat "Standalone Tasks"
								  (if omps/hide-scheduled-and-waiting-next-tasks
								      ""
								    " (including WAITING and SCHEDULED tasks)")))
			    (org-agenda-skip-function 'omps/skip-project-tasks)
			    (org-agenda-todo-ignore-scheduled omps/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-todo-ignore-deadlines omps/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-todo-ignore-with-date omps/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-sorting-strategy
			     '(category-keep))))
		(tags-todo "-CANCELLED+WAITING|HOLD/!"
			   ((org-agenda-overriding-header (concat "Waiting and Postpones Tasks"
								  (if omps/hide-scheduled-and-waiting-next-tasks
								      ""
								    " (including WAITING and SCHEDULED tasks)")))
			    (org-agenda-skip-function 'omps/skip-non-tasks)
			    (org-tags-match-list-sublevels nil)
			    (org-agenda-todo-ignore-scheduled omps/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-todo-ignore-deadlines omps/hide-scheduled-and-waiting-next-tasks)))
		(tags "-REFILE/"
		      ((org-agenda-overriding-header "Tasks to Archive")
		       (org-agenda-skip-function 'omps/skip-non-archivable-tasks)
		       (org-tags-match-list-sublevels nil))))
	       nil))))


;; custome filters
(defun omps/org-auto-exclude-function (tag)
  "Automatic task exclusion in the agenda with / RET"
  (and (cond
	((string=tag "hold")
	 t)
	((string= tag "farm")
	 t))
       (concat "-" tag)))

(setq org-agenda-auto-exclude-function 'omps/org-auto-exclude-function)

; Time clocking
; Resume clocking task when emacs is restarted
(org-clock-persistence-insinuate)
; show lots of clocking history, makes easier to pick items off.
(setq org-clock-history-length 23)
; Resume clocking task on clock in if the clock is open
(setq org-clock-in-resume t)
; change task to next when clocking in
(setq org-clock-in-switch-to-state 'omps/clock-in-to-next)
; seperate drawers for clocking and logs
(setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
; save clock data and state changes and notes in the LOGBOOK drawer 
(setq org-clock-into-drawer t)
;; remove tasks which are getting clocked quickly i.e. tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)
; clock out when moving tasks to done state
(setq org-clock-out-when-done t)
; save the running clock and all clock history when exiting Emacs, load it back on startup.
(setq org-clock-persist t)
; do not prompt to resume an active clock
(setq org-clock-persist-query-resume nil)
; enable auto clock resolution for finding open clocks
(setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
; Include current clicking task in clock reports
(setq org-clock-report-include-clocking-task t)

(setq omps/keep-clock-running nil)

(defun omps/clock-in-to-next (kw)
  "Switch task from TODO to NEXT when clocking in.
Skips capture tasks, projects, and subprojects.
Switch projects and subprojects from NEXT back to TODO"
  (when (not (and (boundp 'org-capture-mode) org-capture-mode))
    (cond
     ((and (member (org-get-todo-state) (list "TODO"))
	   (omps/is-task-p))
      "NEXT")
     ((and (member (org-get-todo-state) (list "NEXT"))
	   (omps/is-project-p))
      "TODO"))))

(defun omps/find-project-task ()
  "Move point to the parent (project) task if any"
  (save-restriction
    (widen)
    (let ((parent-task (save-excursion (org-back-to-heading 'invisible-ok) (point))))
      (while (org-up-heading-safe)
	(when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
	  (setq parent-task (point))))
      (goto-char parent-task)
      parent-task)))

(defun omps/punch-in (arg)
  "Start continuos clocking and set the default task to the selected task. if no task is selected set the organization task as the default task."
  (interative "p")
  (setq omps/keep-clock-running t)
  (if (equal major-mode 'org-agenda-mode)
      ;;
      ;; Agenda
      (let* ((marker (org-get-at-bol 'org-hd-marker))
	     (tags (org-with-point-at marker (org-get-tags-at))))
	(if (and (eq arg 4) tags)
	    (org-agenda-clock-in '(16))
	  (omps/clock-in-organization-task-as-default)))
    ;; we are no longer in agenda
    (save-restriction
      (widen)
      ; Find the tags for the current task
      (if (and (equal major-mode 'org-mode) (not (org-before-first-heading-p)) (eq arg 4))
	  (org-clock-in '(16))
	(omps/clock-in-organization-task-as-default)))))

(defun omps/punch-out ()
  (interactive)
  (setq omps/keep-clock-running nil)
  (when (org-clock-is-active)
    (org-clock-out))
  (org-agenda-remove-restriction-lock))

(defun omps/clock-in-default-task ()
  (save-excursion
    (org-with-point-at org-clock-default-task
      (org-clock-in))))

(defun omps/clock-in-parent-task ()
  (save-excursion
    (org-with-point-at org-clock-default-task
      (org-clock-in))))

(defun omps/clock-in-parent-task ()
  "Move point to the parent (project) task if any and clock in"
  (let ((parent-task))
    (save-excursion
      (save-restriction
      (widen)
      (while (and (not parent-task) (org-up-heading-safe))
	(when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
	  (setq parent-task (point))))
      (if parent-task
	  (org-with-point-at parent-task
	    (org-clock-in))
	(when omps/keep-clock-running
	  (omps/clock-in-default-task)))))))

;; ; defvar omps/organization-task-id " ; may skip this part.

(defun omps/clock-out-maybe ()
  (when (and omps/keep-clock-running
	     (not org-clock-clocking-in)
	     (marker-buffer org-clock-default-task)
	     (not org-clock-resolving-clocks-due-to-idleness))
    (omps/clock-in-parent-task)))

(add-hook 'org-clock-out-hook 'omps/clock-out-maybe 'append)

; use discrete minutes and no rounding increments.
(setq org-time-stamp-rounding-minutes (quote (1 1)))

; shows one minute clocking gap
(setq org-agenda-clock-consistency-checks
      (quote (:max-duration "4:00"
			    :min-duration 0
			    :max-gap 0
			    :gap-ok-around ("4:00"))))

; tag setup.
(setq org-tag-alist (quote ((:startgroup)
			    ("@errand" . ?e)
			    ("@office" . ?o)
			    ("@home" . ?H)
			    (:endgroup)
			    ("WAITING" . ?w)
			    ("HOLD" . ?h)
			    ("PERSONAL" . ?P)
			    ("WORK" . ?W)
			    ("EMACS" . ?E)
			    ("ORG" . ?O)
			    ("OMPS" . ?B)
			    ("NOTE" . ?n)
			    ("CANCELLED" . ?c)
			    ("FLAGGED" . ??))))

;; Handelling notes

;; Phone Call setup
(require 'bbdb)
(require 'bbdb-com)
;; Keybindings for phone calls in the keybindings.el
; Phone capture template handleing with BBDB loopup.
; Adapted from code by Gregory J. Grubbs
;; (defun omps/phone-call ()
;;   "Return name and company info for caller from the bbdb lookup"
;;   (interactive)
;;   (let * (name rec caller)
;;        (setq name (completing-read "Who is calling? "
;; 				   (bbdb-hashtable)
;; 				   'bbdb-complication-predicate
;; 				   'confirm))
;;        (when (> (length name) 0)
;; 	 ; something was supplied - look it up in bbdb
;; 	 (setq rec
;; 	       (or (first
;; 		    (or (bbdb-search (bbdb-records) name nil nil)
;; 			(bbdb-search (bbdb-records) nil name nil))))
;; 	       name))))

;; ; build the bbdb link if we have a bbdb record, otherwise just retirn the name
;; (setq caller (cond ((and rec (vector rec))
;; 		    (let ((name (bbdb-record-name rec))
;; 			  (company (bbdb-record-company rec)))
;; 		      (concat "[[bbdb:"
;; 			      name "]["
;; 			      name "]["
;; 			      (when company
;; 				(concat " - " company)))))
;; 		   (rec)
;; 		   (t "NameOfCaller")))
;; (insert caller)))


; Reminder setup

; export to google calendar

; (require 'org-gcal)
