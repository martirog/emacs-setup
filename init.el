;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; set colors

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(set-face-background 'default "black")           ; frame background
(set-face-foreground 'default "bisque")          ; normal text
                                                 ; mouse
(set-cursor-color "bisque") ; did not need this before 23.1?
;(set-face-font  'default "*courier-bold-r*120-100-100*")
;(set-face-font  'default "Courier New-12")
(set-face-background 'highlight "blue")          ; Ie when selecting buffers
(set-face-foreground 'highlight "yellow")
;(set-face-foreground 'modeline "magenta")
;(set-face-font  'modeline "*bold-r-normal*140-100-100*")
(set-face-background 'isearch "yellow")          ; When highlighting while
                                                 ; searching
(set-face-foreground 'isearch "red")
;(set-face-background 'scroll-bar "black")          ; Ie when selecting buffers
;(set-face-foreground 'scroll-bar "yellow")
(setq x-pointer-foreground-color "black")        ; Adds to bg color,
                                                 ; so keep black
(setq x-pointer-background-color "blue")         ; This is color you really
                                                 ; want ptr/crsr
(set-face-background 'mode-line "#404040")
(set-face-foreground  'mode-line "#FDCE81")
(set-face-background 'mode-line-inactive "#202020")
(set-face-foreground  'mode-line-inactive "#f0f0f0")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; my settings

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Format the title-bar to always include the buffer name
(setq frame-title-format "emacs - %b")

;; disable welcome message
(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message t)
(setq initial-scratch-message nil)
;;remove toolbar
(tool-bar-mode -1)
(menu-bar-mode -1)   ; turn off menu bar, not sure you want this?
(scroll-bar-mode -1) ;
;;show trailing whitespaces
(setq-default show-trailing-whitespace t)
; Indicate empty lines at the end of the buffer
(setq-default indicate-empty-lines t)

; set scrollbar (not uised as scroll bar is turned off)
;(require 'pixel-scroll)
;(pixel-scroll-mode 1)

; turn truncation off
(setq-default truncate-lines t)

(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; mode line

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq-default mode-line-format
              (list
               "%e"
               'mode-line-front-space
               '(:propertize mode-line-mule-info face (:foreground "green"))
               '(:propertize mode-line-client   face (:foreground "green"))
               '(:propertize mode-line-modified face (:foreground "green"))
               '(:propertize mode-line-remote   face (:foreground "green"))
               '(:propertize mode-line-frame-identification face (:foreground "#CF70F7"))
               'mode-line-buffer-identification
               "   "
               '(:propertize mode-line-position face (:foreground "#2EB604"))
               '(vc-mode vc-mode)
               "  "
               '(:propertize mode-line-modes face (:foreground "#CF70F7"))
               '(:propertize mode-line-misc-info face (:foreground "#CC92E0"))
               'mode-line-end-spaces
               ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; self defined key's

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key (quote [?\C-c ?f]) (quote grep-find) )
; move to the grep buffer after run
(add-hook 'grep-mode-hook
          '(lambda ()
             (switch-to-buffer-other-window "*grep*")))
(global-set-key (quote [?\C-c ?o]) (quote find-file-at-point) )
;; Activate occur easily inside isearch
(define-key isearch-mode-map (kbd "C-o")
  (lambda () (interactive)
    (let ((case-fold-search isearch-case-fold-search))
      (occur (if isearch-regexp isearch-string (regexp-quote isearch-string))))))
(global-set-key (kbd "C-c +") 'quick-calc)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; cc-mode  (tandberg c style)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; set c-mode-hook function to override default behavior of various items

(setq tab-width 4);; vc++ default
(setq-default c-basic-offset 4) ;; 2 is default
(setq-default indent-tabs-mode nil);; indent with spaces
(c-set-offset 'case-label '+)
(c-set-offset 'inline-open '0)
(c-set-offset 'arglist-close '0)

(require 'cc-mode)

(defconst my-ttc-style '((c-basic-offset . 4)
                         (c-comment-only-line-offset 0 . 0)
                     (c-offsets-alist
                          (statement-block-intro . +)
                    (knr-argdecl-intro . 5)
                    (substatement-open . 0)
                    (label . 0)
                    (statement-case-open . +)
                          (statement-case-intro . +)
                    (statement-cont . +)
                    (arglist-intro . c-lineup-arglist-intro-after-paren)
                    (arglist-close . c-lineup-arglist)
                    (inline-open . 0))
                         (c-special-indent-hook . c-gnu-impose-minimum)
                         (c-comment-continuation-stars . "")
                         (c-hanging-comment-ender-p . t)))

(defun my-c-mode-common-hook ()

  ;; my customizations for all of c-mode and related modes
  (c-set-offset 'substatement-open 0)
  (c-set-style "ttc")

  ;; other customizations can go here
  )

(c-add-style "ttc" my-ttc-style )

(add-hook 'c-mode-hook 'my-c-mode-common-hook)
(add-hook 'c-mode-hook 'font-lock-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; toggle between horizontal and vertical window split

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
	     (next-win-buffer (window-buffer (next-window)))
	     (this-win-edges (window-edges (selected-window)))
	     (next-win-edges (window-edges (next-window)))
	     (this-win-2nd (not (and (<= (car this-win-edges)
					 (car next-win-edges))
				     (<= (cadr this-win-edges)
					 (cadr next-win-edges)))))
	     (splitter
	      (if (= (car this-win-edges)
		     (car (window-edges (next-window))))
		  'split-window-horizontally
		'split-window-vertically)))
	(delete-other-windows)
	(let ((first-win (selected-window)))
	  (funcall splitter)
	  (if this-win-2nd (other-window 1))
	  (set-window-buffer (selected-window) this-win-buffer)
	  (set-window-buffer (next-window) next-win-buffer)
	  (select-window first-win)
	  (if this-win-2nd (other-window 1))))))

(global-set-key (quote [?\C-c ?t]) (quote toggle-window-split) )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; load verilog mode when .v .dv or .sv

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defconst my-verilog-beg-block-re-ordered
  ( concat "\\(\\<begin\\>\\)"		;1
	   "\\|\\(\\<randcase\\>\\|\\(\\<unique0?\\s-+\\|priority\\s-+\\)?case[xz]?\\>\\)" ; 2,3
	   "\\|\\(\\(\\<disable\\>\\s-+\\|\\<wait\\>\\s-+\\)?fork\\>\\)" ;4,5
	   "\\|\\(\\<class\\>\\)"		;6
	   "\\|\\(\\<table\\>\\)"		;7
	   "\\|\\(\\<specify\\>\\)"		;8
	   "\\|\\(\\<function\\>\\)"		;9
           "\\|\\(\\(?:\\<\\(?:virtual\\|protected\\|static\\)\\>\\s-+\\)*\\<function\\>\\)"  ;10
           "\\|\\(\\<task\\>\\)"                ;11
           "\\|\\(\\(?:\\<\\(?:virtual\\|protected\\|static\\)\\>\\s-+\\)*\\<task\\>\\)"      ;12
           "\\|\\(\\<generate\\>\\)"            ;13
           "\\|\\(\\<covergroup\\>\\)"          ;14
           "\\|\\(\\(?:\\(?:\\<cover\\>\\s-+\\)\\|\\(?:\\<assert\\>\\s-+\\)\\)*\\<property\\>\\)" ;15
           "\\|\\(\\<\\(?:rand\\)?sequence\\>\\)" ;16
           "\\|\\(\\<clocking\\>\\)"              ;17
           "\\|\\(\\<`[ou]vm_[a-z_]+_begin\\>\\)" ;18
           "\\|\\(\\<`vmm_[a-z_]+_member_begin\\>\\)"
	   ;;
))
;; Load verilog mode only when needed
(autoload 'verilog-mode "verilog-mode" "Verilog mode" t )
;; Any files that end in .v, .dv or .sv should be in verilog mode
(add-to-list 'auto-mode-alist '("\\.[ds]?v\\'" . verilog-mode))
;; Any files in verilog mode should have their keywords colorized
(add-hook 'verilog-mode-hook '(lambda () (font-lock-mode 1)))
(add-hook 'verilog-mode-hook 'hs-minor-mode)
(add-to-list 'hs-special-modes-alist (list 'verilog-mode (list my-verilog-beg-block-re-ordered 0) "\\<end\\>" nil 'verilog-forward-sexp-function))
(global-set-key (kbd "C-c a") 'hs-toggle-hiding)

;; Set indent
;;(setq verilog-indent-level 2)
(defvar gc/verilog-indent-level 2)
(setq verilog-indent-level gc/verilog-indent-level
      verilog-indent-level-module gc/verilog-indent-level
      verilog-indent-level-declaration gc/verilog-indent-level
      verilog-indent-level-behavioral gc/verilog-indent-level
      verilog-indent-level-directive gc/verilog-indent-level
      verilog-case-indent gc/verilog-indent-level
      verilog-cexp-indent gc/verilog-indent-level)

(setq verilog-align-ifelse t
      verilog-auto-endcomments t
      verilog-auto-indent-on-newline t
      verilog-auto-lineup nil
      verilog-auto-newline nil
      verilog-date-scientific-format t
      verilog-indent-begin-after-if t
      verilog-highlight-grouping-keywords t
      verilog-highlight-modules t
      verilog-minimum-comment-distance 20
      verilog-tab-always-indent t
      verilog-tab-to-comment nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; activate ido.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t) ;; enable fuzzy matching

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; get erc buffers whit ido

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun rgr/ido-erc-buffer()
  (interactive)
  (switch-to-buffer
   (ido-completing-read "Channel:"
                        (save-excursion
                          (delq
                           nil
                           (mapcar (lambda (buf)
                                     (when (buffer-live-p buf)
                                       (with-current-buffer buf
                                         (and (eq major-mode 'erc-mode)
                                              (buffer-name buf)))))
                                   (buffer-list)))))))

  (global-set-key (kbd "C-c e") 'rgr/ido-erc-buffer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; groovy-mode

; fix this as it is not general

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when (file-directory-p "~/.emacs.d/mode")
    (add-to-list 'load-path "~/.emacs.d/mode")
    (when (file-exists-p "~/.emacs.d/mode/groovy-mode.el")
      (add-to-list 'load-path "~/.emacs.d/mode")
      (load "groovy-mode.el")
      (require 'groovy-mode)
      (add-to-list 'auto-mode-alist '("\\.groovy\\'" . groovy-mode))
      (add-to-list 'auto-mode-alist '("\\Jenkinsfile\\'" . groovy-mode))
      )
    )


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Fucking mac shit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq x-super-keysym 'meta)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; set up the emacs as a server

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq server-name
      (if (getenv "VIRTDESCTOP")
          (getenv "VIRTDESCTOP")
        "my-e-server"))
(server-start)
; as I use multipple emacses for different virtual desctops I need to setup a
; environment variabel describing which setup I am on

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; tramp setup

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq tramp-default-method "ssh")
(defun ido-remove-tramp-from-cache nil
    "Remove any TRAMP entries from `ido-dir-file-cache'.
    This stops tramp from trying to connect to remote hosts on emacs startup,
    which can be very annoying."
    (interactive)
    (setq ido-dir-file-cache
	  (cl-remove-if
	   (lambda (x)
	     (string-match "/\\(rsh\\|ssh\\|telnet\\|su\\|sudo\\|sshx\\|krlogin\\|ksu\\|rcp\\|scp\\|rsync\\|scpx\\|fcp\\|nc\\|ftp\\|smb\\|adb\\):" (car x)))
	   ido-dir-file-cache)))
  ;; redefine `ido-kill-emacs-hook' so that cache is cleaned before being saved
  (defun ido-kill-emacs-hook ()
    (ido-remove-tramp-from-cache)
    (ido-save-history))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; setup python

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq python-shell-interpreter "python3")
