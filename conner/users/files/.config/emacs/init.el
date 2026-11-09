;;; init.el --- Initialization file for Emacs  -*- lexical-binding: nil; -*-
;;; Commentary:
;;; Emacs Startup File --- initialization for Emacs
;;; Code:
(eval-when-compile
  (require 'use-package))

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
  :hook (
         (rust-mode . lsp-deferred)
	 (cpp-mode . lsp-deferred)
	 (python-mode . lsp-deferred))
  :commands (lsp lsp-deferred))

(use-package dap-mode
  :after lsp-mode
  :commands dap-debug
  :hook ((rust-mode . dap-ui-mode)
	 (cpp-mode . dap-mode)
	 (python-mode . dap-mode))
  :config
  (eval-when-compile
    (require 'cl))
  (require 'dap-python)
  (require 'dap-lldb))

(use-package yasnippet
  :hook ((lsp-mode . yas-minor-mode)))

(use-package lsp-ui :commands lsp-ui-mode)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

(use-package flycheck
  :hook (after-init . global-flycheck-mode))

(use-package company
  :hook (prog-mode . company-mode))

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode))

(add-hook 'after-init-hook (lambda () (load-theme 'tango-dark)))

(use-package envrc
  :hook (after-init . envrc-global-mode))

(use-package fontaine
  :ensure t
  :config
  (fontaine-mode 1)
  (fontaine-set-preset (or (fontaine-restore-latest-preset) 'regular))

  
  :custom
  (fontaine-presets
   '((t :default-family "Monospace"
        :default-weight regular
        :default-height 100
        :fixed-pitch-height 1.0
        :fixed-pitch-serif-height 1.0
        :variable-pitch-family "Sans"
        :variable-pitch-height 1.0
        :bold-weight bold
        :italic-slant italic
        :line-spacing nil
        :fixed-pitch-family nil
        :fixed-pitch-weight nil
        :fixed-pitch-serif-family nil
        :fixed-pitch-serif-weight nil
        :variable-pitch-weight nil
        :bold-family nil
        :italic-family nil)
     (regular :default-height 100)
     (large :default-weight semilight
            :default-height 140
            :bold-weight extrabold)

     (monaspace-argon :default-family "Monaspace Argon NF"
                      :default-height 100)
     (monaspace-argon-semi-bold :inherit monaspace-argon
                                :default-weight semibold)
     (monaspace-neon :default-family "Monaspace Neon NF"
                     :default-height 100)
     (monaspace-neon-regular :inherit monaspace-neon
                             :default-weight regular)
     (monaspace-neon-normal :inherit monaspace-neon
                            :default-weight normal)
     (monaspace-neon-semi-bold :inherit monaspace-neon
                               :default-weight semibold)
     (monaspace-xenon :default-family "Monaspace Xenon NF"
                      :default-height 100)
     (monaspace-xenon-semi-bold :inherit monaspace-xenon
                                :default-weight semibold))))

(use-package ligature
  :config
  (ligature-set-ligatures 'prog-mode
			  '(
			    "===" "!==" "=!=" "=/=" "/==" "/=" "#=" "==" "!=" "~~" "=~" "!~" "~-" "-~" "&=" ; ss01
			    ">=" "<=" ; ss02
			    "<-->" "<->" "<!--" "<--" "-->" "<-" "->" "<~>" "<~~" "~~>" "<~" "~>" ; ss03
			    "</" "/>" "</>" "<>" ; ss04
			    "[|" "|]" "/\\" "\\/" "|>" "<|" "<|>" "{|" "|}" ; ss05
			    "###" "+++" "&&&" ; ss06
			    "-:-" "=:=" ":>:" ":<:" "::>" "<::" "::" ":::" ; ss07
			    "..=" "..-" "..<" ".=" ".-" ; ss08
			    "<=>" "<<=" "=>>" "=<<" ">>=" "=>" "<<" ">>" ; ss09
			    "#[" "#(" "#![" ; ss10
			    "..." "///" "//" "!!" "||" ";;" ";;;" ; liga
			    ))
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t))

(setq inhibit-startup-screen t)

;; Fake the footer to avoid warnings
;; (provide 'init)
;;; init.el ends here
