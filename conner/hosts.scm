(define-module (conner hosts)
  #:use-module (gnu system)
  #:use-module (gnu services)
  #:use-module (gnu services sddm)
  #:use-module (gnu services dbus)
  #:use-module (gnu packages kde-plasma)
  #:use-module (gnu packages kde-frameworks)
  #:use-module (gnu packages gnome)
  #:use-module (gnu services base)
  #:use-module (gnu services pm)
  #:use-module (gnu services linux)
  #:use-module (gnu services avahi)
  #:use-module (gnu services cups)
  #:use-module (gnu services desktop)
  #:use-module (gnu services networking)
  #:use-module (gnu services ssh)
  #:use-module (gnu services xorg)
  #:use-module (gnu packages scanner)
  #:use-module (gnu packages containers)
  #:use-module (gnu packages android)
  #:use-module (gnu system shadow)
  #:use-module (gnu system keyboard)
  #:use-module (gnu system mapped-devices)
  #:use-module (gnu system uuid)
  #:use-module (gnu system file-systems)
  #:use-module (gnu bootloader)
  #:use-module (gnu bootloader grub)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd)
  #:use-module (guix gexp)
  #:export (conner-os-base
	    conner-os-desktop
	    conner-laptop-os))

(define-public user-conner
  (user-account
   (name "conner")
   (comment "Conner Ebbinghaus")
   (group "users")
   (home-directory "/home/conner")
   (supplementary-groups '("wheel"))))

(define-public desktop-supplementary-groups '("netdev" "audio" "video" "kvm" "lp" "lpadmin" "adbusers"))

(define-public user-conner-desktop
  (user-account
   (inherit user-conner)
   (supplementary-groups (append (user-account-supplementary-groups user-conner) desktop-supplementary-groups))))

(define-public desktop-packages (cons* print-manager system-config-printer sane-airscan bluedevil bluez-qt podman podman-compose %base-packages))

(define-public (guix-config-with-nonguix-substitute config)
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

(define-public conner-os-base
  (operating-system
   (kernel linux)
   (initrd microcode-initrd)
   (firmware (list linux-firmware))
   (host-name "guix")
   (locale "en_US.utf8")
   (timezone "America/Detroit")
   (keyboard-layout (keyboard-layout "us"))
   (users (cons* user-conner %base-user-accounts))
   (services (append
	      common-extra-services 
	      (modify-services %base-services
			       (guix-service-type config => (guix-config-with-nonguix-substitute config)))))
   (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))
   (file-systems '())))


(define-public conner-os-desktop
  (operating-system
   (inherit conner-os-base)
   (users (cons* user-conner-desktop %base-user-accounts))
   (services (cons*
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
				(guix-service-type config => (guix-config-with-nonguix-substitute config))))))))

(define-public conner-laptop-os
  (operating-system
   (inherit conner-os-desktop)
   (host-name "conner-laptop")
   (mapped-devices (list (mapped-device
                          (source (uuid
                                   "cdafeeb3-6224-459b-a4e2-0e2f8634ca1c"))
                          (target "cryptroot")
                          (type luks-device-mapping))))

   (swap-devices (list (swap-space
			(target "/swapfile")
			(priority 0))))

   ;; The list of file systems that get "mounted".  The unique
   ;; file system identifiers there ("UUIDs") can be obtained
   ;; by running 'blkid' in a terminal.
   (file-systems (cons* (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "8680-A3DE"
                                       'fat32))
                         (type "vfat"))
			(file-system
                         (mount-point "/")
                         (device "/dev/mapper/cryptroot")
                         (type "ext4")
                         (dependencies mapped-devices)) %base-file-systems))))
