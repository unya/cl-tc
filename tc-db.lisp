;;; -*- Mode:Lisp; Syntax:ANSI-Common-Lisp; -*-


(in-package :tokyocabinet)

;;; classes

(defclass database ()
  ((connection :accessor get-connection)
   (db-type    :accessor get-db-type)
   (path       :accessor get-path :initarg :path)
   ))

(defclass hash-database (database)
  ())

(defclass btree-database (database)
  ())

(defclass fixed-length-database (database)
  ())

(defclass table-database (database)
  ())

;;; generic methods

;;(defgeneric get-db-type (db))

(defgeneric open-db (db path)
  (:documentation  "Opens database specified by PATH for database object DB"))
(defgeneric store (db key obj)
  (:documentation  "Stores OBJ identified by KEY in database DB"))
(defgeneric delete (db key)
  (:documentation  "Deletes record from database DB identified by KEY"))
(defgeneric get (db key)
  (:documentation  "Returns a record from database DB identified by KEY"))
(defgeneric get-size (db key)
  (:documentation  "Returns size of record's value"))
(defgeneric sync (db)
  (:documentation  "Synchronises database DB"))
(defgeneric records-p (db)
  (:documentation "Returns the amount of records in database"))
(defgeneric size-p (db)
  (:documentation "Returns the size of database"))

