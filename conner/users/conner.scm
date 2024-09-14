(define-module (conner users conner)
  #:use-module (conner users)
  #:use-module (conner packages prism-launcher)
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
  #:use-module (gnu packages kde)
  #:use-module (gnu packages kde-utils)
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
  #:use-module (gnu services)
  #:use-module (guix gexp)
  #:use-module (gnu home services)
  #:use-module (gnu home services shells)
  #:use-module (gnu home services syncthing)
  #:use-module (gnu home services gnupg)
  #:use-module (guix build utils)
  #:use-module (gnu packages shellutils)
  #:use-module (nongnu packages mozilla)
  #:use-module (nongnu packages game-client)
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
   emacs guile-3.0 emacs-guix emacs-geiser emacs-geiser-guile emacs-paredit emacs-magit emacs-envrc emacs-org
   htop btop
   tmux
   gnupg pinentry-tty
   sops))

(define-public %conner-packages-desktop
  (cons*
   firefox
   ark
   kate okular gwenview
   texlive emacs-auctex
   freecad
   kicad kicad-doc kicad-footprints kicad-packages3d kicad-symbols kicad-templates
   prusa-slicer
   libreoffice xsane
   openjdk21
   prism-launcher steam heroic
   keepassxc
   gimp inkscape blender
   virt-manager
   %conner-packages))

(define-public conner-home
  (home-environment
   (packages %conner-packages)
   (services
    (list (service home-bash-service-type
                   (home-bash-configuration
                    (guix-defaults? #t)
                    (bash-profile (list (plain-file "bash-profile" "\
export HISTFILE=$XDG_CACHE_HOME/.bash_history")))
					;(bashrc (list(plain-file "bashrc-dotenv"  (string-append "\
                                        ;eval \"$(" (which "direnv") " hook bash)\""))))))
                    ))
          (service home-gpg-agent-service-type
                   (home-gpg-agent-configuration
                    (pinentry-program
                     (file-append pinentry-tty "/bin/pinentry-tty"))
                    (ssh-support? #t)))
	  (simple-service 'my-entire-configuration
			  home-files-service-type
			  (list `(".config"
				  ,(local-file "files/.config" #:recursive? #t))))))))

(define-public conner-home-desktop
  (home-environment
   (packages %conner-packages-desktop)
   (services
    (list (service home-bash-service-type
                   (home-bash-configuration
                    (guix-defaults? #t)
                    (bash-profile (list (plain-file "bash-profile" "\
export HISTFILE=$XDG_CACHE_HOME/.bash_history")))
					;(bashrc (list(plain-file "bashrc-dotenv"  (string-append "\
                                        ;eval \"$(" (which "direnv") " hook bash)\""))))))
                    ))
          (service home-syncthing-service-type)
          (service home-gpg-agent-service-type
                   (home-gpg-agent-configuration
                    (pinentry-program
                     (file-append pinentry-qt "/bin/pinentry-qt"))
                    (ssh-support? #t)))
	  (simple-service 'my-entire-configuration
			  home-files-service-type
			  (list `(".config/emacs/init.el"
				  ,(local-file "files/.config/emacs/init.el"))))))))
  
  
