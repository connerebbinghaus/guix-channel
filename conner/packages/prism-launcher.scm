(define-module (prism-launcher)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages markup)
  #:use-module (gnu packages cpp)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages kde-frameworks)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages vulkan)
  #:use-module (gnu packages java)
  #:use-module (gnu packages xdisorg))

(define-public prism-launcher
  (package
   (name "prism-launcher")
   (version "8.4")
   (source (origin
	    (method git-fetch)
	    (uri (git-reference
		  (url "https://github.com/PrismLauncher/PrismLauncher")
		  (commit version)
		  (recursive? #t)))
	    (file-name (git-file-name name version))
	    (sha256
	     (base32
	      "07ngh55rqxslrs3q1qlydxavxcc39dmxsgqnlv7xmn13ci1n5vsr"))
	    (modules '((guix build utils)))
	    (snippet '(for-each delete-file-recursively ; delete bundled libraries available in guix
				(list "libraries/cmark"
				      "libraries/extra-cmake-modules"
				      "libraries/filesystem" ; gulrak-filesystem
				      "libraries/quazip"
				      ;"libraries/tomlplusplus" ; FIXME: something is wrong with guix's tomlplusplus, strange cmake errors
				      "libraries/zlib")))))
   (arguments
    `(#:configure-flags '("-DLauncher_QT_VERSION_MAJOR=5"))) ; Use Qt5, guix's quazip uses it
   (build-system cmake-build-system)
   (native-inputs
    (list extra-cmake-modules pkg-config))
   (inputs
    (list
     qtbase-5
     cmark
     gulrak-filesystem
     quazip
     ;tomlplusplus ; FIXME
     zlib
     mesa
     vulkan-headers
     libxkbcommon
     `(,openjdk17 "jdk")))
   (home-page "https://prismlauncher.org/")
   (synopsis "Custom launcher for Minecraft")
   (description "Prism Launcher is a custom launcher for Minecraft that allows you to easily manage multiple installations of Minecraft at once.")
   (license license:gpl3)))
