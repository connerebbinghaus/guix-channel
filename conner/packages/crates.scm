(define-module (conner packages crates)
  #:use-module (guix build-system cargo)
  #:use-module (guix download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (gnu packages crates-crypto)
  #:use-module (gnu packages crates-graphics)
  #:use-module (gnu packages crates-gtk)
  #:use-module (gnu packages crates-io)
  #:use-module (gnu packages crates-tls)
  #:use-module (gnu packages crates-vcs)
  #:use-module (gnu packages crates-web)
  #:use-module (gnu packages crates-windows)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages pkg-config))

; Guix's rust-pkg-config-0.3 is too old, so here's a newer one
(define-public rust-pkg-config-0.3
  (package
    (name "rust-pkg-config")
    (version "0.3.30")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "pkg-config" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "1v07557dj1sa0aly9c90wsygc0i8xv5vnmyv0g94lpkvj8qb4cfj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-development-inputs
       (("rust-lazy-static" ,rust-lazy-static-1))
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'hardcode-pkg-config-location
           (lambda* (#:key inputs #:allow-other-keys)
             (substitute* "src/lib.rs"
               (("\"pkg-config\"")
                (string-append "\"" (assoc-ref inputs "pkg-config")
                               "/bin/pkg-config\""))))))))
    (native-inputs
     (list pkg-config))
    (home-page "https://github.com/rust-lang/pkg-config-rs")
    (synopsis "Library to run the pkg-config system tool")
    (description
     "A library to run the pkg-config system tool at build time in order to be
used in Cargo build scripts.")
    (license (list license:asl2.0
                   license:expat))))

(define-public rust-libadwaita-sys-0.6
  (package
    (name "rust-libadwaita-sys")
    (version "0.6.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libadwaita-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1a513qlanw6n8dksm1br20a7iz2x1ff5cgg9v5f2dq9bx7j4i9r3"))))
    (build-system cargo-build-system)
    (arguments
     `(;#:tests? #f
       #:cargo-inputs (("rust-gdk4-sys" ,rust-gdk4-sys-0.8)
                             ("rust-gio-sys" ,rust-gio-sys-0.19)
                             ("rust-glib-sys" ,rust-glib-sys-0.19)
                             ("rust-gobject-sys" ,rust-gobject-sys-0.19)
                             ("rust-gtk4-sys" ,rust-gtk4-sys-0.8)
                             ("rust-libc" ,rust-libc-0.2)
                             ("rust-pango-sys" ,rust-pango-sys-0.19)
                             ("rust-system-deps" ,rust-system-deps-6))
       #:cargo-development-inputs
       (("rust-shell-words" ,rust-shell-words-0.1)
        ("rust-tempfile" ,rust-tempfile-3))))
    (native-inputs (list pkg-config))
    (inputs (list gtk libadwaita))
    (home-page "https://world.pages.gitlab.gnome.org/Rust/libadwaita-rs/")
    (synopsis "FFI bindings for libadwaita")
    (description "This package provides FFI bindings for libadwaita.")
    (license license:expat)))

(define-public rust-gtk4-sys-0.8
  (package
    (name "rust-gtk4-sys")
    (version "0.8.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "gtk4-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1dapgvbkhf0kcm2jfmj8r98wzyhwmr5iv358dvb73sl5gxmsi2lc"))))
    (build-system cargo-build-system)
    (arguments
     `(;#:tests? #f
       #:cargo-inputs (("rust-cairo-sys-rs" ,rust-cairo-sys-rs-0.19)
                             ("rust-gdk-pixbuf-sys" ,rust-gdk-pixbuf-sys-0.19)
                             ("rust-gdk4-sys" ,rust-gdk4-sys-0.8)
                             ("rust-gio-sys" ,rust-gio-sys-0.19)
                             ("rust-glib-sys" ,rust-glib-sys-0.19)
                             ("rust-gobject-sys" ,rust-gobject-sys-0.19)
                             ("rust-graphene-sys" ,rust-graphene-sys-0.19)
                             ("rust-gsk4-sys" ,rust-gsk4-sys-0.8)
                             ("rust-libc" ,rust-libc-0.2)
                             ("rust-pango-sys" ,rust-pango-sys-0.19)
                             ("rust-system-deps" ,rust-system-deps-6))
       #:cargo-development-inputs
       (("rust-shell-words" ,rust-shell-words-0.1)
        ("rust-tempfile" ,rust-tempfile-3))))
    (native-inputs (list pkg-config))
    (inputs (list cairo gdk-pixbuf graphene gtk pango))
    (home-page "https://gtk-rs.org/gtk4-rs")
    (synopsis "FFI bindings of GTK 4")
    (description "This package provides FFI bindings of GTK 4.")
    (license license:expat)))

