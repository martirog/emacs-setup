;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; read the setup in the init.org file

; dont add setup her. use the init.org

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'org)
(org-babel-load-file
 (expand-file-name "setup.org"
                   user-emacs-directory))

(org-babel-load-file
 (expand-file-name "xps-setup.org"
                   user-emacs-directory))
