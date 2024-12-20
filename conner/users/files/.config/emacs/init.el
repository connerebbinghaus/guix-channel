(cua-mode t)
(with-eval-after-load 'geiser-guile
  (add-to-list 'geiser-guile-load-path "~/Projects/guix")
  (add-to-list 'geiser-guile-load-path "~/Projects/nonguix")
  (add-to-list 'geiser-guile-load-path "~/Projects/sops-guix/modules")
  (add-to-list 'geiser-guile-load-path "~/Projects/guix-surface"))

(require 'lsp-mode)
(add-hook 'prog-mode-hook #'lsp-deferred)

(global-flycheck-mode +1)
(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'after-init-hook 'envrc-global-mode)
