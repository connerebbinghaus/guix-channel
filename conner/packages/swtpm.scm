(define-module (conner packages swtpm)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages tcl)
  #:use-module (gnu packages networking)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages base)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages bash))

(define-public libtpms
  (package
   (name "libtpms")
   (version "0.10.0")
   (source (origin
	    (method git-fetch)
	    (uri (git-reference
		  (url "https://github.com/stefanberger/libtpms")
		  (commit (string-append "v" version))))
	    (file-name (git-file-name name version))
	    (sha256
	     (base32
	      "0nawrc09ahmb1hcxw58v79bwbm8v7xprg9r8nm78nl3wh9fkzav0"))))
   (build-system gnu-build-system)
   (arguments
    `(#:make-flags '("LDFLAGS_OS=-lc")))
   (inputs
    (list openssl))
   (native-inputs
    (list pkg-config autoconf automake libtool perl))
   (home-page "https://github.com/stefanberger/libtpms/wiki")
   (synopsis "Provides software emulation of a Trusted Platform Module")
   (description "Libtpms is a library that targets the integration of TPM functionality into hypervisors, primarily into Qemu. Libtpms provides a very narrow public API for this purpose so that integration is possible. Only the minimum of necessary APIs are made publicly available.")
   (license license:bsd-3)))


(define-public swtpm
  (package
   (name "swtpm")
   (version "0.10.0")
   (source (origin
	    (method git-fetch)
	    (uri (git-reference
		  (url "https://github.com/stefanberger/swtpm")
		  (commit (string-append "v" version))))
	    (file-name (git-file-name name version))
	    (sha256
	     (base32
	      "1kbxps7kmkd6dnnfv1rzz83bm6ks4pls4lcz0k9y92g0la2m6jk4"))))
   (build-system gnu-build-system)
   (arguments
    `(#:configure-flags '("--with-openssl")
      #:phases
          (modify-phases %standard-phases
			 (add-after 'unpack 'fix-localca-path
				    (lambda _
				      (substitute* "samples/swtpm-localca.conf.in"
						   (("@LOCALSTATEDIR@") "/var")))))))
   (inputs
    (list libtasn1 python-twisted fuse glib openssl json-glib libtpms gmp libseccomp))
   (native-inputs
    (list
     pkg-config
     expect
     socat
     autoconf
     automake
     libtool
     net-tools
     python
     perl
     bash)) ; full bash needed for tests
   (propagated-inputs (list gnutls)) ; for certtool
   (home-page "https://github.com/stefanberger/swtpm/wiki")
   (synopsis "Software TPM Emulator")
   (description "The SWTPM package provides TPM emulators with different front-end interfaces to libtpms. TPM emulators provide socket interfaces (TCP/IP and Unix) and the Linux CUSE interface for the creation of multiple native /dev/vtpm* devices.

The SWTPM package also provides several tools for using the TPM emulator, creating certificates for a TPM, and simulating the manufacturing of a TPM by creating a TPM's EK and platform certificates etc.")
   (license license:bsd-3)))
   
   
	    
		  
   