(define-public rust-gtk4-macros-0.8
  (package
    (name "rust-gtk4-macros")
    (version "0.8.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "gtk4-macros" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0214a8y68kknxcnihsfxwsqvll7ss2rbiplr51cyk34dz1z5lrgc"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-proc-macro-crate" ,rust-proc-macro-crate-3)
                             ("rust-proc-macro2" ,rust-proc-macro2-1)
                             ("rust-quick-xml" ,rust-quick-xml-0.31)
                             ("rust-quote" ,rust-quote-1)
                             ("rust-syn" ,rust-syn-2))
       #:cargo-development-inputs (("rust-futures-channel" ,rust-futures-channel-0.3)
                                   ("rust-futures-util" ,rust-futures-util-0.3)
                                   ("rust-gtk4" ,rust-gtk4-0.8)
                                   ("rust-trybuild2" ,rust-trybuild2-1))))
    (home-page "https://gtk-rs.org/gtk4-rs")
    (synopsis "Macros helpers for GTK 4 bindings")
    (description "This package provides Macros helpers for GTK 4 bindings.")
    (license license:expat)))

(define-public rust-gsk4-sys-0.8
  (package
    (name "rust-gsk4-sys")
    (version "0.8.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "gsk4-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1p5kf912s8qs38lhzzwnm26v498wkp68mx92z38vnf3ccgr4n0i3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-cairo-sys-rs" ,rust-cairo-sys-rs-0.19)
                             ("rust-gdk4-sys" ,rust-gdk4-sys-0.8)
                             ("rust-glib-sys" ,rust-glib-sys-0.19)
                             ("rust-gobject-sys" ,rust-gobject-sys-0.19)
                             ("rust-graphene-sys" ,rust-graphene-sys-0.19)
                             ("rust-libc" ,rust-libc-0.2)
                             ("rust-pango-sys" ,rust-pango-sys-0.19)
                             ("rust-system-deps" ,rust-system-deps-6))
       #:cargo-development-inputs
       (("rust-shell-words" ,rust-shell-words-0.1)
        ("rust-tempfile" ,rust-tempfile-3))))
    (native-inputs (list pkg-config))
    (inputs (list gdk-pixbuf gtk))
    (home-page "https://gtk-rs.org/gtk4-rs")
    (synopsis "FFI bindings of GSK 4")
    (description "This package provides FFI bindings of GSK 4.")
    (license license:expat)))

