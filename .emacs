;; Initialize package system
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("ublt" . "https://elpa.ubolonton.org/packages/") t)
(package-initialize)

;; Load custom configuration files
(load "~/.emacs.rc/rc.el")
(load "~/.emacs.rc/misc-rc.el")
(load "~/.emacs.rc/org-mode-rc.el" t)
(load "~/.emacs.rc/autocommit-rc.el" t)
(load "~/.emacs.shadow/shadow-rc.el" t)

;; Ensure required packages
(dolist (pkg '(company yasnippet projectile find-file-in-project))
  (unless (package-installed-p pkg)
    (package-install pkg)))

;; Declare functions to suppress native compiler warnings
(declare-function jump "hindent")
(dolist (fn '(highlight-indentation python-send-buffer yas-minor-mode yas-reload-all
              highlight-indentation-mode flymake-ler-text flymake-find-err-info
              flymake-goto-prev-error flymake-goto-next-error flymake-init-create-temp-buffer-copy
              eldoc-docstring-format-sym-doc company-doc-buffer company-dabbrev-code
              company-grab-symbol-cons company-in-string-or-comment company-begin-backend
              company-grab-symbol company-mode elpy-xref--apropos elpy-xref--get-completion-table
              elpy-xref--references elpy-xref--goto-identifier elpy-xref--definitions
              elpy-xref--identifier-name elpy-xref--identifier-line elpy-xref--identifier-at-point
              ffip-project-search projectile-current-project-files projectile-project-root))
  (declare-function fn "elpy"))

;; UI settings
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode 1)
(show-paren-mode 1)
(when (version<= "26.0.50" emacs-version)
  (global-display-line-numbers-mode)
  (setq display-line-numbers-type 'relative))

;; Font size
(set-face-attribute 'default nil :font "FiraCode" :height 140)

;; Whitespace settings
(setq whitespace-style
      '(face tabs spaces trailing space-before-tab indentation empty space-after-tab space-mark tab-mark))
(defun rc/set-up-whitespace-handling ()
  (whitespace-mode 1)
  (add-hook 'write-file-functions 'delete-trailing-whitespace nil t))
(dolist (hook '(tuareg-mode-hook c++-mode-hook c-mode-hook emacs-lisp-mode-hook
                rust-mode-hook markdown-mode-hook python-mode-hook asm-mode-hook nasm-mode-hook))
  (add-hook hook 'rc/set-up-whitespace-handling))

;; Theme
(setq catppuccin-flavor 'macchiato) ; or 'latte, 'macchiato, or 'mocha
    (load-theme 'catppuccin t)

; (rc/require-theme 'gruber-darker)

;; IDO and Smex
(require 'ido-completing-read+)
(require 'smex)
(ido-mode 1)
(ido-everywhere 1)
(ido-ubiquitous-mode 1)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; Company (autocompletion)
(require 'company)
(global-company-mode 1)
(add-hook 'tuareg-mode-hook (lambda () (company-mode 0)))

;; Yasnippet
(require 'yasnippet)
(setq yas-snippet-dirs '("~/.emacs.snippets/"))
(yas-global-mode 1)

;; LSP for C/C++
(require 'lsp-mode)
(add-hook 'c-mode-hook 'lsp-deferred)
(add-hook 'c++-mode-hook 'lsp-deferred)
(require 'lsp-ui)

;; C mode settings
(setq c-basic-offset 4
      c-default-style '((java-mode . "java") (awk-mode . "awk") (other . "bsd")))
(add-hook 'c-mode-hook (lambda () (c-toggle-comment-style -1)))

;; Paredit for Lisp modes
(require 'paredit)
(dolist (hook '(emacs-lisp-mode-hook clojure-mode-hook lisp-mode-hook
                common-lisp-mode-hook scheme-mode-hook racket-mode-hook))
  (add-hook hook 'paredit-mode))

;; Emacs Lisp
(add-hook 'emacs-lisp-mode-hook
          (lambda () (local-set-key (kbd "C-c C-j") 'eval-print-last-sexp)))
(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
(add-to-list 'auto-mode-alist '("Cask" . emacs-lisp-mode))

;; Haskell
(require 'haskell-mode)
(require 'hindent)
(setq haskell-process-type 'cabal-new-repl
      haskell-process-log t)
(dolist (hook '(haskell-indent-mode interactive-haskell-mode haskell-doc-mode hindent-mode))
  (add-hook 'haskell-mode-hook hook))

;; Elpy for Python
(require 'elpy)
(elpy-enable)
(add-hook 'python-mode-hook 'elpy-mode)

;; Other packages (no configuration needed)
(dolist (pkg '(scala-mode d-mode yaml-mode glsl-mode tuareg lua-mode less-css-mode
               graphviz-dot-mode clojure-mode cmake-mode rust-mode csharp-mode
               nim-mode jinja2-mode markdown-mode purescript-mode nix-mode
               dockerfile-mode toml-mode nginx-mode kotlin-mode go-mode php-mode
               racket-mode qml-mode ag typescript-mode rfc-mode sml-mode))
  (require pkg))

(require 'elcord)
(elcord-mode)

;; Custom variables
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("9b9d7a851a8e26f294e778e02c8df25c8a3b15170e6f9fd6965ac5f2544ef2a9"
     "7de64ff2bb2f94d7679a7e9019e23c3bf1a6a04ba54341c36e7cf2d2e56e2bcc"
     "b5fd9c7429d52190235f2383e47d340d7ff769f141cd8f9e7a4629a81abc6b19"
     "014cb63097fc7dbda3edf53eb09802237961cbb4c9e9abd705f23b86511b0a69"
     "01a9797244146bbae39b18ef37e6f2ca5bebded90d9fe3a2f342a9e863aaa4fd"
     "276228257774fa4811da55346b1e34130edb068898565ca07c2d83cfb67eb70a"
     default))
 '(org-agenda-dim-blocked-tasks nil)
 '(org-agenda-exporter-settings '((org-agenda-tag-filter-preset (list "+personal"))))
 '(org-cliplink-transport-implementation 'url-el)
 '(org-enforce-todo-dependencies nil)
 '(org-modules
   '(org-bbdb org-bibtex org-docview org-gnus org-habit org-info org-irc
              org-mhe org-rmail org-w3m))
 '(org-refile-use-outline-path 'file)
 '(package-selected-packages
   '(ag all-the-icons auto-complete-c-headers auto-complete-clang
        ayu-theme catppuccin-theme clojure-mode cmake-mode d-mode
        dash-functional diredfl dockerfile-mode doom-themes elcord
        elpy find-file-in-project flycheck-clangcheck glsl-mode
        go-mode graphviz-dot-mode gruber-darker-theme haskell-mode
        helm-company helm-ls-git helm-projectile hindent
        ido-completing-read+ ivy jinja2-mode kotlin-mode lsp-treemacs
        lsp-ui lua-mode magit move-text multiple-cursors nasm-mode
        nginx-mode nim-mode nix-mode org-cliplink paredit
        paredit-everywhere paredit-menu php-mode powershell
        projectile-ripgrep proof-general purescript-mode qml-mode
        racket-mode rfc-mode rust-mode scala-mode smartparens smex
        sml-mode tide toml-mode tree-sitter treesit-auto tuareg
        typescript-mode vertico vterm yaml-mode yasnippet-snippets))
 '(safe-local-variable-values
   '((eval progn (auto-revert-mode 1) (rc/autopull-changes)
           (add-hook 'after-save-hook 'rc/autocommit-changes nil
                     'make-it-local)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
