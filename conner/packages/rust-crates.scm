;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2025 Hilton Chain <hako@ultrarare.space>
;;;
;;; This file is part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (conner packages rust-crates)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cargo)
  #:use-module (guix diagnostics)
  #:use-module (guix utils)
  #:use-module (guix i18n)
  #:use-module (gnu packages rust-sources)
  #:export (lookup-cargo-inputs conner-cargo-inputs))

;;;
;;; This file is managed by ‘guix import’.  Do NOT add definitions manually.
;;;

(define* (crate-name->package-name name)
  (downstream-package-name "rust-" name))

(define* (crate-source name version hash #:key (patches '()) (snippet #f))
  (origin
    (method url-fetch)
    (uri (crate-uri name version))
    (file-name
      (string-append (crate-name->package-name name) "-" version ".tar.gz"))
    (sha256 (base32 hash))
    (modules '((guix build utils)))
    (patches patches)
    (snippet snippet)))

(define-syntax define-cargo-inputs
  (syntax-rules (=>)
    ((_ lookup inputs ...)
     (define lookup
       (let ((table (make-hash-table)))
         (letrec-syntax ((record
                          (syntax-rules (=>)
                            ((_) #t)
                            ((_ (name => lst) rest (... ...))
                             (begin
                               (hashq-set! table 'name (filter identity lst))
                               (record rest (... ...)))))))
           (record inputs ...)
           (lambda (name)
             "Return the inputs for NAME."
             (hashq-ref table name))))))))

(define* (conner-cargo-inputs name
                          ;; NOTE: Change to your own module.
                          #:key (module '(conner packages rust-crates)))
  "Lookup Cargo inputs for NAME defined in MODULE, return an empty list if
unavailable."
  (let ((lookup (module-ref (resolve-interface module) 'lookup-cargo-inputs)))
    (or (lookup name)
        (begin
          (warning (G_ "no Cargo inputs available for '~a'~%") name)
          '()))))


;;;
;;; Rust libraries fetched from crates.io and non-workspace development
;;; snapshots.
;;;

(define qqqq-separator 'begin-of-crates)

(define rust-adler2-2.0.1
  (crate-source "adler2" "2.0.1"
                "1ymy18s9hs7ya1pjc9864l30wk8p2qfqdi7mhhcc5nfakxbij09j"))

(define rust-aead-0.5.2
  (crate-source "aead" "0.5.2"
                "1c32aviraqag7926xcb9sybdm36v5vh9gnxpn4pxdwjc50zl28ni"))

(define rust-aho-corasick-0.7.18
  (crate-source "aho-corasick" "0.7.18"
                "0vv50b3nvkhyy7x7ip19qnsq11bqlnffkmj2yx2xlyk5wzawydqy"))

(define rust-aho-corasick-1.1.4
  (crate-source "aho-corasick" "1.1.4"
                "00a32wb2h07im3skkikc495jvncf62jl6s96vwc7bhi70h9imlyx"))

(define rust-alloc-no-stdlib-2.0.4
  (crate-source "alloc-no-stdlib" "2.0.4"
                "1cy6r2sfv5y5cigv86vms7n5nlwhx1rbyxwcraqnmm1rxiib2yyc"))

(define rust-alloc-stdlib-0.2.2
  (crate-source "alloc-stdlib" "0.2.2"
                "1kkfbld20ab4165p29v172h8g0wvq8i06z8vnng14whw0isq5ywl"))

(define rust-android-system-properties-0.1.5
  (crate-source "android_system_properties" "0.1.5"
                "04b3wrz12837j7mdczqd95b732gw5q7q66cv4yn4646lvccp57l1"))

(define rust-anstream-0.3.2
  (crate-source "anstream" "0.3.2"
                "0qzinx9c8zfq3xqpxzmlv6nrm3ymccr4n8gffkdmj31p50v4za0c"))

(define rust-anstream-1.0.0
  (crate-source "anstream" "1.0.0"
                "13d2bj0xfg012s4rmq44zc8zgy1q8k9yp7yhvfnarscnmwpj2jl2"))

(define rust-anstyle-1.0.1
  (crate-source "anstyle" "1.0.1"
                "1kff80219d5rvvi407wky2zdlb0naxvbbg005s274pidbxfdlc1s"))

(define rust-anstyle-1.0.14
  (crate-source "anstyle" "1.0.14"
                "0030szmgj51fxkic1hpakxxgappxzwm6m154a3gfml83lq63l2wl"))

(define rust-anstyle-parse-0.2.1
  (crate-source "anstyle-parse" "0.2.1"
                "0cy38fbdlnmwyy6q8dn8dcfrpycwnpjkljsjqn3kmc40b7zp924k"))

(define rust-anstyle-parse-1.0.0
  (crate-source "anstyle-parse" "1.0.0"
                "03hkv2690s0crssbnmfkr76kw1k7ah2i6s5amdy9yca2n8w7zkjj"))

(define rust-anstyle-query-1.0.0
  (crate-source "anstyle-query" "1.0.0"
                "0js9bgpqz21g0p2nm350cba1d0zfyixsma9lhyycic5sw55iv8aw"))

(define rust-anstyle-query-1.1.5
  (crate-source "anstyle-query" "1.1.5"
                "1p6shfpnbghs6jsa0vnqd8bb8gd7pjd0jr7w0j8jikakzmr8zi20"))

(define rust-anstyle-wincon-1.0.1
  (crate-source "anstyle-wincon" "1.0.1"
                "12714vwjf4c1wm3qf49m5vmd93qvq2nav6zpjc0bxbh3ayjby2hq"))

(define rust-anstyle-wincon-3.0.11
  (crate-source "anstyle-wincon" "3.0.11"
                "0zblannm70sk3xny337mz7c6d8q8i24vhbqi42ld8v7q1wjnl7i9"))

(define rust-anyhow-1.0.102
  (crate-source "anyhow" "1.0.102"
                "0b447dra1v12z474c6z4jmicdmc5yxz5bakympdnij44ckw2s83z"))

(define rust-arc-swap-1.5.0
  (crate-source "arc-swap" "1.5.0"
                "07sb99f18spqmjx7f4cmqx7hc8ayspcmw9shl4zjvf300ki8rmy5"))

(define rust-ascii-1.1.0
  (crate-source "ascii" "1.1.0"
                "05nyyp39x4wzc1959kv7ckwqpkdzjd9dw4slzyjh73qbhjcfqayr"))

(define rust-askama-0.14.0
  (crate-source "askama" "0.14.0"
                "1i3m3dzshx46v94w24chl6xg7xjyf350gqzzyijy46vp9f3n6lzp"))

(define rust-askama-derive-0.14.0
  (crate-source "askama_derive" "0.14.0"
                "0kx9sfych8m7cswcs75jhq0cy9pqn7iah1w4lvl8hc781wh9g4qj"))

(define rust-askama-parser-0.14.0
  (crate-source "askama_parser" "0.14.0"
                "0n235ljbvbvlhwr54s675x1z6lgbjmzrfrq1c8rg5snmncq5dayn"))

(define rust-async-trait-0.1.89
  (crate-source "async-trait" "0.1.89"
                "1fsxxmz3rzx1prn1h3rs7kyjhkap60i7xvi0ldapkvbb14nssdch"))

(define rust-atk-0.18.2
  (crate-source "atk" "0.18.2"
                "0jw2n5xln62px4dh0hxdzbkbfraznkjakwznwhxrjbh72c9646r4"))

(define rust-atk-sys-0.18.2
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "atk-sys" "0.18.2"
                "11nh2h3g7s772wb6lmjdsjbwi8rf9i11gvyyp8mpv9qc9dl8pr65"))

(define rust-atomic-polyfill-0.1.11
  (crate-source "atomic-polyfill" "0.1.11"
                "0a4vd4zq75xmwbi33flf35qmm2nf99kx3hx2m21lslqnyfrpxzz3"))

(define rust-atomic-waker-1.1.2
  (crate-source "atomic-waker" "1.1.2"
                "1h5av1lw56m0jf0fd3bchxq8a30xv0b4wv8s4zkp4s0i7mfvs18m"))

(define rust-atty-0.2.14
  (crate-source "atty" "0.2.14"
                "1s7yslcs6a28c5vz7jwj63lkfgyx8mx99fdirlhi9lbhhzhrpcyr"))

(define rust-autocfg-1.1.0
  (crate-source "autocfg" "1.1.0"
                "1ylp3cb47ylzabimazvbz9ms6ap784zhb6syaz6c1jqpmcmq0s6l"))

(define rust-autocfg-1.5.0
  (crate-source "autocfg" "1.5.0"
                "1s77f98id9l4af4alklmzq46f21c980v13z2r1pcxx6bqgw0d1n0"))

(define rust-autotools-0.2.7
  (crate-source "autotools" "0.2.7"
                "1kwmqzdpgmy50dr8pzx0029f5iszrma826ji93fw03qvqhkib57g"))

(define rust-axum-0.8.9
  (crate-source "axum" "0.8.9"
                "146df5x8dhczm1sp939gr3839220wl6rxc1k65bzc450z72ridii"))

(define rust-axum-core-0.5.6
  (crate-source "axum-core" "0.5.6"
                "1lcjhxysnbc64rh21ag9m9fpiryd1iwcdh9mwxz1yadiswqqziq8"))

(define rust-base64-0.21.7
  (crate-source "base64" "0.21.7"
                "0rw52yvsk75kar9wgqfwgb414kvil1gn7mqkrhn9zf1537mpsacx"))

(define rust-base64-0.22.1
  (crate-source "base64" "0.22.1"
                "1imqzgh7bxcikp5vx3shqvw9j09g9ly0xr0jma0q66i52r7jbcvj"))

(define rust-basic-toml-0.1.10
  (crate-source "basic-toml" "0.1.10"
                "12hp59jl28kk229q4sqx6v4fc9p66v8i2byi0vlc9922h9g6fqms"))

(define rust-bit-set-0.8.0
  (crate-source "bit-set" "0.8.0"
                "18riaa10s6n59n39vix0cr7l2dgwdhcpbcm97x1xbyfp1q47x008"))

(define rust-bit-vec-0.8.0
  (crate-source "bit-vec" "0.8.0"
                "1xxa1s2cj291r7k1whbxq840jxvmdsq9xgh7bvrxl46m80fllxjy"))

(define rust-bitflags-1.3.2
  (crate-source "bitflags" "1.3.2"
                "12ki6w8gn1ldq7yz9y680llwk5gmrhrzszaa17g1sbrw2r2qvwxy"))

(define rust-bitflags-2.11.1
  (crate-source "bitflags" "2.11.1"
                "1cvqijg3rvwgis20a66vfdxannjsxfy5fgjqkaq3l13gyfcj4lf4"))

(define rust-bitflags-2.4.1
  (crate-source "bitflags" "2.4.1"
                "01ryy3kd671b0ll4bhdvhsz67vwz1lz53fz504injrd7wpv64xrj"))

(define rust-block-buffer-0.10.4
  (crate-source "block-buffer" "0.10.4"
                "0w9sa2ypmrsqqvc20nhwr75wbb5cjr4kkyhpjm1z1lv2kdicfy1h"))

(define rust-block2-0.6.2
  (crate-source "block2" "0.6.2"
                "1xcfllzx6c3jc554nmb5qy6xmlkl6l6j5ib4wd11800n0n3rvsyd"))

(define rust-brotli-8.0.2
  (crate-source "brotli" "8.0.2"
                "0q25r00z3gm5wzvv4vfxvlx5zjb8i4jwyznrvdcp7abs7ihbkn2b"))

(define rust-brotli-decompressor-5.0.0
  (crate-source "brotli-decompressor" "5.0.0"
                "00yyswj1rj20ma4wr4wcci4r9ywlgvxa87nqsv5rik5y588vhjw7"))

(define rust-bs58-0.5.1
  (crate-source "bs58" "0.5.1"
                "1x3v51n5n2s3l0rgrsn142akdf331n2qsa75pscw71fi848vm25z"))

(define rust-btree-range-map-0.7.2
  (crate-source "btree-range-map" "0.7.2"
                "0cvw6xnzgyi25dbc802pn8gjzqhz2axaxayarc5q1ls64ikwkr8v"))

(define rust-btree-slab-0.6.1
  (crate-source "btree-slab" "0.6.1"
                "0g7imqbf9v1p643m9bl9bkpnrf15hh4qlhljm17mq1wz0b9mcavs"))

(define rust-bumpalo-3.20.2
  (crate-source "bumpalo" "3.20.2"
                "1jrgxlff76k9glam0akhwpil2fr1w32gbjdf5hpipc7ld2c7h82x"))

(define rust-bytemuck-1.25.0
  (crate-source "bytemuck" "1.25.0"
                "1v1z32igg9zq49phb3fra0ax5r2inf3aw473vldnm886sx5vdvy8"))

(define rust-byteorder-1.4.3
  (crate-source "byteorder" "1.4.3"
                "0456lv9xi1a5bcm32arknf33ikv76p3fr9yzki4lb2897p2qkh8l"))

(define rust-byteorder-1.5.0
  (crate-source "byteorder" "1.5.0"
                "0jzncxyf404mwqdbspihyzpkndfgda450l0893pz5xj685cg5l0z"))

(define rust-bytes-1.11.1
  (crate-source "bytes" "1.11.1"
                "0czwlhbq8z29wq0ia87yass2mzy1y0jcasjb8ghriiybnwrqfx0y"))

(define rust-cairo-rs-0.18.5
  (crate-source "cairo-rs" "0.18.5"
                "1qjfkcq3mrh3p01nnn71dy3kn99g21xx3j8xcdvzn8ll2pq6x8lc"))

(define rust-cairo-sys-rs-0.18.2
  (crate-source "cairo-sys-rs" "0.18.2"
                "0lfsxl7ylw3phbnwmz3k58j1gnqi6kc2hdc7g3bb7f4hwnl9yp38"))

(define rust-camino-1.2.2
  (crate-source "camino" "1.2.2"
                "0j0ayqfbbl8bxg0795ssk1hzkjix3dvl2kk63hdgzf9cd5nscag6"))

(define rust-capng-0.2.2
  (crate-source "capng" "0.2.2"
                "0x95j3fn8f2ra6d63rxk2phd9y7mjlfi41i6wi1kcq1kh92fky7n"))

(define rust-cargo-metadata-0.19.2
  (crate-source "cargo_metadata" "0.19.2"
                "1fkr8jp6vhva4kc3rhx13yrnl8g3zch463j20vbwa9scxlabcpnx"))

(define rust-cargo-platform-0.1.9
  (crate-source "cargo-platform" "0.1.9"
                "1sinpmqjdk3q9llbmxr0h0nyvqrif1r5qs34l000z73b024z2np3"))

(define rust-cargo-toml-0.22.3
  (crate-source "cargo_toml" "0.22.3"
                "0xvbl0nbi84hvhxiy0brmfvcn63bmj88799fjzsc204w5mcpqjrp"))

(define rust-cc-1.0.79
  (crate-source "cc" "1.0.79"
                "07x93b8zbf3xc2dggdd460xlk1wg8lxm6yflwddxj8b15030klsh"))

(define rust-cc-1.2.62
  (crate-source "cc" "1.2.62"
                "164zsxcy2zzvbbh1qpbrsssz8kmria41j4agih47sal3y1cyip51"))

(define rust-cc-traits-2.0.0
  (crate-source "cc-traits" "2.0.0"
                "1db2m7drl9w3yda4ybxvhykz45krqrlapcg16wkm4jpg67ph60q6"))

(define rust-cesu8-1.1.0
  (crate-source "cesu8" "1.1.0"
                "0g6q58wa7khxrxcxgnqyi9s1z2cjywwwd3hzr5c55wskhx6s0hvd"))

(define rust-cfb-0.7.3
  (crate-source "cfb" "0.7.3"
                "03y6p3dlm7gfds19bq4ba971za16rjbn7q2v0vqcri52l2kjv3yk"))

(define rust-cfg-aliases-0.2.1
  (crate-source "cfg_aliases" "0.2.1"
                "092pxdc1dbgjb6qvh83gk56rkic2n2ybm4yvy76cgynmzi3zwfk1"))

(define rust-cfg-expr-0.15.8
  (crate-source "cfg-expr" "0.15.8"
                "00lgf717pmf5qd2qsxxzs815v6baqg38d6m5i6wlh235p14asryh"))

(define rust-cfg-if-1.0.0
  (crate-source "cfg-if" "1.0.0"
                "1za0vb97n4brpzpv8lsbnzmq5r8f2b0cpqqr0sy8h5bn751xxwds"))

(define rust-cfg-if-1.0.4
  (crate-source "cfg-if" "1.0.4"
                "008q28ajc546z5p2hcwdnckmg0hia7rnx52fni04bwqkzyrghc4k"))

(define rust-chacha20-0.9.1
  (crate-source "chacha20" "0.9.1"
                "0678wipx6kghp71hpzhl2qvx80q7caz3vm8vsvd07b1fpms3yqf3"))

(define rust-chacha20poly1305-0.10.1
  (crate-source "chacha20poly1305" "0.10.1"
                "0dfwq9ag7x7lnd0znafpcn8h7k4nfr9gkzm0w7sc1lcj451pkk8h"))

(define rust-chrono-0.4.44
  (crate-source "chrono" "0.4.44"
                "1c64mk9a235271j5g3v4zrzqqmd43vp9vki7vqfllpqf5rd0fwy6"))

(define rust-chunked-transfer-1.5.0
  (crate-source "chunked_transfer" "1.5.0"
                "00a9h3csr1xwkqrzpz5kag4h92zdkrnxq4ppxidrhrx29syf6kbf"))

(define rust-cipher-0.4.4
  (crate-source "cipher" "0.4.4"
                "1b9x9agg67xq5nq879z66ni4l08m6m3hqcshk37d4is4ysd3ngvp"))

(define rust-clap-4.3.11
  (crate-source "clap" "4.3.11"
                "0pd0chvzszqjczhc407b5b5w7mkybq81nizx721vnzdlgz6fah0n"))

(define rust-clap-4.6.1
  (crate-source "clap" "4.6.1"
                "0lcf88l7vlg796rrqr7wipbbmfa5sgsgx4211b7xmxxv8dz13nqx"))

(define rust-clap-builder-4.3.11
  (crate-source "clap_builder" "4.3.11"
                "0ay701xxriz1blywcw30261xingsq7y7fnpkafdszvi7slw93icq"))

(define rust-clap-builder-4.6.0
  (crate-source "clap_builder" "4.6.0"
                "17q6np22yxhh5y5v53y4l31ps3hlaz45mvz2n2nicr7n3c056jki"))

(define rust-clap-derive-4.3.2
  (crate-source "clap_derive" "4.3.2"
                "0pw2bc8i7cxfrmwpa5wckx3fbw8s019nn7cgkv1yxmlsh4m2pkdq"))

(define rust-clap-derive-4.6.1
  (crate-source "clap_derive" "4.6.1"
                "1acpz49hi00iv9jkapixjzcv7s51x8qkfaqscjm36rqgf428dkpj"))

(define rust-clap-lex-0.5.0
  (crate-source "clap_lex" "0.5.0"
                "06vcvpvp65qggc5agbirzqk2di00gxg6vazzc3qlwzkw70qxm9id"))

(define rust-clap-lex-1.1.0
  (crate-source "clap_lex" "1.1.0"
                "1ycqkpygnlqnndghhcxjb44lzl0nmgsia64x9581030yifxs7m68"))

(define rust-clap-verbosity-flag-3.0.4
  (crate-source "clap-verbosity-flag" "3.0.4"
                "1513fiasgif7h7nxbnzs3ddkwm6n43lwcz5ph4w99zkjnbxb34lx"))

(define rust-cobs-0.2.3
  (crate-source "cobs" "0.2.3"
                "05gd16mws4yd63h8jr3p08in8y8w21rpjp5jb55hzl9bgalh5fk7"))

(define rust-colorchoice-1.0.0
  (crate-source "colorchoice" "1.0.0"
                "1ix7w85kwvyybwi2jdkl3yva2r2bvdcc3ka2grjfzfgrapqimgxc"))

(define rust-colorchoice-1.0.5
  (crate-source "colorchoice" "1.0.5"
                "0w75k89hw39p0mnnhlrwr23q50rza1yjki44qvh2mgrnj065a1qx"))

(define rust-combine-4.6.7
  (crate-source "combine" "4.6.7"
                "1z8rh8wp59gf8k23ar010phgs0wgf5i8cx4fg01gwcnzfn5k0nms"))

(define rust-compile-time-0.2.0
  (crate-source "compile-time" "0.2.0"
                "00yr5ln6qc8qdp6hyi3c3sp56qxjpqx78lv8j0lcbmylg59dwpp5"))

(define rust-convert-case-0.10.0
  (crate-source "convert_case" "0.10.0"
                "1fff1x78mp2c233g68my0ag0zrmjdbym8bfyahjbfy4cxza5hd33"))

(define rust-cookie-0.18.1
  (crate-source "cookie" "0.18.1"
                "0iy749flficrlvgr3hjmf3igr738lk81n5akzf4ym4cs6cxg7pjd"))

(define rust-core-foundation-0.10.1
  (crate-source "core-foundation" "0.10.1"
                "1xjns6dqf36rni2x9f47b65grxwdm20kwdg9lhmzdrrkwadcv9mj"))

(define rust-core-foundation-0.9.4
  (crate-source "core-foundation" "0.9.4"
                "13zvbbj07yk3b61b8fhwfzhy35535a583irf23vlcg59j7h9bqci"))

(define rust-core-foundation-sys-0.8.7
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "core-foundation-sys" "0.8.7"
                "12w8j73lazxmr1z0h98hf3z623kl8ms7g07jch7n4p8f9nwlhdkp"))

(define rust-core-graphics-0.25.0
  (crate-source "core-graphics" "0.25.0"
                "15rv1iyx5g9sy36pjf1ib6km93n8dksn2p9crx14h6f30brssjq6"))

(define rust-core-graphics-types-0.2.0
  (crate-source "core-graphics-types" "0.2.0"
                "1sqka1rz84lr3p69i1s6lggnpnznmrw4ngc5q76w9xhky80s2i1x"))

(define rust-cpufeatures-0.2.17
  (crate-source "cpufeatures" "0.2.17"
                "10023dnnaghhdl70xcds12fsx2b966sxbxjq5sxs49mvxqw5ivar"))

(define rust-crc32fast-1.5.0
  (crate-source "crc32fast" "1.5.0"
                "04d51liy8rbssra92p0qnwjw8i9rm9c4m3bwy19wjamz1k4w30cl"))

(define rust-critical-section-1.1.2
  (crate-source "critical-section" "1.1.2"
                "05pj0pvkdyc9r30xxabam4n8zxdbzxcddr0gdypajcbqjgwgynbh"))

(define rust-crossbeam-channel-0.5.15
  (crate-source "crossbeam-channel" "0.5.15"
                "1cicd9ins0fkpfgvz9vhz3m9rpkh6n8d3437c3wnfsdkd3wgif42"))

(define rust-crossbeam-deque-0.8.6
  (crate-source "crossbeam-deque" "0.8.6"
                "0l9f1saqp1gn5qy0rxvkmz4m6n7fc0b3dbm6q1r5pmgpnyvi3lcx"))

(define rust-crossbeam-epoch-0.9.18
  (crate-source "crossbeam-epoch" "0.9.18"
                "03j2np8llwf376m3fxqx859mgp9f83hj1w34153c7a9c7i5ar0jv"))

(define rust-crossbeam-utils-0.8.21
  (crate-source "crossbeam-utils" "0.8.21"
                "0a3aa2bmc8q35fb67432w16wvi54sfmb69rk9h5bhd18vw0c99fh"))

(define rust-crossterm-0.29.0
  (crate-source "crossterm" "0.29.0"
                "0yzqxxd90k7d2ac26xq1awsznsaq0qika2nv1ik3p0vzqvjg5ffq"))

(define rust-crossterm-winapi-0.9.1
  (crate-source "crossterm_winapi" "0.9.1"
                "0axbfb2ykbwbpf1hmxwpawwfs8wvmkcka5m561l7yp36ldi7rpdc"))

(define rust-crypto-common-0.1.7
  (crate-source "crypto-common" "0.1.7"
                "02nn2rhfy7kvdkdjl457q2z0mklcvj9h662xrq6dzhfialh2kj3q"))

(define rust-cssparser-0.36.0
  (crate-source "cssparser" "0.36.0"
                "1ljplaynfd8p9y00ypy84il27n1q9rz5pdnsb7b3pf5bq3wirrns"))

(define rust-cssparser-macros-0.6.1
  (crate-source "cssparser-macros" "0.6.1"
                "0cfkzj60avrnskdmaf7f8zw6pp3di4ylplk455zrzaf19ax8id8k"))

(define rust-ctor-0.8.0
  (crate-source "ctor" "0.8.0"
                "164sj2zh0321m1rwbipq9vcndvfaxxh52vyvffnxdwdyyz13jb9m"))

(define rust-ctor-proc-macro-0.0.7
  (crate-source "ctor-proc-macro" "0.0.7"
                "1havwah6iryn0ang09y12xxr45jsp7ff27zflz4mhgk017ghlmjj"))

(define rust-darling-0.23.0
  (crate-source "darling" "0.23.0"
                "179fj6p6ajw4dnkrik51wjhifxwy02x5zhligyymcb905zd17bi5"))

(define rust-darling-core-0.23.0
  (crate-source "darling_core" "0.23.0"
                "1c033vrks38vpw8kwgd5w088dsr511kfz55n9db56prkgh7sarcq"))

(define rust-darling-macro-0.23.0
  (crate-source "darling_macro" "0.23.0"
                "13fvzji9xyp304mgq720z5l0xgm54qj68jibwscagkynggn88fdc"))

(define rust-data-encoding-2.11.0
  (crate-source "data-encoding" "2.11.0"
                "1j00wfmk4dzn4bnib07qlhylmd6a3kizwjz8mp00iix3vlamzbm4"))

(define rust-dbus-0.9.11
  (crate-source "dbus" "0.9.11"
                "0wxzld0baycxa4z6zrmnh68yy456b0f82j8wyp8wyymvj8ln0hmr"))

(define rust-deranged-0.5.8
  (crate-source "deranged" "0.5.8"
                "0711df3w16vx80k55ivkwzwswziinj4dz05xci3rvmn15g615n3w"))

(define rust-derive-more-2.1.1
  (crate-source "derive_more" "2.1.1"
                "0d5i10l4aff744jw7v4n8g6cv15rjk5mp0f1z522pc2nj7jfjlfp"))

(define rust-derive-more-impl-2.1.1
  (crate-source "derive_more-impl" "2.1.1"
                "1jwdp836vymp35d7mfvvalplkdgk2683nv3zjlx65n1194k9g6kr"))

(define rust-digest-0.10.7
  (crate-source "digest" "0.10.7"
                "14p2n6ih29x81akj097lvz7wi9b6b9hvls0lwrv7b6xwyy0s5ncy"))

(define rust-directories-6.0.0
  (crate-source "directories" "6.0.0"
                "0zgy2w088v8w865c11dmc3dih899fgrhvrfp7g83h6v6ai60kx8n"))

(define rust-dirs-6.0.0
  (crate-source "dirs" "6.0.0"
                "0knfikii29761g22pwfrb8d0nqpbgw77sni9h2224haisyaams63"))

(define rust-dirs-sys-0.5.0
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "dirs-sys" "0.5.0"
                "1aqzpgq6ampza6v012gm2dppx9k35cdycbj54808ksbys9k366p0"))

(define rust-dispatch2-0.3.1
  (crate-source "dispatch2" "0.3.1"
                "0f5xmnbzpaz1g80m27kd804p75nswh0ikb6wvqh4ba3x9rz3c3hy"))

(define rust-displaydoc-0.2.5
  (crate-source "displaydoc" "0.2.5"
                "1q0alair462j21iiqwrr21iabkfnb13d6x5w95lkdg21q2xrqdlp"))

(define rust-dlopen2-0.5.0
  (crate-source "dlopen2" "0.5.0"
                "1yjg27x20d0v65lji6l18amah5nlx8gciv64iqdz0zqp07qzbd09"))

(define rust-dlopen2-0.8.2
  (crate-source "dlopen2" "0.8.2"
                "1m647mg11ly4f78z34hcndkk4byn25z876y42pid2rlf2pa5nb2y"))

(define rust-dlopen2-derive-0.4.3
  (crate-source "dlopen2_derive" "0.4.3"
                "13vwwh48rlhb679cy15sxs0ppv3k4rkliv07hwx9k03mhy0vgfqg"))

(define rust-dns-lookup-3.0.1
  (crate-source "dns-lookup" "3.0.1"
                "07f4lvzsf0p80qh2haiq01fvpi0rk1lf783bnsxzb8i1xr606fbf"))

(define rust-document-features-0.2.12
  (crate-source "document-features" "0.2.12"
                "0qcgpialq3zgvjmsvar9n6v10rfbv6mk6ajl46dd4pj5hn3aif6l"))

(define rust-dom-query-0.27.0
  (crate-source "dom_query" "0.27.0"
                "129zrgwkfkp11g9izg3x7qzgqmimw0p858c33sd8vywa1h63h7jj"))

(define rust-dpi-0.1.2
  (crate-source "dpi" "0.1.2"
                "0xhsvzgjvdch2fwmfc9vkb708b0q59b6imypyjlgbiigyb74rcfq"))

(define rust-dtoa-1.0.11
  (crate-source "dtoa" "1.0.11"
                "1405jvczpxf1zd3nsvw02r50hr2k6argq6jkgdf04prd9s1g8g2c"))

(define rust-dtoa-short-0.3.5
  (crate-source "dtoa-short" "0.3.5"
                "11rwnkgql5jilsmwxpx6hjzkgyrbdmx1d71s0jyrjqm5nski25fd"))

(define rust-dtor-0.3.0
  (crate-source "dtor" "0.3.0"
                "1r6b2pvha5s0rml5hwf7bhh7ssvs6yzkzzfhivzqcw4qcin7s1gi"))

(define rust-dtor-proc-macro-0.0.6
  (crate-source "dtor-proc-macro" "0.0.6"
                "19fg0mivy9qyvbwmqj3ysj0qm5cay0gyp5fyw1imq89cj95cyy7n"))

(define rust-dunce-1.0.5
  (crate-source "dunce" "1.0.5"
                "04y8wwv3vvcqaqmqzssi6k0ii9gs6fpz96j5w9nky2ccsl23axwj"))

(define rust-dyn-clone-1.0.20
  (crate-source "dyn-clone" "1.0.20"
                "0m956cxcg8v2n8kmz6xs5zl13k2fak3zkapzfzzp7pxih6hix26h"))

(define rust-either-1.15.0
  (crate-source "either" "1.15.0"
                "069p1fknsmzn9llaizh77kip0pqmcwpdsykv2x30xpjyija5gis8"))

(define rust-embed-plist-1.2.2
  (crate-source "embed_plist" "1.2.2"
                "1drvfi1lh9lh8b7pcqp98jdigzsji0kfavbrv126c69pbfgbixjf"))

(define rust-embed-resource-3.0.9
  (crate-source "embed-resource" "3.0.9"
                "1jsbckrpj5drij7rbz9svghrv8sshi3waj77iz8hxr3dsb48h6n3"))

(define rust-encoding-rs-0.8.35
  (crate-source "encoding_rs" "0.8.35"
                "1wv64xdrr9v37rqqdjsyb8l8wzlcbab80ryxhrszvnj59wy0y0vm"))

(define rust-env-filter-1.0.1
  (crate-source "env_filter" "1.0.1"
                "1vvf9xhaxm0m78bp23b8j3cbv1vm5vffn3gaas27mc64rhm0rs9j"))

(define rust-env-logger-0.11.10
  (crate-source "env_logger" "0.11.10"
                "0smmk1hqzk7z91rg7fdq98d03gh9kidkd0ymim43zb4n457w0886"))

(define rust-env-logger-0.8.4
  (crate-source "env_logger" "0.8.4"
                "1qzw8g11dbdfi7ixm44ldykwcqsxqkh8vx5cgpd88zmclgz8g4d1"))

(define rust-equivalent-1.0.2
  (crate-source "equivalent" "1.0.2"
                "03swzqznragy8n0x31lqc78g2af054jwivp7lkrbrc0khz74lyl7"))

(define rust-erased-serde-0.4.10
  (crate-source "erased-serde" "0.4.10"
                "1v1dy16ff8mck2rfqdmwdxl14phlvr8rq0i7yqzxka6ngnhdibfj"))

(define rust-errno-0.3.1
  (crate-source "errno" "0.3.1"
                "0fp7qy6fwagrnmi45msqnl01vksqwdb2qbbv60n9cz7rf0xfrksb"))

(define rust-errno-0.3.14
  (crate-source "errno" "0.3.14"
                "1szgccmh8vgryqyadg8xd58mnwwicf39zmin3bsn63df2wbbgjir"))

(define rust-errno-dragonfly-0.1.2
  (crate-source "errno-dragonfly" "0.1.2"
                "1grrmcm6q8512hkq5yzch3yv8wafflc2apbmsaabiyk44yqz2s5a"))

(define rust-error-chain-0.12.4
  (crate-source "error-chain" "0.12.4"
                "1z6y5isg0il93jp287sv7pn10i4wrkik2cpyk376wl61rawhcbrd"))

(define rust-fastrand-2.4.1
  (crate-source "fastrand" "2.4.1"
                "1mnqxxnxvd69ma9mczabpbbsgwlhd6l78yv3vd681453a9s247wz"))

(define rust-fdeflate-0.3.7
  (crate-source "fdeflate" "0.3.7"
                "130ga18vyxbb5idbgi07njymdaavvk6j08yh1dfarm294ssm6s0y"))

(define rust-field-offset-0.3.6
  (crate-source "field-offset" "0.3.6"
                "0zq5sssaa2ckmcmxxbly8qgz3sxpb8g1lwv90sdh1z74qif2gqiq"))

(define rust-filetime-0.2.29
  (crate-source "filetime" "0.2.29"
                "0napyyfccb26r7fyh9hg7ixrh4vph9h7y7k4iv1j19phqwrpla2w"))

(define rust-find-msvc-tools-0.1.9
  (crate-source "find-msvc-tools" "0.1.9"
                "10nmi0qdskq6l7zwxw5g56xny7hb624iki1c39d907qmfh3vrbjv"))

(define rust-flate2-1.1.9
  (crate-source "flate2" "1.1.9"
                "0g2pb7cxnzcbzrj8bw4v6gpqqp21aycmf6d84rzb6j748qkvlgw4"))

(define rust-fnv-1.0.7
  (crate-source "fnv" "1.0.7"
                "1hc2mcqha06aibcaza94vbi81j6pr9a1bbxrxjfhc91zin8yr7iz"))

(define rust-foldhash-0.1.5
  (crate-source "foldhash" "0.1.5"
                "1wisr1xlc2bj7hk4rgkcjkz3j2x4dhd1h9lwk7mj8p71qpdgbi6r"))

(define rust-foldhash-0.2.0
  (crate-source "foldhash" "0.2.0"
                "1nvgylb099s11xpfm1kn2wcsql080nqmnhj1l25bp3r2b35j9kkp"))

(define rust-foreign-types-0.3.2
  (crate-source "foreign-types" "0.3.2"
                "1cgk0vyd7r45cj769jym4a6s7vwshvd0z4bqrb92q1fwibmkkwzn"))

(define rust-foreign-types-0.5.0
  (crate-source "foreign-types" "0.5.0"
                "0rfr2zfxnx9rz3292z5nyk8qs2iirznn5ff3rd4vgdwza6mdjdyp"))

(define rust-foreign-types-macros-0.2.3
  (crate-source "foreign-types-macros" "0.2.3"
                "0hjpii8ny6l7h7jpns2cp9589016l8mlrpaigcnayjn9bdc6qp0s"))

(define rust-foreign-types-shared-0.1.1
  (crate-source "foreign-types-shared" "0.1.1"
                "0jxgzd04ra4imjv8jgkmdq59kj8fsz6w4zxsbmlai34h26225c00"))

(define rust-foreign-types-shared-0.3.1
  (crate-source "foreign-types-shared" "0.3.1"
                "0nykdvv41a3d4py61bylmlwjhhvdm0b3bcj9vxhqgxaxnp5ik6ma"))

(define rust-form-urlencoded-1.2.2
  (crate-source "form_urlencoded" "1.2.2"
                "1kqzb2qn608rxl3dws04zahcklpplkd5r1vpabwga5l50d2v4k6b"))

(define rust-fs-extra-1.3.0
  (crate-source "fs_extra" "1.3.0"
                "075i25z70j2mz9r7i9p9r521y8xdj81q7skslyb7zhqnnw33fw22"))

(define rust-futures-0.3.21
  (crate-source "futures" "0.3.21"
                "17id2zvn2acny759indn6yj2acfa6lhkwzaidxr2pqfiaigycgzp"))

(define rust-futures-0.3.32
  (crate-source "futures" "0.3.32"
                "0b9q86r5ar18v5xjiyqn7sb8sa32xv98qqnfz779gl7ns7lpw54b"))

(define rust-futures-channel-0.3.21
  (crate-source "futures-channel" "0.3.21"
                "0420lz2fmxa356ax1rp2sqi7b27ykfhvq4w9f1sla4hlp7j3q263"))

(define rust-futures-channel-0.3.32
  (crate-source "futures-channel" "0.3.32"
                "07fcyzrmbmh7fh4ainilf1s7gnwvnk07phdq77jkb9fpa2ffifq7"))

(define rust-futures-core-0.3.21
  (crate-source "futures-core" "0.3.21"
                "1lqhc6mqklh5bmkpr77p42lqwjj8gaskk5ba2p3kl1z4nw2gs28c"))

(define rust-futures-core-0.3.32
  (crate-source "futures-core" "0.3.32"
                "07bbvwjbm5g2i330nyr1kcvjapkmdqzl4r6mqv75ivvjaa0m0d3y"))

(define rust-futures-executor-0.3.21
  (crate-source "futures-executor" "0.3.21"
                "19mq96kwgf06axgdc2fbrjhqzdnxww9vw6cz8b82gqr9z86bj84l"))

(define rust-futures-executor-0.3.32
  (crate-source "futures-executor" "0.3.32"
                "17aplz3ns74qn7a04qg7qlgsdx5iwwwkd4jvdfra6hl3h4w9rwms"))

(define rust-futures-io-0.3.21
  (crate-source "futures-io" "0.3.21"
                "0swn29fysas36ikk5aw55104fi98117amvgxw9g96pjs5ab4ah7w"))

(define rust-futures-io-0.3.32
  (crate-source "futures-io" "0.3.32"
                "063pf5m6vfmyxj74447x8kx9q8zj6m9daamj4hvf49yrg9fs7jyf"))

(define rust-futures-macro-0.3.21
  (crate-source "futures-macro" "0.3.21"
                "04pmj5xfk5rdhlj69wc7w3zvdg3xardg8srig96lszrk00wf3h9k"))

(define rust-futures-macro-0.3.32
  (crate-source "futures-macro" "0.3.32"
                "0ys4b1lk7s0bsj29pv42bxsaavalch35rprp64s964p40c1bfdg8"))

(define rust-futures-sink-0.3.21
  (crate-source "futures-sink" "0.3.21"
                "0s58gx5yw1a21xviw2qgc0wzk225vgn4kbzddrp141m3kw9kw5i1"))

(define rust-futures-sink-0.3.32
  (crate-source "futures-sink" "0.3.32"
                "14q8ml7hn5a6gyy9ri236j28kh0svqmrk4gcg0wh26rkazhm95y3"))

(define rust-futures-task-0.3.21
  (crate-source "futures-task" "0.3.21"
                "0skpiz2ljisywajv79p70yapfwhkqhb39wxy3f09v47mdfbnmijp"))

(define rust-futures-task-0.3.32
  (crate-source "futures-task" "0.3.32"
                "14s3vqf8llz3kjza33vn4ixg6kwxp61xrysn716h0cwwsnri2xq3"))

(define rust-futures-util-0.3.21
  (crate-source "futures-util" "0.3.21"
                "0sh3wqi8p36csjffy0irq8nlx9shqxp7z4dsih6bknarsvaspdyq"))

(define rust-futures-util-0.3.32
  (crate-source "futures-util" "0.3.32"
                "1mn60lw5kh32hz9isinjlpw34zx708fk5q1x0m40n6g6jq9a971q"))

(define rust-fuzzy-matcher-0.3.7
  (crate-source "fuzzy-matcher" "0.3.7"
                "153csv8rsk2vxagb68kpmiknvdd3bzqj03x805khckck28rllqal"))

(define rust-gdk-0.18.2
  (crate-source "gdk" "0.18.2"
                "14967h4pac5gjyrd47yls4wbicrzhbwnd4ajisfwjyk2ijalbwnr"))

(define rust-gdk-pixbuf-0.18.5
  (crate-source "gdk-pixbuf" "0.18.5"
                "1v7svvl0g7zybndmis5inaqqgi1mvcc6s1n8rkb31f5zn3qzbqah"))

(define rust-gdk-pixbuf-sys-0.18.0
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "gdk-pixbuf-sys" "0.18.0"
                "1xya543c4ffd2n7aiwwrdxsyc9casdbasafi6ixcknafckm3k61z"))

(define rust-gdk-sys-0.18.2
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "gdk-sys" "0.18.2"
                "1xzkl9mdfsj1zja7ikrg3g8rinqsb9nqq64yc5k1xb4lhpri6baw"))

(define rust-gdkwayland-sys-0.18.2
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "gdkwayland-sys" "0.18.2"
                "0sgyipcl2k39ybw7mk6mii17ggdgaphva2cz5dbzf8yj0vap200l"))

(define rust-gdkx11-0.18.2
  (crate-source "gdkx11" "0.18.2"
                "1zpvndnqasyk9gfnh8mwkb27gsr70dlkcg1v334bpgji8ghh1aiw"))

(define rust-gdkx11-sys-0.18.2
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "gdkx11-sys" "0.18.2"
                "13a2yjqac7i6bqxkpdjfa5rf33v0v06jdnq12vqjdb01zr2p8bkf"))

(define rust-generic-array-0.14.7
  (crate-source "generic-array" "0.14.7"
                "16lyyrzrljfq424c3n8kfwkqihlimmsg5nhshbbp48np3yjrqr45"))

(define rust-getrandom-0.2.15
  (crate-source "getrandom" "0.2.15"
                "1mzlnrb3dgyd1fb84gvw10pyr8wdqdl4ry4sr64i1s8an66pqmn4"))

(define rust-getrandom-0.2.17
  (crate-source "getrandom" "0.2.17"
                "1l2ac6jfj9xhpjjgmcx6s1x89bbnw9x6j9258yy6xjkzpq0bqapz"))

(define rust-getrandom-0.3.4
  (crate-source "getrandom" "0.3.4"
                "1zbpvpicry9lrbjmkd4msgj3ihff1q92i334chk7pzf46xffz7c9"))

(define rust-getrandom-0.4.2
  (crate-source "getrandom" "0.4.2"
                "0mb5833hf9pvn9dhvxjgfg5dx0m77g8wavvjdpvpnkp9fil1xr8d"))

(define rust-gio-0.18.4
  (crate-source "gio" "0.18.4"
                "0wsc6mnx057s4ailacg99dwgna38dbqli5x7a6y9rdw75x9qzz6l"))

(define rust-gio-sys-0.18.1
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "gio-sys" "0.18.1"
                "1lip8z35iy9d184x2qwjxlbxi64q9cpayy7v1p5y9xdsa3w6smip"))

(define rust-glib-0.18.5
  (crate-source "glib" "0.18.5"
                "1r8fw0627nmn19bgk3xpmcfngx3wkn7mcpq5a8ma3risx3valg93"))

(define rust-glib-macros-0.18.5
  (crate-source "glib-macros" "0.18.5"
                "1p5cla53fcp195zp0hkqpmnn7iwmkdswhy7xh34002bw8y7j5c0b"))

(define rust-glib-sys-0.18.1
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "glib-sys" "0.18.1"
                "164qhsfmlzd5mhyxs8123jzbdfldwxbikfpq5cysj3lddbmy4g06"))

(define rust-glob-0.3.3
  (crate-source "glob" "0.3.3"
                "106jpd3syfzjfj2k70mwm0v436qbx96wig98m4q8x071yrq35hhc"))

(define rust-gobject-sys-0.18.0
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "gobject-sys" "0.18.0"
                "0i6fhp3m6vs3wkzyc22rk2cqj68qvgddxmpaai34l72da5xi4l08"))

(define rust-gtk-0.18.2
  (crate-source "gtk" "0.18.2"
                "0sjh12mvvcmkz54nn30lb2xrzxagshbz1x2i4xfvshpwgccznmpx"))

(define rust-gtk-sys-0.18.2
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "gtk-sys" "0.18.2"
                "0524c9mwx5jxkl8pb6q45g2n1kfwajz1isa0vnvkwmar3k1a2acg"))

(define rust-gtk3-macros-0.18.2
  (crate-source "gtk3-macros" "0.18.2"
                "179yszj83hgfxl4h4g2zfbsyn9a2zc5zrp6nzqv0fkzi45dkrzsj"))

(define rust-h2-0.4.14
  (crate-source "h2" "0.4.14"
                "0cw7jk7kn2vn6f8w8ssh6gis1mljnfjxd606gvi4sjpyjayfy7qp"))

(define rust-hash32-0.2.1
  (crate-source "hash32" "0.2.1"
                "0rrbv5pc5b1vax6j6hk7zvlrpw0h6aybshxy9vbpgsrgfrc5zhxh"))

(define rust-hashbrown-0.12.3
  (crate-source "hashbrown" "0.12.3"
                "1268ka4750pyg2pbgsr43f0289l5zah4arir2k4igx5a8c6fg7la"))

(define rust-hashbrown-0.15.5
  (crate-source "hashbrown" "0.15.5"
                "189qaczmjxnikm9db748xyhiw04kpmhm9xj9k9hg0sgx7pjwyacj"))

(define rust-hashbrown-0.17.1
  (crate-source "hashbrown" "0.17.1"
                "0jmqz7i4yl6cm7rbn0i2ffkfrmwi6xkmzkaldr2v8bcsx2v0jngd"))

(define rust-heapless-0.7.16
  (crate-source "heapless" "0.7.16"
                "0hq7ifnzpdj9rc06rhys4qa3qkr6q3k01kwfca0ak7lbl4jbq16v"))

(define rust-heck-0.4.1
  (crate-source "heck" "0.4.1"
                "1a7mqsnycv5z4z5vnv1k34548jzmc0ajic7c1j8jsaspnhw5ql4m"))

(define rust-heck-0.5.0
  (crate-source "heck" "0.5.0"
                "1sjmpsdl8czyh9ywl3qcsfsq9a307dg4ni2vnlwgnzzqhc4y0113"))

(define rust-hermit-abi-0.1.19
  (crate-source "hermit-abi" "0.1.19"
                "0cxcm8093nf5fyn114w8vxbrbcyvv91d4015rdnlgfll7cs6gd32"))

(define rust-hermit-abi-0.3.2
  (crate-source "hermit-abi" "0.3.2"
                "12v66gy77sqrgmjlx01w9p054nvz4mnhbd6xaazkxnddrp448ca4"))

(define rust-hex-0.4.3
  (crate-source "hex" "0.4.3"
                "0w1a4davm1lgzpamwnba907aysmlrnygbqmfis2mqjx5m552a93z"))

(define rust-home-0.5.11
  (crate-source "home" "0.5.11"
                "1kxb4k87a9sayr8jipr7nq9wpgmjk4hk4047hmf9kc24692k75aq"))

(define rust-hostname-0.3.1
  (crate-source "hostname" "0.3.1"
                "0rz8yf70cvzl3nry71m4bz9w6x4j9kdz3qng6pnwhk2h20z1qwrw"))

(define rust-html-escape-0.2.13
  (crate-source "html-escape" "0.2.13"
                "0xml3hswv0205fbm5iq7dqiwjkr6d245xkfppwi7wqjdfr4x86kd"))

(define rust-html5ever-0.38.0
  (crate-source "html5ever" "0.38.0"
                "1hnbs7d7v26gdgf6mm8rschsjrxazc139lik3q3f051gmqml6m0h"))

(define rust-http-1.4.0
  (crate-source "http" "1.4.0"
                "06iind4cwsj1d6q8c2xgq8i2wka4ps74kmws24gsi1bzdlw2mfp3"))

(define rust-http-body-1.0.1
  (crate-source "http-body" "1.0.1"
                "111ir5k2b9ihz5nr9cz7cwm7fnydca7dx4hc7vr16scfzghxrzhy"))

(define rust-http-body-util-0.1.3
  (crate-source "http-body-util" "0.1.3"
                "0jm6jv4gxsnlsi1kzdyffjrj8cfr3zninnxpw73mvkxy4qzdj8dh"))

(define rust-httparse-1.10.1
  (crate-source "httparse" "1.10.1"
                "11ycd554bw2dkgw0q61xsa7a4jn1wb1xbfacmf3dbwsikvkkvgvd"))

(define rust-httpdate-1.0.3
  (crate-source "httpdate" "1.0.3"
                "1aa9rd2sac0zhjqh24c9xvir96g188zldkx0hr6dnnlx5904cfyz"))

(define rust-humantime-2.1.0
  (crate-source "humantime" "2.1.0"
                "1r55pfkkf5v0ji1x6izrjwdq9v6sc7bv99xj6srywcar37xmnfls"))

(define rust-humantime-2.3.0
  (crate-source "humantime" "2.3.0"
                "092lpipp32ayz4kyyn4k3vz59j9blng36wprm5by0g2ykqr14nqk"))

(define rust-hyper-1.9.0
  (crate-source "hyper" "1.9.0"
                "1jmwbwqcaficskg76kq402gbymbnh2z4v99xwq3l5aa6n8bg16b2"))

(define rust-hyper-rustls-0.27.9
  (crate-source "hyper-rustls" "0.27.9"
                "03vfnsm873wsp1dk0q85nxvk7w6syp8c2m5bcdjcyfgg4786ijik"))

(define rust-hyper-tls-0.6.0
  (crate-source "hyper-tls" "0.6.0"
                "1q36x2yps6hhvxq5r7mc8ph9zz6xlb573gx0x3yskb0fi736y83h"))

(define rust-hyper-util-0.1.20
  (crate-source "hyper-util" "0.1.20"
                "186zdc58hmm663csmjvrzgkr6jdh93sfmi3q2pxi57gcaqjpqm4n"))

(define rust-iana-time-zone-0.1.65
  (crate-source "iana-time-zone" "0.1.65"
                "0w64khw5p8s4nzwcf36bwnsmqzf61vpwk9ca1920x82bk6nwj6z3"))

(define rust-iana-time-zone-haiku-0.1.2
  (crate-source "iana-time-zone-haiku" "0.1.2"
                "17r6jmj31chn7xs9698r122mapq85mfnv98bb4pg6spm0si2f67k"))

(define rust-ico-0.5.0
  (crate-source "ico" "0.5.0"
                "0w9k20ssrwdaphqn5sc1na03xf4n3asl3jl5zx5z1q05avzmsy9y"))

(define rust-icu-collections-2.2.0
  (crate-source "icu_collections" "2.2.0"
                "070r7xd0pynm0hnc1v2jzlbxka6wf50f81wybf9xg0y82v6x3119"))

(define rust-icu-locale-core-2.2.0
  (crate-source "icu_locale_core" "2.2.0"
                "0a9cmin5w1x3bg941dlmgszn33qgq428k7qiqn5did72ndi9n8cj"))

(define rust-icu-normalizer-2.2.0
  (crate-source "icu_normalizer" "2.2.0"
                "1d7krxr0xpc4x9635k1100a24nh0nrc59n65j6yk6gbfkplmwvn5"))

(define rust-icu-normalizer-data-2.2.0
  (crate-source "icu_normalizer_data" "2.2.0"
                "0f5d5d5fhhr9937m2z6z38fzh6agf14z24kwlr6lyczafypf0fys"))

(define rust-icu-properties-2.2.0
  (crate-source "icu_properties" "2.2.0"
                "1pkh3s837808cbwxvfagwc28cvwrz2d9h5rl02jwrhm51ryvdqxy"))

(define rust-icu-properties-data-2.2.0
  (crate-source "icu_properties_data" "2.2.0"
                "052awny0qwkbcbpd5jg2cd7vl5ry26pq4hz1nfsgf10c3qhbnawf"))

(define rust-icu-provider-2.2.0
  (crate-source "icu_provider" "2.2.0"
                "08dl8pxbwr8zsz4c5vphqb7xw0hykkznwi4rw7bk6pwb3krlr70k"))

(define rust-id-arena-2.3.0
  (crate-source "id-arena" "2.3.0"
                "0m6rs0jcaj4mg33gkv98d71w3hridghp5c4yr928hplpkgbnfc1x"))

(define rust-ident-case-1.0.1
  (crate-source "ident_case" "1.0.1"
                "0fac21q6pwns8gh1hz3nbq15j8fi441ncl6w4vlnd1cmc55kiq5r"))

(define rust-idna-1.1.0
  (crate-source "idna" "1.1.0"
                "1pp4n7hppm480zcx411dsv9wfibai00wbpgnjj4qj0xa7kr7a21v"))

(define rust-idna-adapter-1.2.2
  (crate-source "idna_adapter" "1.2.2"
                "0557p76l8hj35r9zn1yv7c6x1c0qbrsffmg80n0yy8361ly3fs6b"))

(define rust-indexmap-1.9.3
  (crate-source "indexmap" "1.9.3"
                "16dxmy7yvk51wvnih3a3im6fp5lmx0wx76i03n06wyak6cwhw1xx"))

(define rust-indexmap-2.14.0
  (crate-source "indexmap" "2.14.0"
                "1na9z6f0d5pkjr1lgsni470v98gv2r7c41j8w48skr089x2yjrnl"))

(define rust-infer-0.19.0
  (crate-source "infer" "0.19.0"
                "1xzwzzg7s3i9jhcd304rb7b7838zkcysd67gmhffg4pxzmmr3255"))

(define rust-inflector-0.11.4
  (crate-source "Inflector" "0.11.4"
                "1lqmcni21ifzyq41fhz6k1j2b23cmsx469s4g4sf01l78miqqhzy"))

(define rust-inout-0.1.4
  (crate-source "inout" "0.1.4"
                "008xfl1jn9rxsq19phnhbimccf4p64880jmnpg59wqi07kk117w7"))

(define rust-inquire-0.9.4
  (crate-source "inquire" "0.9.4"
                "0mlp89ci2r5nr5yw9hcfb7m2r3hcq49iqjnhcbq0qc14h25p6m36"))

(define rust-ipnet-2.12.0
  (crate-source "ipnet" "2.12.0"
                "1qpq2y0asyv0jppw7zww9y96fpnpinwap8a0phhqqgyy3znnz3yr"))

(define rust-is-docker-0.2.0
  (crate-source "is-docker" "0.2.0"
                "1cyibrv6817cqcpf391m327ss40xlbik8wxcv5h9pj9byhksx2wj"))

(define rust-is-executable-1.0.5
  (crate-source "is_executable" "1.0.5"
                "1i78ss45h94nwabbn6ki64a91djlli8zdwwbh56jj9kvhssbiaxs"))

(define rust-is-terminal-0.4.9
  (crate-source "is-terminal" "0.4.9"
                "12xgvc7nsrp3pn8hcxajfhbli2l5wnh3679y2fmky88nhj4qj26b"))

(define rust-is-terminal-polyfill-1.70.2
  (crate-source "is_terminal_polyfill" "1.70.2"
                "15anlc47sbz0jfs9q8fhwf0h3vs2w4imc030shdnq54sny5i7jx6"))

(define rust-is-wsl-0.4.0
  (crate-source "is-wsl" "0.4.0"
                "19bs5pq221d4bknnwiqqkqrnsx2in0fsk8fylxm1747iim4hjdhp"))

(define rust-itoa-1.0.18
  (crate-source "itoa" "1.0.18"
                "10jnd1vpfkb8kj38rlkn2a6k02afvj3qmw054dfpzagrpl6achlg"))

(define rust-itoa-1.0.2
  (crate-source "itoa" "1.0.2"
                "13ap85z7slvma9c36bzi7h5j66dm5sxm4a2g7wiwxbsh826nfb0i"))

(define rust-javascriptcore-rs-1.1.2
  (crate-source "javascriptcore-rs" "1.1.2"
                "1k3z4pmg46znxfmjqvx63d5zr9vdj070f97wgajzp3yfzzlp2mna"))

(define rust-javascriptcore-rs-sys-1.1.1
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "javascriptcore-rs-sys" "1.1.1"
                "092igagxm561lx65sin2z18jpxzyg0288cfzcrdvg97z2j6yf6xg"))

(define rust-jiff-0.2.24
  (crate-source "jiff" "0.2.24"
                "0g87al8yqp05m63dhqzi359xgsslc0grqz00nvfdyq8dcayms2zh"))

(define rust-jiff-static-0.2.24
  (crate-source "jiff-static" "0.2.24"
                "1mz6v0d1hd8wjgfzccgda5g9z01s1yxnyiizvahjw0pq1w1xw070"))

(define rust-jni-0.21.1
  (crate-source "jni" "0.21.1"
                "15wczfkr2r45slsljby12ymf2hij8wi5b104ghck9byjnwmsm1qs"))

(define rust-jni-0.22.4
  (crate-source "jni" "0.22.4"
                "161lza8gz071h22pgyqyx4n91ixd691z2dbb1pq2g97k5i49mzay"))

(define rust-jni-macros-0.22.4
  (crate-source "jni-macros" "0.22.4"
                "18v02mcn5c7mb2yw6r930xg6ynsn7hwkxv8z2kdhn3qprjn0j0d0"))

(define rust-jni-sys-0.3.1
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "jni-sys" "0.3.1"
                "0n1j8fbz081w1igfrpc79n6vgm7h3ik34nziy5fjgq5nz7hm59j1"))

