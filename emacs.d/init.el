;;; package -- Summary  -*- lexical-binding: t; -*-
;;; .emacs/init.el
;;; Commentary:
;;  my Emacs customisations
;;
;;; Code:

;; =====================
;; MELPA package support
;; =====================
(require 'package)
;; adds the melpa archive ot the list of repos
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/"))
;; initialize the package infrastruckture
(package-initialize)
;; if there are no archived package contents, refresh them
;;(when (not package-archive-contents)
;;  (package-refresh-contents))

;; use-package (a declarative package manager).
;; The use-package macro handles installation, configuration, and lazy loading in a single
;; declaration. It became part of Emacs core in version 29.1 and is the recommended way to
;; manage packages in 2026.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; ====================
;; Customisations
;; ====================

;; look and feel
;; ====================
(setq inhibit-startup-message t)       ;; we don't need the startup message

;; Enable global auto-revert
(global-auto-revert-mode t)

;; Also update Dired (directory) buffers when files are added/removed
;;(setq global-auto-revert-non-file-buffers t)


;; the theme we want
(load-theme 'material t)
;;(load-theme 'borland-blue t)
;;(load-theme 'alect-light-alt t)
;;(load-theme 'monokai-pro t)

;; font-lock-mode enable syntax highlighting
(setq font-lock-mode t)

;; global line numbers
(global-display-line-numbers-mode 1)

;; set default indentation width to 2 spaces
(setq-default indent-tabs-mode nil
              tab-width 2)


;; ====================
;; All the Icons
;; ====================
;; https://github.com/domtronn/all-the-icons.el
(use-package all-the-icons :ensure t)

(use-package all-the-icons-dired :ensure t)
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)

(use-package all-the-icons-ibuffer :ensure t
  :init (all-the-icons-ibuffer-mode 1)
  :hook (ibuffer-mode . all-the-icons-ibuffer-mode))

(use-package treemacs-all-the-icons :ensure t)

(use-package all-the-icons-ivy :ensure t
  :after all-the-icons
  :config (all-the-icons-ivy-setup))

;; ====================
;; highlight-indentation stuff
;; ====================
(use-package highlight-indentation
  :ensure t
  :hook ((prog-mode . highlight-indentation-mode)
         (prog-mode . highlight-indentation-current-column-mode))
  :config
  (set-face-background 'highlight-indentation-face "#353535")
  (set-face-background 'highlight-indentation-current-column-face "#505050"))

;; ====================
;; which-key integration - show avaliable keys
;; ====================
(use-package which-key
    :config
    (which-key-mode))

;; ====================
;; direnv integration
;; ====================
(use-package direnv
  :ensure t
  :config
  (direnv-mode))

;; ====================
;; Treemacs
;; ====================
;; https://olddeuteronomy.github.io/post/cpp-programming-in-emacs/
(use-package ivy
  :config
  (ivy-mode)
  (setq ivy-use-virtual-buffers t)
  (add-hook 'after-init-hook (lambda () (setq ivy-height (/ (window-height) 2))))
)

(use-package projectile
  :ensure t
  :config
  (projectile-mode +1)
  (setq projectile-enable-caching t)
  (setq projectile-completion-system 'ivy)
)

(use-package treemacs
  :ensure t
  )
;; If you are using Tree-Sitter for Python, it’s recommended to remap the python-mode
;; to the Tree-Sitter specific python-ts-mode
(add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))

(use-package treemacs-projectile
  :ensure t)
;; Bind it to F12
(global-set-key [(f12)] #'treemacs-select-window)


;; ====================
;; eglot
;; ====================
(require 'eglot)
;; c & c++ env
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)
;;(add-hook 'c-or-c++-mode 'eglot-ensure)
(add-hook 'python-mode-hook 'eglot-ensure)
(add-hook 'python-ts-mode-hook 'eglot-ensure)

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((c-mode c++-mode) . ("clangd")))
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode) . ("pylsp"))))

;; Python LSP (example: basedpyright)
;;(add-to-list 'eglot-server-programs
;;             '((python-mode python-ts-mode) . ("basedpyright-langserver" "--stdio")))

;; ====================
;; flycheck / flymake
;; ====================
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode 1))

;; yaml
(use-package flycheck-yamllint
  :ensure t
  :defer t
  :init
  (progn
    (eval-after-load 'flycheck
      '(add-hook 'flycheck-mode-hook 'flycheck-yamllint-setup))))

(require 'flymake)
;; ansible
(use-package flymake-ansible-lint
  :ensure t
  :commands flymake-ansible-lint-setup)

;;https://olddeuteronomy.github.io/post/cpp-programming-in-emacs/
;;My custom my/flymake-toggle-diagnostics-buffer function toggles the Flymake diagnostics buffer window.
(defun my/flymake-toggle-diagnostics-buffer ()
  (interactive)
  ;; Check if we are in the diagnostics buffer.
  (if (string-search "*Flymake diagnostics" (buffer-name))
      (delete-window)
    (progn
      ;; Activate the Flymake diagnostics buffer.
      ;; and switch to it
      (flymake-show-buffer-diagnostics)
      (let ((name (flymake--diagnostics-buffer-name)))
        (if (get-buffer name)
            (switch-to-buffer-other-window name)
          (error "No Flymake diagnostics buffer found")
          )))))
;; diagnostics buffer bound to F7
(global-set-key [(f7)] #'my/flymake-toggle-diagnostics-buffer)
;; Additional bindings.
(global-set-key (kbd "C-c f b") #'flymake-show-buffer-diagnostics)
(global-set-key (kbd "C-c f p") #'flymake-show-project-diagnostics)


;; ====================
;; python
;; ====================
;; find the python executable
(defconst my-python-exec
  (or (executable-find "python3")
      (executable-find "python")
      "/usr/bin/python3"))

(setq python-shell-interpreter my-python-exec)

(use-package pyvenv
  :ensure t
  :init
  (setenv "WORKON_HOME" "~/pyvenv/")
  :config
  (setq pyvenv-default-virtual-env-name "venv")
  (setq python-shell-interpreter my-python-exec)
  (pyvenv-mode t)

  ;; Activate a real virtualenv directory, not the WORKON_HOME itself
  (let ((default-venv
         (expand-file-name pyvenv-default-virtual-env-name
                           (getenv "WORKON_HOME"))))
    (when (file-directory-p default-venv)
      (python-activate default-venv)))

  )


;; ====================
;; Company
;; ====================
(use-package company
  :ensure t
  :init (global-company-mode)
  :config
  (setq company-idle-delay 0.2) ;; how long to wait before popup
  (setq company-minimum-prefix-length 2)
  (setq company-tooltip-limit 10) ;; maximum number of candidates in popup
  (setq company-tooltip-flip-when-above t) ;; flip the popup when the cursor is above it
  ;; (setq company-show-numbers t) - obsolete
  (setq company-show-quick-access t)
  ;; To prevent default down-casing.
  ;; https://emacs.stackexchange.com/questions/10837/how-to-make-company-mode-be-case-sensitive-on-plain-text
  (setq company-dabbrev-downcase nil)
  ;; 2023-01-13 From a Reddit post on mixed case issue.
  (setq company-dabbrev-ignore-case nil)
  (setq company-dabbrev-code-ignore-case nil))


(use-package company-ansible
  :ensure t
  :after company
  :commands company-ansible
  :init
  (defun my-enable-company-ansible ()
    (require 'company-ansible)
    (company-mode 1)
    (add-to-list (make-local-variable 'company-backends) 'company-ansible))
  :config
  (add-hook 'ansible-mode-hook #'my-enable-company-ansible)
  (add-hook 'ansible-hook #'my-enable-company-ansible))

;; ====================
;; Code Navigation
;; ====================
;; Show the current buffer's imenu entries in a separate buffer
(use-package imenu-list
  :ensure t
  :config
  (setq imenu-list-focus-after-activation t)
  (global-set-key (kbd "C-.") #'imenu-list-minor-mode)
)

;; ====================
;; ansible
;; ====================
(use-package yaml-mode
  :mode "\\.ya?ml\\'"
  :ensure t
)


(use-package ansible
  :ensure t
  :preface
  (defun my-ansible-yaml-p ()
    (let ((file-name (or buffer-file-name "")))
      (not
       (null
        (or (string-match-p
             "/\\(playbooks\\|roles\\|tasks\\|handlers\\|vars\\|defaults\\|group_vars\\|host_vars\\)/"
             file-name)
            (string-match-p
             "\\(?:^\\|/\\)\\(site\\|playbook\\|.*playbook.*\\)\\.ya?ml\\'"
             file-name)
            (save-excursion
              (goto-char (point-min))
              (let ((limit (save-excursion
                             (forward-line 80)
                             (point))))
                (re-search-forward
                 "^[[:space:]]*-?[[:space:]]*\\(hosts\\|tasks\\|roles\\|collections\\|gather_facts\\|become\\):\\(?:[[:space:]]\\|$\\)"
                 limit
                 t))))))))
  (defun my-enable-ansible-yaml ()
    (when (my-ansible-yaml-p)
      (ansible-mode 1)
      (my-enable-company-ansible)
      (when (fboundp 'ansible-doc-mode)
        (ansible-doc-mode 1))
      (when (fboundp 'flymake-ansible-lint-setup)
        (condition-case nil
            (progn
              (flymake-ansible-lint-setup)
              (flymake-mode 1))
          (file-missing nil)))))
  :hook ((yaml-mode yaml-ts-mode) . my-enable-ansible-yaml))

(use-package ansible-doc
  :ensure t
  :after ansible)

;;(use-package ansible
;;  :ensure t
;;  :init (add-hook 'yaml-mode-hook #'(lambda () (ansible-mode 1)))
;;  )

;; ====================
;; c / c++ stuff
;; ====================
;; https://olddeuteronomy.github.io/post/cpp-programming-in-emacs/
;; .h files to open in c++-mode rather than c-mode.
(add-to-list 'auto-mode-alist '("\\.h$" . c++-mode))
;; code Styles
(setq c-default-style "stroustrup")
(setq c-basic-indent 4)
(setq c-basic-offset 4)
;; emacs-fu: don’t indent inside of C++ namespaces
;; http://brrian.tumblr.com/post/9018043954/emacs-fu-dont-indent-inside-of-c-namespaces
(c-set-offset 'innamespace 0)

;; Highlights the word/symbol at point and any other occurrences in
;; view. Also allows to jump to the next or previous occurrence.
;; https://github.com/nschum/highlight-symbol.el
(use-package highlight-symbol
  :ensure t
  :config
  (setq highlight-symbol-on-navigation-p t)
  (add-hook 'prog-mode-hook 'highlight-symbol-mode))

;; Emacs minor mode that highlights numeric literals in source code.
;; https://github.com/Fanael/highlight-numbers
(use-package highlight-numbers
  :ensure t
  :config
  (add-hook 'prog-mode-hook 'highlight-numbers-mode))

;; http://www.reddit.com/r/emacs/comments/2keh6u/show_tabs_and_trailing_whitespaces_only/
(use-package whitespace
  :config
  ;; Commented since there are too many 'valid' whitespaces in some modes.
  ;; (setq-default show-trailing-whitespace t)
  (setq whitespace-style '(face tabs trailing))
  (set-face-attribute 'whitespace-tab nil
      :background "red"
      :foreground "yellow"
      :weight 'bold)
  (add-hook 'prog-mode-hook 'whitespace-mode)
  ;; Delete trailing tabs and spaces on save of a file.
  (add-hook 'before-save-hook 'whitespace-cleanup)
)




;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(global-display-line-numbers-mode t)
 '(package-selected-packages
   '(all-the-icons all-the-icons-dired all-the-icons-ibuffer
                   all-the-icons-ivy ansible ansible-doc
                   better-defaults borland-blue-theme company company-ansible
                   direnv flycheck flycheck-yamllint flymake-ansible-lint
                   highlight-indentation highlight-numbers
                   highlight-symbol imenu-list ivy material-theme
                   monokai-pro-theme projectile pyvenv treemacs
                   treemacs-all-the-icons treemacs-projectile yaml-mode)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "AnonymicePro Nerd Font" :foundry "mlss" :slant normal :weight bold :height 120 :width normal)))))
