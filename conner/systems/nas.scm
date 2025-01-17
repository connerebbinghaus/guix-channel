(define-module (conner systems nas)
  #:use-module (conner systems)
  #:use-module (conner users conner)
  #:use-module (gnu system)
  #:use-module (gnu system file-systems)
  #:use-module (gnu services)
  #:use-module (gnu services base)
  #:use-module (gnu services avahi)
  #:use-module (gnu services guix)
  #:use-module (gnu services dns)
  #:use-module (gnu services web)
  #:use-module (gnu services networking)
  #:use-module (gnu services desktop)
  #:use-module (gnu services certbot)
  #:export (nas-os))

;; ======== DNS =========
(define-zone-entries ebbingha.us.zone
;; Name            TTL Class Type     Data
  ("@"             ""  "IN"  "NS"     "nas")
  ("@"             ""  "IN"  "NS"     "ns2.afraid.org.")
  ("nas"           ""  "IN"  "A"      "0.0.0.0") ;; Updated by DDNS
  ("nas"           ""  "IN"  "AAAA"   "2001:470:c07b::2")
  ("immich"        ""  "IN"  "CNAME"  "nas")
  ("homeassistant" ""  "IN"  "A"      "0.0.0.0") ;; Updated by DDNS
  ("router"        ""  "IN"  "A"      "0.0.0.0") ;; Updated by DDNS
  ("router"        ""  "IN"  "AAAA"   "2001:470:c07b::1"))

(define afraid-slave
  (knot-remote-configuration
   (id "afraid-slave")
   (address (list "69.65.50.192" "2001:1850:1:5:800::6b"))))

(define ebbingha-us-master-zone
  (knot-zone-configuration
   (domain "ebbingha.us")
   (zone (zone-file
	  (origin "ebbingha.us")
	  (serial 2024101800)
	  (entries ebbingha.us.zone)))
   (notify (list "afraid-slave"))
   (zonefile-sync -1)
   (zonefile-load 'difference)
   (journal-content ''changes) ;; This is surely a bug, needing to be double quoted
   (serial-policy 'increment)))

;; ======== NGINX =========
;; Note: Certbot will extend NGINX with a default location for its own purposes.
(define homeassistant-location
  (nginx-location-configuration
   (uri "/")
   (body (list
	  "proxy_pass http://192.168.1.4:8123;"
	  "proxy_set_header Host $host;"
	  "proxy_redirect http:// https://;"
	  "proxy_http_version 1.1;"
	  "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;"
	  "proxy_set_header Upgrade $http_upgrade;"
	  "proxy_set_header Connection $connection_upgrade;"))))


(define homeassistant-server
  (nginx-server-configuration
   (server-name (list "homeassistant.ebbingha.us"))
   (listen '("443 ssl" "[::]:443 ssl"))
   (ssl-certificate "/etc/certs/homeassistant.ebbingha.us/fullchain.pem")
   (ssl-certificate-key "/etc/certs/homassistant.ebbingha.us/privkey.pem")
   (raw-content (list
		 "add_header Strict-Transport-Security \"max-age=31536000; includeSubdomains\";"
		 "ssl_protocols TLSv1.2;"
		 "ssl_ciphers \"EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH:!aNULL:!eNULL:!EXPORT:!DES:!MD5:!PSK:!RC4\";"
		 "ssl_prefer_server_ciphers on;"
		 "ssl_session_cache shared:SSL:10m;"
		 "proxy_buffering off;"))
   (locations (list homeassistant-location))))   

(define-public nas-os
  (operating-system
   (inherit base-os)
   (host-name "nas")
   (services (cons*
	      (service avahi-service-type)
	      (service elogind-service-type)
	      (service guix-home-service-type `(("conner" ,conner-home)))
	      (service knot-service-type
		       (knot-configuration
			(remotes (list afraid-slave))
			(zones (list ebbingha-us-master-zone))))
;	      (service nginx-service-type
;		       (nginx-configuration
;			(shepherd-requirement (list 'renew-certbot-certificates)) ; Need certificates set up
;			(server-blocks (list homeassistant-server))
;			(extra-content "\n
;map $http_upgrade $connection_upgrade {
;    default upgrade;
;    ''      close;
;}")))
;	      (service certbot-service-type
;		       (certbot-configuration
;			(email "connerebbinghaus@gmail.com")
;			(server "https://acme-staging-v02.api.letsencrypt.org/directory") ; for testing
;			(certificates (list
;				       (certificate-configuration
;					(domains '("homeassistant.ebbingha.us")))))))

;	      (service static-networking-service-type
;		       (list (static-networking
;			      (addresses
;			       (list (network-address
;				      (device "enp5s0");
;				      (value "192.168.1.2/24"))))
;			      (routes
;			       (list (network-route
;				      (destination "default")
;				      (gateway "192.168.1.1"))))
;			      (name-servers '("192.168.1.1")))))
	      (service dhcp-client-service-type (dhcp-client-configuration
						 (interfaces '("ens3"))))
	      (append
	       common-extra-services 
	       (modify-services %base-services
				(guix-service-type config => (guix-config-with-substitutes config))))))
   (swap-devices (list (swap-space
                        (target (file-system-label "swap")))))
   (file-systems (cons* (file-system
                         (mount-point "/boot/efi")
                         (device (file-system-label "ESP"))
                         (type "vfat"))
			(file-system
                         (mount-point "/")
                         (device (file-system-label "root"))
                         (type "ext4")) %base-file-systems))))

