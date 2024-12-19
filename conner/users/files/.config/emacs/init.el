(cua-mode t)
(with-eval-after-load 'geiser-guile
  (add-to-list 'geiser-guile-load-path "~/Projects/guix")
  (add-to-list 'geiser-guile-load-path "~/Projects/nonguix")
  (add-to-list 'geiser-guile-load-path "~/Projects/sops-guix")
  (add-to-list 'geiser-guile-load-path "~/Projects/guix-surface"))
  
(add-hook 'after-init-hook 'envrc-global-mode)
