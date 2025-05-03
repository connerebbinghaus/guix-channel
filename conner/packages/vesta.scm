(define-module (conner packages vesta)
  #:use-module (nonguix licenses)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (nonguix build-system binary)
  #:use-module (gnu packages base)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages polkit)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages package-management)
  #:use-module (gnu packages cpio))

(define-public vesta
  (package
   (name "vesta")
   (version "3.5.8")
   (source (origin
	    (method url-fetch)
	    (uri (string-append "https://jp-minerals.org/vesta/archives/" version "/vesta-" version "-1.x86_64.rpm"))
	    (sha256
	     (base32
	      "115zhz2r672apn88kwf8hs94cidksqq273v9bnrgb36npkc559f2"))))
   (build-system binary-build-system)
   (arguments
    `(#:substitutable? #f
      #:patchelf-plan
      `((,(string-append "usr/local/vesta-" ,version "/VESTA-gui") ("atk"
                     "cairo"
                     "fontconfig"
                     "freetype"
                     "gcc:lib"
                     "gdk-pixbuf"
                     "glib"
                     "glu"
                     "gtk+"
                     "gtkglext"
                     "libsm"
                     "libx11"
                     "libxcb"
                     "libxdamage"
                     "libxext"
                     "libxfixes"
                     "libxi"
                     "libxkbfile"
                     "libxmu"
                     "libxrandr"
                     "libxrender"
                     "libxsts"
                     "libxt"
		     "libxxf86vm"
                     "mesa"
                     "pango"
                     "pangox-compat"))
	 (,(string-append "usr/local/vesta-" ,version "/VESTA") ("gcc:lib" "glibc"))
	 (,(string-append "usr/local/vesta-" ,version "/VESTA-core") ("gcc:lib"))
	 (,(string-append "usr/local/vesta-" ,version "/libVESTA.so") ("gcc:lib")))
      #:install-plan `(("usr/" "./"))
      #:modules ((guix build utils)
                  (nonguix build utils)
                  (nonguix build binary-build-system))
      #:phases
      (modify-phases %standard-phases
		     (replace 'unpack
			      (lambda* (#:key source #:allow-other-keys)
				(system (format #f "rpm2cpio ~a | cpio -idmv" source))
				#t))
		     (add-after 'install 'fix-symlinks
				(lambda* (#:key outputs #:allow-other-keys)
				  (let* ((out (assoc-ref outputs "out")))
				    (for-each (lambda (sym)
						(let* ((old-link-dest (readlink sym))
						       (old-link-dest-trimmed (if (string-prefix? "/usr" old-link-dest) (string-drop old-link-dest 4) old-link-dest))
						       (new-link-dest (canonicalize-path (string-append (assoc-ref outputs "out") "/" old-link-dest-trimmed))))
						  (format #t "Fixing symlink: ~a~%" sym)
						  (delete-file sym)
						  (symlink new-link-dest sym)))
					      (find-files out (lambda (file stat) (symbolic-link? file)) #:stat lstat)))
				#t)))))
   (inputs
    `(("glibc" ,glibc)
      ("atk" ,atk)
       ("cairo" ,cairo)
       ("fontconfig" ,fontconfig)
       ("freetype" ,freetype)
       ("gcc:lib" ,gcc "lib")
       ("gdk-pixbuf" ,gdk-pixbuf)
       ("glib" ,glib)
       ("glu" ,glu)
       ("gtk+" ,gtk+)
       ("gtkglext" ,gtkglext)
       ("libice" ,libice)
       ("libsm" ,libsm)
       ("libx11" ,libx11)
       ("libxcb" ,libxcb)
       ("libxdamage" ,libxdamage)
       ("libxext" ,libxext)
       ("libxfixes" ,libxfixes)
       ("libxi" ,libxi)
       ("libxkbfile" ,libxkbfile)
       ("libxmu" ,libxmu)
       ("libxrandr" ,libxrandr)
       ("libxrender" ,libxrender)
       ("libxsts" ,libxtst)
       ("libxt" ,libxt)
       ("libxxf86vm" ,libxxf86vm)
       ("mesa" ,mesa)
       ("pango" ,pango)
       ("pangox-compat" ,pangox-compat)))
   (supported-systems '("x86_64-linux"))
   (native-inputs
     `(("rpm" ,rpm)
       ("cpio" ,cpio)))
   (home-page "https://github.com/stefanberger/swtpm/wiki")
   (synopsis "Visualization for Electronic and Structual Analysis")
   (description "VESTA is a 3D visualization program for structural models, volumetric data such as electron/nuclear densities, and crystal morphologies.")
   (license (nonfree "https://jp-minerals.org/vesta/en/download.html"))))
   
   
	    
		  
   
