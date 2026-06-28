(define-module (conner packages prism-launcher)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages markup)
  #:use-module (gnu packages cpp)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages kde-frameworks)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages vulkan)
  #:use-module (gnu packages java)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages aidc)
  #:use-module (gnu packages backup)
  #:use-module (gnu packages man)
  #:use-module (gnu packages vulkan))

(define-public prism-launcher
  (package
   (name "prism-launcher")
   (version "11.0.2")
   (source (origin
	    (method git-fetch)
	    (uri (git-reference
		  (url "https://github.com/PrismLauncher/PrismLauncher")
		  (commit version)
		  (recursive? #t)))
	    (file-name (git-file-name name version))
	    (sha256
	     (base32
	      "1qzzfaz4k5c3wlgf53v0cpkg5fw24hfknm7j41hkbihrajgv6nxn"))))
   (arguments '(
      #:configure-flags '("-DCMAKE_CXX_FLAGS=-Wno-array-bounds") ;; Causes errors in QT headers
      #:phases
      (modify-phases %standard-phases ; Taken from https://gitlab.com/guix-gaming-channels/games/-/blob/66fe8b72d114ee2de218fc46d0f7ad95d8b3129e/games/packages/minecraft.scm
		     (add-after 'install 'patch-paths
				(lambda* (#:key inputs outputs #:allow-other-keys)
				  (let* ((out            (assoc-ref outputs "out"))
					 (bin            (string-append out "/bin/prismlauncher"))
					 (xrandr         (assoc-ref inputs "xrandr"))
					 (qtwayland      (assoc-ref inputs "qtwayland")))
				    (wrap-program bin
						  `("PATH" ":" prefix (,(string-append xrandr "/bin")))
						  `("QT_PLUGIN_PATH" ":" prefix (,(string-append
										   qtwayland "/lib/qt5/plugins")))
						  `("LD_LIBRARY_PATH" ":" prefix
						    (,@(map (lambda (dep)
							      (string-append (assoc-ref inputs dep)
									     "/lib"))
							    '("libx11" "libxext" "libxcursor"
							      "libxrandr" "libxxf86vm" "pulseaudio" "mesa" "vulkan-loader" "eudev")))))
				    #t))))))
   (build-system cmake-build-system)
   (native-inputs
    (list extra-cmake-modules pkg-config scdoc))
   (inputs
    (list
     bash-minimal
     qtbase
     qtwayland
     qtnetworkauth
     cmark
     gulrak-filesystem
     quazip
     tomlplusplus
     zlib
     mesa
     libx11
     libxext
     libxcursor
     libxrandr
     libxxf86vm
     pulseaudio
     mesa
     xrandr
     gamemode
     qrencode
     libarchive
     vulkan-loader
     eudev))
   (propagated-inputs (list `(,openjdk17 "jdk")))
   (home-page "https://prismlauncher.org/")
   (synopsis "Custom launcher for Minecraft")
   (description "Prism Launcher is a custom launcher for Minecraft that allows you to easily manage multiple installations of Minecraft at once.")
   (license license:gpl3)))
