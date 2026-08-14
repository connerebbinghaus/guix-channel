(define-module (conner systems surface)
  #:use-module (conner systems desktop)
  #:use-module (gnu services)
  #:use-module (gnu system)
  #:use-module (gnu system file-systems)
  #:use-module (surface packages linux)
  #:use-module (surface services touchscreen)
  #:export (conner-surface-os))
  
  

(define-public conner-surface-os
  (operating-system
   (inherit base-os-desktop)
   (host-name "conner-surface")
   (kernel linux-surface)
   (kernel-arguments
    (cons*
     "resume=/dev/nvme0n1p2"
     "cfg80211.ieee80211_regdom=US"
     (operating-system-user-kernel-arguments base-os-desktop)))
   (services (cons*
	      (service iptsd-service-type)
	      desktop-extra-services))
   (swap-devices (list (swap-space
			(target "/dev/nvme0n1p2")
			(priority 0))))
   (file-systems (cons* (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "F282-91EA"
                                       'fat32))
                         (type "vfat"))
			(file-system
                         (mount-point "/")
                         (device (uuid "e8a11dfb-0c64-4c24-b27b-2716a69337d4"))
                         (type "btrfs")) 
                        %base-file-systems))))
