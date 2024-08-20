(define-module (conner systems)
  #:use-module (conner users conner)
  #:use-module (gnu system)
  #:use-module (gnu system shadow)
  #:use-module (gnu services)
  #:use-module (gnu services base)
  #:use-module (gnu services guix)
  #:use-module (gnu services linux)
  #:use-module (gnu services ssh)
  #:use-module (gnu system keyboard)
  #:use-module (gnu bootloader)
  #:use-module (gnu bootloader grub)
  #:use-module (guix gexp)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd)
  #:export (guix-config-with-substitutes
	    common-extra-services
	    base-os))


(define-public (guix-config-with-substitutes config)
  (guix-configuration
   (inherit config)
   (substitute-urls
    (append (list "https://substitutes.nonguix.org")
	    %default-substitute-urls))
   (authorized-keys
    (append (list (plain-file "non-guix.pub"
			      "(public-key (ecc (curve Ed25519) (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))"))
	    %default-authorized-guix-keys))))

(define-public common-extra-services
  (list
   (service openssh-service-type)
   (service zram-device-service-type (zram-device-configuration
                                      (size "8G")
                                      (priority 32766)))))

(define-public base-os
  (operating-system
   (kernel linux)
   (initrd microcode-initrd)
   (firmware (list linux-firmware))
   (host-name "guix")
   (locale "en_US.utf8")
   (timezone "America/Detroit")
   (keyboard-layout (keyboard-layout "us"))
   (users (cons* conner-user %base-user-accounts))
   (services (append
	      common-extra-services 
	      (cons*
	       (service guix-home-service-type conner-home)
	       (modify-services %base-services
			       (guix-service-type config => (guix-config-with-substitutes config))))))
   (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))
   (file-systems '())))
