(define-module (conner packages rust)
  #:use-module (guix utils)
  #:use-module (guix build utils)
  #:use-module (guix platform)
  #:use-module (guix packages)
  #:use-module (gnu packages rust))

(define-public rustc-fixed
  (package
   (inherit rust)
   (arguments
    (substitute-keyword-arguments
     (package-arguments rust)
     ((#:phases phases)
      `(modify-phases ,phases
	 (replace 'build
		  ;; Phase overridden to also build more tools.
		  (lambda* (#:key parallel-build? #:allow-other-keys)
                    (let ((job-spec (string-append
                                     "-j" (if parallel-build?
                                              (number->string (parallel-job-count))
                                              "1"))))
                      (invoke "./x.py" job-spec "build"
                              "library/std" ;rustc
                              "src/tools/cargo"
                              "src/tools/clippy"
                              "src/tools/rust-analyzer"
			      "src/tools/rust-analyzer/crates/proc-macro-srv-cli"
                              "src/tools/rustfmt"))))
	 (replace 'install
		  ;; Phase overridden to also install more tools.
		  (lambda* (#:key outputs #:allow-other-keys)
                    (invoke "./x.py" "install")
                    (substitute* "config.toml"
				 ;; Adjust the prefix to the 'cargo' output.
				 (("prefix = \"[^\"]*\"")
				  (format #f "prefix = ~s" (assoc-ref outputs "cargo"))))
                    (invoke "./x.py" "install" "cargo")
                    (substitute* "config.toml"
				 ;; Adjust the prefix to the 'tools' output.
				 (("prefix = \"[^\"]*\"")
				  (format #f "prefix = ~s" (assoc-ref outputs "tools"))))
                    (invoke "./x.py" "install" "clippy")
                    (invoke "./x.py" "install" "rust-analyzer")
                    (invoke "./x.py" "install" "rustfmt")
		    ;; ./x.py doesn't have an install target
                    ;; for the proc macro server, so we install it manually
                    (let* ((out (assoc-ref outputs "out"))
                           (platform ,(platform-rust-target
                                       (lookup-platform-by-target-or-system
					(or (%current-target-system)
                                            (%current-system))))))
                      (install-file (string-append "build/" platform "/stage2-tools/" platform "/release/rust-analyzer-proc-macro-srv")
                                    (string-append out "/libexec")))))))))))