(define rust-jni-sys-0.4.1
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "jni-sys" "0.4.1"
                "1wlahx6f2zhczdjqyn8mk7kshb8x5vsd927sn3lvw41rrf47ldy6"))

(define rust-jni-sys-macros-0.4.1
  (crate-source "jni-sys-macros" "0.4.1"
                "0r32gbabrak15a7p487765b5wc0jcna2yv88mk6m1zjqyi1bkh1q"))

(define rust-js-sys-0.3.98
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "js-sys" "0.3.98"
                "024zjwpxp6fri4j79bh1686q1x4nw4a06fh1a28zv2rzc4973pv7"))

(define rust-json-patch-3.0.1
  (crate-source "json-patch" "3.0.1"
                "023gm1q5xhhnhz7jqk009yb5wpjl4gckawgzxs82bg5nmzbjcdw6"))

(define rust-jsonptr-0.6.3
  (crate-source "jsonptr" "0.6.3"
                "0w6xkr6ns46nm3136x7www1dczz45y2bl9bsxmb2b6r3vlkjpsjx"))

(define rust-keyboard-types-0.7.0
  (crate-source "keyboard-types" "0.7.0"
                "12jjfk7dwa1cqp6wzw0xl1zzg3arsrnqy4afsynxn2csqfnxql5p"))

