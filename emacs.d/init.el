;;; .emacs/init.el -- Summary
;;; Commentary:
;; my Emacs customisations
;;
;;; Code:
;; =====================
;; MELPA package support
;; =====================
(require 'package)
;; adds the melpa archive ot the list of repos
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
;; initialize the package infrastruckture
(package-initialize)
;; if there are no archived package contents, refresh them
(when (not package-archive-contents)
  (package-refresh-contents))

;; =====================
;; Packages
;; =====================
;; the packages we want
(defvar my-Packages
  '(better-defaults             ;; set up som better Emacs defaults
    material-theme              ;; Theme(s)
    borland-blue-theme          ;;
    sqlformat                   ;; enable sqlformat
    auto-package-update         ;; automatic update of package
    monokai-pro-theme           ;; another theme
    flycheck                    ;; flycheck    ;;flycheck-shellcheck
    elpy                        ;; python env
    py-autopep8                 ;; autopep8 on save
    blacken                     ;; black formating on save
    pyvenv-auto                 ;; python venvs
    company
    company-jedi
    bash-completion
    ;;gnu-elpa-keyring-update     ;; update key ring
    ;;sql-indent                  ;; sql indent
    )
  )
;; scans the list of myPackages
;; if the packages is not installed do so
(mapc #'(lambda (package)
	  (unless (package-installed-p package)
	    (package-install package)))
      my-Packages)

;;(use-package auto-package-update
;;	     :custom
;;	     (auto-package-update-interval 7)
;;	     (auto-package-update-prompt-before-update t)
;;	     (auto-package-update-hide-results t)
;;	     :config
;;	     (auto-package-update-maybe)
;;	     (auto-package-update-time "10:55"))

;; ====================
;; Customisations
;; ====================
(setq inhibit-startup-message t)       ;; we don't need the startup message
;;(load-theme 'material t)             ;; the theme we want
;;(load-theme 'borland-blue t)           ;; the theme we want
;;(load-theme 'alect-light-alt t)
(load-theme 'monokai-pro t)
(global-display-line-numbers-mode t)   ;; enable line numbers global
(add-hook 'after-init-hook #'global-flycheck-mode)
(add-hook 'after-init-hook 'global-company-mode)

;; highlight-indentation stuff
(highlight-indentation-mode t)
(highlight-indentation-current-column-mode t)
(set-face-background 'highlight-indentation-face "#353535")
(set-face-background 'highlight-indentation-current-column-face "#505050")

;; switch of tabs https://www.emacseiki.org/emacs/IndentationBasics
;;(defun turn-off-indent-tabs-mode ()
;;  (setq indent-tabs-mode nil))
;;(add-hook 'sh-mode-hook #'turn-off-indent-tabs-mode)
;;(setq-default indent-tabs-mode nil)
(setq tab-width 2) ;; or any other
;;      c-basic-offset tab-width
;;      cperl-ident-level tab-width
;;      shell-script tab-width)

;;(defun basic-offset ()
;;	(setq sh-basic-offset 2))
;;'(sh-basic-offset 2)

;; sqlformat
(require 'sqlformat)
;; the program to use
(setq sqlformat-command 'pgformatter)

;; additional arguments
;; wrap after 4 columns no-grouping
;;(setq sqlformat-args '("-W4" "-g"))
(setq sqlformat-args '("-g"))
;; enable on save
(add-hook 'sql-mode-hook 'sql-format-on-save-mode)

;; bind the following key to the sqlformat
;;(define-key sql-mode-map (kbd "C-c C-f") 'sqlformat)

;; yasnippet
;;(add-to-list 'load-path
;;                "~/.emacs.d/snippets")
(require 'yasnippet)
(yas-global-mode 1)

;; ansible doc mode
(add-hook 'yaml-mode-hook #'ansible-doc-mode)

;; ==============
;; python
;; ==============
;; enable elpy
(elpy-enable)

;; Enable Flycheck
(when (require 'flycheck nil t)
	(setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
	(add-hook 'elpy-mode-hook 'flycheck-mode))

;; Enable autopep
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-mode)

;;(use-package pyvenv-auto
;;  :hook ((python-mode . pyvenv-auto-run)))
(pyvenv-mode)

;; company autocompletion
(add-to-list 'company-backends '(company-jedi company-files))

;; code navigation
(defun python-imenu-use-flat-index
		()
	(setq imenu-create-index-function
				#'python-imenu-create-flat-index))
(add-hook 'python-mode-hook
	  #'python-imenu-use-flat-index)

;; flymake for shell
;; (add-hook 'sh-mode-hook 'flymake-shellcheck-load)

;;
;; end Customisations
;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-safe-themes
   '("16198c5c7319d07ded977d2414a96fff95f468af313cff6f684fd02f9dfff9b2" "fee7287586b17efbfda432f05539b58e86e059e78006ce9237b8732fde991b4c" "4c56af497ddf0e30f65a7232a8ee21b3d62a8c332c6b268c81e9ea99b11da0d3" "524fa911b70d6b94d71585c9f0c5966fe85fb3a9ddd635362bfabd1a7981a307" "4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" default))
 '(elpy-rpc-python-command "/home/tliebsch/python-envs/am-env/bin/python3")
 '(global-auto-revert-mode t)
 '(global-display-line-numbers-mode t)
 '(package-selected-packages
   '(flymake-shellcheck company-jedi pyenv-mode py-autopep8 elpygen company elpy monokai-pro-theme alect-themes highlight-indentation shfmt flycheck bash-completion yasnippet ansible-doc ansible auto-package-update gnu-elpa-keyring-update sql-indent sqlformat borland-blue-theme material-theme better-defaults))
 '(recentf-mode t)
 '(standard-indent 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Terminess Nerd Font" :foundry "PfEd" :slant normal :weight medium :height 120 :width normal)))))
;;; init.el ends here
