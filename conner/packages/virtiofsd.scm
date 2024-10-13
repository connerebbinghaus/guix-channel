(define-module (conner packages virtiofsd)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages tcl)
  #:use-module (gnu packages networking)
  #:use-module (gnu packages crates-io)
  #:use-module (gnu packages crates-windows)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages base)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages admin))

(define-public rust-virtio-queue-0.12
  (package
    (name "rust-virtio-queue")
    (version "0.12.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "virtio-queue" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1s5zmaxsck4nbrybn7yakf0k273qsbrdi1g55m339jahf9p41n07"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-log" ,rust-log-0.4)
                       ("rust-virtio-bindings" ,rust-virtio-bindings-0.2)
                       ("rust-vm-memory" ,rust-vm-memory-0.14)
                       ("rust-vmm-sys-util" ,rust-vmm-sys-util-0.12))))
    (home-page "https://github.com/rust-vmm/vm-virtio")
    (synopsis "virtio queue implementation")
    (description "This package provides virtio queue implementation.")
    (license (list license:asl2.0 license:bsd-3))))

(define-public rust-virtio-bindings-0.2
  (package
    (name "rust-virtio-bindings")
    (version "0.2.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "virtio-bindings" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0hd2mccfrym1agcnxwq0a76lva14grrsq4sr3g41v6ypb97xzl38"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/rust-vmm/vm-virtio")
    (synopsis "Rust FFI bindings to virtio generated using bindgen")
    (description
     "This package provides Rust FFI bindings to virtio generated using bindgen.")
    (license (list license:bsd-3 license:asl2.0))))

(define-public rust-userfaultfd-sys-0.5
  (package
    (name "rust-userfaultfd-sys")
    (version "0.5.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "userfaultfd-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0hddgh10m3lm39r9cv3xwb5mrq0z9vhiqnkzsimv2z9blv99amfp"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bindgen" ,rust-bindgen-0.68)
                       ("rust-cc" ,rust-cc-1)
                       ("rust-cfg-if" ,rust-cfg-if-1))))
    (home-page "https://github.com/bytecodealliance/userfaultfd-rs")
    (synopsis "Low-level bindings for userfaultfd functionality on Linux")
    (description
     "This package provides Low-level bindings for userfaultfd functionality on Linux.")
    (license (list license:expat license:asl2.0))))

(define-public rust-userfaultfd-0.8
  (package
    (name "rust-userfaultfd")
    (version "0.8.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "userfaultfd" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0d8hp3sp3mwjr3kx1c3ydnrdbzgmbp18fkwnbrl21r6ksivb3n0q"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                       ("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-nix" ,rust-nix-0.27)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-userfaultfd-sys" ,rust-userfaultfd-sys-0.5))))
    (home-page "https://github.com/bytecodealliance/userfaultfd-rs")
    (synopsis "Rust bindings for the Linux userfaultfd functionality")
    (description
     "This package provides Rust bindings for the Linux userfaultfd functionality.")
    (license (list license:expat license:asl2.0))))

(define-public rust-vhost-user-backend-0.15
  (package
    (name "rust-vhost-user-backend")
    (version "0.15.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "vhost-user-backend" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "15jhi9mj6s7zz7zr31c834w9a4jqxkpxacic1s5702p0v0fzn3qz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libc" ,rust-libc-0.2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-userfaultfd" ,rust-userfaultfd-0.8)
                       ("rust-vhost" ,rust-vhost-0.11)
                       ("rust-virtio-bindings" ,rust-virtio-bindings-0.2)
                       ("rust-virtio-queue" ,rust-virtio-queue-0.12)
                       ("rust-vm-memory" ,rust-vm-memory-0.14)
                       ("rust-vmm-sys-util" ,rust-vmm-sys-util-0.12))))
    (home-page "https://github.com/rust-vmm/vhost")
    (synopsis "framework to build vhost-user backend service daemon")
    (description
     "This package provides a framework to build vhost-user backend service daemon.")
    (license license:asl2.0)))