(define rust-leb128fmt-0.1.0
  (crate-source "leb128fmt" "0.1.0"
                "1chxm1484a0bly6anh6bd7a99sn355ymlagnwj3yajafnpldkv89"))

(define rust-libappindicator-0.9.0
  (crate-source "libappindicator" "0.9.0"
                "02nwjmm5qqbkvzbz4j1dd50xs0ywr0i2l2scwmxcqs680yb9nn03"))

(define rust-libappindicator-sys-0.9.0
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "libappindicator-sys" "0.9.0"
                "1bsw2mcxil3zm4zzdir76i7xnaqaq30cd9qpviccrvdb70hwb7kf"))

(define rust-libc-0.2.155
  (crate-source "libc" "0.2.155"
                "0z44c53z54znna8n322k5iwg80arxxpdzjj5260pxxzc9a58icwp"))

(define rust-libc-0.2.186
  (crate-source "libc" "0.2.186"
                "0rnyhzjyqq9x56skkllbjzzzwym3r61lq3l4hqj64v71gw0r3av8"))

(define rust-libdbus-sys-0.2.7
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "libdbus-sys" "0.2.7"
                "0hzhq0dz6lfzmhsym9m95cfhjzrwq74qdg85xkpg2012sj4lg31j"))

(define rust-libloading-0.7.4
  (crate-source "libloading" "0.7.4"
                "17wbccnjvhjd9ibh019xcd8kjvqws8lqgq86lqkpbgig7gyq0wxn"))

(define rust-libredox-0.1.16
  (crate-source "libredox" "0.1.16"
                "0v54zvgknag9310wcjykgv86pgq02qr3mzgkdg4r6m1k7ns3nbz0"))

(define rust-libseccomp-sys-0.2.1
  ;; TODO: Check bundled sources.
  (crate-source "libseccomp-sys" "0.2.1"
                "0f6iw3qsww1dkrx49wh8vmda198i7galfnvfgjc52wj6mpabnz4s"))

(define rust-linux-raw-sys-0.12.1
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "linux-raw-sys" "0.12.1"
                "0lwasljrqxjjfk9l2j8lyib1babh2qjlnhylqzl01nihw14nk9ij"))

(define rust-linux-raw-sys-0.4.5
  ;; TODO: Check bundled sources.
  (crate-source "linux-raw-sys" "0.4.5"
                "00w52pb2cb4b2880ksyzagmzbyjdmp9ac0w3qfvjv3453fnzvg2p"))

(define rust-litemap-0.8.2
  (crate-source "litemap" "0.8.2"
                "1w7628bc7wwcxc4n4s5kw0610xk06710nh2hn5kwwk2wa91z9nlj"))

(define rust-litrs-1.0.0
  (crate-source "litrs" "1.0.0"
                "14p0kzzkavnngvybl88nvfwv031cc2qx4vaxpfwsiifm8grdglqi"))

(define rust-lock-api-0.4.10
  (crate-source "lock_api" "0.4.10"
                "05nd9nzxqidg24d1k8y5vlc8lz9gscpskrikycib46qbl8brgk61"))

(define rust-lock-api-0.4.14
  (crate-source "lock_api" "0.4.14"
                "0rg9mhx7vdpajfxvdjmgmlyrn20ligzqvn8ifmaz7dc79gkrjhr2"))

(define rust-log-0.4.17
  (crate-source "log" "0.4.17"
                "0biqlaaw1lsr8bpnmbcc0fvgjj34yy79ghqzyi0ali7vgil2xcdb"))

(define rust-log-0.4.29
  (crate-source "log" "0.4.29"
                "15q8j9c8g5zpkcw0hnd6cf2z7fxqnvsjh3rw5mv5q10r83i34l2y"))

(define rust-log-reload-0.1.3
  (crate-source "log-reload" "0.1.3"
                "0vakp9ig5hb96r2mdkmf9fvlj1spl9fzhnak2hki7047wbkyk9a0"))

(define rust-lzma-sys-0.1.20
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "lzma-sys" "0.1.20"
                "09sxp20waxyglgn3cjz8qjkspb3ryz2fwx4rigkwvrk46ymh9njz"))

(define rust-mac-addr-0.3.0
  (crate-source "mac-addr" "0.3.0"
                "0pq60czpy0svbwb6rxn6vq0pcwdrmga7lfy21ab8d2k41c75plnk"))

(define rust-machine-uid-0.5.4
  (crate-source "machine-uid" "0.5.4"
                "15mx8v6smhyvvr5rrmqmk79mgq3jh44kn4a3vbb43cfdfgaifwkx"))

(define rust-markup5ever-0.38.0
  (crate-source "markup5ever" "0.38.0"
                "0qhqx70ak6pi9pbyddb61fhd37kypkbbvfnnnamfmzhm547x70w9"))

(define rust-match-cfg-0.1.0
  (crate-source "match_cfg" "0.1.0"
                "1r5j3zqc3qr8ybcx95bk8q57mkizmgmffj5lmicd4i8d9riyigpz"))

(define rust-matchit-0.8.4
  (crate-source "matchit" "0.8.4"
                "1hzl48fwq1cn5dvshfly6vzkzqhfihya65zpj7nz7lfx82mgzqa7"))

(define rust-md5-0.8.0
  (crate-source "md5" "0.8.0"
                "1q6jfsa5w3993dzymxkv9jxpp7vyhgga6z35g6c0c8rk50w0i5mf"))

(define rust-memchr-2.5.0
  (crate-source "memchr" "2.5.0"
                "0vanfk5mzs1g1syqnj03q8n0syggnhn55dq535h2wxr7rwpfbzrd"))

(define rust-memchr-2.8.0
  (crate-source "memchr" "2.8.0"
                "0y9zzxcqxvdqg6wyag7vc3h0blhdn7hkq164bxyx2vph8zs5ijpq"))

(define rust-memoffset-0.9.1
  (crate-source "memoffset" "0.9.1"
                "12i17wh9a9plx869g7j4whf62xw68k5zd4k0k5nh6ys5mszid028"))

(define rust-mime-0.3.17
  (crate-source "mime" "0.3.17"
                "16hkibgvb9klh0w0jk5crr5xv90l3wlf77ggymzjmvl1818vnxv8"))

(define rust-miniz-oxide-0.8.9
  (crate-source "miniz_oxide" "0.8.9"
                "05k3pdg8bjjzayq3rf0qhpirq9k37pxnasfn4arbs17phqn6m9qz"))

(define rust-mio-1.2.0
  (crate-source "mio" "1.2.0"
                "1hanrh4fwsfkdqdaqfidz48zz1wdix23zwn3r2x78am0garfbdsh"))

(define rust-muda-0.19.1
  (crate-source "muda" "0.19.1"
                "1jykz9zhissasiwv3g8x2a2bj5swiidmh1g26kiiicdmcd7q9s0a"))

(define rust-native-tls-0.2.18
  (crate-source "native-tls" "0.2.18"
                "1wmv0g5p6jwyyslyw88w5fv9kc9qvjd1hi2d4sfl4qm19vhh0ma6"))

(define rust-ndk-0.9.0
  (crate-source "ndk" "0.9.0"
                "1m32zpmi5w1pf3j47k6k5fw395dc7aj8d0mdpsv53lqkprxjxx63"))

(define rust-ndk-context-0.1.1
  (crate-source "ndk-context" "0.1.1"
                "12sai3dqsblsvfd1l1zab0z6xsnlha3xsfl7kagdnmj3an3jvc17"))

(define rust-ndk-sys-0.6.0+11769913
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "ndk-sys" "0.6.0+11769913"
                "0wx8r6pji20if4xs04g73gxl98nmjrfc73z0v6w1ypv6a4qdlv7f"))

(define rust-netdev-0.40.1
  (crate-source "netdev" "0.40.1"
                "02haqgwqzxzjwj1dhq0r7wz3g787bxcvx6x8vdwfhgk1v6b002hv"))

(define rust-netlink-packet-core-0.8.1
  (crate-source "netlink-packet-core" "0.8.1"
                "1x707b3a579vr9p9hqdpjhrlfzhrq8zvj9n9w90h3jwlhfvwnqrl"))

(define rust-netlink-packet-route-0.29.0
  (crate-source "netlink-packet-route" "0.29.0"
                "1dj6f59p0hcq9874ln8xv393v0z0pijkpw57k133yknidbm5966z"))

(define rust-netlink-sys-0.8.8
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "netlink-sys" "0.8.8"
                "1bizb26qgk765vg7qyrnwywdwsqzjz68a6s93m4wqsgs23nk0v6d"))

(define rust-new-debug-unreachable-1.0.6
  (crate-source "new_debug_unreachable" "1.0.6"
                "11phpf1mjxq6khk91yzcbd3ympm78m3ivl7xg6lg2c0lf66fy3k5"))

(define rust-nix-0.30.1
  (crate-source "nix" "0.30.1"
                "1dixahq9hk191g0c2ydc0h1ppxj0xw536y6rl63vlnp06lx3ylkl"))

(define rust-ntapi-0.4.3
  (crate-source "ntapi" "0.4.3"
                "1bl0d73avwla7laa4pkqvzvifjbs0avg65w01zxjydgx3likbcy3"))

(define rust-num-conv-0.2.1
  (crate-source "num-conv" "0.2.1"
                "0rqrr29brafaa2za352pbmhkk556n7f8z9rrkgmjp1idvdl3fry6"))

(define rust-num-cpus-1.13.1
  (crate-source "num_cpus" "1.13.1"
                "18apx62z4j4lajj2fi6r1i8slr9rs2d0xrbj2ls85qfyxck4brhr"))

(define rust-num-enum-0.7.6
  (crate-source "num_enum" "0.7.6"
                "09kg0c2y08npdv0c9dbm4m9a9wz8w2qaiqqxl4gj3v22hj1wl2sx"))

(define rust-num-enum-derive-0.7.6
  (crate-source "num_enum_derive" "0.7.6"
                "1y0x9z49s27vdas6mglqbv02sgkdmbr8ns2kwspzrp2ra81rh2b8"))

(define rust-num-threads-0.1.6
  (crate-source "num_threads" "0.1.6"
                "0i5vmffsv6g79z869flp1sja69g1gapddjagdw1k3q9f3l2cw698"))

(define rust-num-traits-0.2.19
  (crate-source "num-traits" "0.2.19"
                "0h984rhdkkqd4ny9cif7y2azl3xdfb7768hb9irhpsch4q3gq787"))

(define rust-objc2-0.6.4
  (crate-source "objc2" "0.6.4"
                "17x8qpl512frscfqbmgjr20kg3y4r0xdqxphja17dz5f0znsh4is"))

(define rust-objc2-app-kit-0.3.2
  (crate-source "objc2-app-kit" "0.3.2"
                "132ijwni8lsi8phq7wnmialkxp46zx998fns3zq5np0ya1mr77nl"))

(define rust-objc2-cloud-kit-0.3.2
  (crate-source "objc2-cloud-kit" "0.3.2"
                "0714xrydi9wvh25s2110sjfpx9mv4xs9p4ys71q8fhxvh3c79bbk"))

(define rust-objc2-core-data-0.3.2
  (crate-source "objc2-core-data" "0.3.2"
                "1ylqsa6hpma7k4090pkil8b7c0i8dcxnh46zwhnfidgv7rjjlh0b"))

(define rust-objc2-core-foundation-0.3.2
  (crate-source "objc2-core-foundation" "0.3.2"
                "0dnmg7606n4zifyjw4ff554xvjmi256cs8fpgpdmr91gckc0s61a"))

(define rust-objc2-core-graphics-0.3.2
  (crate-source "objc2-core-graphics" "0.3.2"
                "01x8413pxq0m5rwidlaczni8v5cz9dc3xqzq8l9zlpl9cv8cj8p0"))

(define rust-objc2-core-image-0.3.2
  (crate-source "objc2-core-image" "0.3.2"
                "01phi7cx2k32a8x45qr0y1623l2b8gg764c6isgj15rbinrn7mg5"))

