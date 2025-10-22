(define-module (conner users conner)
  #:use-module (conner users)
  #:use-module (conner packages prism-launcher)
  #:use-module (conner packages vesta)
  #:use-module (gnu system shadow)
  #:use-module (gnu home)
  #:use-module (gnu packages)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages file)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages shellutils)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu packages rust-apps)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu packages tmux)
  #:use-module (gnu packages kde-utils)
  #:use-module (gnu packages kde-internet)
  #:use-module (gnu packages kde-graphics)
  #:use-module (gnu packages engineering)
  #:use-module (gnu packages libreoffice)
  #:use-module (gnu packages scanner)
  #:use-module (gnu packages java)
  #:use-module (gnu packages password-utils)
  #:use-module (gnu packages texlive)
  #:use-module (gnu packages gimp)
  #:use-module (gnu packages graphics)
  #:use-module (gnu packages inkscape)
  #:use-module (gnu packages virtualization)
  #:use-module (gnu packages dns)
  #:use-module (gnu packages wine)
  #:use-module (gnu packages astronomy)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages video)
  #:use-module (gnu packages tor-browsers)
  #:use-module (gnu packages aspell)
  #:use-module (gnu packages tex)
  #:use-module (gnu packages tree-sitter)
  #:use-module (gnu packages gnuzilla)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages package-management)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages education)
  #:use-module (gnu packages cups)
  #:use-module (nongnu packages wine)
  #:use-module (nongnu packages productivity)
  #:use-module (gnu services)
  #:use-module (guix gexp)
  #:use-module (gnu home services)
  #:use-module (gnu home services shells)
  #:use-module (gnu home services syncthing)
  #:use-module (gnu home services gnupg)
  #:use-module (gnu home services sound)
  #:use-module (gnu home services desktop)
  #:use-module (guix build utils)
  #:use-module (gnu packages shellutils)
  #:use-module (nongnu packages mozilla)
  #:use-module (nongnu packages game-client)
  #:use-module (nongnu packages editors)
  #:use-module (sops packages sops)
  #:export (conner-user
	    conner-user-desktop
	    conner-home
	    conner-home-desktop))

(define-public conner-user
  (user-account
   (name "conner")
   (comment "Conner Ebbinghaus")
   (group "users")
   (home-directory "/home/conner")
   (supplementary-groups '("wheel"))))

(define-public conner-user-desktop
  (user-account
   (inherit conner-user)
   (supplementary-groups (append (user-account-supplementary-groups conner-user) desktop-supplementary-groups))))

(define-public %conner-packages
  (list
   file
   git direnv ripgrep
   emacs guile-3.0 emacs-guix emacs-geiser emacs-geiser-guile emacs-paredit emacs-magit emacs-envrc emacs-org emacs-lsp-mode emacs-lsp-ui emacs-flycheck emacs-company
   emacs-rustic tree-sitter-rust tree-sitter-bash tree-sitter-markdown tree-sitter-scheme tree-sitter-c tree-sitter-cpp tree-sitter-python tree-sitter-awk
   tree-sitter-lua emacs-doom-modeline emacs-use-package emacs-treemacs emacs-lsp-treemacs emacs-yasnippet emacs-yasnippet-snippets python-lsp-server
   htop btop
   tmux
   gnupg pinentry-tty
   sops
   netcat
   kdeconnect
   `(,isc-bind "utils")))

(define-public %conner-packages-desktop
  (cons*
   firefox torbrowser
   vscodium
   ark
   kate okular gwenview
   aspell aspell-dict-en ;;texlive texlive-biber emacs-auctex tree-sitter-latex tree-sitter-bibtex
   freecad
   kicad kicad-doc kicad-footprints kicad-packages3d kicad-symbols kicad-templates
   prusa-slicer
   libreoffice simple-scan ;; xsane
   openjdk21
   prism-launcher steam heroic
   keepassxc
   gimp inkscape blender
   ;;virt-manager
   wine64 winetricks
   stellarium
   font-google-noto font-google-noto-serif-cjk font-google-noto-sans-cjk font-google-noto-emoji
   mpv
   icedove/wayland
   vesta
   zotero
   flatpak
   cups
   %conner-packages))

(define-public conner-home
  (home-environment
   (packages %conner-packages)
   (services
    (cons* (service home-bash-service-type
                   (home-bash-configuration
                    (guix-defaults? #t)
                    (bash-profile (list (plain-file "bash-profile" "\
export HISTFILE=$XDG_CACHE_HOME/.bash_history")))
		    (bashrc (list (plain-file "bashrc-dotenv"  (string-append "\
eval \"$(direnv hook bash)\""))))))
          (service home-gpg-agent-service-type
                   (home-gpg-agent-configuration
                    (pinentry-program
                     (file-append pinentry-tty "/bin/pinentry-tty"))
                    (ssh-support? #t)))
	  (simple-service 'my-entire-configuration
			  home-files-service-type
			  (list `(".config/emacs/init.el"
				  ,(local-file "files/.config/emacs/init.el"))))
	  %base-home-services))))

(define-public conner-home-desktop
  (home-environment
   (packages %conner-packages-desktop)
   (services
    (cons* (service home-bash-service-type
                   (home-bash-configuration
                    (guix-defaults? #t)
                    (bash-profile (list (plain-file "bash-profile" "\
export HISTFILE=$XDG_CACHE_HOME/.bash_history")))
		    (bashrc (list (plain-file "bashrc-dotenv"  (string-append "\
eval \"$(direnv hook bash)\""))))))
           (service home-syncthing-service-type)
	   (service home-dbus-service-type)
	   (service home-pipewire-service-type)
          (service home-gpg-agent-service-type
                   (home-gpg-agent-configuration
                    (pinentry-program
                     (file-append pinentry-qt "/bin/pinentry-qt"))
                    (ssh-support? #t)))
	  (simple-service 'my-entire-configuration
			  home-files-service-type
			  (list `(".config/emacs/init.el"
				  ,(local-file "files/.config/emacs/init.el"))))
	  %base-home-services))))
  
  