(define-public rust-vmm-sys-util-0.12
  (package
    (name "rust-vmm-sys-util")
    (version "0.12.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "vmm-sys-util" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1pjfjdhnab1x14fakxssn2sgf5mrw4paf1ymz2j0vqj6jw1ka50x"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-derive" ,rust-serde-derive-1))))
    (home-page "https://github.com/rust-vmm/vmm-sys-util")
    (synopsis "system utility set")
    (description "This package provides a system utility set.")
    (license license:bsd-3)))

(define-public rust-vm-memory-0.14
  (package
    (name "rust-vm-memory")
    (version "0.14.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "vm-memory" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1x29zjw3lzxg8bcn16y6r88s7nfj6jp8vp6d81vnypycci8blfiw"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arc-swap" ,rust-arc-swap-1)
                       ("rust-bitflags" ,rust-bitflags-2)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-vmm-sys-util" ,rust-vmm-sys-util-0.12)
                       ("rust-winapi" ,rust-winapi-0.3))))
    (home-page "https://github.com/rust-vmm/vm-memory")
    (synopsis "Safe abstractions for accessing the VM physical memory")
    (description
     "This package provides Safe abstractions for accessing the VM physical memory.")
    (license (list license:asl2.0 license:bsd-3))))

(define-public rust-vhost-0.11
  (package
    (name "rust-vhost")
    (version "0.11.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "vhost" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1k47dd064z2mixx3mb29qclhgjly7ymi40nm3a37h6nlcq8qvq3b"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-vm-memory" ,rust-vm-memory-0.14)
                       ("rust-vmm-sys-util" ,rust-vmm-sys-util-0.12))))
    (home-page "https://github.com/rust-vmm/vhost")
    (synopsis "a pure rust library for vdpa, vhost and vhost-user")
    (description
     "This package provides a pure rust library for vdpa, vhost and vhost-user.")
    (license (list license:asl2.0 license:bsd-3))))

(define-public rust-libseccomp-sys-0.2
  (package
    (name "rust-libseccomp-sys")
    (version "0.2.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libseccomp-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0f6iw3qsww1dkrx49wh8vmda198i7galfnvfgjc52wj6mpabnz4s"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/libseccomp-rs/libseccomp-rs")
    (synopsis "Raw FFI Bindings for the libseccomp Library")
    (description
     "This package provides Raw FFI Bindings for the libseccomp Library.")
    (license (list license:expat license:asl2.0))))

(define-public rust-libc-0.2
  (package
    (name "rust-libc")
    (version "0.2.159")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libc" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1i9xpia0hn1y8dws7all8rqng6h3lc8ymlgslnljcvm376jrf7an"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1))))
    (home-page "https://github.com/rust-lang/libc")
    (synopsis "Raw FFI bindings to platform libraries like libc.")
    (description
     "This package provides Raw FFI bindings to platform libraries like libc.")
    (license (list license:expat license:asl2.0))))

(define-public rust-capng-0.2
  (package
    (name "rust-capng")
    (version "0.2.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "capng" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "11cyx3xyk226w9ayi7915p8zas1az8j2iv89hf5pwzzhjdppc9ks"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-1)
                       ("rust-libc" ,rust-libc-0.2))))
    (home-page "https://github.com/slp/capng")
    (synopsis "Rust wrapper for libcap-ng")
    (description "This package provides Rust wrapper for libcap-ng.")
    (license (list license:asl2.0 license:bsd-3))))

(define-public rust-virtiofsd-1
  (package
    (name "rust-virtiofsd")
    (version "1.11.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "virtiofsd" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0hkncicrfv5bp008cjc2vnhqzj3y8z3l078aahydyv7icx1fpxhv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-bitflags" ,rust-bitflags-1)
                       ("rust-capng" ,rust-capng-0.2)
                       ("rust-clap" ,rust-clap-4)
                       ("rust-env-logger" ,rust-env-logger-0.8)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-libseccomp-sys" ,rust-libseccomp-sys-0.2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-postcard" ,rust-postcard-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-syslog" ,rust-syslog-6)
                       ("rust-vhost" ,rust-vhost-0.11)
                       ("rust-vhost-user-backend" ,rust-vhost-user-backend-0.15)
                       ("rust-virtio-bindings" ,rust-virtio-bindings-0.2)
                       ("rust-virtio-queue" ,rust-virtio-queue-0.12)
                       ("rust-vm-memory" ,rust-vm-memory-0.14)
                       ("rust-vmm-sys-util" ,rust-vmm-sys-util-0.12))))
    (inputs (list libseccomp libcap-ng))
    (home-page "https://virtio-fs.gitlab.io/")
    (synopsis "virtio-fs vhost-user device daemon")
    (description "This package provides a virtio-fs vhost-user device daemon.")
    (license (list license:asl2.0 license:bsd-3))))