(define rust-objc2-core-location-0.3.2
  (crate-source "objc2-core-location" "0.3.2"
                "02908pp1knq64wjq07zd6q2z77qppdpd7l2z0by77jabw8a74d6a"))

(define rust-objc2-core-text-0.3.2
  (crate-source "objc2-core-text" "0.3.2"
                "0bfrzqxhgh4y1imk1bb9g0v28g0frigls6hnc942npfj93xhvphc"))

(define rust-objc2-encode-4.1.0
  (crate-source "objc2-encode" "4.1.0"
                "0cqckp4cpf68mxyc2zgnazj8klv0z395nsgbafa61cjgsyyan9gg"))

(define rust-objc2-exception-helper-0.1.1
  (crate-source "objc2-exception-helper" "0.1.1"
                "12nrg6fhhp2rzmnym6s37h7w9v9sa9wbaixvfsq3axrdnzxwb8f7"))

(define rust-objc2-foundation-0.3.2
  (crate-source "objc2-foundation" "0.3.2"
                "0wijkxzzvw2xkzssds3fj8279cbykz2rz9agxf6qh7y2agpsvq73"))

(define rust-objc2-io-kit-0.3.2
  (crate-source "objc2-io-kit" "0.3.2"
                "05dvfcf97w39daaj5qsbfc399lw9hbx3s4h9nwgxrmlpjnizpyik"))

(define rust-objc2-io-surface-0.3.2
  (crate-source "objc2-io-surface" "0.3.2"
                "07fqx4fmwydf2arrc4xs4awv7zyzzxh60fyqdfmrpm9n148qh1qq"))

(define rust-objc2-javascript-core-0.3.2
  (crate-source "objc2-javascript-core" "0.3.2"
                "11j50w71gip729hsjkzdvfqhp9zczz4p0cyfas4k9vfaqi86a7ia"))

(define rust-objc2-quartz-core-0.3.2
  (crate-source "objc2-quartz-core" "0.3.2"
                "07vzaf6y1lk7zygkgvpp23mm19ipdm9yq8af22gvywdkaa23bhcn"))

(define rust-objc2-security-0.3.2
  (crate-source "objc2-security" "0.3.2"
                "0nl9dnnjj0z6yaw5s70szkd62acbgmxgg44km6syilcv20vy37vh"))

(define rust-objc2-system-configuration-0.3.2
  (crate-source "objc2-system-configuration" "0.3.2"
                "15m39m325yhkjpcagcygbv3qx19vr4ym4kdqramwqm6src8vs5kj"))

(define rust-objc2-ui-kit-0.3.2
  (crate-source "objc2-ui-kit" "0.3.2"
                "08mbgqg8pffclyxpz2lr8r1fv8wn2i4m1k6bk1s5fvy06f766zfq"))

(define rust-objc2-user-notifications-0.3.2
  (crate-source "objc2-user-notifications" "0.3.2"
                "0gk1frfj875pkbz3ncs8swvjgdipz3vwq5l42vd3rxzypf615ycx"))

(define rust-objc2-web-kit-0.3.2
  (crate-source "objc2-web-kit" "0.3.2"
                "0zqyflb4r2igpg5s48fmjbcajikvdbwpm7fzf3s3qhqck2msmrdj"))

(define rust-once-cell-1.18.0
  (crate-source "once_cell" "1.18.0"
                "0vapcd5ambwck95wyz3ymlim35jirgnqn9a0qmi19msymv95v2yx"))

(define rust-once-cell-1.21.4
  (crate-source "once_cell" "1.21.4"
                "0l1v676wf71kjg2khch4dphwh1jp3291ffiymr2mvy1kxd5kwz4z"))

(define rust-once-cell-polyfill-1.70.2
  (crate-source "once_cell_polyfill" "1.70.2"
                "1zmla628f0sk3fhjdjqzgxhalr2xrfna958s632z65bjsfv8ljrq"))

(define rust-opaque-debug-0.3.1
  (crate-source "opaque-debug" "0.3.1"
                "10b3w0kydz5jf1ydyli5nv10gdfp97xh79bgz327d273bs46b3f0"))

(define rust-open-5.3.5
  (crate-source "open" "5.3.5"
                "0b691z6jf5gk3sbjmq5qhg22iyngm3p6kprsib3p716w5nfsifig"))

(define rust-openssl-0.10.80
  (crate-source "openssl" "0.10.80"
                "0ryrcbdd7hq0ydvassn4cr02agii1l54yd6sali7chkci2ma4px4"))

(define rust-openssl-macros-0.1.1
  (crate-source "openssl-macros" "0.1.1"
                "173xxvfc63rr5ybwqwylsir0vq6xsj4kxiv4hmg4c3vscdmncj59"))

(define rust-openssl-probe-0.2.1
  (crate-source "openssl-probe" "0.2.1"
                "1gpwpb7smfhkscwvbri8xzbab39wcnby1jgz1s49vf1aqgsdx1vw"))

(define rust-openssl-sys-0.9.116
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "openssl-sys" "0.9.116"
                "1i0qcgsimh8qkfgrglmzz2kq3jk2d5575rz5jvqabka0f7f252pj"))

(define rust-option-ext-0.2.0
  (crate-source "option-ext" "0.2.0"
                "0zbf7cx8ib99frnlanpyikm1bx8qn8x602sw1n7bg6p9x94lyx04"))

(define rust-os-info-3.14.0
  (crate-source "os_info" "3.14.0"
                "09122f72665q30qsaq4r6c57zpphhgjdlvr3d6ixc02sb4bjl0p4"))

(define rust-pango-0.18.3
  (crate-source "pango" "0.18.3"
                "1r5ygq7036sv7w32kp8yxr6vgggd54iaavh3yckanmq4xg0px8kw"))

(define rust-pango-sys-0.18.0
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "pango-sys" "0.18.0"
                "1iaxalcaaj59cl9n10svh4g50v8jrc1a36kd7n9yahx8j7ikfrs3"))

(define rust-parking-lot-0.12.5
  (crate-source "parking_lot" "0.12.5"
                "06jsqh9aqmc94j2rlm8gpccilqm6bskbd67zf6ypfc0f4m9p91ck"))

(define rust-parking-lot-core-0.9.12
  (crate-source "parking_lot_core" "0.9.12"
                "1hb4rggy70fwa1w9nb0svbyflzdc69h047482v2z3sx2hmcnh896"))

(define rust-paste-1.0.15
  (crate-source "paste" "1.0.15"
                "02pxffpdqkapy292harq6asfjvadgp1s005fip9ljfsn9fvxgh2p"))

(define rust-pathdiff-0.2.3
  (crate-source "pathdiff" "0.2.3"
                "1lrqp4ip05df8dzldq6gb2c1sq2gs54gly8lcnv3rhav1qhwx56z"))

(define rust-pem-3.0.6
  (crate-source "pem" "3.0.6"
                "1glia9vv51wx79cysqxgdha6g1bwbbr20bfhijlk2nxw4qycac0x"))

(define rust-percent-encoding-2.3.2
  (crate-source "percent-encoding" "2.3.2"
                "083jv1ai930azvawz2khv7w73xh8mnylk7i578cifndjn5y64kwv"))

(define rust-phf-0.13.1
  (crate-source "phf" "0.13.1"
                "1pzswx5gdglgjgp4azyzwyr4gh031r0kcnpqq6jblga72z3jsmn1"))

(define rust-phf-codegen-0.13.1
  (crate-source "phf_codegen" "0.13.1"
                "1qfnsl2hiny0yg4lwn888xla5iwccszgxnx8dhbwl6s2h2fpzaj9"))

(define rust-phf-generator-0.13.1
  (crate-source "phf_generator" "0.13.1"
                "0dwpp11l41dy9mag4phkyyvhpf66lwbp79q3ik44wmhyfqxcwnhk"))

(define rust-phf-macros-0.13.1
  (crate-source "phf_macros" "0.13.1"
                "1vv9h8pr7xh18sigpvq1hxc8q9nmjmv6gdpqsp65krxiahmh6bw1"))

(define rust-phf-shared-0.13.1
  (crate-source "phf_shared" "0.13.1"
                "0rpjchnswm0x5l4mz9xqfpw0j4w68sjvyqrdrv13h7lqqmmyyzz5"))

(define rust-pin-project-lite-0.2.17
  (crate-source "pin-project-lite" "0.2.17"
                "1kfmwvs271si96zay4mm8887v5khw0c27jc9srw1a75ykvgj54x8"))

(define rust-pin-project-lite-0.2.9
  (crate-source "pin-project-lite" "0.2.9"
                "05n1z851l356hpgqadw4ar64mjanaxq1qlwqsf2k05ziq8xax9z0"))

(define rust-pin-utils-0.1.0
  (crate-source "pin-utils" "0.1.0"
                "117ir7vslsl2z1a7qzhws4pd01cg2d3338c47swjyvqv2n60v1wb"))

(define rust-pkg-config-0.3.33
  (crate-source "pkg-config" "0.3.33"
                "17jnqmcbxsnwhg9gjf0nh6dj5k0x3hgwi3mb9krjnmfa9v435w8r"))

(define rust-plain-0.2.3
  (crate-source "plain" "0.2.3"
                "19n1xbxb4wa7w891268bzf6cbwq4qvdb86bik1z129qb0xnnnndl"))

(define rust-plist-1.9.0
  (crate-source "plist" "1.9.0"
                "1wa6kk1179hxn0dd0sw99jcz4053lfxwzgavnv0p6qh2iqkr29q9"))

(define rust-png-0.17.16
  (crate-source "png" "0.17.16"
                "09kmkms9fmkbkarw0lnf0scqvjwwg3r7riddag0i3q39r0pil5c2"))

(define rust-png-0.18.1
  (crate-source "png" "0.18.1"
                "0qca282xp8a6d7mikxrwji3f52mjn4vnqxz2v9iz5adj665rnxk0"))

(define rust-poly1305-0.8.0
  (crate-source "poly1305" "0.8.0"
                "1grs77skh7d8vi61ji44i8gpzs3r9x7vay50i6cg8baxfa8bsnc1"))

(define rust-portable-atomic-1.13.1
  (crate-source "portable-atomic" "1.13.1"
                "0j8vlar3n5acyigq8q6f4wjx3k3s5yz0rlpqrv76j73gi5qr8fn3"))

(define rust-portable-atomic-util-0.2.7
  (crate-source "portable-atomic-util" "0.2.7"
                "0616j0fhy6y71hyxg3n86f6hng0fmsc269s3wp4gl8ww4p8hd8f2"))

(define rust-postcard-1.0.6
  (crate-source "postcard" "1.0.6"
                "1sza4l5rbha2ffvi4l0w7c9ihxk2i6v4i6bl2g8kq79i6a975vn9"))

(define rust-potential-utf-0.1.5
  (crate-source "potential_utf" "0.1.5"
                "0r0518fr32xbkgzqap509s3r60cr0iancsg9j1jgf37cyz7b20q1"))

(define rust-powerfmt-0.2.0
  (crate-source "powerfmt" "0.2.0"
                "14ckj2xdpkhv3h6l5sdmb9f1d57z8hbfpdldjc2vl5givq2y77j3"))

(define rust-ppv-lite86-0.2.20
  (crate-source "ppv-lite86" "0.2.20"
                "017ax9ssdnpww7nrl1hvqh2lzncpv04nnsibmnw9nxjnaqlpp5bp"))

(define rust-ppv-lite86-0.2.21
  (crate-source "ppv-lite86" "0.2.21"
                "1abxx6qz5qnd43br1dd9b2savpihzjza8gb4fbzdql1gxp2f7sl5"))

(define rust-precomputed-hash-0.1.1
  (crate-source "precomputed-hash" "0.1.1"
                "075k9bfy39jhs53cb2fpb9klfakx2glxnf28zdw08ws6lgpq6lwj"))

(define rust-prettyplease-0.2.37
  (crate-source "prettyplease" "0.2.37"
                "0azn11i1kh0byabhsgab6kqs74zyrg69xkirzgqyhz6xmjnsi727"))

(define rust-proc-macro-crate-1.3.1
  (crate-source "proc-macro-crate" "1.3.1"
                "069r1k56bvgk0f58dm5swlssfcp79im230affwk6d9ck20g04k3z"))

(define rust-proc-macro-crate-2.0.2
  (crate-source "proc-macro-crate" "2.0.2"
                "092x5acqnic14cw6vacqap5kgknq3jn4c6jij9zi6j85839jc3xh"))

(define rust-proc-macro-crate-3.5.0
  (crate-source "proc-macro-crate" "3.5.0"
                "0kv1g1d1zjwxlgcaba2qlshzyy32j03xic8rskqlcr5mnblsfyz6"))

(define rust-proc-macro-error-1.0.4
  (crate-source "proc-macro-error" "1.0.4"
                "1373bhxaf0pagd8zkyd03kkx6bchzf6g0dkwrwzsnal9z47lj9fs"))

(define rust-proc-macro-error-attr-1.0.4
  (crate-source "proc-macro-error-attr" "1.0.4"
                "0sgq6m5jfmasmwwy8x4mjygx5l7kp8s4j60bv25ckv2j1qc41gm1"))

(define rust-proc-macro2-1.0.106
  (crate-source "proc-macro2" "1.0.106"
                "0d09nczyaj67x4ihqr5p7gxbkz38gxhk4asc0k8q23g9n85hzl4g"))

(define rust-proc-macro2-1.0.63
  (crate-source "proc-macro2" "1.0.63"
                "1ssr3643nwfhw7yvqhibjw1k6nsnbv0lxq7mc1zcw38vjax8ydkv"))

(define rust-quick-xml-0.39.4
  (crate-source "quick-xml" "0.39.4"
                "0plfhnna58ad2hlym3q02zrmmh7xdpikzs7hll4x6w7nwba8vk6d"))

(define rust-quote-1.0.29
  (crate-source "quote" "1.0.29"
                "019ij5fwp56ydww6zr46dhmzsf078qkdq9vz6mw1cri7mgl1ac2p"))

(define rust-quote-1.0.45
  (crate-source "quote" "1.0.45"
                "095rb5rg7pbnwdp6v8w5jw93wndwyijgci1b5lw8j1h5cscn3wj1"))

(define rust-r-efi-5.3.0
  (crate-source "r-efi" "5.3.0"
                "03sbfm3g7myvzyylff6qaxk4z6fy76yv860yy66jiswc2m6b7kb9"))

(define rust-r-efi-6.0.0
  (crate-source "r-efi" "6.0.0"
                "1gyrl2k5fyzj9k7kchg2n296z5881lg7070msabid09asp3wkp7q"))

(define rust-rand-0.8.5
  (crate-source "rand" "0.8.5"
                "013l6931nn7gkc23jz5mm3qdhf93jjf0fg64nz2lp4i51qd8vbrl"))

(define rust-rand-0.9.4
  (crate-source "rand" "0.9.4"
                "1sknbxgs6nfg0nxdd7689lwbyr2i4vaswchrv4b34z8vpc3azia4"))

(define rust-rand-chacha-0.3.1
  (crate-source "rand_chacha" "0.3.1"
                "123x2adin558xbhvqb8w4f6syjsdkmqff8cxwhmjacpsl1ihmhg6"))

(define rust-rand-chacha-0.9.0
  (crate-source "rand_chacha" "0.9.0"
                "1jr5ygix7r60pz0s1cv3ms1f6pd1i9pcdmnxzzhjc3zn3mgjn0nk"))

(define rust-rand-core-0.6.4
  (crate-source "rand_core" "0.6.4"
                "0b4j2v4cb5krak1pv6kakv4sz6xcwbrmy2zckc32hsigbrwy82zc"))

(define rust-rand-core-0.9.5
  (crate-source "rand_core" "0.9.5"
                "0g6qc5r3f0hdmz9b11nripyp9qqrzb0xqk9piip8w8qlvqkcibvn"))

(define rust-range-traits-0.3.2
  (crate-source "range-traits" "0.3.2"
                "1ay8ghrp7phr8z1l2kg9fcszwjki5d0s5wfzqw9sjvyp5mrq21fj"))

(define rust-raw-window-handle-0.6.2
  (crate-source "raw-window-handle" "0.6.2"
                "0ff5c648hncwx7hm2a8fqgqlbvbl4xawb6v3xxv9wkpjyrr5arr0"))

(define rust-rayon-1.12.0
  (crate-source "rayon" "1.12.0"
                "0vcj63xgnk72c30vdrak7dhl53snnaqv9x2faf1d94hzg1kb2fgv"))

(define rust-rayon-core-1.13.0
  (crate-source "rayon-core" "1.13.0"
                "14dbr0sq83a6lf1rfjq5xdpk5r6zgzvmzs5j6110vlv2007qpq92"))

(define rust-redact-engine-0.1.2
  (crate-source "redact-engine" "0.1.2"
                "0b5mk7axa24a6fxfnk88zafkkjiznj0rhwgrdl6wni9bmm0vmm4l"))

(define rust-redox-syscall-0.5.18
  (crate-source "redox_syscall" "0.5.18"
                "0b9n38zsxylql36vybw18if68yc9jczxmbyzdwyhb9sifmag4azd"))

(define rust-redox-syscall-0.7.5
  (crate-source "redox_syscall" "0.7.5"
                "06qvcqy42dv563dsbxpxyig0mslwrhyx3xllknqyl4l41nka2rj6"))

(define rust-redox-users-0.5.2
  (crate-source "redox_users" "0.5.2"
                "1b17q7gf7w8b1vvl53bxna24xl983yn7bd00gfbii74bcg30irm4"))

(define rust-ref-cast-1.0.25
  (crate-source "ref-cast" "1.0.25"
                "0zdzc34qjva9xxgs889z5iz787g81hznk12zbk4g2xkgwq530m7k"))

(define rust-ref-cast-impl-1.0.25
  (crate-source "ref-cast-impl" "1.0.25"
                "1nkhn1fklmn342z5c4mzfzlxddv3x8yhxwwk02cj06djvh36065p"))

(define rust-regex-1.12.3
  (crate-source "regex" "1.12.3"
                "0xp2q0x7ybmpa5zlgaz00p8zswcirj9h8nry3rxxsdwi9fhm81z1"))

(define rust-regex-1.6.0
  (crate-source "regex" "1.6.0"
                "12wqvyh4i75j7pc8sgvmqh4yy3qaj4inc4alyv1cdf3lf4kb6kjc"))

(define rust-regex-automata-0.4.14
  (crate-source "regex-automata" "0.4.14"
                "13xf7hhn4qmgfh784llcp2kzrvljd13lb2b1ca0mwnf15w9d87bf"))

(define rust-regex-syntax-0.6.27
  (crate-source "regex-syntax" "0.6.27"
                "0i32nnvyzzkvz1rqp2qyfxrp2170859z8ck37jd63c8irrrppy53"))

(define rust-regex-syntax-0.8.10
  (crate-source "regex-syntax" "0.8.10"
                "02jx311ka0daxxc7v45ikzhcl3iydjbbb0mdrpc1xgg8v7c7v2fw"))

(define rust-reqwest-0.12.28
  (crate-source "reqwest" "0.12.28"
                "0iqidijghgqbzl3bjg5hb4zmigwa4r612bgi0yiq0c90b6jkrpgd"))

(define rust-reqwest-0.13.3
  (crate-source "reqwest" "0.13.3"
                "1h7fgnllk7ihw7836b7z73h9fb5vk90y3irvcm0ysan2l8g05q32"))

(define rust-ring-0.17.14
  (crate-source "ring" "0.17.14"
                "1dw32gv19ccq4hsx3ribhpdzri1vnrlcfqb2vj41xn4l49n9ws54"))

(define rust-rustc-hash-2.1.2
  (crate-source "rustc-hash" "2.1.2"
                "1gjdc5bw9982cj176jvgz9rrqf9xvr1q1ddpzywf5qhs7yzhlc4l"))

(define rust-rustc-version-0.4.0
  (crate-source "rustc_version" "0.4.0"
                "0rpk9rcdk405xhbmgclsh4pai0svn49x35aggl4nhbkd4a2zb85z"))

(define rust-rustc-version-0.4.1
  (crate-source "rustc_version" "0.4.1"
                "14lvdsmr5si5qbqzrajgb6vfn69k0sfygrvfvr2mps26xwi3mjyg"))

(define rust-rustix-0.38.7
  (crate-source "rustix" "0.38.7"
                "1683wxw09rxjv7agbxk6v7bxv6d5zk5scczm0l0al1gbvkmr2a0p"))

(define rust-rustix-1.1.4
  (crate-source "rustix" "1.1.4"
                "14511f9yjqh0ix07xjrjpllah3325774gfwi9zpq72sip5jlbzmn"))

(define rust-rustls-0.23.40
  (crate-source "rustls" "0.23.40"
                "12qnv3ag4wrw7aj8jng74kgrilpjm2b1rfcjaac8h691frccv1pg"))

(define rust-rustls-pki-types-1.14.1
  (crate-source "rustls-pki-types" "1.14.1"
                "1a9pr54y0f3qr97bxpd3ahjldq0gqdld0h799xbnwdzbwxx1k9rh"))

(define rust-rustls-webpki-0.103.13
  (crate-source "rustls-webpki" "0.103.13"
                "0vkm7z9pnxz5qz66p2kmyy2pwx0g4jnsbqk5xzfhs4czcjl2ki31"))

(define rust-rustversion-1.0.22
  (crate-source "rustversion" "1.0.22"
                "0vfl70jhv72scd9rfqgr2n11m5i9l1acnk684m2w83w0zbqdx75k"))

(define rust-ryu-1.0.23
  (crate-source "ryu" "1.0.23"
                "0zs70sg00l2fb9jwrf6cbkdyscjs53anrvai2hf7npyyfi5blx4p"))

(define rust-same-file-1.0.6
  (crate-source "same-file" "1.0.6"
                "00h5j1w87dmhnvbv9l8bic3y7xxsnjmssvifw2ayvgx9mb1ivz4k"))

(define rust-schannel-0.1.29
  (crate-source "schannel" "0.1.29"
                "0ffrzz5vf2s3gnzvphgb5gg8fqifvryl07qcf7q3x1scj3jbghci"))

(define rust-schemars-0.8.22
  (crate-source "schemars" "0.8.22"
                "05an9nbi18ynyxv1rjmwbg6j08j0496hd64mjggh53mwp3hjmgrz"))

(define rust-schemars-0.9.0
  (crate-source "schemars" "0.9.0"
                "0pqncln5hqbzbl2r3yayyr4a82jjf93h2cfxrn0xamvx77wr3lac"))

(define rust-schemars-1.2.1
  (crate-source "schemars" "1.2.1"
                "1k16qzpdpy6p9hrh18q2l6cwawxzyqi25f8masa13l0wm8v2zd52"))

(define rust-schemars-derive-0.8.22
  (crate-source "schemars_derive" "0.8.22"
                "0kakyzrp5801s4i043l4ilv96lzimnlh01pap958h66n99w6bqij"))

(define rust-scopeguard-1.2.0
  (crate-source "scopeguard" "1.2.0"
                "0jcz9sd47zlsgcnm1hdw0664krxwb5gczlif4qngj2aif8vky54l"))

(define rust-security-framework-3.7.0
  (crate-source "security-framework" "3.7.0"
                "07fd0j29j8yczb3hd430vwz784lx9knb5xwbvqna1nbkbivvrx5p"))

(define rust-security-framework-sys-2.17.0
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "security-framework-sys" "2.17.0"
                "1qr0w0y9iwvmv3hwg653q1igngnc5b74xcf0679cbv23z0fnkqkc"))

(define rust-selectors-0.36.1
  (crate-source "selectors" "0.36.1"
                "0370sx9fcb327im4msa0ha5578r95hzwy4bkh443zlwj5b4w1nf5"))

(define rust-semver-1.0.18
  (crate-source "semver" "1.0.18"
                "0659sqgnaqx42nj7n5kh3z35g3jvczsw572jhir4ibys555knadh"))

