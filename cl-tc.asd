(asdf:defsystem tokyocabinet
  :version "0"
  :description "Interface to TokyoCabinet database library"
  :maintainer "Paweł Lasek <pawel.lasek@gmail.com>"
  :author "Paweł Lasek <pawel.lasek@gmail.com>"
  :licence "MIT X11"
  :depends-on (:cffi)
  :serial t
  ;; components likely need manual reordering
  :components ((:file "package")
	       (:file "tokyocabinet")
	       (:file "tc-db"))
  ;; :long-description ""
)
  