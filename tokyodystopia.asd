(asdf:defsystem tokyodystopia
    :version "0"
  :description "Interface to Tokyo Dystopia reverse index system"
  :maintainer "Paweł Lasek <pawel.lasek@gmail.com>"
  :author "Paweł Lasek <pawel.lasek@gmail.com>"
  :licence "MIT-X11"
  :depends-on (:cffi :tokyocabinet)
  :serial t
  ;; components likely need manual reordering
  :components ((:file "package-td")
	       (:file "tc-db")
	       (:static-file "tokyodystopia.i" :pathname "tokyodystopia.i")
	       (:file "tokyodystopia"))
  ;; :long-description ""
  )
