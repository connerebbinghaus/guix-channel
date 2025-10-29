
(define-module (conner systems desktop)
  #:use-module (conner systems)
  #:use-module (conner users conner)
  #:use-module (conner packages swtpm)
  #:use-module (conner packages virtiofsd)
  #:use-module (gnu system)
  #:use-module (gnu system shadow)
  #:use-module (gnu system privilege)
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
  #:use-module (gnu services networking)
  #:use-module (gnu packages firmware)
  #:use-module (guix gexp)
  #:use-module (nongnu packages firmware)
  #:use-module (nongnu packages printers)
  #:export (desktop-packages
	    base-os-desktop))

(define-public desktop-packages (cons* print-manager system-config-printer sane-airscan ipp-usb hplip hplip-plugin bluedevil bluez-qt docker docker-compose swtpm virtiofsd fwupd-nonfree %base-packages))

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
	      (service libvirt-service-type)
	      (service virtlog-service-type)
	      (service containerd-service-type)
	      (service docker-service-type)
	      (extra-special-file "/usr/share/OVMF/OVMF_CODE.fd"
				  (file-append ovmf-x86-64 "/share/firmware/ovmf_x64.bin"))
	      (simple-service 'spice-polkit polkit-service-type (list spice-gtk))
	      (simple-service 'fwupd-dbus dbus-root-service-type (list fwupd-nonfree))
	      (append
	       common-extra-services 
	       (modify-services %desktop-services
				(delete gdm-service-type)
				(guix-service-type config => (guix-config-with-substitutes config))
				(network-manager-service-type config => (network-manager-configuration
									 (dns "dnsmasq")
									 (vpn-plugins (list network-manager-openconnect))))
				))))

(define-public base-os-desktop
  (operating-system
   (inherit base-os)
   (users (cons* conner-user-desktop %base-user-accounts))
   (packages desktop-packages)
   (services desktop-extra-services)
   (privileged-programs
    (append (list (privileged-program
                   (program (file-append spice-gtk "/libexec/spice-client-glib-usb-acl-helper"))
		   (setuid? #t)))
            %default-privileged-programs))))