(define-public rust-gsk4-0.8
  (package
    (name "rust-gsk4")
    (version "0.8.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "gsk4" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1gi1f9s2nd5m2zfwb91vijpzr6nxbfa58inrwml497wkyr5qhqvm"))))
    (build-system cargo-build-system)
    (arguments
     `(; #:tests? #f
       #:cargo-inputs (("rust-cairo-rs" ,rust-cairo-rs-0.19)
                             ("rust-gdk4" ,rust-gdk4-0.8)
                             ("rust-glib" ,rust-glib-0.19)
                             ("rust-graphene-rs" ,rust-graphene-rs-0.19)
                             ("rust-gsk4-sys" ,rust-gsk4-sys-0.8)
                             ("rust-libc" ,rust-libc-0.2)
                             ("rust-pango" ,rust-pango-0.19))
       #:cargo-development-inputs
       (("rust-gir-format-check" ,rust-gir-format-check-0.1))))
    (native-inputs (list pkg-config))
    (inputs (list gtk))
    (home-page "https://gtk-rs.org/gtk4-rs")
    (synopsis "Rust bindings of the GSK 4 library")
    (description "This package provides Rust bindings of the GSK 4 library.")
    (license license:expat)))

(define-public rust-graphene-sys-0.19
  (package
    (name "rust-graphene-sys")
    (version "0.19.8")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "graphene-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "01dg4wgqxaqkdv0vl7hr14b6kbbm96gwdsb5a2ss9jxw8h4hwlrg"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-glib-sys" ,rust-glib-sys-0.19)
                             ("rust-libc" ,rust-libc-0.2)
                             ("rust-pkg-config" ,rust-pkg-config-0.3)
                             ("rust-system-deps" ,rust-system-deps-6))
       #:cargo-development-inputs (("rust-shell-words" ,rust-shell-words-1)
                                   ("rust-tempfile" ,rust-tempfile-3))))
    (native-inputs (list pkg-config))
    (inputs (list glib graphene))
    (home-page "https://gtk-rs.org/")
    (synopsis "FFI bindings to libgraphene-1.0")
    (description "This package provides FFI bindings to libgraphene-1.0.")
    (license license:expat)))

(define-public rust-graphene-rs-0.19
  (package
    (name "rust-graphene-rs")
    (version "0.19.8")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "graphene-rs" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1krblj6kbnixgkmz2b3494jmlm2xlv3qz5qm585frn943l1qdyzm"))))
    (build-system cargo-build-system)
    (arguments
     `(;#:tests? #f
       #:cargo-inputs (("rust-glib" ,rust-glib-0.19)
                             ("rust-graphene-sys" ,rust-graphene-sys-0.19)
                             ("rust-libc" ,rust-libc-0.2))
       #:cargo-development-inputs
       (("rust-gir-format-check" ,rust-gir-format-check-0.1))))
    (native-inputs (list pkg-config))
    (inputs (list glib graphene))
    (home-page "https://gtk-rs.org/")
    (synopsis "Rust bindings for the Graphene library")
    (description
     "This package provides Rust bindings for the Graphene library.")
    (license license:expat)))

(define-public rust-gtk4-0.8
  (package
    (name "rust-gtk4")
    (version "0.8.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "gtk4" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1avinslgnsz3wywf4dfaza8w9c29krd10hxmi8si3bq8kcqi2kmh"))))
    (build-system cargo-build-system)
    (arguments
     `(;#:tests? #f
       #:cargo-inputs (("rust-cairo-rs" ,rust-cairo-rs-0.19)
                             ("rust-field-offset" ,rust-field-offset-0.3)
                             ("rust-futures-channel" ,rust-futures-channel-0.3)
                             ("rust-gdk-pixbuf" ,rust-gdk-pixbuf-0.19)
                             ("rust-gdk4" ,rust-gdk4-0.8)
                             ("rust-gio" ,rust-gio-0.19)
                             ("rust-glib" ,rust-glib-0.19)
                             ("rust-graphene-rs" ,rust-graphene-rs-0.19)
                             ("rust-gsk4" ,rust-gsk4-0.8)
                             ("rust-gtk4-macros" ,rust-gtk4-macros-0.8)
                             ("rust-gtk4-sys" ,rust-gtk4-sys-0.8)
                             ("rust-libc" ,rust-libc-0.2)
                             ("rust-pango" ,rust-pango-0.19))
       #:cargo-development-inputs
       (("rust-gir-format-check" ,rust-gir-format-check-0.1))))
    (native-inputs (list pkg-config))
    (inputs (list cairo glib gtk))
    (home-page "https://gtk-rs.org/gtk4-rs")
    (synopsis "Rust bindings of the GTK 4 library")
    (description "This package provides Rust bindings of the GTK 4 library.")
    (license license:expat)))

(define-public rust-pango-0.19
  (package
    (name "rust-pango")
    (version "0.19.8")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "pango" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1kffxkk7730csly86fkgja50k1184zj9lz49sv7qb0059233439z"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-gio" ,rust-gio-0.19)
                             ("rust-glib" ,rust-glib-0.19)
                             ("rust-libc" ,rust-libc-0.2)
                             ("rust-pango-sys" ,rust-pango-sys-0.19))
       #:cargo-development-inputs
       (("rust-gir-format-check" ,rust-gir-format-check-0.1))))
    (home-page "https://gtk-rs.org/")
    (synopsis "Rust bindings for the Pango library")
    (description "This package provides Rust bindings for the Pango library.")
    (license license:expat)))

(define-public rust-pango-sys-0.19
  (package
    (name "rust-pango-sys")
    (version "0.19.8")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "pango-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "182bcd6255v5yvnskbhxnb6kwak240z7sn54si2b5h46l17xl0zz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-glib-sys" ,rust-glib-sys-0.19)
                             ("rust-gobject-sys" ,rust-gobject-sys-0.19)
                             ("rust-libc" ,rust-libc-0.2)
                             ("rust-system-deps" ,rust-system-deps-6))
       #:cargo-development-inputs (("rust-shell-words" ,rust-shell-words-1)
                                   ("rust-tempfile" ,rust-tempfile-3))))
    (native-inputs (list pkg-config))
    (inputs (list pango))
    (home-page "https://gtk-rs.org/")
    (synopsis "FFI bindings to libpango-1.0")
    (description "This package provides FFI bindings to libpango-1.0.")
    (license license:expat)))

(define-public rust-gdk4-sys-0.8
  (package
    (name "rust-gdk4-sys")
    (version "0.8.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "gdk4-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1pb6vklx9ik7jx9cmrw2vywlx9ssqhll8q77ky8p8w56x2s8yhf9"))))
    (build-system cargo-build-system)
    (arguments
     `(;#:tests? #f
       #:cargo-inputs (("rust-cairo-sys-rs" ,rust-cairo-sys-rs-0.19)
                             ("rust-gdk-pixbuf-sys" ,rust-gdk-pixbuf-sys-0.19)
                             ("rust-gio-sys" ,rust-gio-sys-0.19)
                             ("rust-glib-sys" ,rust-glib-sys-0.19)
                             ("rust-gobject-sys" ,rust-gobject-sys-0.19)
                             ("rust-libc" ,rust-libc-0.2)
                             ("rust-pango-sys" ,rust-pango-sys-0.19)
                             ("rust-pkg-config" ,rust-pkg-config-0.3)
                             ("rust-system-deps" ,rust-system-deps-6))
       #:cargo-development-inputs (("rust-shell-words" ,rust-shell-words-1)
                                   ("rust-tempfile" ,rust-tempfile-3))))
    (native-inputs (list pkg-config))
    (inputs (list cairo gdk-pixbuf glib gtk pango))
    (home-page "https://gtk-rs.org/gtk4-rs")
    (synopsis "FFI bindings of GDK 4")
    (description "This package provides FFI bindings of GDK 4.")
    (license license:expat)))

