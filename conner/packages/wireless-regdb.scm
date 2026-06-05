(define-module (conner packages wireless-regdb)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages python))

(define-public wireless-regdb-signed
  (package
    (name "wireless-regdb-signed")
    (version (package-version wireless-regdb))
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "mirror://kernel.org/software/network/wireless-regdb/"
                    "wireless-regdb-" version ".tar.xz"))
              (sha256
               (base32 "04lc9jp8zxhyqxvkhrm637sswi2xm48jw8jnp3iflnknnf5d0m7j"))

              ;; We're building 'regulatory.bin' by ourselves.
              (snippet '(begin
                         (map delete-file '("regulatory.bin"
                                            "regulatory.db"))))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'gzip-determinism
            (lambda _
              (substitute* "Makefile"
                (("gzip") "gzip --no-name"))))
	  (replace 'build
		   (lambda* (#:key (make-flags '()) #:allow-other-keys)
		     (apply invoke "make" "regulatory.db" make-flags)))
          (add-after 'build 'build-regulatory.bin-unsigned
		     (lambda* (#:key (make-flags '()) #:allow-other-keys)
		       (apply invoke "make" "regulatory.bin"
			      (cons*
			       ;; Leave this empty so that db2bin.py doesn't try to sign
			       ;; ‘regulatory.bin’.  This allows us to avoid managing a key
			       ;; pair for the whole distribution.
			       "REGDB_PRIVKEY="
			       ;; Don't generate a public key for the same reason.  These are
			       ;; used as Makefile targets and can't be the empty string.
			       "REGDB_PUBCERT=/dev/null"
			       "REGDB_PUBKEY=/dev/null"
			       make-flags))))
          ;; We check if the 'regulatory.db' we just built is the same as the
          ;; one that got signed by upstream.
	  (replace 'check
		   (lambda _
		     (invoke "openssl" "smime"
			     "-verify" "-inform" "DER"
			     "-signer" "sforshee.x509.pem"
			     "-in" "regulatory.db.p7s" "-content" "regulatory.db"
			     "-out" "/dev/null"
			     "-CAfile" "sforshee.x509.pem")))
          (delete 'configure))  ; no configure script
      #:make-flags
      #~(list (string-append "PREFIX=" #$output)
              (string-append "FIRMWARE_PATH=$(PREFIX)/lib/firmware"))))
    (native-inputs (list openssl        ; to verify signature
			 python-wrapper))
    (home-page
     "https://wireless.wiki.kernel.org/en/developers/regulatory/wireless-regdb")
    (synopsis "Wireless regulatory database")
    (description
     "This package contains the wireless regulatory database used by the Linux
cfg80211 subsystem and the legacy Central Regulatory Database Agent (CRDA).
The database contains information on country-specific regulations for the
wireless spectrum.")
    (license license:isc)))
