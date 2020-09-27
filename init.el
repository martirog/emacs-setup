;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; read the setup in the init.org file

; dont add setup her. use the init.org

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'org)
(org-babel-load-file
 (expand-file-name "setup.org"
                   user-emacs-directory))

(mapc #'org-babel-load-file (directory-files (concat user-emacs-directory "extra") t "\\.org$"))
