(in-package :tokyocabinet-sys)
;;; This file was automatically generated by SWIG (http://www.swig.org).
;;; Version 1.3.38
;;;
;;; Do not make changes to this file unless you know what you are doing--modify
;;; the SWIG interface file instead.


;;;SWIG wrapper code starts here

(cl:defmacro defanonenum (&body enums)
   "Converts anonymous enums to defconstants."
  `(cl:progn ,@(cl:loop for value in enums
                        for index = 0 then (cl:1+ index)
                        when (cl:listp value) do (cl:setf index (cl:second value)
                                                          value (cl:first value))
                        collect `(cl:defconstant ,value ,index))))

(cl:eval-when (:compile-toplevel :load-toplevel)
  (cl:unless (cl:fboundp 'swig-lispify)
    (cl:defun swig-lispify (name flag cl:&optional (package cl:*package*))
      (cl:labels ((helper (lst last rest cl:&aux (c (cl:car lst)))
                    (cl:cond
                      ((cl:null lst)
                       rest)
                      ((cl:upper-case-p c)
                       (helper (cl:cdr lst) 'upper
                               (cl:case last
                                 ((lower digit) (cl:list* c #\- rest))
                                 (cl:t (cl:cons c rest)))))
                      ((cl:lower-case-p c)
                       (helper (cl:cdr lst) 'lower (cl:cons (cl:char-upcase c) rest)))
                      ((cl:digit-char-p c)
                       (helper (cl:cdr lst) 'digit 
                               (cl:case last
                                 ((upper lower) (cl:list* c #\- rest))
                                 (cl:t (cl:cons c rest)))))
                      ((cl:char-equal c #\_)
                       (helper (cl:cdr lst) '_ (cl:cons #\- rest)))
                      (cl:t
                       (cl:error "Invalid character: ~A" c)))))
        (cl:let ((fix (cl:case flag
                        ((constant enumvalue) "+")
                        (variable "*")
                        (cl:t ""))))
          (cl:intern
           (cl:concatenate
            'cl:string
            fix
            (cl:nreverse (helper (cl:concatenate 'cl:list name) cl:nil cl:nil))
            fix)
           package))))))

;;;SWIG wrapper code ends here


(cffi:defcfun ("tcxstrnew" tcxstrnew) :pointer)

(cffi:defcfun ("tcxstrnew2" tcxstrnew2) :pointer
  (str :string))

(cffi:defcfun ("tcxstrnew3" tcxstrnew3) :pointer
  (asiz :int))

(cffi:defcfun ("tcxstrdup" tcxstrdup) :pointer
  (xstr :pointer))

(cffi:defcfun ("tcxstrdel" tcxstrdel) :void
  (xstr :pointer))

(cffi:defcfun ("tcxstrcat" tcxstrcat) :void
  (xstr :pointer)
  (ptr :pointer)
  (size :int))

(cffi:defcfun ("tcxstrcat2" tcxstrcat2) :void
  (xstr :pointer)
  (str :string))

(cffi:defcfun ("tcxstrptr" tcxstrptr) :pointer
  (xstr :pointer))

(cffi:defcfun ("tcxstrsize" tcxstrsize) :int
  (xstr :pointer))

(cffi:defcfun ("tcxstrclear" tcxstrclear) :void
  (xstr :pointer))

(cffi:defcfun ("tclistnew" tclistnew) :pointer)

(cffi:defcfun ("tclistnew2" tclistnew2) :pointer
  (anum :int))

(cffi:defcfun ("tclistnew3" tclistnew3) :pointer
  (str :string)
  &rest)

(cffi:defcfun ("tclistdup" tclistdup) :pointer
  (list :pointer))

(cffi:defcfun ("tclistdel" tclistdel) :void
  (list :pointer))

(cffi:defcfun ("tclistnum" tclistnum) :int
  (list :pointer))

(cffi:defcfun ("tclistval" tclistval) :pointer
  (list :pointer)
  (index :int)
  (sp :pointer))

(cffi:defcfun ("tclistval2" tclistval2) :string
  (list :pointer)
  (index :int))

(cffi:defcfun ("tclistpush" tclistpush) :void
  (list :pointer)
  (ptr :pointer)
  (size :int))

(cffi:defcfun ("tclistpush2" tclistpush2) :void
  (list :pointer)
  (str :string))

(cffi:defcfun ("tclistpop" tclistpop) :pointer
  (list :pointer)
  (sp :pointer))

(cffi:defcfun ("tclistpop2" tclistpop2) :string
  (list :pointer))

(cffi:defcfun ("tclistunshift" tclistunshift) :void
  (list :pointer)
  (ptr :pointer)
  (size :int))

(cffi:defcfun ("tclistunshift2" tclistunshift2) :void
  (list :pointer)
  (str :string))

(cffi:defcfun ("tclistshift" tclistshift) :pointer
  (list :pointer)
  (sp :pointer))

(cffi:defcfun ("tclistshift2" tclistshift2) :string
  (list :pointer))

(cffi:defcfun ("tclistinsert" tclistinsert) :void
  (list :pointer)
  (index :int)
  (ptr :pointer)
  (size :int))

(cffi:defcfun ("tclistinsert2" tclistinsert2) :void
  (list :pointer)
  (index :int)
  (str :string))

(cffi:defcfun ("tclistremove" tclistremove) :pointer
  (list :pointer)
  (index :int)
  (sp :pointer))

(cffi:defcfun ("tclistremove2" tclistremove2) :string
  (list :pointer)
  (index :int))

(cffi:defcfun ("tclistover" tclistover) :void
  (list :pointer)
  (index :int)
  (ptr :pointer)
  (size :int))

(cffi:defcfun ("tclistover2" tclistover2) :void
  (list :pointer)
  (index :int)
  (str :string))

(cffi:defcfun ("tclistsort" tclistsort) :void
  (list :pointer))

(cffi:defcfun ("tclistlsearch" tclistlsearch) :int
  (list :pointer)
  (ptr :pointer)
  (size :int))

(cffi:defcfun ("tclistbsearch" tclistbsearch) :int
  (list :pointer)
  (ptr :pointer)
  (size :int))

(cffi:defcfun ("tclistclear" tclistclear) :void
  (list :pointer))

(cffi:defcfun ("tclistdump" tclistdump) :pointer
  (list :pointer)
  (sp :pointer))

(cffi:defcfun ("tclistload" tclistload) :pointer
  (ptr :pointer)
  (size :int))

(cffi:defcfun ("tclistsortci" tclistsortci) :void
  (list :pointer))

(cffi:defcfun ("tclistsortex" tclistsortex) :void
  (list :pointer)
  (cmp :pointer))

(cffi:defcfun ("tclistinvert" tclistinvert) :void
  (list :pointer))

(cffi:defcfun ("tcmapnew" tcmapnew) :pointer)

(cffi:defcfun ("tcmapnew2" tcmapnew2) :pointer
  (bnum :pointer))

(cffi:defcfun ("tcmapnew3" tcmapnew3) :pointer
  (str :string)
  &rest)

(cffi:defcfun ("tcmapdup" tcmapdup) :pointer
  (map :pointer))

(cffi:defcfun ("tcmapdel" tcmapdel) :void
  (map :pointer))

(cffi:defcfun ("tcmapput" tcmapput) :void
  (map :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (vbuf :pointer)
  (vsiz :int))

(cffi:defcfun ("tcmapput2" tcmapput2) :void
  (map :pointer)
  (kstr :string)
  (vstr :string))

(cffi:defcfun ("tcmapputkeep" tcmapputkeep) :pointer
  (map :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (vbuf :pointer)
  (vsiz :int))

(cffi:defcfun ("tcmapputkeep2" tcmapputkeep2) :pointer
  (map :pointer)
  (kstr :string)
  (vstr :string))

(cffi:defcfun ("tcmapputcat" tcmapputcat) :void
  (map :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (vbuf :pointer)
  (vsiz :int))

(cffi:defcfun ("tcmapputcat2" tcmapputcat2) :void
  (map :pointer)
  (kstr :string)
  (vstr :string))

(cffi:defcfun ("tcmapout" tcmapout) :pointer
  (map :pointer)
  (kbuf :pointer)
  (ksiz :int))

(cffi:defcfun ("tcmapout2" tcmapout2) :pointer
  (map :pointer)
  (kstr :string))

(cffi:defcfun ("tcmapget" tcmapget) :pointer
  (map :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (sp :pointer))

(cffi:defcfun ("tcmapget2" tcmapget2) :string
  (map :pointer)
  (kstr :string))

(cffi:defcfun ("tcmapmove" tcmapmove) :pointer
  (map :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (head :pointer))

(cffi:defcfun ("tcmapmove2" tcmapmove2) :pointer
  (map :pointer)
  (kstr :string)
  (head :pointer))

(cffi:defcfun ("tcmapiterinit" tcmapiterinit) :void
  (map :pointer))

(cffi:defcfun ("tcmapiternext" tcmapiternext) :pointer
  (map :pointer)
  (sp :pointer))

(cffi:defcfun ("tcmapiternext2" tcmapiternext2) :string
  (map :pointer))

(cffi:defcfun ("tcmaprnum" tcmaprnum) :pointer
  (map :pointer))

(cffi:defcfun ("tcmapmsiz" tcmapmsiz) :pointer
  (map :pointer))

(cffi:defcfun ("tcmapkeys" tcmapkeys) :pointer
  (map :pointer))

(cffi:defcfun ("tcmapvals" tcmapvals) :pointer
  (map :pointer))

(cffi:defcfun ("tcmapaddint" tcmapaddint) :int
  (map :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (num :int))

(cffi:defcfun ("tcmapadddouble" tcmapadddouble) :double
  (map :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (num :double))

(cffi:defcfun ("tcmapclear" tcmapclear) :void
  (map :pointer))

(cffi:defcfun ("tcmapcutfront" tcmapcutfront) :void
  (map :pointer)
  (num :int))

(cffi:defcfun ("tcmapdump" tcmapdump) :pointer
  (map :pointer)
  (sp :pointer))

(cffi:defcfun ("tcmapload" tcmapload) :pointer
  (ptr :pointer)
  (size :int))

(defanonenum 
	(HDBFOPEN #.(cl:ash 1 0))
	(HDBFFATAL #.(cl:ash 1 1)))

(defanonenum 
	(HDBTLARGE #.(cl:ash 1 0))
	(HDBTDEFLATE #.(cl:ash 1 1))
	(HDBTBZIP #.(cl:ash 1 2))
	(HDBTTCBS #.(cl:ash 1 3))
	(HDBTEXCODEC #.(cl:ash 1 4)))

(defanonenum 
	(HDBOREADER #.(cl:ash 1 0))
	(HDBOWRITER #.(cl:ash 1 1))
	(HDBOCREAT #.(cl:ash 1 2))
	(HDBOTRUNC #.(cl:ash 1 3))
	(HDBONOLCK #.(cl:ash 1 4))
	(HDBOLCKNB #.(cl:ash 1 5))
	(HDBOTSYNC #.(cl:ash 1 6)))

(cffi:defcfun ("tchdbmemsync" tchdbmemsync) :pointer
  (hdb :pointer)
  (phys :pointer))

(cffi:defcfun ("tchdbhasmutex" tchdbhasmutex) :pointer
  (hdb :pointer))

(cffi:defcfun ("tchdbcacheclear" tchdbcacheclear) :pointer
  (hdb :pointer))

(cffi:defcfun ("tchdberrmsg" tchdberrmsg) :string
  (ecode :int))

(cffi:defcfun ("tchdbnew" tchdbnew) :pointer)

(cffi:defcfun ("tchdbdel" tchdbdel) :void
  (hdb :pointer))

(cffi:defcfun ("tchdbecode" tchdbecode) :int
  (hdb :pointer))

(cffi:defcfun ("tchdbsetmutex" tchdbsetmutex) :pointer
  (hdb :pointer))

(cffi:defcfun ("tchdbtune" tchdbtune) :pointer
  (hdb :pointer)
  (bnum :pointer)
  (apow :pointer)
  (fpow :pointer)
  (opts :pointer))

(cffi:defcfun ("tchdbsetcache" tchdbsetcache) :pointer
  (hdb :pointer)
  (rcnum :pointer))

(cffi:defcfun ("tchdbsetxmsiz" tchdbsetxmsiz) :pointer
  (hdb :pointer)
  (xmsiz :pointer))

(cffi:defcfun ("tchdbopen" tchdbopen) :pointer
  (hdb :pointer)
  (path :string)
  (omode :int))

(cffi:defcfun ("tchdbclose" tchdbclose) :pointer
  (hdb :pointer))

(cffi:defcfun ("tchdbput" tchdbput) :pointer
  (hdb :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (vbuf :pointer)
  (vsiz :int))

(cffi:defcfun ("tchdbput2" tchdbput2) :pointer
  (hdb :pointer)
  (kstr :string)
  (vstr :string))

(cffi:defcfun ("tchdbputkeep" tchdbputkeep) :pointer
  (hdb :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (vbuf :pointer)
  (vsiz :int))

(cffi:defcfun ("tchdbputkeep2" tchdbputkeep2) :pointer
  (hdb :pointer)
  (kstr :string)
  (vstr :string))

(cffi:defcfun ("tchdbputcat" tchdbputcat) :pointer
  (hdb :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (vbuf :pointer)
  (vsiz :int))

(cffi:defcfun ("tchdbputcat2" tchdbputcat2) :pointer
  (hdb :pointer)
  (kstr :string)
  (vstr :string))

(cffi:defcfun ("tchdbputasync" tchdbputasync) :pointer
  (hdb :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (vbuf :pointer)
  (vsiz :int))

(cffi:defcfun ("tchdbputasync2" tchdbputasync2) :pointer
  (hdb :pointer)
  (kstr :string)
  (vstr :string))

(cffi:defcfun ("tchdbout" tchdbout) :pointer
  (hdb :pointer)
  (kbuf :pointer)
  (ksiz :int))

(cffi:defcfun ("tchdbout2" tchdbout2) :pointer
  (hdb :pointer)
  (kstr :string))

(cffi:defcfun ("tchdbget" tchdbget) :pointer
  (hdb :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (sp :pointer))

(cffi:defcfun ("tchdbget2" tchdbget2) :string
  (hdb :pointer)
  (kstr :string))

(cffi:defcfun ("tchdbget3" tchdbget3) :int
  (hdb :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (vbuf :pointer)
  (max :int))

(cffi:defcfun ("tchdbvsiz" tchdbvsiz) :int
  (hdb :pointer)
  (kbuf :pointer)
  (ksiz :int))

(cffi:defcfun ("tchdbvsiz2" tchdbvsiz2) :int
  (hdb :pointer)
  (kstr :string))

(cffi:defcfun ("tchdbiterinit" tchdbiterinit) :pointer
  (hdb :pointer))

(cffi:defcfun ("tchdbiternext" tchdbiternext) :pointer
  (hdb :pointer)
  (sp :pointer))

(cffi:defcfun ("tchdbiternext2" tchdbiternext2) :string
  (hdb :pointer))

(cffi:defcfun ("tchdbiternext3" tchdbiternext3) :pointer
  (hdb :pointer)
  (kxstr :pointer)
  (vxstr :pointer))

(cffi:defcfun ("tchdbfwmkeys" tchdbfwmkeys) :pointer
  (hdb :pointer)
  (pbuf :pointer)
  (psiz :int)
  (max :int))

(cffi:defcfun ("tchdbfwmkeys2" tchdbfwmkeys2) :pointer
  (hdb :pointer)
  (pstr :string)
  (max :int))

(cffi:defcfun ("tchdbaddint" tchdbaddint) :int
  (hdb :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (num :int))

(cffi:defcfun ("tchdbadddouble" tchdbadddouble) :double
  (hdb :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (num :double))

(cffi:defcfun ("tchdbsync" tchdbsync) :pointer
  (hdb :pointer))

(cffi:defcfun ("tchdboptimize" tchdboptimize) :pointer
  (hdb :pointer)
  (bnum :pointer)
  (apow :pointer)
  (fpow :pointer)
  (opts :pointer))

(cffi:defcfun ("tchdbvanish" tchdbvanish) :pointer
  (hdb :pointer))

(cffi:defcfun ("tchdbcopy" tchdbcopy) :pointer
  (hdb :pointer)
  (path :string))

(cffi:defcfun ("tchdbtranbegin" tchdbtranbegin) :pointer
  (hdb :pointer))

(cffi:defcfun ("tchdbtrancommit" tchdbtrancommit) :pointer
  (hdb :pointer))

(cffi:defcfun ("tchdbtranabort" tchdbtranabort) :pointer
  (hdb :pointer))

(cffi:defcfun ("tchdbpath" tchdbpath) :string
  (hdb :pointer))

(cffi:defcfun ("tchdbrnum" tchdbrnum) :pointer
  (hdb :pointer))

(cffi:defcfun ("tchdbfsiz" tchdbfsiz) :pointer
  (hdb :pointer))

(defanonenum 
	(BDBFOPEN #.(cl:ash 1 0))
	(BDBFFATAL #.(cl:ash 1 1)))

(defanonenum 
	(BDBTLARGE #.(cl:ash 1 0))
	(BDBTDEFLATE #.(cl:ash 1 1))
	(BDBTBZIP #.(cl:ash 1 2))
	(BDBTTCBS #.(cl:ash 1 3))
	(BDBTEXCODEC #.(cl:ash 1 4)))

(defanonenum 
	(BDBOREADER #.(cl:ash 1 0))
	(BDBOWRITER #.(cl:ash 1 1))
	(BDBOCREAT #.(cl:ash 1 2))
	(BDBOTRUNC #.(cl:ash 1 3))
	(BDBONOLCK #.(cl:ash 1 4))
	(BDBOLCKNB #.(cl:ash 1 5))
	(BDBOTSYNC #.(cl:ash 1 6)))

(cffi:defcstruct BDBCUR
	(bdb :pointer)
	(id :pointer)
	(kidx :pointer)
	(vidx :pointer))

(defanonenum 
	BDBCPCURRENT
	BDBCPBEFORE
	BDBCPAFTER)

(cffi:defcfun ("tcbdberrmsg" tcbdberrmsg) :string
  (ecode :int))

(cffi:defcfun ("tcbdbnew" tcbdbnew) :pointer)

(cffi:defcfun ("tcbdbdel" tcbdbdel) :void
  (bdb :pointer))

(cffi:defcfun ("tcbdbecode" tcbdbecode) :int
  (bdb :pointer))

(cffi:defcfun ("tcbdbsetmutex" tcbdbsetmutex) :pointer
  (bdb :pointer))

(cffi:defcfun ("tcbdbsetcmpfunc" tcbdbsetcmpfunc) :pointer
  (bdb :pointer)
  (cmp :pointer)
  (cmpop :pointer))

(cffi:defcfun ("tcbdbtune" tcbdbtune) :pointer
  (bdb :pointer)
  (lmemb :pointer)
  (nmemb :pointer)
  (bnum :pointer)
  (apow :pointer)
  (fpow :pointer)
  (opts :pointer))

(cffi:defcfun ("tcbdbsetcache" tcbdbsetcache) :pointer
  (bdb :pointer)
  (lcnum :pointer)
  (ncnum :pointer))

(cffi:defcfun ("tcbdbsetxmsiz" tcbdbsetxmsiz) :pointer
  (bdb :pointer)
  (xmsiz :pointer))

(cffi:defcfun ("tcbdbopen" tcbdbopen) :pointer
  (bdb :pointer)
  (path :string)
  (omode :int))

(cffi:defcfun ("tcbdbclose" tcbdbclose) :pointer
  (bdb :pointer))

(cffi:defcfun ("tcbdbput" tcbdbput) :pointer
  (bdb :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (vbuf :pointer)
  (vsiz :int))

(cffi:defcfun ("tcbdbput2" tcbdbput2) :pointer
  (bdb :pointer)
  (kstr :string)
  (vstr :string))

(cffi:defcfun ("tcbdbputkeep" tcbdbputkeep) :pointer
  (bdb :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (vbuf :pointer)
  (vsiz :int))

(cffi:defcfun ("tcbdbputkeep2" tcbdbputkeep2) :pointer
  (bdb :pointer)
  (kstr :string)
  (vstr :string))

(cffi:defcfun ("tcbdbputcat" tcbdbputcat) :pointer
  (bdb :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (vbuf :pointer)
  (vsiz :int))

(cffi:defcfun ("tcbdbputcat2" tcbdbputcat2) :pointer
  (bdb :pointer)
  (kstr :string)
  (vstr :string))

(cffi:defcfun ("tcbdbputdup" tcbdbputdup) :pointer
  (bdb :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (vbuf :pointer)
  (vsiz :int))

(cffi:defcfun ("tcbdbputdup2" tcbdbputdup2) :pointer
  (bdb :pointer)
  (kstr :string)
  (vstr :string))

(cffi:defcfun ("tcbdbputdup3" tcbdbputdup3) :pointer
  (bdb :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (vals :pointer))

(cffi:defcfun ("tcbdbout" tcbdbout) :pointer
  (bdb :pointer)
  (kbuf :pointer)
  (ksiz :int))

(cffi:defcfun ("tcbdbout2" tcbdbout2) :pointer
  (bdb :pointer)
  (kstr :string))

(cffi:defcfun ("tcbdbout3" tcbdbout3) :pointer
  (bdb :pointer)
  (kbuf :pointer)
  (ksiz :int))

(cffi:defcfun ("tcbdbget" tcbdbget) :pointer
  (bdb :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (sp :pointer))

(cffi:defcfun ("tcbdbget2" tcbdbget2) :string
  (bdb :pointer)
  (kstr :string))

(cffi:defcfun ("tcbdbget3" tcbdbget3) :pointer
  (bdb :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (sp :pointer))

(cffi:defcfun ("tcbdbget4" tcbdbget4) :pointer
  (bdb :pointer)
  (kbuf :pointer)
  (ksiz :int))

(cffi:defcfun ("tcbdbvnum" tcbdbvnum) :int
  (bdb :pointer)
  (kbuf :pointer)
  (ksiz :int))

(cffi:defcfun ("tcbdbvnum2" tcbdbvnum2) :int
  (bdb :pointer)
  (kstr :string))

(cffi:defcfun ("tcbdbvsiz" tcbdbvsiz) :int
  (bdb :pointer)
  (kbuf :pointer)
  (ksiz :int))

(cffi:defcfun ("tcbdbvsiz2" tcbdbvsiz2) :int
  (bdb :pointer)
  (kstr :string))

(cffi:defcfun ("tcbdbrange" tcbdbrange) :pointer
  (bdb :pointer)
  (bkbuf :pointer)
  (bksiz :int)
  (binc :pointer)
  (ekbuf :pointer)
  (eksiz :int)
  (einc :pointer)
  (max :int))

(cffi:defcfun ("tcbdbrange2" tcbdbrange2) :pointer
  (bdb :pointer)
  (bkstr :string)
  (binc :pointer)
  (ekstr :string)
  (einc :pointer)
  (max :int))

(cffi:defcfun ("tcbdbfwmkeys" tcbdbfwmkeys) :pointer
  (bdb :pointer)
  (pbuf :pointer)
  (psiz :int)
  (max :int))

(cffi:defcfun ("tcbdbfwmkeys2" tcbdbfwmkeys2) :pointer
  (bdb :pointer)
  (pstr :string)
  (max :int))

(cffi:defcfun ("tcbdbaddint" tcbdbaddint) :int
  (bdb :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (num :int))

(cffi:defcfun ("tcbdbadddouble" tcbdbadddouble) :double
  (bdb :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (num :double))

(cffi:defcfun ("tcbdbsync" tcbdbsync) :pointer
  (bdb :pointer))

(cffi:defcfun ("tcbdboptimize" tcbdboptimize) :pointer
  (bdb :pointer)
  (lmemb :pointer)
  (nmemb :pointer)
  (bnum :pointer)
  (apow :pointer)
  (fpow :pointer)
  (opts :pointer))

(cffi:defcfun ("tcbdbvanish" tcbdbvanish) :pointer
  (bdb :pointer))

(cffi:defcfun ("tcbdbcopy" tcbdbcopy) :pointer
  (bdb :pointer)
  (path :string))

(cffi:defcfun ("tcbdbtranbegin" tcbdbtranbegin) :pointer
  (bdb :pointer))

(cffi:defcfun ("tcbdbtrancommit" tcbdbtrancommit) :pointer
  (bdb :pointer))

(cffi:defcfun ("tcbdbtranabort" tcbdbtranabort) :pointer
  (bdb :pointer))

(cffi:defcfun ("tcbdbpath" tcbdbpath) :string
  (bdb :pointer))

(cffi:defcfun ("tcbdbrnum" tcbdbrnum) :pointer
  (bdb :pointer))

(cffi:defcfun ("tcbdbfsiz" tcbdbfsiz) :pointer
  (bdb :pointer))

(cffi:defcfun ("tcbdbcurnew" tcbdbcurnew) :pointer
  (bdb :pointer))

(cffi:defcfun ("tcbdbcurdel" tcbdbcurdel) :void
  (cur :pointer))

(cffi:defcfun ("tcbdbcurfirst" tcbdbcurfirst) :pointer
  (cur :pointer))

(cffi:defcfun ("tcbdbcurlast" tcbdbcurlast) :pointer
  (cur :pointer))

(cffi:defcfun ("tcbdbcurjump" tcbdbcurjump) :pointer
  (cur :pointer)
  (kbuf :pointer)
  (ksiz :int))

(cffi:defcfun ("tcbdbcurjump2" tcbdbcurjump2) :pointer
  (cur :pointer)
  (kstr :string))

(cffi:defcfun ("tcbdbcurprev" tcbdbcurprev) :pointer
  (cur :pointer))

(cffi:defcfun ("tcbdbcurnext" tcbdbcurnext) :pointer
  (cur :pointer))

(cffi:defcfun ("tcbdbcurput" tcbdbcurput) :pointer
  (cur :pointer)
  (vbuf :pointer)
  (vsiz :int)
  (cpmode :int))

(cffi:defcfun ("tcbdbcurput2" tcbdbcurput2) :pointer
  (cur :pointer)
  (vstr :string)
  (cpmode :int))

(cffi:defcfun ("tcbdbcurout" tcbdbcurout) :pointer
  (cur :pointer))

(cffi:defcfun ("tcbdbcurkey" tcbdbcurkey) :pointer
  (cur :pointer)
  (sp :pointer))

(cffi:defcfun ("tcbdbcurkey2" tcbdbcurkey2) :string
  (cur :pointer))

(cffi:defcfun ("tcbdbcurkey3" tcbdbcurkey3) :pointer
  (cur :pointer)
  (sp :pointer))

(cffi:defcfun ("tcbdbcurval" tcbdbcurval) :pointer
  (cur :pointer)
  (sp :pointer))

(cffi:defcfun ("tcbdbcurval2" tcbdbcurval2) :string
  (cur :pointer))

(cffi:defcfun ("tcbdbcurval3" tcbdbcurval3) :pointer
  (cur :pointer)
  (sp :pointer))

(cffi:defcfun ("tcbdbcurrec" tcbdbcurrec) :pointer
  (cur :pointer)
  (kxstr :pointer)
  (vxstr :pointer))

(cffi:defcfun ("tcbdbhasmutex" tcbdbhasmutex) :pointer
  (bdb :pointer))

(cffi:defcfun ("tcbdbmemsync" tcbdbmemsync) :pointer
  (bdb :pointer)
  (phys :pointer))

(cffi:defcfun ("tcbdbcacheclear" tcbdbcacheclear) :pointer
  (bdb :pointer))

(cffi:defcfun ("tcbdbcmpfunc" tcbdbcmpfunc) :pointer
  (bdb :pointer))

(cffi:defcfun ("tcbdbforeach" tcbdbforeach) :pointer
  (bdb :pointer)
  (iter :pointer)
  (op :pointer))

(defanonenum 
	(FDBFOPEN #.(cl:ash 1 0))
	(FDBFFATAL #.(cl:ash 1 1)))

(defanonenum 
	(FDBOREADER #.(cl:ash 1 0))
	(FDBOWRITER #.(cl:ash 1 1))
	(FDBOCREAT #.(cl:ash 1 2))
	(FDBOTRUNC #.(cl:ash 1 3))
	(FDBONOLCK #.(cl:ash 1 4))
	(FDBOLCKNB #.(cl:ash 1 5)))

(defanonenum 
	(FDBIDMIN #.-1)
	(FDBIDPREV #.-2)
	(FDBIDMAX #.-3)
	(FDBIDNEXT #.-4))

(cffi:defcfun ("tcfdberrmsg" tcfdberrmsg) :string
  (ecode :int))

(cffi:defcfun ("tcfdbnew" tcfdbnew) :pointer)

(cffi:defcfun ("tcfdbdel" tcfdbdel) :void
  (fdb :pointer))

(cffi:defcfun ("tcfdbecode" tcfdbecode) :int
  (fdb :pointer))

(cffi:defcfun ("tcfdbsetmutex" tcfdbsetmutex) :pointer
  (fdb :pointer))

(cffi:defcfun ("tcfdbtune" tcfdbtune) :pointer
  (fdb :pointer)
  (width :pointer)
  (limsiz :pointer))

(cffi:defcfun ("tcfdbopen" tcfdbopen) :pointer
  (fdb :pointer)
  (path :string)
  (omode :int))

(cffi:defcfun ("tcfdbclose" tcfdbclose) :pointer
  (fdb :pointer))

(cffi:defcfun ("tcfdbput" tcfdbput) :pointer
  (fdb :pointer)
  (id :pointer)
  (vbuf :pointer)
  (vsiz :int))

(cffi:defcfun ("tcfdbput2" tcfdbput2) :pointer
  (fdb :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (vbuf :pointer)
  (vsiz :int))

(cffi:defcfun ("tcfdbput3" tcfdbput3) :pointer
  (fdb :pointer)
  (kstr :string)
  (vstr :pointer))

(cffi:defcfun ("tcfdbputkeep" tcfdbputkeep) :pointer
  (fdb :pointer)
  (id :pointer)
  (vbuf :pointer)
  (vsiz :int))

(cffi:defcfun ("tcfdbputkeep2" tcfdbputkeep2) :pointer
  (fdb :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (vbuf :pointer)
  (vsiz :int))

(cffi:defcfun ("tcfdbputkeep3" tcfdbputkeep3) :pointer
  (fdb :pointer)
  (kstr :string)
  (vstr :pointer))

(cffi:defcfun ("tcfdbputcat" tcfdbputcat) :pointer
  (fdb :pointer)
  (id :pointer)
  (vbuf :pointer)
  (vsiz :int))

(cffi:defcfun ("tcfdbputcat2" tcfdbputcat2) :pointer
  (fdb :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (vbuf :pointer)
  (vsiz :int))

(cffi:defcfun ("tcfdbputcat3" tcfdbputcat3) :pointer
  (fdb :pointer)
  (kstr :string)
  (vstr :pointer))

(cffi:defcfun ("tcfdbout" tcfdbout) :pointer
  (fdb :pointer)
  (id :pointer))

(cffi:defcfun ("tcfdbout2" tcfdbout2) :pointer
  (fdb :pointer)
  (kbuf :pointer)
  (ksiz :int))

(cffi:defcfun ("tcfdbout3" tcfdbout3) :pointer
  (fdb :pointer)
  (kstr :string))

(cffi:defcfun ("tcfdbget" tcfdbget) :pointer
  (fdb :pointer)
  (id :pointer)
  (sp :pointer))

(cffi:defcfun ("tcfdbget2" tcfdbget2) :pointer
  (fdb :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (sp :pointer))

(cffi:defcfun ("tcfdbget3" tcfdbget3) :string
  (fdb :pointer)
  (kstr :string))

(cffi:defcfun ("tcfdbget4" tcfdbget4) :int
  (fdb :pointer)
  (id :pointer)
  (vbuf :pointer)
  (max :int))

(cffi:defcfun ("tcfdbvsiz" tcfdbvsiz) :int
  (fdb :pointer)
  (id :pointer))

(cffi:defcfun ("tcfdbvsiz2" tcfdbvsiz2) :int
  (fdb :pointer)
  (kbuf :pointer)
  (ksiz :int))

(cffi:defcfun ("tcfdbvsiz3" tcfdbvsiz3) :int
  (fdb :pointer)
  (kstr :string))

(cffi:defcfun ("tcfdbiterinit" tcfdbiterinit) :pointer
  (fdb :pointer))

(cffi:defcfun ("tcfdbiternext" tcfdbiternext) :pointer
  (fdb :pointer))

(cffi:defcfun ("tcfdbiternext2" tcfdbiternext2) :pointer
  (fdb :pointer)
  (sp :pointer))

(cffi:defcfun ("tcfdbiternext3" tcfdbiternext3) :string
  (fdb :pointer))

(cffi:defcfun ("tcfdbrange" tcfdbrange) :pointer
  (fdb :pointer)
  (lower :pointer)
  (upper :pointer)
  (max :int)
  (np :pointer))

(cffi:defcfun ("tcfdbrange2" tcfdbrange2) :pointer
  (fdb :pointer)
  (lbuf :pointer)
  (lsiz :int)
  (ubuf :pointer)
  (usiz :int)
  (max :int))

(cffi:defcfun ("tcfdbrange3" tcfdbrange3) :pointer
  (fdb :pointer)
  (lstr :string)
  (ustr :string)
  (max :int))

(cffi:defcfun ("tcfdbrange4" tcfdbrange4) :pointer
  (fdb :pointer)
  (ibuf :pointer)
  (isiz :int)
  (max :int))

(cffi:defcfun ("tcfdbrange5" tcfdbrange5) :pointer
  (fdb :pointer)
  (istr :pointer)
  (max :int))

(cffi:defcfun ("tcfdbaddint" tcfdbaddint) :int
  (fdb :pointer)
  (id :pointer)
  (num :int))

(cffi:defcfun ("tcfdbadddouble" tcfdbadddouble) :double
  (fdb :pointer)
  (id :pointer)
  (num :double))

(cffi:defcfun ("tcfdbsync" tcfdbsync) :pointer
  (fdb :pointer))

(cffi:defcfun ("tcfdboptimize" tcfdboptimize) :pointer
  (fdb :pointer)
  (width :pointer)
  (limsiz :pointer))

(cffi:defcfun ("tcfdbvanish" tcfdbvanish) :pointer
  (fdb :pointer))

(cffi:defcfun ("tcfdbcopy" tcfdbcopy) :pointer
  (fdb :pointer)
  (path :string))

(cffi:defcfun ("tcfdbpath" tcfdbpath) :string
  (fdb :pointer))

(cffi:defcfun ("tcfdbrnum" tcfdbrnum) :pointer
  (fdb :pointer))

(cffi:defcfun ("tcfdbfsiz" tcfdbfsiz) :pointer
  (fdb :pointer))

(cffi:defcfun ("tcfdbhasmutex" tcfdbhasmutex) :pointer
  (fdb :pointer))

(cffi:defcfun ("tcfdbmemsync" tcfdbmemsync) :pointer
  (fdb :pointer)
  (phys :pointer))

(cffi:defcfun ("tcfdbputproc" tcfdbputproc) :pointer
  (fdb :pointer)
  (id :pointer)
  (vbuf :pointer)
  (vsiz :int)
  (proc :pointer)
  (op :pointer))

(cffi:defcfun ("tcfdbforeach" tcfdbforeach) :pointer
  (fdb :pointer)
  (iter :pointer)
  (op :pointer))

(defanonenum 
	(TDBFOPEN #.(cl:ash 1 0))
	(TDBFFATAL #.(cl:ash 1 1)))

(defanonenum 
	(TDBTLARGE #.(cl:ash 1 0))
	(TDBTDEFLATE #.(cl:ash 1 1))
	(TDBTBZIP #.(cl:ash 1 2))
	(TDBTTCBS #.(cl:ash 1 3))
	(TDBTEXCODEC #.(cl:ash 1 4)))

(defanonenum 
	(TDBOREADER #.(cl:ash 1 0))
	(TDBOWRITER #.(cl:ash 1 1))
	(TDBOCREAT #.(cl:ash 1 2))
	(TDBOTRUNC #.(cl:ash 1 3))
	(TDBONOLCK #.(cl:ash 1 4))
	(TDBOLCKNB #.(cl:ash 1 5))
	(TDBOTSYNC #.(cl:ash 1 6)))

(defanonenum 
	TDBITLEXICAL
	TDBITDECIMAL
	(TDBITOPT #.9998)
	(TDBITVOID #.9999)
	(TDBITKEEP #.(cl:ash 1 24)))

(cffi:defcstruct TDBCOND
	(name :string)
	(nsiz :int)
	(op :int)
	(sign :pointer)
	(noidx :pointer)
	(expr :string)
	(esiz :int)
	(alive :pointer))

(cffi:defcstruct TDBQRY
	(tdb :pointer)
	(conds :pointer)
	(cnum :int)
	(oname :string)
	(otype :int)
	(max :int)
	(hint :pointer))

(defanonenum 
	TDBQCSTREQ
	TDBQCSTRINC
	TDBQCSTRBW
	TDBQCSTREW
	TDBQCSTRAND
	TDBQCSTROR
	TDBQCSTROREQ
	TDBQCSTRRX
	TDBQCNUMEQ
	TDBQCNUMGT
	TDBQCNUMGE
	TDBQCNUMLT
	TDBQCNUMLE
	TDBQCNUMBT
	TDBQCNUMOREQ
	(TDBQCNEGATE #.(cl:ash 1 24))
	(TDBQCNOIDX #.(cl:ash 1 25)))

(defanonenum 
	TDBQOSTRASC
	TDBQOSTRDESC
	TDBQONUMASC
	TDBQONUMDESC)

(defanonenum 
	(TDBQPPUT #.(cl:ash 1 0))
	(TDBQPOUT #.(cl:ash 1 1))
	(TDBQPSTOP #.(cl:ash 1 24)))

(cffi:defcfun ("tctdberrmsg" tctdberrmsg) :string
  (ecode :int))

(cffi:defcfun ("tctdbnew" tctdbnew) :pointer)

(cffi:defcfun ("tctdbdel" tctdbdel) :void
  (tdb :pointer))

(cffi:defcfun ("tctdbecode" tctdbecode) :int
  (tdb :pointer))

(cffi:defcfun ("tctdbsetmutex" tctdbsetmutex) :pointer
  (tdb :pointer))

(cffi:defcfun ("tctdbtune" tctdbtune) :pointer
  (tdb :pointer)
  (bnum :pointer)
  (apow :pointer)
  (fpow :pointer)
  (opts :pointer))

(cffi:defcfun ("tctdbsetcache" tctdbsetcache) :pointer
  (tdb :pointer)
  (rcnum :pointer)
  (lcnum :pointer)
  (ncnum :pointer))

(cffi:defcfun ("tctdbsetxmsiz" tctdbsetxmsiz) :pointer
  (tdb :pointer)
  (xmsiz :pointer))

(cffi:defcfun ("tctdbopen" tctdbopen) :pointer
  (tdb :pointer)
  (path :string)
  (omode :int))

(cffi:defcfun ("tctdbclose" tctdbclose) :pointer
  (tdb :pointer))

(cffi:defcfun ("tctdbput" tctdbput) :pointer
  (tdb :pointer)
  (pkbuf :pointer)
  (pksiz :int)
  (cols :pointer))

(cffi:defcfun ("tctdbput2" tctdbput2) :pointer
  (tdb :pointer)
  (pkbuf :pointer)
  (pksiz :int)
  (cbuf :pointer)
  (csiz :int))

(cffi:defcfun ("tctdbput3" tctdbput3) :pointer
  (tdb :pointer)
  (pkstr :string)
  (cstr :string))

(cffi:defcfun ("tctdbputkeep" tctdbputkeep) :pointer
  (tdb :pointer)
  (pkbuf :pointer)
  (pksiz :int)
  (cols :pointer))

(cffi:defcfun ("tctdbputkeep2" tctdbputkeep2) :pointer
  (tdb :pointer)
  (pkbuf :pointer)
  (pksiz :int)
  (cbuf :pointer)
  (csiz :int))

(cffi:defcfun ("tctdbputkeep3" tctdbputkeep3) :pointer
  (tdb :pointer)
  (pkstr :string)
  (cstr :string))

(cffi:defcfun ("tctdbputcat" tctdbputcat) :pointer
  (tdb :pointer)
  (pkbuf :pointer)
  (pksiz :int)
  (cols :pointer))

(cffi:defcfun ("tctdbputcat2" tctdbputcat2) :pointer
  (tdb :pointer)
  (pkbuf :pointer)
  (pksiz :int)
  (cbuf :pointer)
  (csiz :int))

(cffi:defcfun ("tctdbputcat3" tctdbputcat3) :pointer
  (tdb :pointer)
  (pkstr :string)
  (cstr :string))

(cffi:defcfun ("tctdbout" tctdbout) :pointer
  (tdb :pointer)
  (pkbuf :pointer)
  (pksiz :int))

(cffi:defcfun ("tctdbout2" tctdbout2) :pointer
  (tdb :pointer)
  (pkstr :string))

(cffi:defcfun ("tctdbget" tctdbget) :pointer
  (tdb :pointer)
  (pkbuf :pointer)
  (pksiz :int))

(cffi:defcfun ("tctdbget2" tctdbget2) :string
  (tdb :pointer)
  (pkbuf :pointer)
  (pksiz :int)
  (sp :pointer))

(cffi:defcfun ("tctdbget3" tctdbget3) :string
  (tdb :pointer)
  (pkstr :string))

(cffi:defcfun ("tctdbvsiz" tctdbvsiz) :int
  (tdb :pointer)
  (pkbuf :pointer)
  (pksiz :int))

(cffi:defcfun ("tctdbvsiz2" tctdbvsiz2) :int
  (tdb :pointer)
  (pkstr :string))

(cffi:defcfun ("tctdbiterinit" tctdbiterinit) :pointer
  (tdb :pointer))

(cffi:defcfun ("tctdbiternext" tctdbiternext) :pointer
  (tdb :pointer)
  (sp :pointer))

(cffi:defcfun ("tctdbiternext2" tctdbiternext2) :string
  (tdb :pointer))

(cffi:defcfun ("tctdbfwmkeys" tctdbfwmkeys) :pointer
  (tdb :pointer)
  (pbuf :pointer)
  (psiz :int)
  (max :int))

(cffi:defcfun ("tctdbfwmkeys2" tctdbfwmkeys2) :pointer
  (tdb :pointer)
  (pstr :string)
  (max :int))

(cffi:defcfun ("tctdbaddint" tctdbaddint) :int
  (tdb :pointer)
  (pkbuf :pointer)
  (pksiz :int)
  (num :int))

(cffi:defcfun ("tctdbadddouble" tctdbadddouble) :double
  (tdb :pointer)
  (pkbuf :pointer)
  (pksiz :int)
  (num :double))

(cffi:defcfun ("tctdbsync" tctdbsync) :pointer
  (tdb :pointer))

(cffi:defcfun ("tctdboptimize" tctdboptimize) :pointer
  (tdb :pointer)
  (bnum :pointer)
  (apow :pointer)
  (fpow :pointer)
  (opts :pointer))

(cffi:defcfun ("tctdbvanish" tctdbvanish) :pointer
  (tdb :pointer))

(cffi:defcfun ("tctdbcopy" tctdbcopy) :pointer
  (tdb :pointer)
  (path :string))

(cffi:defcfun ("tctdbtranbegin" tctdbtranbegin) :pointer
  (tdb :pointer))

(cffi:defcfun ("tctdbtrancommit" tctdbtrancommit) :pointer
  (tdb :pointer))

(cffi:defcfun ("tctdbtranabort" tctdbtranabort) :pointer
  (tdb :pointer))

(cffi:defcfun ("tctdbpath" tctdbpath) :string
  (tdb :pointer))

(cffi:defcfun ("tctdbrnum" tctdbrnum) :pointer
  (tdb :pointer))

(cffi:defcfun ("tctdbfsiz" tctdbfsiz) :pointer
  (tdb :pointer))

(cffi:defcfun ("tctdbsetindex" tctdbsetindex) :pointer
  (tdb :pointer)
  (name :string)
  (type :int))

(cffi:defcfun ("tctdbgenuid" tctdbgenuid) :pointer
  (tdb :pointer))

(cffi:defcfun ("tctdbqrynew" tctdbqrynew) :pointer
  (tdb :pointer))

(cffi:defcfun ("tctdbqrydel" tctdbqrydel) :void
  (qry :pointer))

(cffi:defcfun ("tctdbqryaddcond" tctdbqryaddcond) :void
  (qry :pointer)
  (name :string)
  (op :int)
  (expr :string))

(cffi:defcfun ("tctdbqrysetorder" tctdbqrysetorder) :void
  (qry :pointer)
  (name :string)
  (type :int))

(cffi:defcfun ("tctdbqrysetmax" tctdbqrysetmax) :void
  (qry :pointer)
  (max :int))

(cffi:defcfun ("tctdbqrysearch" tctdbqrysearch) :pointer
  (qry :pointer))

(cffi:defcfun ("tctdbqrysearchout" tctdbqrysearchout) :pointer
  (qry :pointer))

(cffi:defcfun ("tctdbqryproc" tctdbqryproc) :pointer
  (qry :pointer)
  (proc :pointer)
  (op :pointer))

(cffi:defcfun ("tctdbqryhint" tctdbqryhint) :string
  (qry :pointer))

(cffi:defcfun ("tctdbhasmutex" tctdbhasmutex) :pointer
  (tdb :pointer))

(cffi:defcfun ("tctdbmemsync" tctdbmemsync) :pointer
  (tdb :pointer)
  (phys :pointer))

(cffi:defcfun ("tctdbforeach" tctdbforeach) :pointer
  (tdb :pointer)
  (iter :pointer)
  (op :pointer))

(cffi:defcfun ("tctdbstrtoindextype" tctdbstrtoindextype) :int
  (str :string))

(cffi:defcfun ("tctdbqrystrtocondop" tctdbqrystrtocondop) :int
  (str :string))

(cffi:defcfun ("tctdbqrystrtoordertype" tctdbqrystrtoordertype) :int
  (str :string))

(defanonenum 
	ADBOVOID
	ADBOMDB
	ADBONDB
	ADBOHDB
	ADBOBDB
	ADBOFDB
	ADBOTDB)

(cffi:defcfun ("tcadbnew" tcadbnew) :pointer)

(cffi:defcfun ("tcadbdel" tcadbdel) :void
  (adb :pointer))

(cffi:defcfun ("tcadbopen" tcadbopen) :pointer
  (adb :pointer)
  (name :string))

(cffi:defcfun ("tcadbclose" tcadbclose) :pointer
  (adb :pointer))

(cffi:defcfun ("tcadbput" tcadbput) :pointer
  (adb :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (vbuf :pointer)
  (vsiz :int))

(cffi:defcfun ("tcadbput2" tcadbput2) :pointer
  (adb :pointer)
  (kstr :string)
  (vstr :string))

(cffi:defcfun ("tcadbputkeep" tcadbputkeep) :pointer
  (adb :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (vbuf :pointer)
  (vsiz :int))

(cffi:defcfun ("tcadbputkeep2" tcadbputkeep2) :pointer
  (adb :pointer)
  (kstr :string)
  (vstr :string))

(cffi:defcfun ("tcadbputcat" tcadbputcat) :pointer
  (adb :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (vbuf :pointer)
  (vsiz :int))

(cffi:defcfun ("tcadbputcat2" tcadbputcat2) :pointer
  (adb :pointer)
  (kstr :string)
  (vstr :string))

(cffi:defcfun ("tcadbout" tcadbout) :pointer
  (adb :pointer)
  (kbuf :pointer)
  (ksiz :int))

(cffi:defcfun ("tcadbout2" tcadbout2) :pointer
  (adb :pointer)
  (kstr :string))

(cffi:defcfun ("tcadbget" tcadbget) :pointer
  (adb :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (sp :pointer))

(cffi:defcfun ("tcadbget2" tcadbget2) :string
  (adb :pointer)
  (kstr :string))

(cffi:defcfun ("tcadbvsiz" tcadbvsiz) :int
  (adb :pointer)
  (kbuf :pointer)
  (ksiz :int))

(cffi:defcfun ("tcadbvsiz2" tcadbvsiz2) :int
  (adb :pointer)
  (kstr :string))

(cffi:defcfun ("tcadbiterinit" tcadbiterinit) :pointer
  (adb :pointer))

(cffi:defcfun ("tcadbiternext" tcadbiternext) :pointer
  (adb :pointer)
  (sp :pointer))

(cffi:defcfun ("tcadbiternext2" tcadbiternext2) :string
  (adb :pointer))

(cffi:defcfun ("tcadbfwmkeys" tcadbfwmkeys) :pointer
  (adb :pointer)
  (pbuf :pointer)
  (psiz :int)
  (max :int))

(cffi:defcfun ("tcadbfwmkeys2" tcadbfwmkeys2) :pointer
  (adb :pointer)
  (pstr :string)
  (max :int))

(cffi:defcfun ("tcadbaddint" tcadbaddint) :int
  (adb :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (num :int))

(cffi:defcfun ("tcadbadddouble" tcadbadddouble) :double
  (adb :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (num :double))

(cffi:defcfun ("tcadbsync" tcadbsync) :pointer
  (adb :pointer))

(cffi:defcfun ("tcadbvanish" tcadbvanish) :pointer
  (adb :pointer))

(cffi:defcfun ("tcadbcopy" tcadbcopy) :pointer
  (adb :pointer)
  (path :string))

(cffi:defcfun ("tcadbrnum" tcadbrnum) :pointer
  (adb :pointer))

(cffi:defcfun ("tcadbsize" tcadbsize) :pointer
  (adb :pointer))

(cffi:defcfun ("tcadbmisc" tcadbmisc) :pointer
  (adb :pointer)
  (name :string)
  (args :pointer))

(cffi:defcfun ("tcadbomode" tcadbomode) :int
  (adb :pointer))

(cffi:defcfun ("tcadbreveal" tcadbreveal) :pointer
  (adb :pointer))

(cffi:defcfun ("tcadbputproc" tcadbputproc) :pointer
  (adb :pointer)
  (kbuf :pointer)
  (ksiz :int)
  (vbuf :string)
  (vsiz :int)
  (proc :pointer)
  (op :pointer))

(cffi:defcfun ("tcadbforeach" tcadbforeach) :pointer
  (adb :pointer)
  (iter :pointer)
  (op :pointer))