(define-public rust-freetype-sys-0.20
  (package
   (inherit rust-freetype-sys-0.17)
   (name "rust-freetype-sys")
   (version "0.20.1")
   (source
    (origin
     (method url-fetch)
     (uri (crate-uri "freetype-sys" version))
     (file-name (string-append name "-" version ".tar.gz"))
     (sha256
      (base32 "0d5iiv95ap3lwy7b0hxbc8caa9ng1fg3wlwrvb7rld39jrdxqzhf"))))
   (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs
       (("rust-libc" ,rust-libc-0.2)
        ("rust-pkg-config" ,rust-pkg-config-0.3))))
    (inputs
     (list freetype))
   (license license:expat)))

(define-public rust-freetype-rs-0.35
  (package
    (name "rust-freetype-rs")
    (version "0.35.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "freetype-rs" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1gzfb9fax3d3s691ys99nfihpzwl7hacvxnwvlxg4sph1fzd5ymi"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                             ("rust-freetype-sys" ,rust-freetype-sys-0.20)
                             ("rust-libc" ,rust-libc-0.2))
       #:cargo-development-inputs
       (("rust-unicode-normalization" ,rust-unicode-normalization-0.1))))
    (home-page "https://github.com/PistonDevelopers/freetype-rs")
    (synopsis "Bindings for FreeType font library")
    (description
     "This package provides Bindings for @code{FreeType} font library.")
    (license license:expat)))

