(defpackage #:tokyocabinet-sys
  (:nicknames #:cl-tc.tc-sys)
  (:use #:cl #:cffi))
(defpackage #:tokyocabinet
    (:nicknames #:cl-tc.tc)
  (:use #:cl #:tokyocabinet-sys))

(defpackage #:tokyotyrant-sys
  (:nicknames #:cl-tc.tt-sys)
  (:use #:cl #:cffi))
(defpackage #:tokyotyrant
    (:nicknames #:cl-tc.tt)
  (:use #:cl #:tokyotyrant-sys))

(defpackage #:tokyodystopia-sys
  (:nicknames #:cl-tc.td-sys)
  (:use #:cl #:cffi))
(defpackage #:tokyodystopia
    (:nicknames #:cl-tc.td)
  (:use #:cl #:tokyodystopia-sys))
