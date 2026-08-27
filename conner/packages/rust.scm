(define-module (conner packages rust)
  #:use-module (guix utils)
  #:use-module (guix build utils)
  #:use-module (guix platform)
  #:use-module (guix packages)
  #:use-module (gnu packages rust)
  #:use-module (gnu packages llvm-meta)
  #:use-module (guix search-paths)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages gdb)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages cross-base)
  #:use-module (guix gexp)
  #:use-module (conner packages))

(define-public rustc-fixed rust) ;; Now fixed upstream

(define %cargo-reference-hash
  "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")

(define (absolute-file-name file directory)
  "Return the canonical absolute file name for FILE, which lives in the
vicinity of DIRECTORY."
  (canonicalize-path
   (cond ((string-prefix? "/" file) file)
         ((not directory) file)
         ((string-prefix? "/" directory)
          (string-append directory "/" file))
         (else file))))

; Taken from guix's gnu/packages/rust.scm
(define* (rust-uri version #:key (dist "static"))
  (string-append "https://" dist ".rust-lang.org/dist/"
                 "rustc-" version "-src.tar.gz"))
(define* (rust-bootstrapped-package base-rust version checksum)
  "Bootstrap rust VERSION with source checksum CHECKSUM using BASE-RUST."
  (package
    (inherit base-rust)
    (version version)
    (source
     (origin
       (inherit (package-source base-rust))
       (uri (rust-uri version))
       (sha256 (base32 checksum))))
    (arguments
     (substitute-keyword-arguments (package-arguments base-rust)
       ((#:disallowed-references _ '())
        (list (this-package-native-input "rustc-bootstrap")))))
    (native-inputs
     (modify-inputs native-inputs
       (replace "rustc-bootstrap" base-rust)
       (replace "cargo-bootstrap" (list base-rust "cargo"))))))

;; From guix's rust-team branch as of commit aa8d7df51f
(define-public rust-1.95
  (let ((base-rust
         (rust-bootstrapped-package
          rust-1.94 "1.95.0"
          "05d53hj717ildhvm3rln7821r08nzbbfk72nqcvpb5j67sl856za")))
    (package
      (inherit base-rust)
      (source
       (origin
         (inherit (package-source base-rust))
         (snippet
          '(begin
             (for-each delete-file-recursively
                       '("src/llvm-project"
                         "vendor/curl-sys-0.4.79+curl-8.12.0/curl"
                         "vendor/curl-sys-0.4.83+curl-8.15.0/curl"
                         "vendor/curl-sys-0.4.84+curl-8.17.0/curl"
                         "vendor/jemalloc-sys-0.5.3+5.3.0-patched/jemalloc"
                         "vendor/jemalloc-sys-0.5.4+5.3.0-patched/jemalloc"
                         "vendor/libffi-sys-4.1.0/libffi"
                         "vendor/libmimalloc-sys-0.1.44/c_src/mimalloc"
                         "vendor/libz-sys-1.1.21/src/zlib"
                         "vendor/libz-sys-1.1.23/src/zlib"
                         "vendor/openssl-src-111.28.2+1.1.1w/openssl"
                         "vendor/openssl-src-300.5.0+3.5.0/openssl"
                         "vendor/openssl-src-300.5.4+3.5.4/openssl"
                         "vendor/tikv-jemalloc-sys-0.5.4+5.3.0-patched/jemalloc"
                         "vendor/tikv-jemalloc-sys-0.6.1+5.3.0-1-\
ge13ca993e8ccb9ba9847cc330696e02839f328f7/jemalloc"))
             ;; Remove vendored dynamically linked libraries.
             ;; find . -not -type d -executable -exec file {} \+ | grep ELF
             ;; Also remove the bundled (mostly Windows) libraries.
             (for-each delete-file
                       (find-files "vendor" "\\.(a|dll|exe|lib)$"))
             ;; Use the packaged nghttp2.
             (for-each
              (lambda (ver)
                (let ((vendored-dir
                       (format #f "vendor/libnghttp2-sys-~a/nghttp2" ver))
                      (build-rs
                       (format #f "vendor/libnghttp2-sys-~a/build.rs" ver)))
                  (delete-file-recursively vendored-dir)
                  (delete-file build-rs)
                  (call-with-output-file build-rs
                    (lambda (port)
                      (format port "fn main() {~@
                         println!(\"cargo:rustc-link-lib=nghttp2\");~@
                         }~%")))))
              '("0.1.11+1.64.0"))
             ;; Adjust vendored dependency to explicitly use rustix with libc
             ;; backend.
             (substitute* '("vendor/tempfile-3.14.0/Cargo.toml"
                            "vendor/tempfile-3.16.0/Cargo.toml"
                            "vendor/tempfile-3.19.1/Cargo.toml"
                            "vendor/tempfile-3.20.0/Cargo.toml"
                            "vendor/tempfile-3.21.0/Cargo.toml"
                            "vendor/tempfile-3.23.0/Cargo.toml"
                            "vendor/tempfile-3.24.0/Cargo.toml")
               (("features = \\[\"fs\"" all)
                (string-append all ", \"use-libc\""))))))))))

;; From guix's rust-team branch as of commit aa8d7df51f
(define-public rust-1.96
  (let ((base-rust
         (rust-bootstrapped-package
          rust-1.95 "1.96.0"
          "0i1v0i878zviwxz3hr18dxq7dqv4ggbykns0r3x8m55jafqrw2p9")))
    (package
      (inherit base-rust)
      (source
       (origin
         (inherit (package-source base-rust))
         (snippet
          '(begin
             (for-each delete-file-recursively
                       '("src/llvm-project"
                         "vendor/curl-sys-0.4.79+curl-8.12.0/curl"
                         "vendor/curl-sys-0.4.84+curl-8.17.0/curl"
                         "vendor/curl-sys-0.4.87+curl-8.19.0/curl"
                         "vendor/jemalloc-sys-0.5.3+5.3.0-patched/jemalloc"
                         "vendor/jemalloc-sys-0.5.4+5.3.0-patched/jemalloc"
                         "vendor/libffi-sys-4.1.0/libffi"
                         "vendor/libmimalloc-sys-0.1.44/c_src/mimalloc"
                         "vendor/libz-sys-1.1.21/src/zlib"
                         "vendor/libz-sys-1.1.23/src/zlib"
                         "vendor/libz-sys-1.1.24/src/zlib"
                         "vendor/openssl-src-111.28.2+1.1.1w/openssl"
                         "vendor/openssl-src-300.5.0+3.5.0/openssl"
                         "vendor/openssl-src-300.5.4+3.5.4/openssl"
                         "vendor/tikv-jemalloc-sys-0.5.4+5.3.0-patched/jemalloc"
                         "vendor/tikv-jemalloc-sys-0.6.1+5.3.0-1-\
ge13ca993e8ccb9ba9847cc330696e02839f328f7/jemalloc"))
             ;; Remove vendored dynamically linked libraries.
             ;; find . -not -type d -executable -exec file {} \+ | grep ELF
             ;; Also remove the bundled (mostly Windows) libraries.
             (for-each delete-file
                       (find-files "vendor" "\\.(a|dll|exe|lib)$"))
             ;; Use the packaged nghttp2.
             (for-each
              (lambda (ver)
                (let ((vendored-dir
                       (format #f "vendor/libnghttp2-sys-~a/nghttp2" ver))
                      (build-rs
                       (format #f "vendor/libnghttp2-sys-~a/build.rs" ver)))
                  (delete-file-recursively vendored-dir)
                  (delete-file build-rs)
                  (call-with-output-file build-rs
                    (lambda (port)
                      (format port "fn main() {~@
                         println!(\"cargo:rustc-link-lib=nghttp2\");~@
                         }~%")))))
              '("0.1.11+1.64.0"
                "0.1.13+1.68.1"))
             ;; Adjust vendored dependency to explicitly use rustix with libc
             ;; backend.
             (substitute* '("vendor/tempfile-3.14.0/Cargo.toml"
                            "vendor/tempfile-3.16.0/Cargo.toml"
                            "vendor/tempfile-3.19.1/Cargo.toml"
                            "vendor/tempfile-3.20.0/Cargo.toml"
                            "vendor/tempfile-3.21.0/Cargo.toml"
                            "vendor/tempfile-3.23.0/Cargo.toml"
                            "vendor/tempfile-3.27.0/Cargo.toml")
               (("features = \\[\"fs\"" all)
                (string-append all ", \"use-libc\""))))))))))

(define-public rust-1.97
  (let ((base-rust
         (rust-bootstrapped-package
          rust-1.96 "1.97.1"
          "178sxzghqr09awgjr4f1pqzdc779ahsx0l9svp0gvjskki12nb32")))
    (package
      (inherit base-rust)
      (source
       (origin
        (inherit (package-source base-rust))
	(patches (conner-patches "rust-1.97-clippy-fix-proc-macros-aux-race.patch" "0001-build-std-obey-RUST_SRC_PATH.patch"))
        (snippet
         '(begin
             (for-each delete-file-recursively
                       '("src/llvm-project"
                         "vendor/curl-sys-0.4.79+curl-8.12.0/curl"
                         "vendor/curl-sys-0.4.87+curl-8.19.0/curl"
                         "vendor/curl-sys-0.4.88+curl-8.20.0/curl"
                         "vendor/jemalloc-sys-0.5.3+5.3.0-patched/jemalloc"
                         "vendor/jemalloc-sys-0.5.4+5.3.0-patched/jemalloc"
                         "vendor/libffi-sys-4.1.0/libffi"
                         "vendor/libmimalloc-sys-0.1.44/c_src/mimalloc"
                         "vendor/libz-sys-1.1.21/src/zlib"
                         "vendor/libz-sys-1.1.23/src/zlib"
                         "vendor/libz-sys-1.1.28/src/zlib"
                         "vendor/openssl-src-111.28.2+1.1.1w/openssl"
                         "vendor/openssl-src-300.5.0+3.5.0/openssl"
                         "vendor/openssl-src-300.6.0+3.6.2/openssl"
                         "vendor/tikv-jemalloc-sys-0.5.4+5.3.0-patched/jemalloc"
                         "vendor/tikv-jemalloc-sys-0.6.1+5.3.0-1-\
ge13ca993e8ccb9ba9847cc330696e02839f328f7/jemalloc"))
             ;; Remove vendored dynamically linked libraries.
             ;; find . -not -type d -executable -exec file {} \+ | grep ELF
             ;; Also remove the bundled (mostly Windows) libraries.
             (for-each delete-file
                       (find-files "vendor" "\\.(a|dll|exe|lib)$"))
             ;; Use the packaged nghttp2.
             (for-each
              (lambda (ver)
                (let ((vendored-dir
                       (format #f "vendor/libnghttp2-sys-~a/nghttp2" ver))
                      (build-rs
                       (format #f "vendor/libnghttp2-sys-~a/build.rs" ver)))
                  (delete-file-recursively vendored-dir)
                  (delete-file build-rs)
                  (call-with-output-file build-rs
                    (lambda (port)
                      (format port "fn main() {~@
                         println!(\"cargo:rustc-link-lib=nghttp2\");~@
                         }~%")))))
              '("0.1.11+1.64.0"
                "0.1.13+1.68.1"))
             ;; Adjust vendored dependency to explicitly use rustix with libc
             ;; backend.
             (substitute* '("vendor/tempfile-3.14.0/Cargo.toml"
                            "vendor/tempfile-3.16.0/Cargo.toml"
                            "vendor/tempfile-3.19.1/Cargo.toml"
                            "vendor/tempfile-3.20.0/Cargo.toml"
                            "vendor/tempfile-3.23.0/Cargo.toml"
                            "vendor/tempfile-3.27.0/Cargo.toml")
               (("features = \\[\"fs\"" all)
                (string-append all ", \"use-libc\""))))))))))

(define-public rust-1.98
  (let ((base-rust
         (rust-bootstrapped-package
          rust-1.97 "1.98.0"
          "0ag9fm5m75i30l6j93i6anfxa5h7nnbfkzc55fz9zgpzfprsw9mj")))
    (package
      (inherit base-rust)
      (source
       (origin
        (inherit (package-source base-rust))
        (snippet
         '(begin
             (for-each delete-file-recursively
                       '("src/llvm-project"
                         "vendor/curl-sys-0.4.79+curl-8.12.0/curl"
                         "vendor/curl-sys-0.4.87+curl-8.19.0/curl"
                         "vendor/curl-sys-0.4.90+curl-8.21.0/curl"
                         "vendor/jemalloc-sys-0.5.3+5.3.0-patched/jemalloc"
                         "vendor/jemalloc-sys-0.5.4+5.3.0-patched/jemalloc"
                         "vendor/libffi-sys-4.1.0/libffi"
                         "vendor/libmimalloc-sys-0.1.49/c_src/mimalloc"
                         "vendor/libz-sys-1.1.21/src/zlib"
                         "vendor/libz-sys-1.1.23/src/zlib"
                         "vendor/libz-sys-1.1.29/src/zlib"
                         "vendor/openssl-src-111.28.2+1.1.1w/openssl"
                         "vendor/openssl-src-300.5.0+3.5.0/openssl"
                         "vendor/openssl-src-300.6.1+3.6.3/openssl"
                         "vendor/tikv-jemalloc-sys-0.5.4+5.3.0-patched/jemalloc"
                         "vendor/tikv-jemalloc-sys-0.6.1+5.3.0-1-\
ge13ca993e8ccb9ba9847cc330696e02839f328f7/jemalloc"))
             ;; Remove vendored dynamically linked libraries.
             ;; find . -not -type d -executable -exec file {} \+ | grep ELF
             ;; Also remove the bundled (mostly Windows) libraries.
             (for-each delete-file
                       (find-files "vendor" "\\.(a|dll|exe|lib)$"))
             ;; Use the packaged nghttp2.
             (for-each
              (lambda (ver)
                (let ((vendored-dir
                       (format #f "vendor/libnghttp2-sys-~a/nghttp2" ver))
                      (build-rs
                       (format #f "vendor/libnghttp2-sys-~a/build.rs" ver)))
                  (delete-file-recursively vendored-dir)
                  (delete-file build-rs)
                  (call-with-output-file build-rs
                    (lambda (port)
                      (format port "fn main() {~@
                         println!(\"cargo:rustc-link-lib=nghttp2\");~@
                         }~%")))))
              '("0.1.11+1.64.0"
                "0.1.13+1.68.1"))
             ;; Adjust vendored dependency to explicitly use rustix with libc
             ;; backend.
             (substitute* '("vendor/tempfile-3.14.0/Cargo.toml"
                            "vendor/tempfile-3.16.0/Cargo.toml"
                            "vendor/tempfile-3.19.1/Cargo.toml"
                            "vendor/tempfile-3.20.0/Cargo.toml"
                            "vendor/tempfile-3.23.0/Cargo.toml"
                            "vendor/tempfile-3.27.0/Cargo.toml")
               (("features = \\[\"fs\"" all)
                (string-append all ", \"use-libc\""))))))))))

(define (make-ignore-test-list strs)
  "Function to make creating a list to ignore tests a bit easier."
  (map (lambda (str)
    `((,str) (string-append "#[ignore]\n" ,str)))
    strs))

(define-public rust-latest
  (let ((base-rust rust-1.98))
    (package
      (inherit base-rust)
      (properties (append
                    (alist-delete 'hidden? (package-properties base-rust))
                    ;; Keep in sync with the llvm used to build rust.
                    (clang-compiler-cpu-architectures "22")))
      (outputs (cons* "rust-src" "tools" (package-outputs base-rust)))
      (arguments
       (substitute-keyword-arguments
         (strip-keyword-arguments '(#:tests?)
                                  (package-arguments base-rust))
         ((#:modules modules)
          (cons '(srfi srfi-26) modules))
         ((#:phases phases)
          `(modify-phases ,phases
             (add-after 'unpack 'patch-shebangs-in-tests
               (lambda* (#:key inputs #:allow-other-keys)
                 (with-directory-excursion
                   "src/tools/rust-analyzer/crates/parser/test_data"
                   (substitute* '("lexer/ok/shebang_frontmatter.rast"
                                  "parser/inline/ok/frontmatter.rast")
                     (("/usr/bin/env cargo")
                      (search-input-file inputs "bin/cargo")))
                   (substitute* "lexer/ok/single_line_comments.rast"
                     (("/usr/bin/env bash")
                      (search-input-file inputs "bin/bash"))))))
             (add-after 'unpack 'disable-tests-requiring-git
               (lambda _
                 (substitute* "src/tools/cargo/tests/testsuite/publish_lockfile.rs"
                   ,@(make-ignore-test-list
                      '("fn note_resolve_changes")))))
             (add-after 'unpack 'disable-tests-using-cargo-publish
               (lambda _
                 (substitute* "src/tools/cargo/tests/testsuite/install.rs"
                   ,@(make-ignore-test-list
                      '("fn failed_install_retains_temp_directory")))))
             ,@(if (target-riscv64?)
                   ;; Keep this phase separate so it can be adjusted without needing
                   ;; to adjust the skipped tests on other architectures.
                   `((add-after 'unpack 'disable-tests-broken-on-riscv64
                       (lambda _
                         (with-directory-excursion "src/tools/cargo/tests/testsuite"
                           (substitute* "build.rs"
                             ,@(make-ignore-test-list
                                 '("fn uplift_dwp_of_bin_on_linux")))
                           (substitute* "cache_lock.rs"
                             ,@(make-ignore-test-list
                                 '("fn multiple_shared"
                                   "fn multiple_download"
                                   "fn download_then_mutate"
                                   "fn mutate_err_is_atomic")))
                           (substitute* "global_cache_tracker.rs"
                             ,@(make-ignore-test-list
                                 '("fn package_cache_lock_during_build"))))
                         (with-directory-excursion "src/tools/clippy/tests"
                           ;; `"vectorcall"` is not a supported ABI for the current target
                           (delete-file "ui/missing_const_for_fn/could_be_const.rs")
                           (substitute* "missing-test-files.rs"
                             ,@(make-ignore-test-list
                                '("fn test_missing_tests")))))))
                   `())
             (add-after 'unpack 'skip-unupdated-clippy-tests
               (lambda _
                 (with-directory-excursion "src/tools/clippy/tests/ui"
                   (delete-file "cognitive_complexity.rs")
                   (delete-file "cognitive_complexity.stderr"))))
             (add-after 'unpack 'disable-tests-requiring-network-access
               (lambda _
                 (substitute* "src/tools/cargo/tests/testsuite/git.rs"
                   ,@(make-ignore-test-list
                      '("fn dep_with_scp_like_submodule_url")))
                 (substitute* "src/tools/cargo/tests/testsuite/git_auth.rs"
                   ,@(make-ignore-test-list
                      '("fn net_err_suggests_fetch_with_cli")))
                 (substitute* "src/tools/cargo/tests/testsuite/package.rs"
                   ,@(make-ignore-test-list
                      '("fn publish_to_crates_io_warns")))))
             (add-after 'unpack 'patch-process-tests
               (lambda* (#:key inputs #:allow-other-keys)
                 (let ((bash (assoc-ref inputs "bash")))
                   (with-directory-excursion "library/std/src"
                     (substitute* "process/tests.rs"
                       (("\"/bin/sh\"")
                        (string-append "\"" bash "/bin/sh\"")))
                     ;; The three tests which are known to fail upstream on QEMU
                     ;; emulation on aarch64 and riscv64 also fail on x86_64 in
                     ;; Guix's build system.  Skip them on all builds.
                     (substitute* "sys/process/unix/common/tests.rs"
                       ;; We can't use make-ignore-test-list because we will get
                       ;; build errors due to the double [ignore] block.
                       (("target_arch = \"arm\"" arm)
                        (string-append "target_os = \"linux\",\n"
                                       "        " arm)))))))
             (add-after 'unpack 'disable-interrupt-tests
               (lambda _
                 ;; This test hangs in the build container; disable it.
                 (substitute* "src/tools/cargo/tests/testsuite/freshness.rs"
                   ,@(make-ignore-test-list
                      '("fn linking_interrupted")))
                 ;; Likewise for the ctrl_c_kills_everyone test.
                 (substitute* "src/tools/cargo/tests/testsuite/death.rs"
                   ,@(make-ignore-test-list
                      '("fn ctrl_c_kills_everyone")))))
             (add-after 'unpack 'adjust-rpath-values
               ;; This adds %output:out to rpath, allowing us to install utilities in
               ;; different outputs while reusing the shared libraries.
               (lambda* (#:key outputs #:allow-other-keys)
                 (let ((out (assoc-ref outputs "out")))
                   (substitute* "src/bootstrap/src/core/builder/cargo.rs"
                     ((" = rpath.*" all)
                      (string-append all
                                     "                "
                                     "self.rustflags.arg(\"-Clink-args=-Wl,-rpath="
                                     out "/lib\");\n"))))))
             (add-after 'unpack 'unpack-profiler-rt
               ;; Copy compiler-rt sources to where libprofiler_builtins looks
               ;; for its vendored copy.
               (lambda* (#:key inputs #:allow-other-keys)
                 (mkdir-p "src/llvm-project/compiler-rt")
                 (copy-recursively
                  (search-input-directory inputs "/compiler-rt")
                  "src/llvm-project/compiler-rt")))
             (add-after 'unpack 'unpack-libunwind
               (lambda* (#:key inputs #:allow-other-keys)
                 (mkdir-p "src/llvm-project/libunwind")
                 (copy-recursively
                  (search-input-directory inputs "/libunwind")
                  "src/llvm-project/libunwind")))
             (replace 'patch-cargo-checksums
               (lambda _
                 (substitute*
                   (append '("Cargo.lock"
                             "src/bootstrap/Cargo.lock")
                           (find-files "compiler" "Cargo.lock")
                           (find-files "library" "Cargo.lock")
                           (find-files "src/doc" "Cargo.lock")
                           (remove
                             ;; Don't mess with the lock files in the Cargo
                             ;; testsuite; it messes up the tests.
                             (cut string-contains <>
                                  "cargo/tests/testsuite")
                             (find-files "src/tools" "Cargo.lock")))
                   (("(checksum = )\".*\"" all name)
                    (string-append name "\"" ,%cargo-reference-hash "\"")))
                 (generate-all-checksums "vendor")))
             (add-after 'configure 'enable-profiling
               (lambda _
                 (substitute* "config.toml"
                   (("^profiler =.*$") "")
                   (("\\[build\\]") "\n[build]\nprofiler = true\n"))))
             (add-after 'configure 'add-gdb-to-config
               (lambda* (#:key inputs #:allow-other-keys)
                 (let ((gdb (assoc-ref inputs "gdb")))
                   (substitute* "config.toml"
                     (("^python =.*" all)
                      (string-append all
                                     "gdb = \"" gdb "/bin/gdb\"\n"))))))
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
                           "src/tools/llvm-bitcode-linker"
                           "src/tools/rust-analyzer"
                           "src/tools/rustfmt"))))
             (replace 'check
               ;; Phase overridden to also test more tools.
               (lambda* (#:key tests? parallel-build? #:allow-other-keys)
                 (when tests?
                   (let ((job-spec (string-append
                                    "-j" (if parallel-build?
                                             (number->string (parallel-job-count))
                                             "1"))))
                     (invoke "./x.py" job-spec "test" "-vv"
                             "library/std"
                             "src/tools/cargo"
                             "src/tools/clippy"
                             "src/tools/rust-analyzer"
                             "src/tools/rustfmt")))))
             (replace 'install
               ;; Phase overridden to also install more tools.
               (lambda* (#:key outputs #:allow-other-keys)
                 ;; Install rustc, std, and llvm-bitcode-linker.
                 ;; rust-src is handled separately in 'install-rust-src'.
                 (invoke "./x.py" "install" "compiler/rustc" "library/std"
                         "llvm-bitcode-linker")
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
                 (invoke "./x.py" "install" "rustfmt")))
             (add-before 'patch-cargo-checksums 'save-old-library-manifest
               (lambda _
                 (copy-file "library/Cargo.lock" ".old-library-manifest")))
             (add-after 'install 'install-rust-src
               (lambda* (#:key outputs #:allow-other-keys)
                 (let ((out (assoc-ref outputs "rust-src"))
                       (dest "/lib/rustlib/src/rust"))
                   (mkdir-p (string-append out dest))
                   (copy-recursively "library" (string-append out dest "/library"))
                   ;; rust-analyzer needs the original checksums; otherwise
                   ;; it fails to cargo manifest in the stdlib, and then
                   ;; analysis/inference involving stdlib structs doesn't work.
                   ;;
                   ;; For example, in the following trivial program:
                   ;;
                   ;; fn main() {
                   ;;     let x = Vec::<usize>::new();
                   ;; }
                   ;;
                   ;; rust-analyzer since version 1.82 can't infer
                   ;; the type of x unless the following line is present.
                   (copy-file ".old-library-manifest"
                              (string-append out dest "/library/Cargo.lock"))
                   (copy-recursively "src" (string-append out dest "/src")))))
             (add-before 'install 'remove-uninstall-script
               (lambda _
                 ;; Don't install the uninstall script.  It has no use
                 ;; on Guix and it retains a reference to the host's bash.
                 (substitute* "src/tools/rust-installer/install-template.sh"
                   (("install_uninstaller \"") "# install_uninstaller \""))))
             (add-after 'install-rust-src 'dont-reference-previous-cargo-version
               (lambda* (#:key outputs #:allow-other-keys)
                 (with-directory-excursion
                   (string-append (assoc-ref outputs "rust-src")
                                  "/lib/rustlib/src/rust/src/tools/")
                   (substitute* (find-files "." "\\.(rs|rast)$")
                     (("#!.*/bin/cargo")
                      (string-append "#!" (assoc-ref outputs "cargo")
                                     "/bin/cargo"))))))
             (add-after 'install-rust-src 'wrap-rust-analyzer
               (lambda* (#:key outputs #:allow-other-keys)
                 (let ((bin (string-append (assoc-ref outputs "tools") "/bin")))
                   (rename-file (string-append bin "/rust-analyzer")
                                (string-append bin "/.rust-analyzer-real"))
                   (call-with-output-file (string-append bin "/rust-analyzer")
                     (lambda (port)
                       (format port "#!~a
if test -z \"${RUST_SRC_PATH}\";then export RUST_SRC_PATH=~S;fi;
exec -a \"$0\" \"~a\" \"$@\""
                               (which "bash")
                               (string-append (assoc-ref outputs "rust-src")
                                              "/lib/rustlib/src/rust/library")
                               (string-append bin "/.rust-analyzer-real"))))
                   (chmod (string-append bin "/rust-analyzer") #o755))))))))
      (native-inputs
       (modify-inputs (package-native-inputs base-rust)
        (prepend
          ;; Keep in sync with the llvm used to build rust.
          (package-source clang-runtime-22)
          ;; Add test inputs.
          gdb/pinned
          git-minimal/pinned
          procps)))
      (native-search-paths
       (cons*
         ;; For HTTPS access, Cargo reads from a single-file certificate
         ;; specified with $CARGO_HTTP_CAINFO. See
         ;; https://doc.rust-lang.org/cargo/reference/environment-variables.html
         (search-path-specification
          (variable "CARGO_HTTP_CAINFO")
          (file-type 'regular)
          (separator #f)              ;single entry
          (files '("etc/ssl/certs/ca-certificates.crt")))
         ;; Make the sources discoverable not just when wrapped.
         (search-path-specification
          (variable "RUST_SRC_PATH")
          (separator #f)              ;single entry
          (files '("lib/rustlib/src/rust/library")))
         ;; rustc invokes gcc, so we need to set its search paths accordingly.
         %gcc-search-paths)))))

(define-public with-nightly-features
  (lambda (base-rust)
    (package
     (inherit base-rust)
     (arguments
      (substitute-keyword-arguments
       (package-arguments base-rust)
       ((#:phases phases)
        #~(modify-phases #$phases
          (add-after 'configure 'enable-nightly-features
	   (lambda _
	     (substitute* "config.toml"
			  (("channel = \"stable\"") "channel = \"nightly\"")))))))))))

(define-public with-extra-targets
  (lambda (base-rust extra-targets)
    (package
      (inherit base-rust)
      (outputs '("out"))
      (arguments
       (substitute-keyword-arguments (package-arguments base-rust)
         ((#:phases phases)
          #~(modify-phases #$phases
              (replace 'configure
                (lambda* (#:key inputs outputs #:allow-other-keys)
                  (let* ((out (assoc-ref outputs "out"))
                         (target-cc
                          (search-input-file
                           inputs (string-append "/bin/" #$target-cc-name))))
                    (call-with-output-file "config.toml"
                      (lambda (port)
                        (display (string-append "
[llvm]
[build]
cargo = \"" (search-input-file inputs "/bin/cargo") "\"
rustc = \"" (search-input-file inputs "/bin/rustc") "\"
docs = false
python = \"" (which "python") "\"
vendor = true
submodules = false
target = [\"" #$target "\"]
[install]
prefix = \"" out "\"
sysconfdir = \"etc\"
[rust]
debug = false
jemalloc = false
default-linker = \"" target-cc "\"
channel = \"stable\"
[target." #$(platform-rust-target (lookup-platform-by-system (%current-system))) "]
# These are all native tools
llvm-config = \"" (search-input-file inputs "/bin/llvm-config") "\"
linker = \"" (which "gcc") "\"
cc = \"" (which "gcc") "\"
cxx = \"" (which "g++") "\"
ar = \"" (which "ar") "\"
[target." #$target "]
llvm-config = \"" (search-input-file inputs "/bin/llvm-config") "\"
linker = \"" target-cc "\"
cc = \"" target-cc "\"
cxx = \"" (search-input-file inputs (string-append "/bin/" #$target-cxx-name)) "\"
ar = \"" (search-input-file inputs (string-append "/bin/" #$target-ar-name)) "\"
[dist]
") port)))))))))))))

(define-public make-rust-sysroot
  (lambda (target deps target-cc target-cxx target-ar)
    (make-rust-sysroot/implementation target deps target-cc target-cxx target-ar rust-latest)))

(define make-rust-sysroot/implementation
  (lambda (target deps target-cc-name target-cxx-name target-ar-name base-rust)
    (package
      (inherit base-rust)
      (name (string-append "rust-sysroot-for-" target))
      (outputs '("out"))
      (arguments
       (substitute-keyword-arguments (package-arguments base-rust)
         ((#:tests? _ #f) #f)           ; This package for cross-building.
         ((#:phases phases)
          #~(modify-phases #$phases
              (add-after 'unpack 'unbundle-xz
                (lambda _
                  (delete-file-recursively "vendor/lzma-sys-0.1.20/xz-5.2")
                  ;; Remove the option of using the static library.
                  ;; This is necessary for building the sysroot.
                  (substitute* "vendor/lzma-sys-0.1.20/build.rs"
                    (("!want_static && ") ""))))
              #$@(if (target-mingw? target)
                     `((add-after 'set-env 'patch-for-mingw
                         (lambda* (#:key inputs #:allow-other-keys)
                           (let* ((arch ,(string-take target
                                                      (string-index target #\-)))
                                  (mingw (assoc-ref inputs
                                                    (string-append "mingw-w64-" arch
                                                                   "-winpthreads"))))
                             (setenv "LIBRARY_PATH"
                                     (string-join
                                       (delete
                                         (string-append mingw "/lib")
                                         (string-split (getenv "LIBRARY_PATH") #\:))
                                       ":"))
                             (setenv "CPLUS_INCLUDE_PATH"
                                     (string-join
                                       (delete
                                         (string-append mingw "/include")
                                         (string-split (getenv "CPLUS_INCLUDE_PATH") #\:))
                                       ":"))))))
                     `())
              (replace 'set-env
                (lambda* (#:key inputs #:allow-other-keys)
                  (setenv "SHELL" (which "sh"))
                  (setenv "CONFIG_SHELL" (which "sh"))
                  (setenv "CC" (which "gcc"))
                  ;; The Guix LLVM package installs only shared libraries.
                  (setenv "LLVM_LINK_SHARED" "1")

                  (setenv "CROSS_LIBRARY_PATH" (getenv "LIBRARY_PATH"))
                  (setenv "CROSS_CPLUS_INCLUDE_PATH" (getenv "CPLUS_INCLUDE_PATH"))
                  (when (assoc-ref inputs (string-append "glibc-cross-" #$target))
                    (setenv "LIBRARY_PATH"
                            (string-join
                             (delete
                              (string-append
                               (assoc-ref inputs
                                          (string-append "glibc-cross-" #$target))
                               "/lib")
                              (string-split (getenv "LIBRARY_PATH") #\:))
                             ":"))
                    (setenv "CPLUS_INCLUDE_PATH"
                            (string-join
                             (delete
                              (string-append
                               (assoc-ref inputs
                                          (string-append "glibc-cross-" #$target))
                               "/include")
                              (string-split (getenv "CPLUS_INCLUDE_PATH") #\:))
                             ":")))))
              (replace 'configure
                (lambda* (#:key inputs outputs #:allow-other-keys)
                  (let* ((out (assoc-ref outputs "out"))
                         (target-cc
                          (search-input-file
                           inputs (string-append "/bin/" #$target-cc-name))))
                    (call-with-output-file "config.toml"
                      (lambda (port)
                        (display (string-append "
[llvm]
[build]
cargo = \"" (search-input-file inputs "/bin/cargo") "\"
rustc = \"" (search-input-file inputs "/bin/rustc") "\"
docs = false
python = \"" (which "python") "\"
vendor = true
submodules = false
target = [\"" #$target "\"]
[install]
prefix = \"" out "\"
sysconfdir = \"etc\"
[rust]
debug = false
jemalloc = false
default-linker = \"" target-cc "\"
channel = \"stable\"
[target." #$(platform-rust-target (lookup-platform-by-system (%current-system))) "]
# These are all native tools
llvm-config = \"" (search-input-file inputs "/bin/llvm-config") "\"
linker = \"" (which "gcc") "\"
cc = \"" (which "gcc") "\"
cxx = \"" (which "g++") "\"
ar = \"" (which "ar") "\"
[target." #$target "]
llvm-config = \"" (search-input-file inputs "/bin/llvm-config") "\"
linker = \"" target-cc "\"
cc = \"" target-cc "\"
cxx = \"" (search-input-file inputs (string-append "/bin/" #$target-cxx-name)) "\"
ar = \"" (search-input-file inputs (string-append "/bin/" #$target-ar-name)) "\"
[dist]
") port))))))
              (replace 'build
                ;; Phase overridden to build the necessary directories.
                (lambda* (#:key parallel-build? #:allow-other-keys)
                  (let ((job-spec (string-append
                                   "-j" (if parallel-build?
                                            (number->string (parallel-job-count))
                                            "1"))))
                    ;; This works for us with the --sysroot flag
                    ;; and then we can build ONLY library/std
                    (invoke "./x.py" job-spec "build" "library/std"))))
              (replace 'install
                (lambda _
                  (invoke "./x.py" "install" "library/std")))
              (delete 'enable-profiling)
              (delete 'install-rust-src)
              (delete 'dont-reference-previous-cargo-version)
              (delete 'wrap-rust-analyzer)
              (delete 'wrap-rustc)))))
      (inputs
       (modify-inputs inputs
         (prepend xz)))                 ; for lzma-sys
      (propagated-inputs
       (if (target-mingw? target)
           (modify-inputs propagated-inputs
             (prepend
              (make-mingw-w64
                (string-take target (string-index target #\-))
                #:with-winpthreads? #t)))
           (package-propagated-inputs base-rust)))
      (native-inputs
       (append native-inputs deps))
      (properties
       `((hidden? . #t) ,(package-properties base-rust))))))