(define-public rust-cairo-sys-rs-0.19
  (package
    (name "rust-cairo-sys-rs")
    (version "0.19.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "cairo-sys-rs" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0r0yp0lph77lm4blrn6fvdmz2i3r8ibkkjg6nmwbvvv4jq8v6fzx"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-glib-sys" ,rust-glib-sys-0.19)
                             ("rust-libc" ,rust-libc-0.2)
                             ("rust-system-deps" ,rust-system-deps-6)
                             ("rust-windows-sys" ,rust-windows-sys-0.52)
                             ("rust-x11" ,rust-x11-2))
       #:cargo-development-inputs (("rust-shell-words" ,rust-shell-words-1)
                                   ("rust-tempfile" ,rust-tempfile-3))))
    (native-inputs (list pkg-config))
    (inputs (list cairo))
    (home-page "https://gtk-rs.org/")
    (synopsis "FFI bindings to libcairo")
    (description "This package provides FFI bindings to libcairo.")
    (license license:expat)))

(define-public rust-cairo-rs-0.19
  (package
    (name "rust-cairo-rs")
    (version "0.19.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "cairo-rs" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0qp5rixgipdj9d8yd5458hzfxam1rgpzcxi90vq6q0v91r6jmb5j"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                             ("rust-cairo-sys-rs" ,rust-cairo-sys-rs-0.19)
                             ("rust-freetype-rs" ,rust-freetype-rs-0.35)
                             ("rust-glib" ,rust-glib-0.19)
                             ("rust-libc" ,rust-libc-0.2)
                             ("rust-thiserror" ,rust-thiserror-1))
       #:cargo-development-inputs
       (("rust-gir-format-check" ,rust-gir-format-check-0.1))))
    (native-inputs (list pkg-config))
    (inputs (list cairo))
    (home-page "https://gtk-rs.org/")
    (synopsis "Rust bindings for the Cairo library")
    (description "This package provides Rust bindings for the Cairo library.")
    (license license:expat)))

(define-public rust-gdk4-0.8
  (package
    (name "rust-gdk4")
    (version "0.8.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "gdk4" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "01qak43mrlszsy9cfsmqk1ql4228m2rylbg514g3fsidsjfmq9nv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-cairo-rs" ,rust-cairo-rs-0.19)
                             ("rust-gdk-pixbuf" ,rust-gdk-pixbuf-0.19)
                             ("rust-gdk4-sys" ,rust-gdk4-sys-0.8)
                             ("rust-gio" ,rust-gio-0.19)
                             ("rust-gl" ,rust-gl-0.14)
                             ("rust-glib" ,rust-glib-0.19)
                             ("rust-libc" ,rust-libc-0.2)
                             ("rust-pango" ,rust-pango-0.19))
       #:cargo-development-inputs
       (("rust-gir-format-check" ,rust-gir-format-check-0.1))))
    (native-inputs (list pkg-config))
    (inputs (list cairo gdk-pixbuf gtk))
    (home-page "https://gtk-rs.org/gtk4-rs")
    (synopsis "Rust bindings of the GDK 4 library")
    (description "This package provides Rust bindings of the GDK 4 library.")
    (license license:expat)))

(define-public rust-glib-macros-0.19
  (package
    (name "rust-glib-macros")
    (version "0.19.9")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "glib-macros" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1mzsh8jkg8vldvgvr9gsaidvn2myn5cbdn8a6m8rgbhlg8kv0aa4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-heck" ,rust-heck-0.5)
                             ("rust-proc-macro-crate" ,rust-proc-macro-crate-3)
                             ("rust-proc-macro2" ,rust-proc-macro2-1)
                             ("rust-quote" ,rust-quote-1)
                             ("rust-syn" ,rust-syn-2))
       #:cargo-development-inputs
       (("rust-glib" ,rust-glib-0.19)
        ("rust-once-cell" ,rust-once-cell-1)
        ("rust-trybuild2" ,rust-trybuild2-1))))
    (native-inputs (list pkg-config))
    (inputs (list glib))
    (home-page "https://gtk-rs.org/")
    (synopsis "Rust bindings for the GLib library, proc macros crate")
    (description
     "This package provides Rust bindings for the GLib library, proc macros crate.")
    (license license:expat)))