(define rust-semver-1.0.28
  (crate-source "semver" "1.0.28"
                "1kaimrpy876bcgi8bfj0qqfxk77zm9iz2zhn1hp9hj685z854y4a"))

(define rust-serde-1.0.168
  (crate-source "serde" "1.0.168"
                "1br697rmgkfm1p578midw90s7wwkpr1wicq8s7g6f0vj92azh56n"))

(define rust-serde-1.0.228
  (crate-source "serde" "1.0.228"
                "17mf4hhjxv5m90g42wmlbc61hdhlm6j9hwfkpcnd72rpgzm993ls"))

(define rust-serde-core-1.0.228
  (crate-source "serde_core" "1.0.228"
                "1bb7id2xwx8izq50098s5j2sqrrvk31jbbrjqygyan6ask3qbls1"))

(define rust-serde-derive-1.0.168
  (crate-source "serde_derive" "1.0.168"
                "0hfnd7c6i7vbbcfpzp3if9sr1lg25qajfkysfx0y9266g2b5iznl"))

(define rust-serde-derive-1.0.228
  (crate-source "serde_derive" "1.0.228"
                "0y8xm7fvmr2kjcd029g9fijpndh8csv5m20g4bd76w8qschg4h6m"))

(define rust-serde-derive-internals-0.29.1
  (crate-source "serde_derive_internals" "0.29.1"
                "04g7macx819vbnxhi52cx0nhxi56xlhrybgwybyy7fb9m4h6mlhq"))

(define rust-serde-json-1.0.149
  (crate-source "serde_json" "1.0.149"
                "11jdx4vilzrjjd1dpgy67x5lgzr0laplz30dhv75lnf5ffa07z43"))

(define rust-serde-path-to-error-0.1.20
  (crate-source "serde_path_to_error" "0.1.20"
                "0mxls44p2ycmnxh03zpnlxxygq42w61ws7ir7r0ba6rp5s1gza8h"))

(define rust-serde-regex-1.1.0
  (crate-source "serde_regex" "1.1.0"
                "1pxsnxb8c198szghk1hvzvhva36w2q5zs70hqkmdf5d89qd6y4x8"))

(define rust-serde-repr-0.1.20
  (crate-source "serde_repr" "0.1.20"
                "1755gss3f6lwvv23pk7fhnjdkjw7609rcgjlr8vjg6791blf6php"))

(define rust-serde-spanned-0.6.9
  (crate-source "serde_spanned" "0.6.9"
                "18vmxq6qfrm110caszxrzibjhy2s54n1g5w1bshxq9kjmz7y0hdz"))

(define rust-serde-spanned-1.1.1
  (crate-source "serde_spanned" "1.1.1"
                "09jzk7i6wihn3d8i3wi4j4n98ghi93c3b8m8k64nxq0ijn3vaqk6"))

(define rust-serde-untagged-0.1.9
  (crate-source "serde-untagged" "0.1.9"
                "0n2hdjzas7w949klw1rpfzmpc9sm4sz9sa664jz969id9a5g9ypr"))

(define rust-serde-urlencoded-0.7.1
  (crate-source "serde_urlencoded" "0.7.1"
                "1zgklbdaysj3230xivihs30qi5vkhigg323a9m62k8jwf4a1qjfk"))

(define rust-serde-with-3.20.0
  (crate-source "serde_with" "3.20.0"
                "1qnddis0nz2yg0dl06fnhf2q3hkim0vraq8ac3xzl8xjnwn1qb77"))

(define rust-serde-with-macros-3.20.0
  (crate-source "serde_with_macros" "3.20.0"
                "1b5z2zs1flszvyfk2i5pky6qdigg82y467zlc81gpd7c723lh35r"))

(define rust-serialize-to-javascript-0.1.2
  (crate-source "serialize-to-javascript" "0.1.2"
                "1ignjbylp82s9pyhrmb0f26mjzwvpqr6qc6zgjvwv5x10xm6dwq4"))

(define rust-serialize-to-javascript-impl-0.1.2
  (crate-source "serialize-to-javascript-impl" "0.1.2"
                "0pdpclvrpw377s64q2vdk9ia8n6nywg6w2w6yw56fvciq0ry0bkp"))

(define rust-servo-arc-0.4.3
  (crate-source "servo_arc" "0.4.3"
                "0c2rl0r9x4kbppwlcrd5bnwds612na179im7kb37vqadncxbh3qp"))

(define rust-sha1-0.10.6
  (crate-source "sha1" "0.10.6"
                "1fnnxlfg08xhkmwf2ahv634as30l1i3xhlhkvxflmasi5nd85gz3"))

(define rust-sha1-smol-1.0.1
  (crate-source "sha1_smol" "1.0.1"
                "0pbh2xjfnzgblws3hims0ib5bphv7r5rfdpizyh51vnzvnribymv"))

(define rust-sha2-0.10.9
  (crate-source "sha2" "0.10.9"
                "10xjj843v31ghsksd9sl9y12qfc48157j1xpb8v1ml39jy0psl57"))

(define rust-sha256-1.6.0
  (crate-source "sha256" "1.6.0"
                "1xn86nlyq9mr4a8ybfw3z3275rnh58mb83phjfbp1sxxca2zr07q"))

(define rust-shlex-1.3.0
  (crate-source "shlex" "1.3.0"
                "0r1y6bv26c1scpxvhg2cabimrmwgbp4p3wy6syj9n0c4s3q2znhg"))

(define rust-signal-hook-0.3.18
  (crate-source "signal-hook" "0.3.18"
                "1qnnbq4g2vixfmlv28i1whkr0hikrf1bsc4xjy2aasj2yina30fq"))

(define rust-signal-hook-mio-0.2.5
  (crate-source "signal-hook-mio" "0.2.5"
                "1k20rr76ngvmzr6kskkl7dv8iyb84cbydpjbjk3mpcj0lykijnmp"))

(define rust-signal-hook-registry-1.4.8
  (crate-source "signal-hook-registry" "1.4.8"
                "06vc7pmnki6lmxar3z31gkyg9cw7py5x9g7px70gy2hil75nkny4"))

(define rust-simd-adler32-0.3.9
  (crate-source "simd-adler32" "0.3.9"
                "0532ysdwcvzyp2bwpk8qz0hijplcdwpssr5gy5r7qwqqy5z5qgbh"))

(define rust-simd-cesu8-1.1.1
  (crate-source "simd_cesu8" "1.1.1"
                "0crcbgvyycmazji2vqj9vxn2czdyl3gxmicp4xqdzkc7pdbh3ycl"))

(define rust-simdutf8-0.1.5
  (crate-source "simdutf8" "0.1.5"
                "0vmpf7xaa0dnaikib5jlx6y4dxd3hxqz6l830qb079g7wcsgxag3"))

(define rust-siphasher-1.0.3
  (crate-source "siphasher" "1.0.3"
                "0jg6l9xyzca5vy4h6gf8r6p4kk84g98fk95pzig1kq6cr4z8grcf"))

(define rust-slab-0.4.12
  (crate-source "slab" "0.4.12"
                "1xcwik6s6zbd3lf51kkrcicdq2j4c1fw0yjdai2apy9467i0sy8c"))

(define rust-slab-0.4.7
  (crate-source "slab" "0.4.7"
                "1vyw3rkdfdfkzfa1mh83s237sll8v5kazfwxma60bq4b59msf526"))

(define rust-smallvec-1.13.2
  (crate-source "smallvec" "1.13.2"
                "0rsw5samawl3wsw6glrsb127rx6sh89a8wyikicw6dkdcjd1lpiw"))

(define rust-smallvec-1.15.1
  (crate-source "smallvec" "1.15.1"
                "00xxdxxpgyq5vjnpljvkmy99xij5rxgh913ii1v16kzynnivgcb7"))

(define rust-socket2-0.6.3
  (crate-source "socket2" "0.6.3"
                "0gkjjcyn69hqhhlh5kl8byk5m0d7hyrp2aqwzbs3d33q208nwxis"))

(define rust-softbuffer-0.4.8
  (crate-source "softbuffer" "0.4.8"
                "1hznrcdzhhlr2x84926g28ybnlx649y1anr7mc4m3w5v3sl8vhda"))

(define rust-soup3-0.5.0
  (crate-source "soup3" "0.5.0"
                "17sgrkvx5jy6r6pyyhh8cl5mrm96rf0yfl3lqypm24pk815947s7"))

(define rust-soup3-sys-0.5.0
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "soup3-sys" "0.5.0"
                "09vcp2m0hcddjqsv979d4jnribxp1pvipgjyy4j2z8c0lr88kgky"))

(define rust-specta-2.0.0-rc.20
  (crate-source "specta" "2.0.0-rc.20"
                "1g6943b99cz5xsj3c949va848v6n76qbgv0mpivw2baxaq9b5jsc"))

(define rust-specta-macros-2.0.0-rc.17
  (crate-source "specta-macros" "2.0.0-rc.17"
                "0wlg1f0vqfk5irz1lrhik09i4rd70bn0mxh1aagfnrb9h4lrv6b8"))

(define rust-spin-0.9.8
  (crate-source "spin" "0.9.8"
                "0rvam5r0p3a6qhc18scqpvpgb3ckzyqxpgdfyjnghh8ja7byi039"))

(define rust-stable-deref-trait-1.2.0
  (crate-source "stable_deref_trait" "1.2.0"
                "1lxjr8q2n534b2lhkxd6l6wcddzjvnksi58zv11f9y0jjmr15wd8"))

(define rust-stable-deref-trait-1.2.1
  (crate-source "stable_deref_trait" "1.2.1"
                "15h5h73ppqyhdhx6ywxfj88azmrpml9gl6zp3pwy2malqa6vxqkc"))

(define rust-string-cache-0.9.0
  (crate-source "string_cache" "0.9.0"
                "008rwf8gd1xhwr523r5zzzgypgkfmrz6l3wwh7r2k9w5qzw9d1d1"))

(define rust-string-cache-codegen-0.6.1
  (crate-source "string_cache_codegen" "0.6.1"
                "0scvya8dsfard2r8m7pb2cjnar312jc9g165fsghacdjdpj3amjq"))

(define rust-strsim-0.10.0
  (crate-source "strsim" "0.10.0"
                "08s69r4rcrahwnickvi0kq49z524ci50capybln83mg6b473qivk"))

(define rust-strsim-0.11.1
  (crate-source "strsim" "0.11.1"
                "0kzvqlw8hxqb7y598w1s0hxlnmi84sg5vsipp3yg5na5d1rvba3x"))

(define rust-subtle-2.6.1
  (crate-source "subtle" "2.6.1"
                "14ijxaymghbl1p0wql9cib5zlwiina7kall6w7g89csprkgbvhhk"))

(define rust-swift-rs-1.0.7
  (crate-source "swift-rs" "1.0.7"
                "1my4s3w5a5nvlpnzjnfi38snn7spgfn2m0yarzym2bc55s7cjms0"))

(define rust-syn-1.0.109
  (crate-source "syn" "1.0.109"
                "0ds2if4600bd59wsv7jjgfkayfzy3hnazs394kz6zdkmna8l3dkj"))

(define rust-syn-1.0.98
  (crate-source "syn" "1.0.98"
                "1pbklw6fnwwgrkj8qz3wcjfggmn7vmyln44gg0yc5r2dj25fy2n5"))

(define rust-syn-2.0.117
  (crate-source "syn" "2.0.117"
                "16cv7c0wbn8amxc54n4w15kxlx5ypdmla8s0gxr2l7bv7s0bhrg6"))

(define rust-syn-2.0.32
  (crate-source "syn" "2.0.32"
                "1qn9q2ah4ryxxalwjw8md95j4g6rrm93k2fawkzs9wfn9wl19613"))

(define rust-sync-wrapper-1.0.2
  (crate-source "sync_wrapper" "1.0.2"
                "0qvjyasd6w18mjg5xlaq5jgy84jsjfsvmnn12c13gypxbv75dwhb"))

(define rust-synstructure-0.13.2
  (crate-source "synstructure" "0.13.2"
                "1lh9lx3r3jb18f8sbj29am5hm9jymvbwh6jb1izsnnxgvgrp12kj"))

(define rust-sysinfo-0.36.1
  (crate-source "sysinfo" "0.36.1"
                "0z9141y32amzlg87ky0swsi4myhwngcdpfmjnzzvkrv0a1s00a15"))

(define rust-syslog-6.1.1
  (crate-source "syslog" "6.1.1"
                "1lvs8ld2ps38yll29fryqwr45axm55vf46b5zvx24lbrbddykiyz"))

(define rust-system-configuration-0.7.0
  (crate-source "system-configuration" "0.7.0"
                "12rwilylzc625qnxl30h5kf8wj5ka61zjrwpmb034cd0mc6ksgx1"))

(define rust-system-configuration-sys-0.6.0
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "system-configuration-sys" "0.6.0"
                "1i5sqrmgy58l4704hibjbl36hclddglh73fb3wx95jnmrq81n7cf"))

(define rust-system-deps-6.2.2
  (crate-source "system-deps" "6.2.2"
                "0j93ryw031n3h8b0nfpj5xwh3ify636xmv8kxianvlyyipmkbrd3"))

(define rust-tao-0.35.2
  (crate-source "tao" "0.35.2"
                "1r2w6ivjfn5fqrzxqb00q7sh9j9nj87l8p74y7y6bpka92g7ygx3"))

(define rust-tao-macros-0.1.3
  (crate-source "tao-macros" "0.1.3"
                "1zbx0ifpn6xi4sc6vp7wq0sbpgrdwr0cm2xbisr7vh9aigmnpqgl"))

(define rust-tar-0.4.45
  (crate-source "tar" "0.4.45"
                "0wq90hif25348zrvmk88q01g8aj8v8pla7f1vxgsf7x2frj2ls92"))

(define rust-target-lexicon-0.12.16
  (crate-source "target-lexicon" "0.12.16"
                "1cg3bnx1gdkdr5hac1hzxy64fhw4g7dqkd0n3dxy5lfngpr1mi31"))

(define rust-tauri-2.11.2
  (crate-source "tauri" "2.11.2"
                "0a6cyhar0cry58xbi9yn9qkiz5xv25zglyhpy62msdyggach8x23"))

(define rust-tauri-build-2.6.2
  (crate-source "tauri-build" "2.6.2"
                "1isinikimq4gfmp0i1q4xx5d0vnipr9504jf9sjijff2bw2zk8aa"))

(define rust-tauri-codegen-2.6.2
  (crate-source "tauri-codegen" "2.6.2"
                "1schiyrirpiycjd6bc6x40vfdx26qkidmrvq826a69d052ak3874"))

(define rust-tauri-macros-2.6.2
  (crate-source "tauri-macros" "2.6.2"
                "0929xvdib0ci1ybhxvanp8xib85f5wfjacavvbvd48bci7iv8v5f"))

(define rust-tauri-runtime-2.11.2
  (crate-source "tauri-runtime" "2.11.2"
                "1vr9y76n2y8bsykfrrk19q42bqgs4gh75wz2dym7x0682rqjs8j8"))

(define rust-tauri-runtime-wry-2.11.2
  (crate-source "tauri-runtime-wry" "2.11.2"
                "1nbcbx0hz7qpn5nzjhya9a8pcl11r8aikr8gin77mcpccgp4jf5q"))

(define rust-tauri-utils-2.9.2
  (crate-source "tauri-utils" "2.9.2"
                "15dap6xnglb06c93qjid3vq8glq14jyb2mkcisbk2xkhkbgpj8q9"))

(define rust-tauri-winres-0.3.6
  (crate-source "tauri-winres" "0.3.6"
                "1dnld4gpnb2k9p7id2ksl3wfrnqmbm5q77nj1m1gx2w5d1fd8rfc"))

(define rust-tempfile-3.27.0
  (crate-source "tempfile" "3.27.0"
                "1gblhnyfjsbg9wjg194n89wrzah7jy3yzgnyzhp56f3v9jd7wj9j"))

(define rust-tendril-0.5.0
  (crate-source "tendril" "0.5.0"
                "090dcvslanahwjnm4ihggjiv7fc82gir9c24nps319fmd71hyyf4"))

(define rust-termcolor-1.1.3
  (crate-source "termcolor" "1.1.3"
                "0mbpflskhnz3jf312k50vn0hqbql8ga2rk0k79pkgchip4q4vcms"))

(define rust-thiserror-1.0.41
  (crate-source "thiserror" "1.0.41"
                "00kqnfrj466w3mpk7h4537lzr5q9gbqaghgrwkd3zvw7jfx68sn1"))

(define rust-thiserror-1.0.69
  (crate-source "thiserror" "1.0.69"
                "0lizjay08agcr5hs9yfzzj6axs53a2rgx070a1dsi3jpkcrzbamn"))

(define rust-thiserror-2.0.18
  (crate-source "thiserror" "2.0.18"
                "1i7vcmw9900bvsmay7mww04ahahab7wmr8s925xc083rpjybb222"))

(define rust-thiserror-impl-1.0.41
  (crate-source "thiserror-impl" "1.0.41"
                "0nbc6jjhg2jfm767qp4rwy2a56gkvsd0cjg5y2jddi019csjhjfi"))

(define rust-thiserror-impl-1.0.69
  (crate-source "thiserror-impl" "1.0.69"
                "1h84fmn2nai41cxbhk6pqf46bxqq1b344v8yz089w1chzi76rvjg"))

(define rust-thiserror-impl-2.0.18
  (crate-source "thiserror-impl" "2.0.18"
                "1mf1vrbbimj1g6dvhdgzjmn6q09yflz2b92zs1j9n3k7cxzyxi7b"))

(define rust-thread-local-1.1.9
  (crate-source "thread_local" "1.1.9"
                "1191jvl8d63agnq06pcnarivf63qzgpws5xa33hgc92gjjj4c0pn"))

(define rust-time-0.3.11
  (crate-source "time" "0.3.11"
                "05rjpgfsq6gvizn89ydwwmy0ihgfvikxcwq8bz09dw5jvi0izjbj"))

(define rust-time-0.3.47
  (crate-source "time" "0.3.47"
                "0b7g9ly2iabrlgizliz6v5x23yq5d6bpp0mqz6407z1s526d8fvl"))

(define rust-time-core-0.1.8
  (crate-source "time-core" "0.1.8"
                "1jidl426mw48i7hjj4hs9vxgd9lwqq4vyalm4q8d7y4iwz7y353n"))

(define rust-time-macros-0.2.27
  (crate-source "time-macros" "0.2.27"
                "058ja265waq275wxvnfwavbz9r1hd4dgwpfn7a1a9a70l32y8w1f"))

(define rust-tiny-http-0.12.0
  (crate-source "tiny_http" "0.12.0"
                "10nw9kk2i2aq4l4csy0825qkq0l66f9mz2c1n57yg8hkckgib69q"))

(define rust-tinystr-0.8.3
  (crate-source "tinystr" "0.8.3"
                "0vfr8x285w6zsqhna0a9jyhylwiafb2kc8pj2qaqaahw48236cn8"))

(define rust-tinyvec-1.11.0
  (crate-source "tinyvec" "1.11.0"
                "1wvycrghzmaysnw34kzwnf0mfx6r75045s24r214wnnjadqfcq9y"))

(define rust-tinyvec-macros-0.1.1
  (crate-source "tinyvec_macros" "0.1.1"
                "081gag86208sc3y6sdkshgw3vysm5d34p431dzw0bshz66ncng0z"))

(define rust-tokio-1.52.3
  (crate-source "tokio" "1.52.3"
                "1zpzazypkg61sw91na1m85x5s4rsjym335fwwhwm1hcs70dz1iwg"))

(define rust-tokio-macros-2.7.0
  (crate-source "tokio-macros" "2.7.0"
                "15m4f37mdafs0gg36sh0rskm1i768lb7zmp8bw67kaxr3avnqniq"))

(define rust-tokio-native-tls-0.3.1
  (crate-source "tokio-native-tls" "0.3.1"
                "1wkfg6zn85zckmv4im7mv20ca6b1vmlib5xwz9p7g19wjfmpdbmv"))

(define rust-tokio-rustls-0.26.4
  (crate-source "tokio-rustls" "0.26.4"
                "0qggwknz9w4bbsv1z158hlnpkm97j3w8v31586jipn99byaala8p"))

(define rust-tokio-tungstenite-0.29.0
  (crate-source "tokio-tungstenite" "0.29.0"
                "0p4i0a9fwhn92y4ybc0z75pc8hn2hjjgnlymminqb1c5h9ga0wlg"))

(define rust-tokio-util-0.7.18
  (crate-source "tokio-util" "0.7.18"
                "1600rd47pylwn7cap1k7s5nvdaa9j7w8kqigzp1qy7mh0p4cxscs"))

(define rust-toml-0.8.2
  (crate-source "toml" "0.8.2"
                "0g9ysjaqvm2mv8q85xpqfn7hi710hj24sd56k49wyddvvyq8lp8q"))

(define rust-toml-0.9.12+spec-1.1.0
  (crate-source "toml" "0.9.12+spec-1.1.0"
                "0qwqbrymqn88mg2yqyq3rj52z6p20448z0jxdbpjsbpwg5g894ng"))

(define rust-toml-1.1.2+spec-1.1.0
  (crate-source "toml" "1.1.2+spec-1.1.0"
                "1vpggpamqhw4852kic7465zsidczsla06wz6friqkkfbhigd3ww1"))

(define rust-toml-datetime-0.6.3
  (crate-source "toml_datetime" "0.6.3"
                "0jsy7v8bdvmzsci6imj8fzgd255fmy5fzp6zsri14yrry7i77nkw"))

(define rust-toml-datetime-0.7.5+spec-1.1.0
  (crate-source "toml_datetime" "0.7.5+spec-1.1.0"
                "0iqkgvgsxmszpai53dbip7sf2igic39s4dby29dbqf1h9bnwzqcj"))

(define rust-toml-datetime-1.1.1+spec-1.1.0
  (crate-source "toml_datetime" "1.1.1+spec-1.1.0"
                "1mws2mkkf46l7inn77azhm0vdwxngv9vsbhbl0ah33p2c9gzcr9i"))

(define rust-toml-edit-0.19.15
  (crate-source "toml_edit" "0.19.15"
                "08bl7rp5g6jwmfpad9s8jpw8wjrciadpnbaswgywpr9hv9qbfnqv"))

(define rust-toml-edit-0.20.2
  (crate-source "toml_edit" "0.20.2"
                "0f7k5svmxw98fhi28jpcyv7ldr2s3c867pjbji65bdxjpd44svir"))

(define rust-toml-edit-0.25.11+spec-1.1.0
  (crate-source "toml_edit" "0.25.11+spec-1.1.0"
                "0awzffbkx33v9x4h19b5mfrwp3sn4ifr16y58sbk6j6l5v9c8n8b"))

(define rust-toml-parser-1.1.2+spec-1.1.0
  (crate-source "toml_parser" "1.1.2+spec-1.1.0"
                "09kmzc55a0j21whm290wlf5a8b18a0qc87a1s8sncrckc6wfkax2"))

(define rust-toml-writer-1.1.1+spec-1.1.0
  (crate-source "toml_writer" "1.1.1+spec-1.1.0"
                "1nwjhvvrxz8f4ck1qi4xcz2x9qhpci37nrknhxxf9sqk22dsyvbm"))

(define rust-tower-0.5.3
  (crate-source "tower" "0.5.3"
                "1m5i3a2z1sgs8nnz1hgfq2nr4clpdmizlp1d9qsg358ma5iyzrgb"))

(define rust-tower-http-0.6.10
  (crate-source "tower-http" "0.6.10"
                "0lfbddgrhmxhnb3afazawsl4cxqfcs8wvq5hm34ija0wz3czvmk8"))

