(define-module (conner systems surface)
  #:use-module (conner systems desktop)
  #:use-module (surface packages linux)
  #:use-module (surface services touchscreen)
  #:use-module (gnu system)
  #:use-module (gnu system mapped-devices)
  #:use-module (gnu system file-systems)
  #:use-module (gnu services)
  #:export (conner-laptop-os))
  
(define additional-surface-packages '())
(define additional-surface-services
  (list (service iptsd-service-type)))			     		     

(define-public conner-surface-os
  (operating-system
   (inherit base-os-desktop)
   (host-name "conner-surface")
   (kernel linux-surface)
   (services (append additional-surface-services (operating-system-services base-os-desktop)))
   (packages (append additional-surface-packages (operating-system-packages base-os-desktop)))))
