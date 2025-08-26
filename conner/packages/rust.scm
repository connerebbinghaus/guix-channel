(define-module (conner packages rust)
  #:use-module (guix utils)
  #:use-module (guix build utils)
  #:use-module (guix platform)
  #:use-module (guix packages)
  #:use-module (gnu packages rust))

(define-public rustc-fixed rust) ;; Now fixed upstream