(define rust-tower-layer-0.3.3
  (crate-source "tower-layer" "0.3.3"
                "03kq92fdzxin51w8iqix06dcfgydyvx7yr6izjq0p626v9n2l70j"))

(define rust-tower-service-0.3.3
  (crate-source "tower-service" "0.3.3"
                "1hzfkvkci33ra94xjx64vv3pp0sq346w06fpkcdwjcid7zhvdycd"))

(define rust-tracing-0.1.44
  (crate-source "tracing" "0.1.44"
                "006ilqkg1lmfdh3xhg3z762izfwmxcvz0w7m4qx2qajbz9i1drv3"))

(define rust-tracing-core-0.1.36
  (crate-source "tracing-core" "0.1.36"
                "16mpbz6p8vd6j7sf925k9k8wzvm9vdfsjbynbmaxxyq6v7wwm5yv"))

(define rust-tray-icon-0.23.1
  (crate-source "tray-icon" "0.23.1"
                "0wq7dhhqajm5hwhdlc5sbkgi8wz1700430zjipp8agjqh06vpv8m"))

(define rust-try-lock-0.2.5
  (crate-source "try-lock" "0.2.5"
                "0jqijrrvm1pyq34zn1jmy2vihd4jcrjlvsh4alkjahhssjnsn8g4"))

(define rust-tungstenite-0.29.0
  (crate-source "tungstenite" "0.29.0"
                "1f7673dhqbfxc0f2ccyiyqhv882nkialnzm5qb3vkbwky8m1a0bc"))

(define rust-typeid-1.0.3
  (crate-source "typeid" "1.0.3"
                "0727ypay2p6mlw72gz3yxkqayzdmjckw46sxqpaj08v0b0r64zdw"))

(define rust-typenum-1.20.0
  (crate-source "typenum" "1.20.0"
                "1pj35y6q11d3y55gdl6g1h2dfhmybjming0jdi9bh0bpnqm11kj0"))

(define rust-unic-char-property-0.9.0
  (crate-source "unic-char-property" "0.9.0"
                "08g21dn3wwix3ycfl0vrbahn0835nv2q3swm8wms0vwvgm07mid8"))

(define rust-unic-char-range-0.9.0
  (crate-source "unic-char-range" "0.9.0"
                "1g0z7iwvjhqspi6194zsff8vy6i3921hpqcrp3v1813hbwnh5603"))

(define rust-unic-common-0.9.0
  (crate-source "unic-common" "0.9.0"
                "1g1mm954m0zr497dl4kx3vr09yaly290zs33bbl4wrbaba1gzmw0"))

(define rust-unic-ucd-ident-0.9.0
  (crate-source "unic-ucd-ident" "0.9.0"
                "11v9mfyl9rqnvd9a8hgmbgnzyxd3lcx0dkv7klhskjl10dya6c72"))

(define rust-unic-ucd-version-0.9.0
  (crate-source "unic-ucd-version" "0.9.0"
                "1i5hnzpfnxkp4ijfk8kvhpvj84bij575ybqx1b6hyigy6wi2zgcn"))

(define rust-unicode-ident-1.0.2
  (crate-source "unicode-ident" "1.0.2"
                "19zf5lzhzix2s35lp5lckdy90sw0kfi5a0ii49d24dcj7yk1pihm"))

(define rust-unicode-ident-1.0.24
  (crate-source "unicode-ident" "1.0.24"
                "0xfs8y1g7syl2iykji8zk5hgfi5jw819f5zsrbaxmlzwsly33r76"))

(define rust-unicode-segmentation-1.13.2
  (crate-source "unicode-segmentation" "1.13.2"
                "135a26m4a0wj319gcw28j6a5aqvz00jmgwgmcs6szgxjf942facn"))

(define rust-unicode-width-0.2.2
  (crate-source "unicode-width" "0.2.2"
                "0m7jjzlcccw716dy9423xxh0clys8pfpllc5smvfxrzdf66h9b5l"))

(define rust-unicode-xid-0.2.6
  (crate-source "unicode-xid" "0.2.6"
                "0lzqaky89fq0bcrh6jj6bhlz37scfd8c7dsj5dq7y32if56c1hgb"))

(define rust-universal-hash-0.5.1
  (crate-source "universal-hash" "0.5.1"
                "1sh79x677zkncasa95wz05b36134822w6qxmi1ck05fwi33f47gw"))

(define rust-untrusted-0.9.0
  (crate-source "untrusted" "0.9.0"
                "1ha7ib98vkc538x0z60gfn0fc5whqdd85mb87dvisdcaifi6vjwf"))

(define rust-url-2.5.8
  (crate-source "url" "2.5.8"
                "1v8f7nx3hpr1qh76if0a04sj08k86amsq4h8cvpw6wvk76jahrzz"))

(define rust-urlencoding-2.1.3
  (crate-source "urlencoding" "2.1.3"
                "1nj99jp37k47n0hvaz5fvz7z6jd0sb4ppvfy3nphr1zbnyixpy6s"))

(define rust-urlpattern-0.3.0
  (crate-source "urlpattern" "0.3.0"
                "0vds6wyawgap069q34wl0yf8w5qdmpi6r2ffxv10nid1787d7b3h"))

(define rust-utf-8-0.7.6
  (crate-source "utf-8" "0.7.6"
                "1a9ns3fvgird0snjkd3wbdhwd3zdpc2h5gpyybrfr6ra5pkqxk09"))

(define rust-utf8-iter-1.0.4
  (crate-source "utf8_iter" "1.0.4"
                "1gmna9flnj8dbyd8ba17zigrp9c4c3zclngf5lnb5yvz1ri41hdn"))

(define rust-utf8-width-0.1.8
  (crate-source "utf8-width" "0.1.8"
                "14d08vrz878wqpmqw46yl5l1vwmdf00zx4i49z8iahdmf3cw14hj"))

(define rust-utf8parse-0.2.1
  (crate-source "utf8parse" "0.2.1"
                "02ip1a0az0qmc2786vxk2nqwsgcwf17d3a38fkf0q7hrmwh9c6vi"))

(define rust-utf8parse-0.2.2
  (crate-source "utf8parse" "0.2.2"
                "088807qwjq46azicqwbhlmzwrbkz7l4hpw43sdkdyyk524vdxaq6"))

(define rust-uuid-1.11.0
  (crate-source "uuid" "1.11.0"
                "0sj4l28lif2wm4xrafdfgqjywjzv43wzp8nii9a4i539myhg1igq"))

(define rust-uuid-1.23.1
  (crate-source "uuid" "1.23.1"
                "0xlwg23rmsfl3gx98qsyzpl24pf4bs9wi3mqx5c6i319hyb4mmyx"))

(define rust-uuid-macro-internal-1.11.0
  (crate-source "uuid-macro-internal" "1.11.0"
                "024s8hxxjwgc218kfx9xs274dhnkv1ik9818kv7d0f1sw5zzb4bb"))

(define rust-uzers-0.12.2
  (crate-source "uzers" "0.12.2"
                "13g1igzqpn5jvsbcp45rs2pw9fsxa1f8pp6j250mpqpy3bxpb0hb"))

(define rust-vcpkg-0.2.15
  (crate-source "vcpkg" "0.2.15"
                "09i4nf5y8lig6xgj3f7fyrvzd3nlaw4znrihw8psidvv5yk4xkdc"))

(define rust-version-check-0.9.4
  (crate-source "version_check" "0.9.4"
                "0gs8grwdlgh0xq660d7wr80x14vxbizmd8dbp29p2pdncx8lp1s9"))

(define rust-version-check-0.9.5
  (crate-source "version_check" "0.9.5"
                "0nhhi4i5x89gm911azqbn7avs9mdacw2i3vcz3cnmz3mv4rqz4hb"))

(define rust-version-compare-0.2.1
  (crate-source "version-compare" "0.2.1"
                "03nziqxwnxlizl42cwsx33vi5xd2cf2jnszhh9rzay7g6xl8bhh3"))

(define rust-vhost-0.13.0
  (crate-source "vhost" "0.13.0"
                "0gv2anqr1rgydqlici5cmnk0pib1ll4fk4f5397vcv3pv3aamq5w"))

(define rust-vhost-user-backend-0.17.0
  (crate-source "vhost-user-backend" "0.17.0"
                "0hp93lbhws4r8s1lnq50ws9adllf8q69gh6ysamhbl1pci3kv86s"))

(define rust-virtio-bindings-0.2.4
  (crate-source "virtio-bindings" "0.2.4"
                "0s0angigj4j81xyxr380jpqjx89p3qm1as2ks45lbjzq00ffc48p"))

(define rust-virtio-queue-0.14.0
  (crate-source "virtio-queue" "0.14.0"
                "13cs1vd6l93lnq3xv15labz5wb2w7p70qwl92vqfd9vhplzjybl7"))

(define rust-vm-memory-0.16.0
  (crate-source "vm-memory" "0.16.0"
                "08ainy3x7j15r768dxzqlf8mwach7227hz7b66hrhs8b8a3rz4g2"))

(define rust-vmm-sys-util-0.12.1
  (crate-source "vmm-sys-util" "0.12.1"
                "1pjfjdhnab1x14fakxssn2sgf5mrw4paf1ymz2j0vqj6jw1ka50x"))

(define rust-vswhom-0.1.0
  (crate-source "vswhom" "0.1.0"
                "12v0fjjzxdc3y5c0lcwycfhphz7zf2s06hl5krwhawah0xzrp5xy"))

(define rust-vswhom-sys-0.1.3
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "vswhom-sys" "0.1.3"
                "0l0i4fijapsybmfckfqh53yqxsg0bm5ikja6vz8ngw0zpm67w1pv"))

(define rust-walkdir-2.5.0
  (crate-source "walkdir" "2.5.0"
                "0jsy7a710qv8gld5957ybrnc07gavppp963gs32xk4ag8130jy99"))

(define rust-want-0.3.1
  (crate-source "want" "0.3.1"
                "03hbfrnvqqdchb5kgxyavb9jabwza0dmh2vw5kg0dq8rxl57d9xz"))

(define rust-wasi-0.11.0+wasi-snapshot-preview1
  (crate-source "wasi" "0.11.0+wasi-snapshot-preview1"
                "08z4hxwkpdpalxjps1ai9y7ihin26y9f476i53dv98v45gkqg3cw"))

(define rust-wasi-0.11.1+wasi-snapshot-preview1
  (crate-source "wasi" "0.11.1+wasi-snapshot-preview1"
                "0jx49r7nbkbhyfrfyhz0bm4817yrnxgd3jiwwwfv0zl439jyrwyc"))

(define rust-wasip2-1.0.3+wasi-0.2.9
  (crate-source "wasip2" "1.0.3+wasi-0.2.9"
                "1mi3w855dz99xzjqc4aa8c9q5b6z1y5c963pkk4cvmr6vdr4c1i0"))

(define rust-wasip3-0.4.0+wasi-0.3.0-rc-2026-01-06
  (crate-source "wasip3" "0.4.0+wasi-0.3.0-rc-2026-01-06"
                "19dc8p0y2mfrvgk3qw3c3240nfbylv22mvyxz84dqpgai2zzha2l"))

(define rust-wasite-0.1.0
  (crate-source "wasite" "0.1.0"
                "0nw5h9nmcl4fyf4j5d4mfdjfgvwi1cakpi349wc4zrr59wxxinmq"))

(define rust-wasm-bindgen-0.2.121
  (crate-source "wasm-bindgen" "0.2.121"
                "14375vc40l67lk9rxp59my4r6s64h2an3vjfh9j0hnqngk8f3b29"))

(define rust-wasm-bindgen-futures-0.4.71
  (crate-source "wasm-bindgen-futures" "0.4.71"
                "1f3k8r13nqshrlxwq0naxpbh250b4l6p526wlw2m78pv7w6jsjcn"))

(define rust-wasm-bindgen-macro-0.2.121
  (crate-source "wasm-bindgen-macro" "0.2.121"
                "0y45ghbkvs5rmxvdyhqrx8nzyy45rdx6619c01iaarykmzsfcs4f"))

(define rust-wasm-bindgen-macro-support-0.2.121
  (crate-source "wasm-bindgen-macro-support" "0.2.121"
                "1wjr69qa8rwmk4v7243dr100k393qi0avznk6p5sgck4bk1rwnnr"))

(define rust-wasm-bindgen-shared-0.2.121
  (crate-source "wasm-bindgen-shared" "0.2.121"
                "0h9la4176j5bvgbr64cqkmirif8z59vrcax9i4qx1w79045i1q64"))

(define rust-wasm-encoder-0.244.0
  (crate-source "wasm-encoder" "0.244.0"
                "06c35kv4h42vk3k51xjz1x6hn3mqwfswycmr6ziky033zvr6a04r"))

(define rust-wasm-metadata-0.244.0
  (crate-source "wasm-metadata" "0.244.0"
                "02f9dhlnryd2l7zf03whlxai5sv26x4spfibjdvc3g9gd8z3a3mv"))

(define rust-wasm-streams-0.4.2
  (crate-source "wasm-streams" "0.4.2"
                "0rddn007hp6k2cm91mm9y33n79b0jxv0c3znzszcvv67hn6ks18m"))

(define rust-wasm-streams-0.5.0
  (crate-source "wasm-streams" "0.5.0"
                "1fqbcx33w8ys5i5dv3p28a82g4yiclmhn80fcfp137kwa7vc87lx"))

(define rust-wasmparser-0.244.0
  (crate-source "wasmparser" "0.244.0"
                "1zi821hrlsxfhn39nqpmgzc0wk7ax3dv6vrs5cw6kb0v5v3hgf27"))

(define rust-web-atoms-0.2.4
  (crate-source "web_atoms" "0.2.4"
                "0f65zxzg1g8xra01kg7im614s11nyhpkl3i5zls1ipqmz3pgdkyp"))

(define rust-web-sys-0.3.98
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "web-sys" "0.3.98"
                "1aijiwx7wsfzj37p1gnqn6wv4j2ppf4rqwhrzb8blf6gigzjsmsb"))

(define rust-webbrowser-1.2.1
  (crate-source "webbrowser" "1.2.1"
                "0wlz31z5zgwvjgg95w0wyzmp7ny5dx20ggm7ys7ydwbaj605bj8g"))

(define rust-webkit2gtk-2.0.2
  (crate-source "webkit2gtk" "2.0.2"
                "14s7zkrdcqayjz443ia5ba0y86j6i3ghhr40mwpgnc1m058720m1"))

(define rust-webkit2gtk-sys-2.0.2
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "webkit2gtk-sys" "2.0.2"
                "19affdnf0x698fcjxfzxb59mdm635q59d5gnzw9gw3ggq9jmysli"))

(define rust-webview2-com-0.38.2
  (crate-source "webview2-com" "0.38.2"
                "0sn9bdm9mvfq3j3bbmssigh3s4wyd8p88m2f8i5cacsvg8x28c3i"))

(define rust-webview2-com-macros-0.8.1
  (crate-source "webview2-com-macros" "0.8.1"
                "0m4vkg7pgcwv3743ka9hgp3ywszrwv6x8g425dxkck4inv0j3ab7"))

(define rust-webview2-com-sys-0.38.2
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "webview2-com-sys" "0.38.2"
                "175zmj5w86z6k6f6gbavz8pil9d58xa280hp55ykfwnpzz7kc4rq"))

(define rust-which-8.0.2
  (crate-source "which" "8.0.2"
                "0nf4c067qvw5zzk0lr9iadzfnaprr9kkrj0cgmxf8smgmapmz6c1"))

(define rust-whoami-1.6.1
  (crate-source "whoami" "1.6.1"
                "0zg9sz669vhqyxysn4lymnianj29jxs2vl6k2lqcl0kp0yslsjjx"))

(define rust-winapi-0.3.9
  (crate-source "winapi" "0.3.9"
                "06gl025x418lchw1wxj64ycr7gha83m44cjr5sarhynd9xkrm0sw"))

