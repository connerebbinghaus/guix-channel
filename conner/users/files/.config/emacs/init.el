;;; init.el --- Initialization file for Emacs
;;; Commentary:
;;; Emacs Startup File --- initialization for Emacs
;;; Code:
(eval-when-compile
  (require 'use-package))

(cua-mode t)

(use-package geiser-guile)
(with-eval-after-load 'geiser-guile
  (add-to-list 'geiser-guile-load-path "~/Projects/guix")
  (add-to-list 'geiser-guile-load-path "~/Projects/nonguix")
  (add-to-list 'geiser-guile-load-path "~/Projects/sops-guix/modules")
  (add-to-list 'geiser-guile-load-path "~/Projects/guix-surface"))

(use-package treemacs :commands (treemacs))

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (rust-mode . lsp-deferred)
	 (cpp-mode . lsp-deferred))
  :commands (lsp lsp-deferred))

(use-package lsp-ui :commands lsp-ui-mode)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

(use-package flycheck
  :init (global-flycheck-mode))

(use-package company
  :hook (prog-mode . company-mode))

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode))

(add-hook 'after-init-hook (lambda () (load-theme 'tango-dark)))

(use-package envrc
  :hook (after-init . envrc-global-mode))

;; Fake the footer to avoid warnings
;; (provide 'init)
;;; init.el ends here