(define-public rust-glib-0.19
  (package
    (name "rust-glib")
    (version "0.19.9")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "glib" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0i2ak1scmzfmfxbm2dr146jl4y9mafxf1ald05jr8iimy5wh4r9r"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-test-flags
       '("--release" "--"
         "--skip=structured_log")
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                             ("rust-futures-channel" ,rust-futures-channel-0.3)
                             ("rust-futures-core" ,rust-futures-core-0.3)
                             ("rust-futures-executor" ,rust-futures-executor-0.3)
                             ("rust-futures-task" ,rust-futures-task-0.3)
                             ("rust-futures-util" ,rust-futures-util-0.3)
                             ("rust-gio-sys" ,rust-gio-sys-0.19)
                             ("rust-glib-macros" ,rust-glib-macros-0.19)
                             ("rust-glib-sys" ,rust-glib-sys-0.19)
                             ("rust-gobject-sys" ,rust-gobject-sys-0.19)
                             ("rust-libc" ,rust-libc-0.2)
                             ("rust-log" ,rust-log-0.4)
                             ("rust-memchr" ,rust-memchr-2)
                             ("rust-smallvec" ,rust-smallvec-1)
                             ("rust-thiserror" ,rust-thiserror-1))
       #:cargo-development-inputs
       (("rust-criterion" ,rust-criterion-0.5)
        ("rust-gir-format-check" ,rust-gir-format-check-0.1)
        ("rust-tempfile" ,rust-tempfile-3)
        ("rust-trybuild2" ,rust-trybuild2-1))))
    (native-inputs (list pkg-config))
    (inputs (list glib))
    (home-page "https://gtk-rs.org/")
    (synopsis "Rust bindings for the GLib library")
    (description "This package provides Rust bindings for the GLib library.")
    (license license:expat)))

(define-public rust-gio-0.19
  (package
    (name "rust-gio")
    (version "0.19.8")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "gio" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1znz5ngfvv3gbndf6lzz3hs27hlb8ysls4axlfccrzvkscbz2jac"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-test-flags
       '("--release" "--"
         "--skip=settings::test::bool_set_get"
         "--skip=settings::test::string_get")
       #:cargo-inputs (("rust-futures-channel" ,rust-futures-channel-0.3)
                             ("rust-futures-core" ,rust-futures-core-0.3)
                             ("rust-futures-io" ,rust-futures-io-0.3)
                             ("rust-futures-util" ,rust-futures-util-0.3)
                             ("rust-gio-sys" ,rust-gio-sys-0.19)
                             ("rust-glib" ,rust-glib-0.19)
                             ("rust-libc" ,rust-libc-0.2)
                             ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                             ("rust-smallvec" ,rust-smallvec-1)
                             ("rust-thiserror" ,rust-thiserror-1))
       #:cargo-development-inputs
       (("rust-futures" ,rust-futures-0.3)
        ("rust-futures-util" ,rust-futures-util-0.3)
        ("rust-gir-format-check" ,rust-gir-format-check-0.1)
        ("rust-serial-test" ,rust-serial-test-2))))
    (native-inputs (list pkg-config))
    (inputs (list glib))
    (home-page "https://gtk-rs.org/")
    (synopsis "Rust bindings for the Gio library")
    (description "This package provides Rust bindings for the Gio library.")
    (license license:expat)))

(define-public rust-gobject-sys-0.19
  (package
    (name "rust-gobject-sys")
    (version "0.19.8")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "gobject-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "17lb7dfbpcg8zchwlfbc08kckwf0a7d9n5ly3pyic13f5ljpws9f"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-glib-sys" ,rust-glib-sys-0.19)
                             ("rust-libc" ,rust-libc-0.2)
                             ("rust-system-deps" ,rust-system-deps-6))
       #:cargo-development-inputs
       (("rust-shell-words" ,rust-shell-words-1)
        ("rust-tempfile" ,rust-tempfile-3))))
    (native-inputs (list pkg-config))
    (inputs (list glib))
    (home-page "https://gtk-rs.org/")
    (synopsis "FFI bindings to libgobject-2.0")
    (description "This package provides FFI bindings to libgobject-2.0.")
    (license license:expat)))

(define-public rust-glib-sys-0.19
  (package
    (name "rust-glib-sys")
    (version "0.19.8")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "glib-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "19f4q8x77vd7c1d9ikw492yskq5kpd7k04qb8xnh1c427a6w2baw"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-libc" ,rust-libc-0.2)
                             ("rust-system-deps" ,rust-system-deps-6))))
    (home-page "https://gtk-rs.org/")
    (synopsis "FFI bindings to libglib-2.0")
    (description "This package provides FFI bindings to libglib-2.0.")
    (license license:expat)))

