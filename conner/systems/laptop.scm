(define-module (conner systems laptop)
  #:use-module (conner systems desktop)
  #:use-module (gnu system)
  #:use-module (gnu system mapped-devices)
  #:use-module (gnu system file-systems)
  #:export (conner-laptop-os))
  
  

(define-public conner-laptop-os
  (operating-system
   (inherit base-os-desktop)
   (host-name "conner-laptop")
   (mapped-devices (list (mapped-device
                          (source (uuid
                                   "cdafeeb3-6224-459b-a4e2-0e2f8634ca1c"))
                          (target "cryptroot")
                          (type luks-device-mapping))))

   (swap-devices (list (swap-space
			(target "/swapfile")
			(priority 0))))
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
