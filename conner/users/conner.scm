(define-module (conner users conner)
  #:use-module (conner users)
  #:use-module (conner packages prism-launcher)
  #:use-module (gnu system shadow)
  #:use-module (gnu home)
  #:use-module (gnu packages)
  #:use-module (gnu packages gnupg)
  #:use-module (gnu services)
  #:use-module (guix gexp)
  #:use-module (gnu home services shells)
  #:use-module (gnu home services syncthing)
  #:use-module (gnu home services gnupg)
  #:use-module (guix build utils)
  #:use-module (gnu packages shellutils)
  #:use-module (nongnu packages mozilla)
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

(define-public conner-home
  (home-environment
   (packages (specifications->packages (list
					"file"
					"git" "direnv" "ripgrep"
					"emacs" "guile" "emacs-geiser" "emacs-geiser-guile" "emacs-paredit" "emacs-magit" "emacs-envrc" "emacs-org"
					"htop" "btop"
					"tmux"
					"gnupg" "pinentry-tty"
					)))
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
                    (ssh-support? #t)))))))

(define-public conner-home-desktop
  (home-environment
   (packages (cons* firefox prism-launcher
		    (specifications->packages (list
					"ark" "file"
					"git" "direnv" "ripgrep"
					"keepassxc"
					"kate" "emacs" "guile" "emacs-geiser" "emacs-geiser-guile" "emacs-paredit" "emacs-magit" "emacs-envrc" "emacs-org"
					"htop" "btop"
					"freecad"
					"kicad" "kicad-doc" "kicad-footprints" "kicad-packages3d" "kicad-symbols" "kicad-templates"
					"libreoffice" "xsane"
					"openjdk@17"
					"tmux"
					"gnupg" "pinentry-qt"
					))))
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
                    (ssh-support? #t)))))))
  
  
