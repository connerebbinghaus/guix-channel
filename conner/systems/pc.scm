(define-module (conner systems pc)
  #:use-module (conner systems desktop)
  #:use-module (gnu system)
  #:use-module (gnu system file-systems)
  #:export (conner-pc-os))

(define-public conner-pc-os
  (operating-system
   (inherit base-os-desktop)
   (host-name "conner-pc")
   (swap-devices (list (swap-space
                        (target (uuid
                                 "2c9faf91-40d3-489c-8fb8-a51faacb542b")))))
   (file-systems (cons* (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "A9F2-DB4A"
                                       'fat32))
                         (type "vfat"))
			(file-system
                         (mount-point "/")
                         (device (uuid
                                  "2a8fea67-f10c-451d-b071-d639b7528ea4"
                                  'ext4))
                         (type "ext4")) %base-file-systems))))

