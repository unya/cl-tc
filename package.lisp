(defpackage #:tokyocabinet-sys
  (:nicknames #:tc-sys)
  (:use #:cl #:cffi))
(defpackage #:tokyocabinet
    (:nicknames #:tc)
  (:use #:cl #:tokyocabinet-sys))