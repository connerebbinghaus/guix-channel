(define-module (conner systems pc)
  #:use-module (conner systems desktop)
  #:use-module (gnu system)
  #:use-module (gnu system file-systems)
  #:use-module (gnu services)
  #:use-module (gnu services certbot)
  #:use-module (gnu services web)
  #:export (conner-pc-os))

(define substitute-location
  (nginx-location-configuration
   (uri "/")
   (body (list
	  "proxy_pass http://localhost:8999;"
	  "proxy_set_header Host $host;"
	  "proxy_redirect http:// https://;"
	  "proxy_http_version 1.1;"
	  "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;"))))
	  
(define substitute-server
  (nginx-server-configuration
   (server-name (list "cebbing.tplinkdns.com"))
   (listen '("443 ssl" "[::]:443 ssl"))
   (ssl-certificate "/etc/certs/cebbing.tplinkdns.com/fullchain.pem")
   (ssl-certificate-key "/etc/certs/cebbing.tplinkdns.com/privkey.pem")
   (locations (list substitute-location))))

(define-public conner-pc-os
  (operating-system
   (inherit base-os-desktop)
   (host-name "conner-pc")
   (services (cons*
	      (service certbot-service-type
		       (certbot-configuration
			(email "connerebbinghaus@gmail.com")
			(certificates
			 (list
			  (certificate-configuration
			   (domains '("cebbing.tplinkdns.com")))))))
	      (service nginx-service-type
		       (nginx-configuration
			(server-blocks (list substitute-server))))
	      (operating-system-services base-os-desktop)))
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

