(define-module (conner packages vesta)
  #:use-module (nonguix licenses)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (nonguix build-system binary)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages polkit)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages xorg))

(define-public vesta
  (package
   (name "vesta")
   (version "3.5.8")
   (source (origin
	    (method url-fetch)
	    (uri (string-append "https://jp-minerals.org/vesta/archives/" version "/VESTA-gtk3.tar.bz2"))
	    (sha256
	     (base32
	      "1y4dhqhk0jy7kbkkx2c6lsrm5lirn796mq67r5j1s7xkq8jz1gkq"))))
   (build-system binary-build-system)
   (arguments
     `(#:patchelf-plan
       `(("VESTA-gui" ("atk"
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
	 ("VESTA" ("gcc:lib"))
	 ("VESTA-core" ("gcc:lib"))
	 ("libVESTA.so" ("gcc:lib")))))
   (inputs
     `(("atk" ,atk)
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
   (home-page "https://github.com/stefanberger/swtpm/wiki")
   (synopsis "Visualization for Electronic and Structual Analysis")
   (description "VESTA is a 3D visualization program for structural models, volumetric data such as electron/nuclear densities, and crystal morphologies.")
   (license (nonfree "https://jp-minerals.org/vesta/en/download.html"))))
   
   
	    
		  
   
