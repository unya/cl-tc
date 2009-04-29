
(defpackage #:tokyodystopia-sys
  (:nicknames #:cl-tc.td-sys)
  (:use #:cl #:cffi))
(defpackage #:tokyodystopia
    (:nicknames #:cl-tc.td)
  (:use #:cl #:tokyodystopia-sys))
