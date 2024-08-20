
(define-module (conner systems desktop)
  #:use-module (conner systems)
  #:use-module (conner users conner)
  #:use-module (gnu system)
  #:use-module (gnu system shadow)
  #:use-module (gnu packages kde-plasma)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages scanner)
  #:use-module (gnu packages kde-frameworks)
  #:use-module (gnu packages containers)
  #:use-module (gnu packages android)
  #:use-module (gnu services)
  #:use-module (gnu services base)
  #:use-module (gnu services guix)
  #:use-module (gnu services desktop)
  #:use-module (gnu services sddm)
  #:use-module (gnu services cups)
  #:use-module (gnu services pm)
  #:use-module (gnu services xorg)
  #:export (desktop-packages
	    base-os-desktop))

(define-public desktop-packages (cons* print-manager system-config-printer sane-airscan bluedevil bluez-qt podman podman-compose %base-packages))

(define-public base-os-desktop
  (operating-system
   (inherit base-os)
   (users (cons* conner-user-desktop %base-user-accounts))
   (packages desktop-packages)
   (services (cons*
	      (service guix-home-service-type `(("conner" ,conner-home-desktop)))
	      (service plasma-desktop-service-type)
	      (service sddm-service-type)
	      (service cups-service-type
		       (cups-configuration
			(web-interface? #t)))
	      (service power-profiles-daemon-service-type)
	      (service bluetooth-service-type)
	      (udev-rules-service 'android android-udev-rules
				  #:groups '("adbusers"))
	      (append
	       common-extra-services 
	       (modify-services %desktop-services
				(delete gdm-service-type)
				(guix-service-type config => (guix-config-with-substitutes config))))))))