(define rust-winapi-i686-pc-windows-gnu-0.4.0
  (crate-source "winapi-i686-pc-windows-gnu" "0.4.0"
                "1dmpa6mvcvzz16zg6d5vrfy4bxgg541wxrcip7cnshi06v38ffxc"
		#:snippet '(delete-file-recursively "lib")))

(define rust-winapi-util-0.1.11
  (crate-source "winapi-util" "0.1.11"
                "08hdl7mkll7pz8whg869h58c1r9y7in0w0pk8fm24qc77k0b39y2"))

(define rust-winapi-util-0.1.5
  (crate-source "winapi-util" "0.1.5"
                "0y71bp7f6d536czj40dhqk0d55wfbbwqfp2ymqf1an5ibgl6rv3h"))

(define rust-winapi-x86-64-pc-windows-gnu-0.4.0
  (crate-source "winapi-x86_64-pc-windows-gnu" "0.4.0"
                "0gqq64czqb64kskjryj8isp62m2sgvx25yyj3kpc2myh85w24bki"
		#:snippet '(delete-file-recursively "lib")))

(define rust-window-vibrancy-0.6.0
  (crate-source "window-vibrancy" "0.6.0"
                "174srq6qy9a4qiwcq1kk5r1wmab1vp4ykl4g4pr654rz3yiwbgnr"))

(define rust-windows-0.61.3
  (crate-source "windows" "0.61.3"
                "14v8dln7i4ccskd8danzri22bkjkbmgzh284j3vaxhd4cykx7awv"))

(define rust-windows-aarch64-gnullvm-0.42.2
  (crate-source "windows_aarch64_gnullvm" "0.42.2"
                "1y4q0qmvl0lvp7syxvfykafvmwal5hrjb4fmv04bqs0bawc52yjr"))

(define rust-windows-aarch64-gnullvm-0.48.0
  (crate-source "windows_aarch64_gnullvm" "0.48.0"
                "1g71yxi61c410pwzq05ld7si4p9hyx6lf5fkw21sinvr3cp5gbli"
		#:snippet '(delete-file-recursively "lib")))

(define rust-windows-aarch64-gnullvm-0.52.6
  (crate-source "windows_aarch64_gnullvm" "0.52.6"
                "1lrcq38cr2arvmz19v32qaggvj8bh1640mdm9c2fr877h0hn591j"))

(define rust-windows-aarch64-gnullvm-0.53.1
  (crate-source "windows_aarch64_gnullvm" "0.53.1"
                "0lqvdm510mka9w26vmga7hbkmrw9glzc90l4gya5qbxlm1pl3n59"))

(define rust-windows-aarch64-msvc-0.42.2
  (crate-source "windows_aarch64_msvc" "0.42.2"
                "0hsdikjl5sa1fva5qskpwlxzpc5q9l909fpl1w6yy1hglrj8i3p0"))

(define rust-windows-aarch64-msvc-0.48.0
  (crate-source "windows_aarch64_msvc" "0.48.0"
                "1wvwipchhywcjaw73h998vzachf668fpqccbhrxzrz5xszh2gvxj"
		#:snippet '(delete-file-recursively "lib")))

(define rust-windows-aarch64-msvc-0.52.6
  (crate-source "windows_aarch64_msvc" "0.52.6"
                "0sfl0nysnz32yyfh773hpi49b1q700ah6y7sacmjbqjjn5xjmv09"))

(define rust-windows-aarch64-msvc-0.53.1
  (crate-source "windows_aarch64_msvc" "0.53.1"
                "01jh2adlwx043rji888b22whx4bm8alrk3khjpik5xn20kl85mxr"))

(define rust-windows-collections-0.2.0
  (crate-source "windows-collections" "0.2.0"
                "1s65anr609qvsjga7w971p6iq964h87670dkfqfypnfgwnswxviv"))

(define rust-windows-core-0.61.2
  (crate-source "windows-core" "0.61.2"
                "1qsa3iw14wk4ngfl7ipcvdf9xyq456ms7cx2i9iwf406p7fx7zf0"))

(define rust-windows-core-0.62.2
  (crate-source "windows-core" "0.62.2"
                "1swxpv1a8qvn3bkxv8cn663238h2jccq35ff3nsj61jdsca3ms5q"))

(define rust-windows-future-0.2.1
  (crate-source "windows-future" "0.2.1"
                "13mdzcdn51ckpzp3frb8glnmkyjr1c30ym9wnzj9zc97hkll2spw"))

(define rust-windows-i686-gnu-0.42.2
  (crate-source "windows_i686_gnu" "0.42.2"
                "0kx866dfrby88lqs9v1vgmrkk1z6af9lhaghh5maj7d4imyr47f6"))

(define rust-windows-i686-gnu-0.48.0
  (crate-source "windows_i686_gnu" "0.48.0"
                "0hd2v9kp8fss0rzl83wzhw0s5z8q1b4875m6s1phv0yvlxi1jak2"
		#:snippet '(delete-file-recursively "lib")))

(define rust-windows-i686-gnu-0.52.6
  (crate-source "windows_i686_gnu" "0.52.6"
                "02zspglbykh1jh9pi7gn8g1f97jh1rrccni9ivmrfbl0mgamm6wf"))

(define rust-windows-i686-gnu-0.53.1
  (crate-source "windows_i686_gnu" "0.53.1"
                "18wkcm82ldyg4figcsidzwbg1pqd49jpm98crfz0j7nqd6h6s3ln"))

(define rust-windows-i686-gnullvm-0.52.6
  (crate-source "windows_i686_gnullvm" "0.52.6"
                "0rpdx1537mw6slcpqa0rm3qixmsb79nbhqy5fsm3q2q9ik9m5vhf"))

(define rust-windows-i686-gnullvm-0.53.1
  (crate-source "windows_i686_gnullvm" "0.53.1"
                "030qaxqc4salz6l4immfb6sykc6gmhyir9wzn2w8mxj8038mjwzs"))

(define rust-windows-i686-msvc-0.42.2
  (crate-source "windows_i686_msvc" "0.42.2"
                "0q0h9m2aq1pygc199pa5jgc952qhcnf0zn688454i7v4xjv41n24"))

(define rust-windows-i686-msvc-0.48.0
  (crate-source "windows_i686_msvc" "0.48.0"
                "004fkyqv3if178xx9ksqc4qqv8sz8n72mpczsr2vy8ffckiwchj5"
		#:snippet '(delete-file-recursively "lib")))

(define rust-windows-i686-msvc-0.52.6
  (crate-source "windows_i686_msvc" "0.52.6"
                "0rkcqmp4zzmfvrrrx01260q3xkpzi6fzi2x2pgdcdry50ny4h294"))

(define rust-windows-i686-msvc-0.53.1
  (crate-source "windows_i686_msvc" "0.53.1"
                "1hi6scw3mn2pbdl30ji5i4y8vvspb9b66l98kkz350pig58wfyhy"))

(define rust-windows-implement-0.60.2
  (crate-source "windows-implement" "0.60.2"
                "1psxhmklzcf3wjs4b8qb42qb6znvc142cb5pa74rsyxm1822wgh5"))

(define rust-windows-interface-0.59.3
  (crate-source "windows-interface" "0.59.3"
                "0n73cwrn4247d0axrk7gjp08p34x1723483jxjxjdfkh4m56qc9z"))

(define rust-windows-link-0.1.3
  (crate-source "windows-link" "0.1.3"
                "12kr1p46dbhpijr4zbwr2spfgq8i8c5x55mvvfmyl96m01cx4sjy"))

(define rust-windows-link-0.2.1
  (crate-source "windows-link" "0.2.1"
                "1rag186yfr3xx7piv5rg8b6im2dwcf8zldiflvb22xbzwli5507h"))

(define rust-windows-numerics-0.2.0
  (crate-source "windows-numerics" "0.2.0"
                "1cf2j8nbqf0hqqa7chnyid91wxsl2m131kn0vl3mqk3c0rlayl4i"))

(define rust-windows-registry-0.6.1
  (crate-source "windows-registry" "0.6.1"
                "082p7l615qk8a4g8g15yipc5lghga6cgfhm74wm7zknwzgvjnx82"))

(define rust-windows-result-0.3.4
  (crate-source "windows-result" "0.3.4"
                "1il60l6idrc6hqsij0cal0mgva6n3w6gq4ziban8wv6c6b9jpx2n"))

(define rust-windows-result-0.4.1
  (crate-source "windows-result" "0.4.1"
                "1d9yhmrmmfqh56zlj751s5wfm9a2aa7az9rd7nn5027nxa4zm0bp"))

(define rust-windows-strings-0.4.2
  (crate-source "windows-strings" "0.4.2"
                "0mrv3plibkla4v5kaakc2rfksdd0b14plcmidhbkcfqc78zwkrjn"))

(define rust-windows-strings-0.5.1
  (crate-source "windows-strings" "0.5.1"
                "14bhng9jqv4fyl7lqjz3az7vzh8pw0w4am49fsqgcz67d67x0dvq"))

(define rust-windows-sys-0.45.0
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "windows-sys" "0.45.0"
                "1l36bcqm4g89pknfp8r9rl1w4bn017q6a8qlx8viv0xjxzjkna3m"))

(define rust-windows-sys-0.48.0
  (crate-source "windows-sys" "0.48.0"
                "1aan23v5gs7gya1lc46hqn9mdh8yph3fhxmhxlw36pn6pqc28zb7"))

(define rust-windows-sys-0.52.0
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "windows-sys" "0.52.0"
                "0gd3v4ji88490zgb6b5mq5zgbvwv7zx1ibn8v3x83rwcdbryaar8"))

(define rust-windows-sys-0.59.0
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "windows-sys" "0.59.0"
                "0fw5672ziw8b3zpmnbp9pdv1famk74f1l9fcbc3zsrzdg56vqf0y"))

(define rust-windows-sys-0.60.2
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "windows-sys" "0.60.2"
                "1jrbc615ihqnhjhxplr2kw7rasrskv9wj3lr80hgfd42sbj01xgj"))

(define rust-windows-sys-0.61.2
  ;; TODO REVIEW: Check bundled sources.
  (crate-source "windows-sys" "0.61.2"
                "1z7k3y9b6b5h52kid57lvmvm05362zv1v8w0gc7xyv5xphlp44xf"))

(define rust-windows-targets-0.42.2
  (crate-source "windows-targets" "0.42.2"
                "0wfhnib2fisxlx8c507dbmh97kgij4r6kcxdi0f9nk6l1k080lcf"))

(define rust-windows-targets-0.48.1
  (crate-source "windows-targets" "0.48.1"
                "0pz9ad4mpp06h80hkmzlib78b5r9db7isycy1gr9j17pj1sb3m05"))

(define rust-windows-targets-0.52.6
  (crate-source "windows-targets" "0.52.6"
                "0wwrx625nwlfp7k93r2rra568gad1mwd888h1jwnl0vfg5r4ywlv"))

(define rust-windows-targets-0.53.5
  (crate-source "windows-targets" "0.53.5"
                "1wv9j2gv3l6wj3gkw5j1kr6ymb5q6dfc42yvydjhv3mqa7szjia9"))

(define rust-windows-threading-0.1.0
  (crate-source "windows-threading" "0.1.0"
                "19jpn37zpjj2q7pn07dpq0ay300w65qx7wdp13wbp8qf5snn6r5n"))

(define rust-windows-version-0.1.7
  (crate-source "windows-version" "0.1.7"
                "0c9nnqpcq770977k77mw1p66gpw45khwhqkjdcrd1f89l4fhl1p4"))

(define rust-windows-x86-64-gnu-0.42.2
  (crate-source "windows_x86_64_gnu" "0.42.2"
                "0dnbf2xnp3xrvy8v9mgs3var4zq9v9yh9kv79035rdgyp2w15scd"))

(define rust-windows-x86-64-gnu-0.48.0
  (crate-source "windows_x86_64_gnu" "0.48.0"
                "1cblz5m6a8q6ha09bz4lz233dnq5sw2hpra06k9cna3n3xk8laya"
		#:snippet '(delete-file-recursively "lib")))

(define rust-windows-x86-64-gnu-0.52.6
  (crate-source "windows_x86_64_gnu" "0.52.6"
                "0y0sifqcb56a56mvn7xjgs8g43p33mfqkd8wj1yhrgxzma05qyhl"))

(define rust-windows-x86-64-gnu-0.53.1
  (crate-source "windows_x86_64_gnu" "0.53.1"
                "16d4yiysmfdlsrghndr97y57gh3kljkwhfdbcs05m1jasz6l4f4w"))

(define rust-windows-x86-64-gnullvm-0.42.2
  (crate-source "windows_x86_64_gnullvm" "0.42.2"
                "18wl9r8qbsl475j39zvawlidp1bsbinliwfymr43fibdld31pm16"))

(define rust-windows-x86-64-gnullvm-0.48.0
  (crate-source "windows_x86_64_gnullvm" "0.48.0"
                "0lxryz3ysx0145bf3i38jkr7f9nxiym8p3syklp8f20yyk0xp5kq"
		#:snippet '(delete-file-recursively "lib")))

(define rust-windows-x86-64-gnullvm-0.52.6
  (crate-source "windows_x86_64_gnullvm" "0.52.6"
                "03gda7zjx1qh8k9nnlgb7m3w3s1xkysg55hkd1wjch8pqhyv5m94"))

(define rust-windows-x86-64-gnullvm-0.53.1
  (crate-source "windows_x86_64_gnullvm" "0.53.1"
                "1qbspgv4g3q0vygkg8rnql5c6z3caqv38japiynyivh75ng1gyhg"))

(define rust-windows-x86-64-msvc-0.42.2
  (crate-source "windows_x86_64_msvc" "0.42.2"
                "1w5r0q0yzx827d10dpjza2ww0j8iajqhmb54s735hhaj66imvv4s"))

(define rust-windows-x86-64-msvc-0.48.0
  (crate-source "windows_x86_64_msvc" "0.48.0"
                "12ipr1knzj2rwjygyllfi5mkd0ihnbi3r61gag5n2jgyk5bmyl8s"
		#:snippet '(delete-file-recursively "lib")))

(define rust-windows-x86-64-msvc-0.52.6
  (crate-source "windows_x86_64_msvc" "0.52.6"
                "1v7rb5cibyzx8vak29pdrk8nx9hycsjs4w0jgms08qk49jl6v7sq"))

(define rust-windows-x86-64-msvc-0.53.1
  (crate-source "windows_x86_64_msvc" "0.53.1"
                "0l6npq76vlq4ksn4bwsncpr8508mk0gmznm6wnhjg95d19gzzfyn"))

(define rust-winnow-0.5.40
  (crate-source "winnow" "0.5.40"
                "0xk8maai7gyxda673mmw3pj1hdizy5fpi7287vaywykkk19sk4zm"))

(define rust-winnow-0.7.15
  (crate-source "winnow" "0.7.15"
                "0i9rkl2rqpbnnxlgs20gmkj3nd0b2k8q55mjmpc2ybb84xwxjyfz"))

(define rust-winnow-1.0.3
  (crate-source "winnow" "1.0.3"
                "1wajycd3krn6h699vydjv7hm0ll5l31p899qzpk59y2is74y34h5"))

(define rust-winreg-0.55.0
  (crate-source "winreg" "0.55.0"
                "15xy060vylrsp91bc0ximx3xziwipzlrn1n2ab19w3n56x9pcnnb"))

(define rust-wit-bindgen-0.51.0
  (crate-source "wit-bindgen" "0.51.0"
                "19fazgch8sq5cvjv3ynhhfh5d5x08jq2pkw8jfb05vbcyqcr496p"))

(define rust-wit-bindgen-0.57.1
  (crate-source "wit-bindgen" "0.57.1"
                "0vjk2jb593ri9k1aq4iqs2si9mrw5q46wxnn78im7hm7hx799gqy"))

(define rust-wit-bindgen-core-0.51.0
  (crate-source "wit-bindgen-core" "0.51.0"
                "1p2jszqsqbx8k7y8nwvxg65wqzxjm048ba5phaq8r9iy9ildwqga"))

(define rust-wit-bindgen-rust-0.51.0
  (crate-source "wit-bindgen-rust" "0.51.0"
                "08bzn5fsvkb9x9wyvyx98qglknj2075xk1n7c5jxv15jykh6didp"))

(define rust-wit-bindgen-rust-macro-0.51.0
  (crate-source "wit-bindgen-rust-macro" "0.51.0"
                "0ymizapzv2id89igxsz2n587y2hlfypf6n8kyp68x976fzyrn3qc"))

(define rust-wit-component-0.244.0
  (crate-source "wit-component" "0.244.0"
                "1clwxgsgdns3zj2fqnrjcp8y5gazwfa1k0sy5cbk0fsmx4hflrlx"))

(define rust-wit-parser-0.244.0
  (crate-source "wit-parser" "0.244.0"
                "0dm7avvdxryxd5b02l0g5h6933z1cw5z0d4wynvq2cywq55srj7c"))

(define rust-writeable-0.6.3
  (crate-source "writeable" "0.6.3"
                "1i54d13h9bpap2hf13xcry1s4lxh7ap3923g8f3c0grd7c9fbyhz"))

(define rust-wry-0.55.1
  (crate-source "wry" "0.55.1"
                "054mw4y35lk2nirgpdrx25kq7rcx2h6q32sp2v0djpx5v9qrhvqq"))

(define rust-x11-2.21.0
  (crate-source "x11" "2.21.0"
                "0bnvl09d7044k067gqdx1ln2r0ljp5f4675icwb0216d9i3aabah"))

(define rust-x11-dl-2.21.0
  (crate-source "x11-dl" "2.21.0"
                "0vsiq62xpcfm0kn9zjw5c9iycvccxl22jya8wnk18lyxzqj5jwrq"))

(define rust-xattr-1.6.1
  (crate-source "xattr" "1.6.1"
                "0ml1mb43gqasawillql6b344m0zgq8mz0isi11wj8vbg43a5mr1j"))

(define rust-xml-1.3.0
  (crate-source "xml" "1.3.0"
                "128s58qhq8whrx90zbw8r5algr7lakgbf7mn05jfk234rbjqavv3"))

(define rust-xmltree-0.12.0
  (crate-source "xmltree" "0.12.0"
                "0w7zwk9680c6qpnx17jv83fbc1q8f8wyf90pmfcf895ir89l7h6b"))

(define rust-xz2-0.1.7
  (crate-source "xz2" "0.1.7"
                "1qk7nzpblizvayyq4xzi4b0zacmmbqr6vb9fc0v1avyp17f4931q"))

(define rust-yoke-0.8.2
  (crate-source "yoke" "0.8.2"
                "1jprcs7a98a5whvfs6r3jvfh1nnfp6zyijl7y4ywmn88lzywbs5b"))

(define rust-yoke-derive-0.8.2
  (crate-source "yoke-derive" "0.8.2"
                "13l5y5sz4lqm7rmyakjbh6vwgikxiql51xfff9hq2j485hk4r16y"))

(define rust-zerocopy-0.7.35
  (crate-source "zerocopy" "0.7.35"
                "1w36q7b9il2flg0qskapgi9ymgg7p985vniqd09vi0mwib8lz6qv"))

(define rust-zerocopy-0.8.48
  (crate-source "zerocopy" "0.8.48"
                "1sb8plax8jbrsng1jdval7bdhk7hhrx40dz3hwh074k6knzkgm7f"))

(define rust-zerocopy-derive-0.7.35
  (crate-source "zerocopy-derive" "0.7.35"
                "0gnf2ap2y92nwdalzz3x7142f2b83sni66l39vxp2ijd6j080kzs"))

(define rust-zerocopy-derive-0.8.48
  (crate-source "zerocopy-derive" "0.8.48"
                "1m5s0g92cxggqc74j83k1priz24k3z93sj5gadppd20p9c4cvqvh"))

(define rust-zerofrom-0.1.8
  (crate-source "zerofrom" "0.1.8"
                "0wjjdj7gdmd0iq91gzkxl7dlv0nhkk80l4bmdpzh3a1yh48mmh0f"))

(define rust-zerofrom-derive-0.1.7
  (crate-source "zerofrom-derive" "0.1.7"
                "18c4wsnznhdxx6m80piil1lbyszdiwsshgjrybqcm4b6qic22lqi"))

(define rust-zeroize-1.8.2
  (crate-source "zeroize" "1.8.2"
                "1l48zxgcv34d7kjskr610zqsm6j2b4fcr2vfh9jm9j1jgvk58wdr"))

(define rust-zerotrie-0.2.4
  (crate-source "zerotrie" "0.2.4"
                "1gr0pkcn3qsr6in6iixqyp0vbzwf2j1jzyvh7yl2yydh3p9m548g"))

(define rust-zerovec-0.11.6
  (crate-source "zerovec" "0.11.6"
                "0fdjsy6b31q9i0d73sl7xjd12xadbwi45lkpfgqnmasrqg5i3ych"))

(define rust-zerovec-derive-0.11.3
  (crate-source "zerovec-derive" "0.11.3"
                "0m85qj92mmfvhjra6ziqky5b1p4kcmp5069k7kfadp5hr8jw8pb2"))

(define rust-zmij-1.0.21
  (crate-source "zmij" "1.0.21"
                "1amb5i6gz7yjb0dnmz5y669674pqmwbj44p4yfxfv2ncgvk8x15q"))

(define ssss-separator 'end-of-crates)

;;;
;;; Cargo inputs.
;;;

(define-cargo-inputs lookup-cargo-inputs
                     (globalprotect-openconnect =>
                                                (list rust-inflector-0.11.4
                                                 rust-adler2-2.0.1
                                                 rust-aead-0.5.2
                                                 rust-aho-corasick-1.1.4
                                                 rust-alloc-no-stdlib-2.0.4
                                                 rust-alloc-stdlib-0.2.2
                                                 rust-android-system-properties-0.1.5
                                                 rust-anstream-1.0.0
                                                 rust-anstyle-1.0.14
                                                 rust-anstyle-parse-1.0.0
                                                 rust-anstyle-query-1.1.5
                                                 rust-anstyle-wincon-3.0.11
                                                 rust-anyhow-1.0.102
                                                 rust-ascii-1.1.0
                                                 rust-askama-0.14.0
                                                 rust-askama-derive-0.14.0
                                                 rust-askama-parser-0.14.0
                                                 rust-async-trait-0.1.89
                                                 rust-atk-0.18.2
                                                 rust-atk-sys-0.18.2
                                                 rust-atomic-waker-1.1.2
                                                 rust-autocfg-1.5.0
                                                 rust-autotools-0.2.7
                                                 rust-axum-0.8.9
                                                 rust-axum-core-0.5.6
                                                 rust-base64-0.21.7
                                                 rust-base64-0.22.1
                                                 rust-basic-toml-0.1.10
                                                 rust-bit-set-0.8.0
                                                 rust-bit-vec-0.8.0
                                                 rust-bitflags-1.3.2
                                                 rust-bitflags-2.11.1
                                                 rust-block-buffer-0.10.4
                                                 rust-block2-0.6.2
                                                 rust-brotli-8.0.2
                                                 rust-brotli-decompressor-5.0.0
                                                 rust-bs58-0.5.1
                                                 rust-bumpalo-3.20.2
                                                 rust-bytemuck-1.25.0
                                                 rust-byteorder-1.5.0
                                                 rust-bytes-1.11.1
                                                 rust-cairo-rs-0.18.5
                                                 rust-cairo-sys-rs-0.18.2
                                                 rust-camino-1.2.2
                                                 rust-cargo-platform-0.1.9
                                                 rust-cargo-metadata-0.19.2
                                                 rust-cargo-toml-0.22.3
                                                 rust-cc-1.2.62
                                                 rust-cesu8-1.1.0
                                                 rust-cfb-0.7.3
                                                 rust-cfg-expr-0.15.8
                                                 rust-cfg-if-1.0.4
                                                 rust-cfg-aliases-0.2.1
                                                 rust-chacha20-0.9.1
                                                 rust-chacha20poly1305-0.10.1
                                                 rust-chrono-0.4.44
                                                 rust-chunked-transfer-1.5.0
                                                 rust-cipher-0.4.4
                                                 rust-clap-4.6.1
                                                 rust-clap-verbosity-flag-3.0.4
                                                 rust-clap-builder-4.6.0
                                                 rust-clap-derive-4.6.1
                                                 rust-clap-lex-1.1.0
                                                 rust-colorchoice-1.0.5
                                                 rust-combine-4.6.7
                                                 rust-compile-time-0.2.0
                                                 rust-convert-case-0.10.0
                                                 rust-cookie-0.18.1
                                                 rust-core-foundation-0.9.4
                                                 rust-core-foundation-0.10.1
                                                 rust-core-foundation-sys-0.8.7
                                                 rust-core-graphics-0.25.0
                                                 rust-core-graphics-types-0.2.0
                                                 rust-cpufeatures-0.2.17
                                                 rust-crc32fast-1.5.0
                                                 rust-crossbeam-channel-0.5.15
                                                 rust-crossbeam-deque-0.8.6
                                                 rust-crossbeam-epoch-0.9.18
                                                 rust-crossbeam-utils-0.8.21
                                                 rust-crossterm-0.29.0
                                                 rust-crossterm-winapi-0.9.1
                                                 rust-crypto-common-0.1.7
                                                 rust-cssparser-0.36.0
                                                 rust-cssparser-macros-0.6.1
                                                 rust-ctor-0.8.0
                                                 rust-ctor-proc-macro-0.0.7
                                                 rust-darling-0.23.0
                                                 rust-darling-core-0.23.0
                                                 rust-darling-macro-0.23.0
                                                 rust-data-encoding-2.11.0
                                                 rust-dbus-0.9.11
                                                 rust-deranged-0.5.8
                                                 rust-derive-more-2.1.1
                                                 rust-derive-more-impl-2.1.1
                                                 rust-digest-0.10.7
                                                 rust-directories-6.0.0
                                                 rust-dirs-6.0.0
                                                 rust-dirs-sys-0.5.0
                                                 rust-dispatch2-0.3.1
                                                 rust-displaydoc-0.2.5
                                                 rust-dlopen2-0.5.0
                                                 rust-dlopen2-0.8.2
                                                 rust-dlopen2-derive-0.4.3
                                                 rust-dns-lookup-3.0.1
                                                 rust-document-features-0.2.12
                                                 rust-dom-query-0.27.0
                                                 rust-dpi-0.1.2
                                                 rust-dtoa-1.0.11
                                                 rust-dtoa-short-0.3.5
                                                 rust-dtor-0.3.0
                                                 rust-dtor-proc-macro-0.0.6
                                                 rust-dunce-1.0.5
                                                 rust-dyn-clone-1.0.20
                                                 rust-either-1.15.0
                                                 rust-embed-resource-3.0.9
                                                 rust-embed-plist-1.2.2
                                                 rust-encoding-rs-0.8.35
                                                 rust-env-filter-1.0.1
                                                 rust-env-logger-0.11.10
                                                 rust-equivalent-1.0.2
                                                 rust-erased-serde-0.4.10
                                                 rust-errno-0.3.14
                                                 rust-fastrand-2.4.1
                                                 rust-fdeflate-0.3.7
                                                 rust-field-offset-0.3.6
                                                 rust-filetime-0.2.29
                                                 rust-find-msvc-tools-0.1.9
                                                 rust-flate2-1.1.9
                                                 rust-fnv-1.0.7
                                                 rust-foldhash-0.1.5
                                                 rust-foldhash-0.2.0
                                                 rust-foreign-types-0.3.2
                                                 rust-foreign-types-0.5.0
                                                 rust-foreign-types-macros-0.2.3
                                                 rust-foreign-types-shared-0.1.1
                                                 rust-foreign-types-shared-0.3.1
                                                 rust-form-urlencoded-1.2.2
                                                 rust-fs-extra-1.3.0
                                                 rust-futures-0.3.32
                                                 rust-futures-channel-0.3.32
                                                 rust-futures-core-0.3.32
                                                 rust-futures-executor-0.3.32
                                                 rust-futures-io-0.3.32
                                                 rust-futures-macro-0.3.32
                                                 rust-futures-sink-0.3.32
                                                 rust-futures-task-0.3.32
                                                 rust-futures-util-0.3.32
                                                 rust-fuzzy-matcher-0.3.7
                                                 rust-gdk-0.18.2
                                                 rust-gdk-pixbuf-0.18.5
                                                 rust-gdk-pixbuf-sys-0.18.0
                                                 rust-gdk-sys-0.18.2
                                                 rust-gdkwayland-sys-0.18.2
                                                 rust-gdkx11-0.18.2
                                                 rust-gdkx11-sys-0.18.2
                                                 rust-generic-array-0.14.7
                                                 rust-getrandom-0.2.17
                                                 rust-getrandom-0.3.4
                                                 rust-getrandom-0.4.2
                                                 rust-gio-0.18.4
                                                 rust-gio-sys-0.18.1
                                                 rust-glib-0.18.5
                                                 rust-glib-macros-0.18.5
                                                 rust-glib-sys-0.18.1
                                                 rust-glob-0.3.3
                                                 rust-gobject-sys-0.18.0
                                                 rust-gtk-0.18.2
                                                 rust-gtk-sys-0.18.2
                                                 rust-gtk3-macros-0.18.2
                                                 rust-h2-0.4.14
                                                 rust-hashbrown-0.12.3
                                                 rust-hashbrown-0.15.5
                                                 rust-hashbrown-0.17.1
                                                 rust-heck-0.4.1
                                                 rust-heck-0.5.0
                                                 rust-hex-0.4.3
                                                 rust-home-0.5.11
                                                 rust-html-escape-0.2.13
                                                 rust-html5ever-0.38.0
                                                 rust-http-1.4.0
                                                 rust-http-body-1.0.1
                                                 rust-http-body-util-0.1.3
                                                 rust-httparse-1.10.1
                                                 rust-httpdate-1.0.3
                                                 rust-humantime-2.3.0
                                                 rust-hyper-1.9.0
                                                 rust-hyper-rustls-0.27.9
                                                 rust-hyper-tls-0.6.0
                                                 rust-hyper-util-0.1.20
                                                 rust-iana-time-zone-0.1.65
                                                 rust-iana-time-zone-haiku-0.1.2
                                                 rust-ico-0.5.0
                                                 rust-icu-collections-2.2.0
                                                 rust-icu-locale-core-2.2.0
                                                 rust-icu-normalizer-2.2.0
                                                 rust-icu-normalizer-data-2.2.0
                                                 rust-icu-properties-2.2.0
                                                 rust-icu-properties-data-2.2.0
                                                 rust-icu-provider-2.2.0
                                                 rust-id-arena-2.3.0
                                                 rust-ident-case-1.0.1
                                                 rust-idna-1.1.0
                                                 rust-idna-adapter-1.2.2
                                                 rust-indexmap-1.9.3
                                                 rust-indexmap-2.14.0
                                                 rust-infer-0.19.0
                                                 rust-inout-0.1.4
                                                 rust-inquire-0.9.4
                                                 rust-ipnet-2.12.0
                                                 rust-is-docker-0.2.0
                                                 rust-is-wsl-0.4.0
                                                 rust-is-executable-1.0.5
                                                 rust-is-terminal-polyfill-1.70.2
                                                 rust-itoa-1.0.18
                                                 rust-javascriptcore-rs-1.1.2
                                                 rust-javascriptcore-rs-sys-1.1.1
                                                 rust-jiff-0.2.24
                                                 rust-jiff-static-0.2.24
                                                 rust-jni-0.21.1
                                                 rust-jni-0.22.4
                                                 rust-jni-macros-0.22.4
                                                 rust-jni-sys-0.3.1
                                                 rust-jni-sys-0.4.1
                                                 rust-jni-sys-macros-0.4.1
                                                 rust-js-sys-0.3.98
                                                 rust-json-patch-3.0.1
                                                 rust-jsonptr-0.6.3
                                                 rust-keyboard-types-0.7.0
                                                 rust-leb128fmt-0.1.0
                                                 rust-libappindicator-0.9.0
                                                 rust-libappindicator-sys-0.9.0
                                                 rust-libc-0.2.186
                                                 rust-libdbus-sys-0.2.7
                                                 rust-libloading-0.7.4
                                                 rust-libredox-0.1.16
                                                 rust-linux-raw-sys-0.12.1
                                                 rust-litemap-0.8.2
                                                 rust-litrs-1.0.0
                                                 rust-lock-api-0.4.14
                                                 rust-log-0.4.29
                                                 rust-log-reload-0.1.3
                                                 rust-lzma-sys-0.1.20
                                                 rust-mac-addr-0.3.0
                                                 rust-machine-uid-0.5.4
                                                 rust-markup5ever-0.38.0
                                                 rust-matchit-0.8.4
                                                 rust-md5-0.8.0
                                                 rust-memchr-2.8.0
                                                 rust-memoffset-0.9.1
                                                 rust-mime-0.3.17
                                                 rust-miniz-oxide-0.8.9
                                                 rust-mio-1.2.0
                                                 rust-muda-0.19.1
                                                 rust-native-tls-0.2.18
                                                 rust-ndk-0.9.0
                                                 rust-ndk-context-0.1.1
                                                 rust-ndk-sys-0.6.0+11769913
                                                 rust-netdev-0.40.1
                                                 rust-netlink-packet-core-0.8.1
                                                 rust-netlink-packet-route-0.29.0
                                                 rust-netlink-sys-0.8.8
                                                 rust-new-debug-unreachable-1.0.6
                                                 rust-nix-0.30.1
                                                 rust-ntapi-0.4.3
                                                 rust-num-conv-0.2.1
                                                 rust-num-traits-0.2.19
                                                 rust-num-enum-0.7.6
                                                 rust-num-enum-derive-0.7.6
                                                 rust-objc2-0.6.4
                                                 rust-objc2-app-kit-0.3.2
                                                 rust-objc2-cloud-kit-0.3.2
                                                 rust-objc2-core-data-0.3.2
                                                 rust-objc2-core-foundation-0.3.2
                                                 rust-objc2-core-graphics-0.3.2
                                                 rust-objc2-core-image-0.3.2
                                                 rust-objc2-core-location-0.3.2
                                                 rust-objc2-core-text-0.3.2
                                                 rust-objc2-encode-4.1.0
                                                 rust-objc2-exception-helper-0.1.1
                                                 rust-objc2-foundation-0.3.2
                                                 rust-objc2-io-kit-0.3.2
                                                 rust-objc2-io-surface-0.3.2
                                                 rust-objc2-javascript-core-0.3.2
                                                 rust-objc2-quartz-core-0.3.2
                                                 rust-objc2-security-0.3.2
                                                 rust-objc2-system-configuration-0.3.2
                                                 rust-objc2-ui-kit-0.3.2
                                                 rust-objc2-user-notifications-0.3.2
                                                 rust-objc2-web-kit-0.3.2
                                                 rust-once-cell-1.21.4
                                                 rust-once-cell-polyfill-1.70.2
                                                 rust-opaque-debug-0.3.1
                                                 rust-open-5.3.5
                                                 rust-openssl-0.10.80
                                                 rust-openssl-macros-0.1.1
                                                 rust-openssl-probe-0.2.1
                                                 rust-openssl-sys-0.9.116
                                                 rust-option-ext-0.2.0
                                                 rust-os-info-3.14.0
                                                 rust-pango-0.18.3
                                                 rust-pango-sys-0.18.0
                                                 rust-parking-lot-0.12.5
                                                 rust-parking-lot-core-0.9.12
                                                 rust-paste-1.0.15
                                                 rust-pathdiff-0.2.3
                                                 rust-pem-3.0.6
                                                 rust-percent-encoding-2.3.2
                                                 rust-phf-0.13.1
                                                 rust-phf-codegen-0.13.1
                                                 rust-phf-generator-0.13.1
                                                 rust-phf-macros-0.13.1
                                                 rust-phf-shared-0.13.1
                                                 rust-pin-project-lite-0.2.17
                                                 rust-pkg-config-0.3.33
                                                 rust-plain-0.2.3
                                                 rust-plist-1.9.0
                                                 rust-png-0.17.16
                                                 rust-png-0.18.1
                                                 rust-poly1305-0.8.0
                                                 rust-portable-atomic-1.13.1
                                                 rust-portable-atomic-util-0.2.7
                                                 rust-potential-utf-0.1.5
                                                 rust-powerfmt-0.2.0
                                                 rust-ppv-lite86-0.2.21
                                                 rust-precomputed-hash-0.1.1
                                                 rust-prettyplease-0.2.37
                                                 rust-proc-macro-crate-1.3.1
                                                 rust-proc-macro-crate-2.0.2
                                                 rust-proc-macro-crate-3.5.0
                                                 rust-proc-macro-error-1.0.4
                                                 rust-proc-macro-error-attr-1.0.4
                                                 rust-proc-macro2-1.0.106
                                                 rust-quick-xml-0.39.4
                                                 rust-quote-1.0.45
                                                 rust-r-efi-5.3.0
                                                 rust-r-efi-6.0.0
                                                 rust-rand-0.9.4
                                                 rust-rand-chacha-0.9.0
                                                 rust-rand-core-0.6.4
                                                 rust-rand-core-0.9.5
                                                 rust-raw-window-handle-0.6.2
                                                 rust-rayon-1.12.0
                                                 rust-rayon-core-1.13.0
                                                 rust-redact-engine-0.1.2
                                                 rust-redox-syscall-0.5.18
                                                 rust-redox-syscall-0.7.5
                                                 rust-redox-users-0.5.2
                                                 rust-ref-cast-1.0.25
                                                 rust-ref-cast-impl-1.0.25
                                                 rust-regex-1.12.3
                                                 rust-regex-automata-0.4.14
                                                 rust-regex-syntax-0.8.10
                                                 rust-reqwest-0.12.28
                                                 rust-reqwest-0.13.3
                                                 rust-ring-0.17.14
                                                 rust-rustc-hash-2.1.2
                                                 rust-rustc-version-0.4.1
                                                 rust-rustix-1.1.4
                                                 rust-rustls-0.23.40
                                                 rust-rustls-pki-types-1.14.1
                                                 rust-rustls-webpki-0.103.13
                                                 rust-rustversion-1.0.22
                                                 rust-ryu-1.0.23
                                                 rust-same-file-1.0.6
                                                 rust-schannel-0.1.29
                                                 rust-schemars-0.8.22
                                                 rust-schemars-0.9.0
                                                 rust-schemars-1.2.1
                                                 rust-schemars-derive-0.8.22
                                                 rust-scopeguard-1.2.0
                                                 rust-security-framework-3.7.0
                                                 rust-security-framework-sys-2.17.0
                                                 rust-selectors-0.36.1
                                                 rust-semver-1.0.28
                                                 rust-serde-1.0.228
                                                 rust-serde-untagged-0.1.9
                                                 rust-serde-core-1.0.228
                                                 rust-serde-derive-1.0.228
                                                 rust-serde-derive-internals-0.29.1
                                                 rust-serde-json-1.0.149
                                                 rust-serde-path-to-error-0.1.20
                                                 rust-serde-regex-1.1.0
                                                 rust-serde-repr-0.1.20
                                                 rust-serde-spanned-0.6.9
                                                 rust-serde-spanned-1.1.1
                                                 rust-serde-urlencoded-0.7.1
                                                 rust-serde-with-3.20.0
                                                 rust-serde-with-macros-3.20.0
                                                 rust-serialize-to-javascript-0.1.2
                                                 rust-serialize-to-javascript-impl-0.1.2
                                                 rust-servo-arc-0.4.3
                                                 rust-sha1-0.10.6
                                                 rust-sha1-smol-1.0.1
                                                 rust-sha2-0.10.9
                                                 rust-sha256-1.6.0
                                                 rust-shlex-1.3.0
                                                 rust-signal-hook-0.3.18
                                                 rust-signal-hook-mio-0.2.5
                                                 rust-signal-hook-registry-1.4.8
                                                 rust-simd-adler32-0.3.9
                                                 rust-simd-cesu8-1.1.1
                                                 rust-simdutf8-0.1.5
                                                 rust-siphasher-1.0.3
                                                 rust-slab-0.4.12
                                                 rust-smallvec-1.15.1
                                                 rust-socket2-0.6.3
                                                 rust-softbuffer-0.4.8
                                                 rust-soup3-0.5.0
                                                 rust-soup3-sys-0.5.0
                                                 rust-specta-2.0.0-rc.20
                                                 rust-specta-macros-2.0.0-rc.17
                                                 rust-stable-deref-trait-1.2.1
                                                 rust-string-cache-0.9.0
                                                 rust-string-cache-codegen-0.6.1
                                                 rust-strsim-0.11.1
                                                 rust-subtle-2.6.1
                                                 rust-swift-rs-1.0.7
                                                 rust-syn-1.0.109
                                                 rust-syn-2.0.117
                                                 rust-sync-wrapper-1.0.2
                                                 rust-synstructure-0.13.2
                                                 rust-sysinfo-0.36.1
                                                 rust-system-configuration-0.7.0
                                                 rust-system-configuration-sys-0.6.0
                                                 rust-system-deps-6.2.2
                                                 rust-tao-0.35.2
                                                 rust-tao-macros-0.1.3
                                                 rust-tar-0.4.45
                                                 rust-target-lexicon-0.12.16
                                                 rust-tauri-2.11.2
                                                 rust-tauri-build-2.6.2
                                                 rust-tauri-codegen-2.6.2
                                                 rust-tauri-macros-2.6.2
                                                 rust-tauri-runtime-2.11.2
                                                 rust-tauri-runtime-wry-2.11.2
                                                 rust-tauri-utils-2.9.2
                                                 rust-tauri-winres-0.3.6
                                                 rust-tempfile-3.27.0
                                                 rust-tendril-0.5.0
                                                 rust-thiserror-1.0.69
                                                 rust-thiserror-2.0.18
                                                 rust-thiserror-impl-1.0.69
                                                 rust-thiserror-impl-2.0.18
                                                 rust-thread-local-1.1.9
                                                 rust-time-0.3.47
                                                 rust-time-core-0.1.8
                                                 rust-time-macros-0.2.27
                                                 rust-tiny-http-0.12.0
                                                 rust-tinystr-0.8.3
                                                 rust-tinyvec-1.11.0
                                                 rust-tinyvec-macros-0.1.1
                                                 rust-tokio-1.52.3
                                                 rust-tokio-macros-2.7.0
                                                 rust-tokio-native-tls-0.3.1
                                                 rust-tokio-rustls-0.26.4
                                                 rust-tokio-tungstenite-0.29.0
                                                 rust-tokio-util-0.7.18
                                                 rust-toml-0.8.2
                                                 rust-toml-0.9.12+spec-1.1.0
                                                 rust-toml-1.1.2+spec-1.1.0
                                                 rust-toml-datetime-0.6.3
                                                 rust-toml-datetime-0.7.5+spec-1.1.0
                                                 rust-toml-datetime-1.1.1+spec-1.1.0
                                                 rust-toml-edit-0.19.15
                                                 rust-toml-edit-0.20.2
                                                 rust-toml-edit-0.25.11+spec-1.1.0
                                                 rust-toml-parser-1.1.2+spec-1.1.0
                                                 rust-toml-writer-1.1.1+spec-1.1.0
                                                 rust-tower-0.5.3
                                                 rust-tower-http-0.6.10
                                                 rust-tower-layer-0.3.3
                                                 rust-tower-service-0.3.3
                                                 rust-tracing-0.1.44
                                                 rust-tracing-core-0.1.36
                                                 rust-tray-icon-0.23.1
                                                 rust-try-lock-0.2.5
                                                 rust-tungstenite-0.29.0
                                                 rust-typeid-1.0.3
                                                 rust-typenum-1.20.0
                                                 rust-unic-char-property-0.9.0
                                                 rust-unic-char-range-0.9.0
                                                 rust-unic-common-0.9.0
                                                 rust-unic-ucd-ident-0.9.0
                                                 rust-unic-ucd-version-0.9.0
                                                 rust-unicode-ident-1.0.24
                                                 rust-unicode-segmentation-1.13.2
                                                 rust-unicode-width-0.2.2
                                                 rust-unicode-xid-0.2.6
                                                 rust-universal-hash-0.5.1
                                                 rust-untrusted-0.9.0
                                                 rust-url-2.5.8
                                                 rust-urlencoding-2.1.3
                                                 rust-urlpattern-0.3.0
                                                 rust-utf-8-0.7.6
                                                 rust-utf8-width-0.1.8
                                                 rust-utf8-iter-1.0.4
                                                 rust-utf8parse-0.2.2
                                                 rust-uuid-1.23.1
                                                 rust-uzers-0.12.2
                                                 rust-vcpkg-0.2.15
                                                 rust-version-compare-0.2.1
                                                 rust-version-check-0.9.5
                                                 rust-vswhom-0.1.0
                                                 rust-vswhom-sys-0.1.3
                                                 rust-walkdir-2.5.0
                                                 rust-want-0.3.1
                                                 rust-wasi-0.11.1+wasi-snapshot-preview1
                                                 rust-wasip2-1.0.3+wasi-0.2.9
                                                 rust-wasip3-0.4.0+wasi-0.3.0-rc-2026-01-06
                                                 rust-wasite-0.1.0
                                                 rust-wasm-bindgen-0.2.121
                                                 rust-wasm-bindgen-futures-0.4.71
                                                 rust-wasm-bindgen-macro-0.2.121
                                                 rust-wasm-bindgen-macro-support-0.2.121
                                                 rust-wasm-bindgen-shared-0.2.121
                                                 rust-wasm-encoder-0.244.0
                                                 rust-wasm-metadata-0.244.0
                                                 rust-wasm-streams-0.4.2
                                                 rust-wasm-streams-0.5.0
                                                 rust-wasmparser-0.244.0
                                                 rust-web-sys-0.3.98
                                                 rust-web-atoms-0.2.4
                                                 rust-webbrowser-1.2.1
                                                 rust-webkit2gtk-2.0.2
                                                 rust-webkit2gtk-sys-2.0.2
                                                 rust-webview2-com-0.38.2
                                                 rust-webview2-com-macros-0.8.1
                                                 rust-webview2-com-sys-0.38.2
                                                 rust-which-8.0.2
                                                 rust-whoami-1.6.1
                                                 rust-winapi-0.3.9
                                                 rust-winapi-i686-pc-windows-gnu-0.4.0
                                                 rust-winapi-util-0.1.11
                                                 rust-winapi-x86-64-pc-windows-gnu-0.4.0
                                                 rust-window-vibrancy-0.6.0
                                                 rust-windows-0.61.3
                                                 rust-windows-collections-0.2.0
                                                 rust-windows-core-0.61.2
                                                 rust-windows-core-0.62.2
                                                 rust-windows-future-0.2.1
                                                 rust-windows-implement-0.60.2
                                                 rust-windows-interface-0.59.3
                                                 rust-windows-link-0.1.3
                                                 rust-windows-link-0.2.1
                                                 rust-windows-numerics-0.2.0
                                                 rust-windows-registry-0.6.1
                                                 rust-windows-result-0.3.4
                                                 rust-windows-result-0.4.1
                                                 rust-windows-strings-0.4.2
                                                 rust-windows-strings-0.5.1
                                                 rust-windows-sys-0.45.0
                                                 rust-windows-sys-0.52.0
                                                 rust-windows-sys-0.59.0
                                                 rust-windows-sys-0.60.2
                                                 rust-windows-sys-0.61.2
                                                 rust-windows-targets-0.42.2
                                                 rust-windows-targets-0.52.6
                                                 rust-windows-targets-0.53.5
                                                 rust-windows-threading-0.1.0
                                                 rust-windows-version-0.1.7
                                                 rust-windows-aarch64-gnullvm-0.42.2
                                                 rust-windows-aarch64-gnullvm-0.52.6
                                                 rust-windows-aarch64-gnullvm-0.53.1
                                                 rust-windows-aarch64-msvc-0.42.2
                                                 rust-windows-aarch64-msvc-0.52.6
                                                 rust-windows-aarch64-msvc-0.53.1
                                                 rust-windows-i686-gnu-0.42.2
                                                 rust-windows-i686-gnu-0.52.6
                                                 rust-windows-i686-gnu-0.53.1
                                                 rust-windows-i686-gnullvm-0.52.6
                                                 rust-windows-i686-gnullvm-0.53.1
                                                 rust-windows-i686-msvc-0.42.2
                                                 rust-windows-i686-msvc-0.52.6
                                                 rust-windows-i686-msvc-0.53.1
                                                 rust-windows-x86-64-gnu-0.42.2
                                                 rust-windows-x86-64-gnu-0.52.6
                                                 rust-windows-x86-64-gnu-0.53.1
                                                 rust-windows-x86-64-gnullvm-0.42.2
                                                 rust-windows-x86-64-gnullvm-0.52.6
                                                 rust-windows-x86-64-gnullvm-0.53.1
                                                 rust-windows-x86-64-msvc-0.42.2
                                                 rust-windows-x86-64-msvc-0.52.6
                                                 rust-windows-x86-64-msvc-0.53.1
                                                 rust-winnow-0.5.40
                                                 rust-winnow-0.7.15
                                                 rust-winnow-1.0.3
                                                 rust-winreg-0.55.0
                                                 rust-wit-bindgen-0.51.0
                                                 rust-wit-bindgen-0.57.1
                                                 rust-wit-bindgen-core-0.51.0
                                                 rust-wit-bindgen-rust-0.51.0
                                                 rust-wit-bindgen-rust-macro-0.51.0
                                                 rust-wit-component-0.244.0
                                                 rust-wit-parser-0.244.0
                                                 rust-writeable-0.6.3
                                                 rust-wry-0.55.1
                                                 rust-x11-2.21.0
                                                 rust-x11-dl-2.21.0
                                                 rust-xattr-1.6.1
                                                 rust-xml-1.3.0
                                                 rust-xmltree-0.12.0
                                                 rust-xz2-0.1.7
                                                 rust-yoke-0.8.2
                                                 rust-yoke-derive-0.8.2
                                                 rust-zerocopy-0.8.48
                                                 rust-zerocopy-derive-0.8.48
                                                 rust-zerofrom-0.1.8
                                                 rust-zerofrom-derive-0.1.7
                                                 rust-zeroize-1.8.2
                                                 rust-zerotrie-0.2.4
                                                 rust-zerovec-0.11.6
                                                 rust-zerovec-derive-0.11.3
                                                 rust-zmij-1.0.21))
                     (virtiofsd =>
                                (list rust-aho-corasick-0.7.18
                                      rust-anstream-0.3.2
                                      rust-anstyle-1.0.1
                                      rust-anstyle-parse-0.2.1
                                      rust-anstyle-query-1.0.0
                                      rust-anstyle-wincon-1.0.1
                                      rust-arc-swap-1.5.0
                                      rust-atomic-polyfill-0.1.11
                                      rust-atty-0.2.14
                                      rust-autocfg-1.1.0
                                      rust-bitflags-1.3.2
                                      rust-bitflags-2.4.1
                                      rust-btree-range-map-0.7.2
                                      rust-btree-slab-0.6.1
                                      rust-byteorder-1.4.3
                                      rust-capng-0.2.2
                                      rust-cc-1.0.79
                                      rust-cc-traits-2.0.0
                                      rust-cfg-if-1.0.0
                                      rust-clap-4.3.11
                                      rust-clap-builder-4.3.11
                                      rust-clap-derive-4.3.2
                                      rust-clap-lex-0.5.0
                                      rust-cobs-0.2.3
                                      rust-colorchoice-1.0.0
                                      rust-critical-section-1.1.2
                                      rust-env-logger-0.8.4
                                      rust-errno-0.3.1
                                      rust-errno-dragonfly-0.1.2
                                      rust-error-chain-0.12.4
                                      rust-futures-0.3.21
                                      rust-futures-channel-0.3.21
                                      rust-futures-core-0.3.21
                                      rust-futures-executor-0.3.21
                                      rust-futures-io-0.3.21
                                      rust-futures-macro-0.3.21
                                      rust-futures-sink-0.3.21
                                      rust-futures-task-0.3.21
                                      rust-futures-util-0.3.21
                                      rust-getrandom-0.2.15
                                      rust-hash32-0.2.1
                                      rust-heapless-0.7.16
                                      rust-heck-0.4.1
                                      rust-hermit-abi-0.1.19
                                      rust-hermit-abi-0.3.2
                                      rust-hostname-0.3.1
                                      rust-humantime-2.1.0
                                      rust-is-terminal-0.4.9
                                      rust-itoa-1.0.2
                                      rust-libc-0.2.155
                                      rust-libseccomp-sys-0.2.1
                                      rust-linux-raw-sys-0.4.5
                                      rust-lock-api-0.4.10
                                      rust-log-0.4.17
                                      rust-match-cfg-0.1.0
                                      rust-memchr-2.5.0
                                      rust-num-cpus-1.13.1
                                      rust-num-threads-0.1.6
                                      rust-once-cell-1.18.0
                                      rust-pin-project-lite-0.2.9
                                      rust-pin-utils-0.1.0
                                      rust-postcard-1.0.6
                                      rust-ppv-lite86-0.2.20
                                      rust-proc-macro2-1.0.63
                                      rust-quote-1.0.29
                                      rust-rand-0.8.5
                                      rust-rand-chacha-0.3.1
                                      rust-rand-core-0.6.4
                                      rust-range-traits-0.3.2
                                      rust-regex-1.6.0
                                      rust-regex-syntax-0.6.27
                                      rust-rustc-version-0.4.0
                                      rust-rustix-0.38.7
                                      rust-scopeguard-1.2.0
                                      rust-semver-1.0.18
                                      rust-serde-1.0.168
                                      rust-serde-derive-1.0.168
                                      rust-slab-0.4.7
                                      rust-smallvec-1.13.2
                                      rust-spin-0.9.8
                                      rust-stable-deref-trait-1.2.0
                                      rust-strsim-0.10.0
                                      rust-syn-1.0.98
                                      rust-syn-2.0.32
                                      rust-syslog-6.1.1
                                      rust-termcolor-1.1.3
                                      rust-thiserror-1.0.41
                                      rust-thiserror-impl-1.0.41
                                      rust-time-0.3.11
                                      rust-unicode-ident-1.0.2
                                      rust-utf8parse-0.2.1
                                      rust-uuid-1.11.0
                                      rust-uuid-macro-internal-1.11.0
                                      rust-version-check-0.9.4
                                      rust-vhost-0.13.0
                                      rust-vhost-user-backend-0.17.0
                                      rust-virtio-bindings-0.2.4
                                      rust-virtio-queue-0.14.0
                                      rust-vm-memory-0.16.0
                                      rust-vmm-sys-util-0.12.1
                                      rust-wasi-0.11.0+wasi-snapshot-preview1
                                      rust-winapi-0.3.9
                                      rust-winapi-i686-pc-windows-gnu-0.4.0
                                      rust-winapi-util-0.1.5
                                      rust-winapi-x86-64-pc-windows-gnu-0.4.0
                                      rust-windows-sys-0.48.0
                                      rust-windows-targets-0.48.1
                                      rust-windows-aarch64-gnullvm-0.48.0
                                      rust-windows-aarch64-msvc-0.48.0
                                      rust-windows-i686-gnu-0.48.0
                                      rust-windows-i686-msvc-0.48.0
                                      rust-windows-x86-64-gnu-0.48.0
                                      rust-windows-x86-64-gnullvm-0.48.0
                                      rust-windows-x86-64-msvc-0.48.0
                                      rust-zerocopy-0.7.35
                                      rust-zerocopy-derive-0.7.35)))
