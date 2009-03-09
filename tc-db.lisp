(in-package :tokyocabinet)

(defclass database ()
  ((connection :accessor get-connection :initarg :connection)
   (db-type    :accessor get-db-type    :initarg :db-type)))

