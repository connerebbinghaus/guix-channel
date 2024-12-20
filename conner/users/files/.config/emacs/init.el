;;; init.el --- Initialization file for Emacs
;;; Commentary:
;;; Emacs Startup File --- initialization for Emacs
;;; Code:
(require 'lsp-mode)
(require 'flycheck)
(require 'doom-modeline)
(require 'geiser)

(cua-mode t)
(with-eval-after-load 'geiser-guile
  (add-to-list 'geiser-guile-load-path "~/Projects/guix")
  (add-to-list 'geiser-guile-load-path "~/Projects/nonguix")
  (add-to-list 'geiser-guile-load-path "~/Projects/sops-guix/modules")
  (add-to-list 'geiser-guile-load-path "~/Projects/guix-surface"))

(add-hook 'rust-mode-hook #'lsp-deferred)
(add-hook 'cpp-mode-hook #'lsp-deferred)

(add-hook 'after-init-hook #'global-flycheck-mode)
(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'after-init-hook 'envrc-global-mode)
(add-hook 'after-init-hook #'doom-modeline-mode)
(add-hook 'after-init-hook (lambda () (load-theme 'tango-dark)))

;; Fake the footer to avoid warnings
;; (provide 'init)
;;; init.el ends here
