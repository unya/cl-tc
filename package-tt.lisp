
(defpackage #:tokyotyrant-sys
  (:nicknames #:cl-tc.tt-sys)
  (:use #:cl #:cffi))
(defpackage #:tokyotyrant
    (:nicknames #:cl-tc.tt)
  (:use #:cl #:tokyotyrant-sys))
