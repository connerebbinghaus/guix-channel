(define-module (conner packages prusa-slicer)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (gnu packages)
  #:use-module (gnu packages engineering)
  #:use-module (gnu packages gl))

(define-public glfw-3.4-fixed
  (package
   (inherit glfw-3.4)
   (name "glfw")
   (arguments (cons*
	       #:configure-flags #~(list "-DBUILD_SHARED_LIBS=ON" "-DGLFW_BUILD_DOCS=OFF") ; work around https://github.com/glfw/glfw/issues/2501
	       (strip-keyword-arguments (list #:configure-flags) (package-arguments glfw-3.4))))))

(define with-fixed-glfw
  ;; The package transformation procedure.
  (package-input-rewriting `((,glfw-3.4 . ,glfw-3.4-fixed))))

(define-public prusa-slicer-fixed
  (with-fixed-glfw prusa-slicer))
