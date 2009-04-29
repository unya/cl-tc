(defpackage #:tokyocabinet-sys
  (:nicknames #:cl-tc.tc-sys)
  (:use #:cl #:cffi))
(defpackage #:tokyocabinet
    (:nicknames #:cl-tc.tc)
  (:use #:cl #:tokyocabinet-sys))
