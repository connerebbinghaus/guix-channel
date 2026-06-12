(define-module (conner packages vpn)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (conner packages rust-crates)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix build-system cargo)
  #:use-module (guix build gnu-build-system)
  #:use-module (guix build utils)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages vpn)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages webkit))

(define (absolute-file-name file directory)
  "Return the canonical absolute file name for FILE, which lives in the
vicinity of DIRECTORY."
  (canonicalize-path
   (cond ((string-prefix? "/" file) file)
         ((not directory) file)
         ((string-prefix? "/" directory)
          (string-append directory "/" file))
         (else file))))


(define globalprotect-openconnect-sources
  (origin
   (method git-fetch)
   (uri (git-reference
         (url "https://github.com/yuezk/GlobalProtect-openconnect/")
         (commit "77209426814aaf87c37398e08bb2278e018b8836")))
   (file-name (git-file-name "globalprotect-openconnect" "2.5.4"))
   (sha256
    (base32 "0baa8ijfknlign8jhs5wggib6hgajch6iwy79n0ycb78pg9w67kv"))
   (modules '((guix build utils)))
   (patches (find-files (absolute-file-name "patches/globalprotect-openconnect" (current-source-directory))))
   ;; Delete bundled sources
   (snippet '(for-each delete-file-recursively (list "crates/openconnect/deps/libxml2" "crates/openconnect/deps/openconnect" "packaging/files/usr/libexec/gpclient/vpnc-script")))))

(define-public openconnect-for-globalprotect-openconnect
  (package
   (inherit openconnect)
   (name "openconnect-for-globalprotect-openconnect")
   (arguments
    (substitute-keyword-arguments arguments
     ((#:phases phases #~%standard-phases)
       #~(modify-phases #$phases
	   (add-after 'unpack 'apply-gp-patches
		    (lambda* (#:key inputs #:allow-other-keys)
		      (for-each (lambda (file)
			(format #t "Applying patch '~a'...~%" file)
			(invoke "patch" "-p1" "--force"
				"--input" file)) (find-files #$(file-append globalprotect-openconnect-sources "/crates/openconnect/deps/patches/")))))
	   (add-after 'apply-gp-patches 'apply-our-patches
		    (lambda* (#:key inputs #:allow-other-keys)
		      (for-each (lambda (file)
			(format #t "Applying patch '~a'...~%" file)
			(invoke "patch" "-p1" "--force"
				"--input" file)) (find-files #$(local-file "patches/openconnect-for-globalprotect-openconnect" #:recursive? #t)))))))))))

(define-public globalprotect-openconnect
(let ((commit "77209426814aaf87c37398e08bb2278e018b8836")
        (revision "2"))
  (package
    (name "globalprotect-openconnect")
    (version "2.5.4")
    (source globalprotect-openconnect-sources)
    (build-system cargo-build-system)
    (arguments
     (list #:install-source? #f
       #:cargo-install-paths ''("apps/gpauth" "apps/gpclient" "apps/gpgui-helper/src-tauri" "apps/gpservice")
       #:phases
       #~(modify-phases %standard-phases
         (add-before 'configure 'set-gp-binary-paths
           (lambda* (#:key outputs #:allow-other-keys #:rest args)
             (let ((out (assoc-ref outputs "out")))
               (setenv "GP_CLIENT_BINARY" (string-append out "/bin/gpclient"))
	       (setenv "GP_SERVICE_BINARY" (string-append out "/bin/gpservice"))
	       (setenv "GP_GUI_BINARY" (string-append out "")) ;; We don't have this
	       (setenv "GP_GUI_HELPER_BINARY" (string-append out "/bin/gpgui-helper"))
	       (setenv "GP_AUTH_BINARY" (string-append out "/bin/gpauth"))
	       (setenv "GP_CSD_WRAPPER" (string-append out "/libexec/gpclient/hipreport.sh"))
	       (setenv "GP_VPNC_SCRIPT" (string-append #$vpnc-scripts "/etc/vpnc/vpnc-script"))
               #t)))
	  (add-before 'install 'patch-etc
           (lambda* (#:key outputs #:allow-other-keys #:rest args)
             (let ((out (assoc-ref outputs "out")))
               (for-each (lambda (file)
			   (substitute* file
					(("/usr/bin/gpclient") (string-append out "/bin/gpclient"))))
			 (list "packaging/files/usr/lib/NetworkManager/dispatcher.d/pre-down.d/gpclient.down"
			       "packaging/files/usr/libexec/gpclient/hipreport.sh")))))
	  (add-after 'install 'install-etc
	   (lambda* (#:key outputs #:allow-other-keys #:rest args)
	     (let ((out (assoc-ref outputs "out")))
	       (install-file "packaging/files/usr/lib/NetworkManager/dispatcher.d/pre-down.d/gpclient.down" (string-append out "/etc/NetworkManager/dispatcher.d/pre-down.d/"))
	       (install-file "packaging/files/usr/lib/NetworkManager/dispatcher.d/gpclient-nm-hook" (string-append out "/etc/NetworkManager/dispatcher.d/"))
	       (install-file "packaging/files/usr/libexec/gpclient/hipreport.sh" (string-append out "/libexec/gpclient/"))))))))
    (native-inputs (list pkg-config autoconf automake libtool))
    (inputs (cons* gobject-introspection at-spi2-core atkmm cairo gdk-pixbuf glib harfbuzz librsvg libsoup pango webkitgtk openssl gtk+ lz4 webkitgtk-for-gtk3 openconnect-for-globalprotect-openconnect vpnc-scripts (conner-cargo-inputs 'globalprotect-openconnect)))
    (home-page "https://github.com/yuezk/GlobalProtect-openconnect")
    (synopsis "A GlobalProtect VPN client for Linux")
    (description "A modern GlobalProtect VPN client for Linux, built on OpenConnect with full support for SSO authentication. ")
    (license (list license:expat license:gpl3)))))
