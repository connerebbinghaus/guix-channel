(define-module (conner systems pc)
  #:use-module (conner systems)
  #:use-module (conner systems desktop)
  #:use-module (guix gexp)
  #:use-module (gnu services)
  #:use-module (gnu services virtualization)
  #:use-module (gnu system)
  #:use-module (gnu system file-systems)
  #:use-module (gnu packages firmware)
  #:export (conner-pc-os))

(define-public conner-pc-os
  (operating-system
   (inherit base-os-desktop)
   (host-name "conner-pc")
   (kernel-arguments
    (cons* "resume=/dev/nvme0n1p2"
           %default-kernel-arguments))
   (swap-devices (list (swap-space
                        (target (uuid
                                 "2c9faf91-40d3-489c-8fb8-a51faacb542b")))))
   (services (cons*
	      (service libvirt-service-type)
	      (service virtlog-service-type)
	      (extra-special-file "/usr/share/OVMF/OVMF_CODE.fd"
                    (file-append ovmf-x86-64 "/share/firmware/ovmf_x64.bin"))
	      desktop-extra-services))

   (file-systems (cons*
		  tmp-tmpfs-file-system
		  (file-system
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