(define-public rust-gio-sys-0.19
  (package
    (name "rust-gio-sys")
    (version "0.19.8")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "gio-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1vylsskpipfwl7mvffp1s0227d0k5amyhd32dfnp3mhl8yx47mrc"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-glib-sys" ,rust-glib-sys-0.19)
                             ("rust-gobject-sys" ,rust-gobject-sys-0.19)
                             ("rust-libc" ,rust-libc-0.2)
                             ("rust-system-deps" ,rust-system-deps-6)
                             ("rust-windows-sys" ,rust-windows-sys-0.52))
       #:cargo-development-inputs
       (("rust-shell-words" ,rust-shell-words-1)
        ("rust-tempfile" ,rust-tempfile-3))))
    (native-inputs (list pkg-config))
    (inputs (list glib))
    (home-page "https://gtk-rs.org/")
    (synopsis "FFI bindings to libgio-2.0")
    (description "This package provides FFI bindings to libgio-2.0.")
    (license license:expat)))

(define-public rust-gdk-pixbuf-sys-0.19
  (package
    (name "rust-gdk-pixbuf-sys")
    (version "0.19.8")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "gdk-pixbuf-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0y93g24mdgskvyhva46xv3qyb1cvj5xpi0yqnh7cb31wz2j0byjf"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-gio-sys" ,rust-gio-sys-0.19)
                             ("rust-glib-sys" ,rust-glib-sys-0.19)
                             ("rust-gobject-sys" ,rust-gobject-sys-0.19)
                             ("rust-libc" ,rust-libc-0.2)
                             ("rust-system-deps" ,rust-system-deps-6))
       #:cargo-development-inputs
       (("rust-shell-words" ,rust-shell-words-1)
        ("rust-tempfile" ,rust-tempfile-3))))
    (native-inputs (list pkg-config))
    (inputs (list gdk-pixbuf gtk+))
    (home-page "https://gtk-rs.org/")
    (synopsis "FFI bindings to libgdk_pixbuf-2.0")
    (description "This package provides FFI bindings to libgdk_pixbuf-2.0.")
    (license license:expat)))

(define-public rust-gdk-pixbuf-0.19
  (package
    (name "rust-gdk-pixbuf")
    (version "0.19.8")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "gdk-pixbuf" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "16c6kznkh3vi82843ays8awdm37fwjd1fblv6g3h64824shsnkk2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-gdk-pixbuf-sys" ,rust-gdk-pixbuf-sys-0.19)
                             ("rust-gio" ,rust-gio-0.19)
                             ("rust-glib" ,rust-glib-0.19)
                             ("rust-libc" ,rust-libc-0.2))
       #:cargo-development-inputs
       (("rust-gir-format-check" ,rust-gir-format-check-0.1))))
    (native-inputs (list pkg-config))
    (inputs (list glib gdk-pixbuf))
    (home-page "https://gtk-rs.org/")
    (synopsis "Rust bindings for the GdkPixbuf library")
    (description
     "This package provides Rust bindings for the @code{GdkPixbuf} library.")
    (license license:expat)))

(define-public rust-libadwaita-0.6
  (package
    (name "rust-libadwaita")
    (version "0.6.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libadwaita" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1nf5hxmk1bzjj8hxavwgz04kiv3hxb52qjh9f9gfrqdr9019kd4i"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-gdk-pixbuf" ,rust-gdk-pixbuf-0.19)
                             ("rust-gdk4" ,rust-gdk4-0.8)
                             ("rust-gio" ,rust-gio-0.19)
                             ("rust-glib" ,rust-glib-0.19)
                             ("rust-gtk4" ,rust-gtk4-0.8)
                             ("rust-libadwaita-sys" ,rust-libadwaita-sys-0.6)
                             ("rust-libc" ,rust-libc-0.2)
                             ("rust-pango" ,rust-pango-0.19))))
    (native-inputs (list pkg-config))
    (inputs (list libadwaita))
    (home-page "https://world.pages.gitlab.gnome.org/Rust/libadwaita-rs/")
    (synopsis "Rust bindings for libadwaita")
    (description "This package provides Rust bindings for libadwaita.")
    (license license:expat)))
