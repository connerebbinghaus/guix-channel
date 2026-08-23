
(define-module (conner systems desktop)
  #:use-module (conner systems)
  #:use-module (conner users conner)
  #:use-module (conner packages swtpm)
  #:use-module (conner packages virtiofsd)
  #:use-module (conner packages vpn)
  #:use-module (gnu system)
  #:use-module (gnu system shadow)
  #:use-module (gnu system privilege)
  #:use-module (gnu system nss)
  #:use-module (gnu system file-systems)
  #:use-module (gnu packages kde-plasma)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages scanner)
  #:use-module (gnu packages kde-frameworks)
  #:use-module (gnu packages containers)
  #:use-module (gnu packages android)
  #:use-module (gnu packages spice)
  #:use-module (gnu packages docker)
  #:use-module (gnu packages cups)
  #:use-module (gnu packages printers)
  #:use-module (gnu packages nfs)
  #:use-module (gnu packages vpn)
  #:use-module (nongnu packages printers)
  #:use-module (gnu services)
  #:use-module (gnu services base)
  #:use-module (gnu services guix)
  #:use-module (gnu services desktop)
  #:use-module (gnu services sddm)
  #:use-module (gnu services cups)
  #:use-module (gnu services pm)
  #:use-module (gnu services xorg)
  #:use-module (gnu services virtualization)
  #:use-module (gnu services dbus)
  #:use-module (gnu services docker)
  #:use-module (gnu services nfs)
  #:use-module (gnu services networking)
  #:use-module (gnu services kerberos)
  #:use-module (gnu services shepherd)
  #:use-module (gnu packages firmware)
  #:use-module (gnu packages networking)
  #:use-module (gnu packages vulkan)
  #:use-module (gnu packages radio)
  #:use-module (gnu packages kerberos)
  #:use-module (guix gexp)
  #:use-module (nongnu packages firmware)
  #:use-module (nongnu packages printers)
  #:export (desktop-packages
	    base-os-desktop))

(define rtl-sdr-modprobe
  (plain-file "rtl-sdr.conf"
              "blacklist dvb_usb_rtl28xxu
blacklist dvb_usb_rtl2832u
blacklist rtl2832
blacklist rtl2830"))

(define-public desktop-packages (cons* print-manager system-config-printer sane-airscan ipp-usb hplip hplip-plugin sane-backends bluedevil bluez-qt swtpm virtiofsd fwupd-nonfree iwd globalprotect-openconnect vpn-slice vulkan-loader rtl-sdr nfs-utils mit-krb5 %base-packages))

(define-public desktop-extra-services (cons*
	      (service guix-home-service-type `(("conner" ,conner-home-desktop)))
	      (service plasma-desktop-service-type)
	      (service sddm-service-type
		       (sddm-configuration
			;; (display-server "wayland")
			(theme "breeze")))
	      (service cups-service-type
		       (cups-configuration
			(web-interface? #t)
			(extensions
			 (list brlaser cups-filters epson-inkjet-printer-escpr foomatic-filters hplip-minimal splix hplip-plugin))))
	      (service power-profiles-daemon-service-type)
	      (service bluetooth-service-type)
	      (udev-rules-service 'android android-udev-rules
				  #:groups '("adbusers"))
	      (udev-rules-service 'rtl-sdr rtl-sdr)
	      (simple-service 'rtl-sdr-modprobe-conf etc-service-type
                                   (list `("modprobe.d/rtl-sdr.conf"
                                           ,rtl-sdr-modprobe)))
	      (service libvirt-service-type)
	      (service virtlog-service-type)
	      (service containerd-service-type)
	      (service docker-service-type)
	      (extra-special-file "/usr/share/OVMF/OVMF_CODE.fd"
				  (file-append ovmf-x86-64 "/share/firmware/ovmf_x64.bin"))
	      (simple-service 'spice-polkit polkit-service-type (list spice-gtk))
	      (simple-service 'globalprotect-openconnect-hook special-files-service-type
			      (list
			       `("/etc/NetworkManager/dispatcher.d/gpclient-nm-hook" ,(file-append globalprotect-openconnect "/etc/NetworkManager/dispatcher.d/gpclient-nm-hook"))
			       `("/etc/NetworkManager/dispatcher.d/pre-down.d/gpclient.down" ,(file-append globalprotect-openconnect "/etc/NetworkManager/dispatcher.d/pre-down.d/gpclient.down"))))
	      (service iwd-service-type)
	      (simple-service 'guix-moe guix-service-type
			      (guix-extension
			       (authorized-keys
				(list (plain-file "guix-moe-old.pub"
						  "(public-key (ecc (curve Ed25519) (q #374EC58F5F2EC0412431723AF2D527AD626B049D657B5633AAAEBC694F3E33F9#)))")
				      ;; New key since 2025-10-29.
				      (plain-file "guix-moe.pub"
						  "(public-key (ecc (curve Ed25519) (q #552F670D5005D7EB6ACF05284A1066E52156B51D75DE3EBD3030CD046675D543#)))")))
			       (substitute-urls
				'("https://cache-cdn.guix.moe"))))
	      (service krb5-service-type
		       (krb5-configuration
			(default-realm "EBBINGHA.US")
			(dns-canonicalize-hostname? #f)			
			(realms (list
				 (krb5-realm
				  (name "EBBINGHA.US")
				  (admin-server "kerberos.ebbingha.us")
				  (kdc "kerberos.ebbingha.us"))))))
	      (service pam-krb5-service-type (pam-krb5-configuration))
	      (service gss-service-type (gss-configuration))
	      (service rpcbind-service-type (rpcbind-configuration))
	      (service pipefs-service-type (pipefs-configuration))
              (simple-service 'network-online shepherd-root-service-type
		  (list
		   (shepherd-service
		    (requirement '(networking))
		    (provision '(network-online))
		    (documentation "Wait for the network to come up.")
		    (start #~(lambda _
			       (let* ((cmd
				       "set -eux
c=0
while ! /run/setuid-programs/ping -qc1 -W1 example.org; do
	sleep 1
	[ \"$((c += 1))\" -lt 30 ] || exit 1  # Limit the wait time
done
")
				      (status (system cmd)))
				 (= 0 (status:exit-val status)))))
		    (one-shot? #t))))
	      (append
	       common-extra-services 
	       (modify-services %desktop-services
				(delete gdm-service-type)
				(delete wpa-supplicant-service-type)
				(guix-service-type config => (guix-config-with-substitutes config))
				(network-manager-service-type config => (network-manager-configuration
									 (vpn-plugins (list network-manager-openconnect))
									 (shepherd-requirement (list 'iwd))))))))

(define-public nas-nfs-filesystem
  (file-system
   (type "nfs4")
   (device "nas.ebbingha.us:/storage")
   (mount-point "/mnt/nas")
   (options "rw,rsize=1048576,wsize=1048576,vers=4,sec=krb5i")
   (create-mount-point? #t)
   (mount-may-fail? #t)
   (shepherd-requirements '(network-online))))

(define-public base-os-desktop
  (operating-system
   (inherit base-os)
   (users (cons* conner-user-desktop %base-user-accounts))
   (packages desktop-packages)
   (services desktop-extra-services)
   (name-service-switch %mdns-host-lookup-nss)
   (privileged-programs
    (append (list (privileged-program
                   (program (file-append spice-gtk "/libexec/spice-client-glib-usb-acl-helper"))
		   (setuid? #t)))
            %default-privileged-programs))))
