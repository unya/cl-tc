%module tokyotyrant
%insert("lisphead") %{
(in-package :tokyotyrant-sys)
(define-foreign-library tokyotyrant
  (:unix (:or "libtokyotyrant.so.7" "libtokyotyrant.so"))
  (t (:default "libtokyotyrant")))
(use-foreign-library tokyotyrant)

%}

typedef struct {                         /* type of structure for a remote database */
  int fd;                                /* file descriptor */
  TTSOCK *sock;                          /* socket object */
  int ecode;                             /* last happened error code */
} TCRDB;

enum {                                   /* enumeration for error codes */
  TTESUCCESS,                            /* success */
  TTEINVALID,                            /* invalid operation */
  TTENOHOST,                             /* host not found */
  TTEREFUSED,                            /* connection refused */
  TTESEND,                               /* send error */
  TTERECV,                               /* recv error */
  TTEKEEP,                               /* existing record */
  TTENOREC,                              /* no record found */
  TTEMISC = 9999                         /* miscellaneous error */
};

enum {                                   /* enumeration for scripting extension options */
  RDBXOLCKREC = 1 << 0,                  /* record locking */
  RDBXOLCKGLB = 1 << 1                   /* global locking */
};

enum {                                   /* enumeration for scripting extension options */
  RDBMONOULOG = 1 << 0                   /* omission of update log */
};


/* Get the message string corresponding to an error code.
   `ecode' specifies the error code.
   The return value is the message string of the error code. */
const char *tcrdberrmsg(int ecode);


/* Create a remote database object.
   The return value is the new remote database object. */
TCRDB *tcrdbnew(void);


/* Delete a remote database object.
   `rdb' specifies the remote database object. */
void tcrdbdel(TCRDB *rdb);


/* Get the last happened error code of a remote database object.
   `rdb' specifies the remote database object.
   The return value is the last happened error code.
   The following error code is defined: `TTESUCCESS' for success, `TTEINVALID' for invalid
   operation, `TTENOHOST' for host not found, `TTEREFUSED' for connection refused, `TTESEND' for
   send error, `TTERECV' for recv error, `TTEKEEP' for existing record, `TTENOREC' for no record
   found, `TTEMISC' for miscellaneous error. */
int tcrdbecode(TCRDB *rdb);


/* Open a remote database.
   `rdb' specifies the remote database object.
   `host' specifies the name or the address of the server.
   `port' specifies the port number.  If it is not more than 0, UNIX domain socket is used and
   the path of the socket file is specified by the host parameter.
   If successful, the return value is true, else, it is false. */
bool tcrdbopen(TCRDB *rdb, const char *host, int port);


/* Close a remote database object.
   `rdb' specifies the remote database object.
   If successful, the return value is true, else, it is false. */
bool tcrdbclose(TCRDB *rdb);


/* Store a record into a remote database object.
   `rdb' specifies the remote database object.
   `kbuf' specifies the pointer to the region of the key.
   `ksiz' specifies the size of the region of the key.
   `vbuf' specifies the pointer to the region of the value.
   `vsiz' specifies the size of the region of the value.
   If successful, the return value is true, else, it is false.
   If a record with the same key exists in the database, it is overwritten. */
bool tcrdbput(TCRDB *rdb, const void *kbuf, int ksiz, const void *vbuf, int vsiz);


/* Store a string record into a remote object.
   `rdb' specifies the remote database object.
   `kstr' specifies the string of the key.
   `vstr' specifies the string of the value.
   If successful, the return value is true, else, it is false.
   If a record with the same key exists in the database, it is overwritten. */
bool tcrdbput2(TCRDB *rdb, const char *kstr, const char *vstr);


/* Store a new record into a remote database object.
   `rdb' specifies the remote database object.
   `kbuf' specifies the pointer to the region of the key.
   `ksiz' specifies the size of the region of the key.
   `vbuf' specifies the pointer to the region of the value.
   `vsiz' specifies the size of the region of the value.
   If successful, the return value is true, else, it is false.
   If a record with the same key exists in the database, this function has no effect. */
bool tcrdbputkeep(TCRDB *rdb, const void *kbuf, int ksiz, const void *vbuf, int vsiz);


/* Store a new string record into a remote database object.
   `rdb' specifies the remote database object.
   `kstr' specifies the string of the key.
   `vstr' specifies the string of the value.
   If successful, the return value is true, else, it is false.
   If a record with the same key exists in the database, this function has no effect. */
bool tcrdbputkeep2(TCRDB *rdb, const char *kstr, const char *vstr);


/* Concatenate a value at the end of the existing record in a remote database object.
   `rdb' specifies the remote database object.
   `kbuf' specifies the pointer to the region of the key.
   `ksiz' specifies the size of the region of the key.
   `vbuf' specifies the pointer to the region of the value.
   `vsiz' specifies the size of the region of the value.
   If successful, the return value is true, else, it is false.
   If there is no corresponding record, a new record is created. */
bool tcrdbputcat(TCRDB *rdb, const void *kbuf, int ksiz, const void *vbuf, int vsiz);


/* Concatenate a string value at the end of the existing record in a remote database object.
   `rdb' specifies the remote database object.
   `kstr' specifies the string of the key.
   `vstr' specifies the string of the value.
   If successful, the return value is true, else, it is false.
   If there is no corresponding record, a new record is created. */
bool tcrdbputcat2(TCRDB *rdb, const char *kstr, const char *vstr);


/* Concatenate a value at the end of the existing record and shift it to the left.
   `rdb' specifies the remote database object.
   `kbuf' specifies the pointer to the region of the key.
   `ksiz' specifies the size of the region of the key.
   `vbuf' specifies the pointer to the region of the value.
   `vsiz' specifies the size of the region of the value.
   `width' specifies the width of the record.
   If successful, the return value is true, else, it is false.
   If there is no corresponding record, a new record is created. */
bool tcrdbputshl(TCRDB *rdb, const void *kbuf, int ksiz, const void *vbuf, int vsiz, int width);


/* Concatenate a string value at the end of the existing record and shift it to the left.
   `rdb' specifies the remote database object.
   `kstr' specifies the string of the key.
   `vstr' specifies the string of the value.
   `width' specifies the width of the record.
   If successful, the return value is true, else, it is false.
   If there is no corresponding record, a new record is created. */
bool tcrdbputshl2(TCRDB *rdb, const char *kstr, const char *vstr, int width);


/* Store a record into a remote database object without response from the server.
   `rdb' specifies the remote database object.
   `kbuf' specifies the pointer to the region of the key.
   `ksiz' specifies the size of the region of the key.
   `vbuf' specifies the pointer to the region of the value.
   `vsiz' specifies the size of the region of the value.
   If successful, the return value is true, else, it is false.
   If a record with the same key exists in the database, it is overwritten. */
bool tcrdbputnr(TCRDB *rdb, const void *kbuf, int ksiz, const void *vbuf, int vsiz);


/* Store a string record into a remote object without response from the server.
   `rdb' specifies the remote database object.
   `kstr' specifies the string of the key.
   `vstr' specifies the string of the value.
   If successful, the return value is true, else, it is false.
   If a record with the same key exists in the database, it is overwritten. */
bool tcrdbputnr2(TCRDB *rdb, const char *kstr, const char *vstr);


/* Remove a record of a remote database object.
   `rdb' specifies the remote database object.
   `kbuf' specifies the pointer to the region of the key.
   `ksiz' specifies the size of the region of the key.
   If successful, the return value is true, else, it is false. */
bool tcrdbout(TCRDB *rdb, const void *kbuf, int ksiz);


/* Remove a string record of a remote database object.
   `rdb' specifies the remote database object.
   `kstr' specifies the string of the key.
   If successful, the return value is true, else, it is false. */
bool tcrdbout2(TCRDB *rdb, const char *kstr);


/* Retrieve a record in a remote database object.
   `rdb' specifies the remote database object.
   `kbuf' specifies the pointer to the region of the key.
   `ksiz' specifies the size of the region of the key.
   `sp' specifies the pointer to the variable into which the size of the region of the return
   value is assigned.
   If successful, the return value is the pointer to the region of the value of the corresponding
   record.  `NULL' is returned if no record corresponds.
   Because an additional zero code is appended at the end of the region of the return value,
   the return value can be treated as a character string.  Because the region of the return
   value is allocated with the `malloc' call, it should be released with the `free' call when
   it is no longer in use. */
void *tcrdbget(TCRDB *rdb, const void *kbuf, int ksiz, int *sp);


/* Retrieve a string record in a remote database object.
   `rdb' specifies the remote database object.
   `kstr' specifies the string of the key.
   If successful, the return value is the string of the value of the corresponding record.
   `NULL' is returned if no record corresponds.
   Because the region of the return value is allocated with the `malloc' call, it should be
   released with the `free' call when it is no longer in use. */
char *tcrdbget2(TCRDB *rdb, const char *kstr);


/* Retrieve records in a remote database object.
   `rdb' specifies the remote database object.
   `recs' specifies a map object containing the retrieval keys.  As a result of this function,
   keys existing in the database have the corresponding values and keys not existing in the
   database are removed.
   If successful, the return value is true, else, it is false. */
bool tcrdbget3(TCRDB *rdb, TCMAP *recs);


/* Get the size of the value of a record in a remote database object.
   `rdb' specifies the remote database object.
   `kbuf' specifies the pointer to the region of the key.
   `ksiz' specifies the size of the region of the key.
   If successful, the return value is the size of the value of the corresponding record, else,
   it is -1. */
int tcrdbvsiz(TCRDB *rdb, const void *kbuf, int ksiz);


/* Get the size of the value of a string record in a remote database object.
   `rdb' specifies the remote database object.
   `kstr' specifies the string of the key.
   If successful, the return value is the size of the value of the corresponding record, else,
   it is -1. */
int tcrdbvsiz2(TCRDB *rdb, const char *kstr);


/* Initialize the iterator of a remote database object.
   `rdb' specifies the remote database object.
   If successful, the return value is true, else, it is false.
   The iterator is used in order to access the key of every record stored in a database. */
bool tcrdbiterinit(TCRDB *rdb);


/* Get the next key of the iterator of a remote database object.
   `rdb' specifies the remote database object.
   `sp' specifies the pointer to the variable into which the size of the region of the return
   value is assigned.
   If successful, the return value is the pointer to the region of the next key, else, it is
   `NULL'.  `NULL' is returned when no record is to be get out of the iterator.
   Because an additional zero code is appended at the end of the region of the return value, the
   return value can be treated as a character string.  Because the region of the return value is
   allocated with the `malloc' call, it should be released with the `free' call when it is no
   longer in use.  The iterator can be updated by multiple connections and then it is not assured
   that every record is traversed. */
void *tcrdbiternext(TCRDB *rdb, int *sp);


/* Get the next key string of the iterator of a remote database object.
   `rdb' specifies the remote database object.
   If successful, the return value is the string of the next key, else, it is `NULL'.  `NULL' is
   returned when no record is to be get out of the iterator.
   Because the region of the return value is allocated with the `malloc' call, it should be
   released with the `free' call when it is no longer in use.  The iterator can be updated by
   multiple connections and then it is not assured that every record is traversed. */
char *tcrdbiternext2(TCRDB *rdb);


/* Get forward matching keys in a remote database object.
   `rdb' specifies the remote database object.
   `pbuf' specifies the pointer to the region of the prefix.
   `psiz' specifies the size of the region of the prefix.
   `max' specifies the maximum number of keys to be fetched.  If it is negative, no limit is
   specified.
   The return value is a list object of the corresponding keys.  This function does never fail
   and return an empty list even if no key corresponds.
   Because the object of the return value is created with the function `tclistnew', it should be
   deleted with the function `tclistdel' when it is no longer in use. */
TCLIST *tcrdbfwmkeys(TCRDB *rdb, const void *pbuf, int psiz, int max);


/* Get forward matching string keys in a remote database object.
   `rdb' specifies the remote database object.
   `pstr' specifies the string of the prefix.
   `max' specifies the maximum number of keys to be fetched.  If it is negative, no limit is
   specified.
   The return value is a list object of the corresponding keys.  This function does never fail
   and return an empty list even if no key corresponds.
   Because the object of the return value is created with the function `tclistnew', it should be
   deleted with the function `tclistdel' when it is no longer in use. */
TCLIST *tcrdbfwmkeys2(TCRDB *rdb, const char *pstr, int max);


/* Add an integer to a record in a remote database object.
   `rdb' specifies the remote database object connected as a writer.
   `kbuf' specifies the pointer to the region of the key.
   `ksiz' specifies the size of the region of the key.
   `num' specifies the additional value.
   If successful, the return value is the summation value, else, it is `INT_MIN'.
   If the corresponding record exists, the value is treated as an integer and is added to.  If no
   record corresponds, a new record of the additional value is stored. */
int tcrdbaddint(TCRDB *rdb, const void *kbuf, int ksiz, int num);


/* Add a real number to a record in a remote database object.
   `rdb' specifies the remote database object connected as a writer.
   `kbuf' specifies the pointer to the region of the key.
   `ksiz' specifies the size of the region of the key.
   `num' specifies the additional value.
   If successful, the return value is the summation value, else, it is `NAN'.
   If the corresponding record exists, the value is treated as a real number and is added to.  If
   no record corresponds, a new record of the additional value is stored. */
double tcrdbadddouble(TCRDB *rdb, const void *kbuf, int ksiz, double num);


/* Call a function of the scripting language extension.
   `rdb' specifies the remote database object.
   `name' specifies the function name.
   `opts' specifies options by bitwise-or: `RDBXOLCKREC' for record locking, `RDBXOLCKGLB' for
   global locking.
   `kbuf' specifies the pointer to the region of the key.
   `ksiz' specifies the size of the region of the key.
   `vbuf' specifies the pointer to the region of the value.
   `vsiz' specifies the size of the region of the value.
   `sp' specifies the pointer to the variable into which the size of the region of the return
   value is assigned.
   If successful, the return value is the pointer to the region of the value of the response.
   `NULL' is returned on failure.
   Because an additional zero code is appended at the end of the region of the return value,
   the return value can be treated as a character string.  Because the region of the return
   value is allocated with the `malloc' call, it should be released with the `free' call when
   it is no longer in use. */
void *tcrdbext(TCRDB *rdb, const char *name, int opts,
               const void *kbuf, int ksiz, const void *vbuf, int vsiz, int *sp);


/* Call a function of the scripting language extension.
   `rdb' specifies the remote database object.
   `name' specifies the function name.
   `opts' specifies options by bitwise-or: `RDBXOLCKREC' for record locking, `RDBXOLCKGLB' for
   global locking.
   `kstr' specifies the string of the key.
   `vstr' specifies the string of the value.
   If successful, the return value is the string of the value of the response.  `NULL' is
   returned on failure.
   Because the region of the return value is allocated with the `malloc' call, it should be
   released with the `free' call when it is no longer in use. */
char *tcrdbext2(TCRDB *rdb, const char *name, int opts, const char *kstr, const char *vstr);


/* Synchronize updated contents of a remote database object with the file and the device.
   `rdb' specifies the remote database object.
   If successful, the return value is true, else, it is false. */
bool tcrdbsync(TCRDB *rdb);


/* Remove all records of a remote database object.
   `rdb' specifies the remote database object.
   If successful, the return value is true, else, it is false. */
bool tcrdbvanish(TCRDB *rdb);


/* Copy the database file of a remote database object.
   `rdb' specifies the remote database object.
   `path' specifies the path of the destination file.  If it begins with `@', the trailing
   substring is executed as a command line.
   If successful, the return value is true, else, it is false.  False is returned if the executed
   command returns non-zero code.
   The database file is assured to be kept synchronized and not modified while the copying or
   executing operation is in progress.  So, this function is useful to create a backup file of
   the database file. */
bool tcrdbcopy(TCRDB *rdb, const char *path);


/* Restore the database file of a remote database object from the update log.
   `rdb' specifies the remote database object.
   `path' specifies the path of the update log directory.  If it begins with `+', the trailing
   substring is treated as the path and consistency checking is omitted.
   `ts' specifies the beginning timestamp in microseconds.
   If successful, the return value is true, else, it is false. */
bool tcrdbrestore(TCRDB *rdb, const char *path, uint64_t ts);


/* Set the replication master of a remote database object from the update log.
   `rdb' specifies the remote database object.
   `host' specifies the name or the address of the server.  If it is `NULL', replication of the
   database is disabled.
   `port' specifies the port number.
   If successful, the return value is true, else, it is false. */
bool tcrdbsetmst(TCRDB *rdb, const char *host, int port);


/* Get the number of records of a remote database object.
   `rdb' specifies the remote database object.
   The return value is the number of records or 0 if the object does not connect to any database
   server. */
uint64_t tcrdbrnum(TCRDB *rdb);


/* Get the size of the database of a remote database object.
   `rdb' specifies the remote database object.
   The return value is the size of the database or 0 if the object does not connect to any
   database server. */
uint64_t tcrdbsize(TCRDB *rdb);


/* Get the status string of the database of a remote database object.
   `rdb' specifies the remote database object.
   The return value is the status message of the database or `NULL' if the object does not
   connect to any database server.  The message format is TSV.  The first field of each line
   means the parameter name and the second field means the value.
   Because the region of the return value is allocated with the `malloc' call, it should be
   released with the `free' call when it is no longer in use. */
char *tcrdbstat(TCRDB *rdb);


/* Call a versatile function for miscellaneous operations of a remote database object.
   `rdb' specifies the remote database object.
   `name' specifies the name of the function.  All databases support "putlist", "outlist", and
   "getlist".  "putlist" is to store records.  It receives keys and values one after the other,
   and returns an empty list.  "outlist" is to remove records.  It receives keys, and returns an
   empty list.  "getlist" is to retrieve records.  It receives keys, and returns keys and values
   of corresponding records one after the other.  Table database supports "setindex", "search",
   and "genuid".
   `opts' specifies options by bitwise-or: `RDBMONOULOG' for omission of the update log.
   `args' specifies a list object containing arguments.
   If successful, the return value is a list object of the result.  `NULL' is returned on failure.
   Because the object of the return value is created with the function `tclistnew', it
   should be deleted with the function `tclistdel' when it is no longer in use. */
TCLIST *tcrdbmisc(TCRDB *rdb, const char *name, int opts, const TCLIST *args);



/*************************************************************************************************
 * table extension
 *************************************************************************************************/


enum {                                   /* enumeration for index types */
  RDBITLEXICAL = TDBITLEXICAL,           /* lexical string */
  RDBITDECIMAL = TDBITDECIMAL,           /* decimal string */
  RDBITOPT = TDBITOPT,                   /* optimize */
  RDBITVOID = TDBITVOID,                 /* void */
  RDBITKEEP = TDBITKEEP                  /* keep existing index */
};

typedef struct {                         /* type of structure for a query */
  TCRDB *rdb;                            /* database object */
  TCLIST *args;                          /* arguments for the method */
} RDBQRY;

enum {                                   /* enumeration for query conditions */
  RDBQCSTREQ = TDBQCSTREQ,               /* string is equal to */
  RDBQCSTRINC = TDBQCSTRINC,             /* string is included in */
  RDBQCSTRBW = TDBQCSTRBW,               /* string begins with */
  RDBQCSTREW = TDBQCSTREW,               /* string ends with */
  RDBQCSTRAND = TDBQCSTRAND,             /* string includes all tokens in */
  RDBQCSTROR = TDBQCSTROR,               /* string includes at least one token in */
  RDBQCSTROREQ = TDBQCSTROREQ,           /* string is equal to at least one token in */
  RDBQCSTRRX = TDBQCSTRRX,               /* string matches regular expressions of */
  RDBQCNUMEQ = TDBQCNUMEQ,               /* number is equal to */
  RDBQCNUMGT = TDBQCNUMGT,               /* number is greater than */
  RDBQCNUMGE = TDBQCNUMGE,               /* number is greater than or equal to */
  RDBQCNUMLT = TDBQCNUMLT,               /* number is less than */
  RDBQCNUMLE = TDBQCNUMLE,               /* number is less than or equal to */
  RDBQCNUMBT = TDBQCNUMBT,               /* number is between two tokens of */
  RDBQCNUMOREQ = TDBQCNUMOREQ,           /* number is equal to at least one token in */
  RDBQCNEGATE = TDBQCNEGATE,             /* negation flag */
  RDBQCNOIDX = TDBQCNOIDX                /* no index flag */
};

enum {                                   /* enumeration for order types */
  RDBQOSTRASC = TDBQOSTRASC,             /* string ascending */
  RDBQOSTRDESC = TDBQOSTRDESC,           /* string descending */
  RDBQONUMASC = TDBQONUMASC,             /* number ascending */
  RDBQONUMDESC = TDBQONUMDESC            /* number descending */
};


/* Store a record into a remote database object.
   `rdb' specifies the remote database object connected as a writer.
   `pkbuf' specifies the pointer to the region of the primary key.
   `pksiz' specifies the size of the region of the primary key.
   `cols' specifies a map object containing columns.
   If successful, the return value is true, else, it is false.
   If a record with the same key exists in the database, it is overwritten. */
bool tcrdbtblput(TCRDB *rdb, const void *pkbuf, int pksiz, TCMAP *cols);


/* Store a new record into a remote database object.
   `rdb' specifies the remote database object connected as a writer.
   `pkbuf' specifies the pointer to the region of the primary key.
   `pksiz' specifies the size of the region of the primary key.
   `cols' specifies a map object containing columns.
   If successful, the return value is true, else, it is false.
   If a record with the same key exists in the database, this function has no effect. */
bool tcrdbtblputkeep(TCRDB *rdb, const void *pkbuf, int pksiz, TCMAP *cols);


/* Concatenate columns of the existing record in a remote database object.
   `rdb' specifies the remote database object connected as a writer.
   `pkbuf' specifies the pointer to the region of the primary key.
   `pksiz' specifies the size of the region of the primary key.
   `cols' specifies a map object containing columns.
   If successful, the return value is true, else, it is false.
   If there is no corresponding record, a new record is created. */
bool tcrdbtblputcat(TCRDB *rdb, const void *pkbuf, int pksiz, TCMAP *cols);


/* Remove a record of a remote database object.
   `rdb' specifies the remote database object connected as a writer.
   `pkbuf' specifies the pointer to the region of the primary key.
   `pksiz' specifies the size of the region of the primary key.
   If successful, the return value is true, else, it is false. */
bool tcrdbtblout(TCRDB *rdb, const void *pkbuf, int pksiz);


/* Retrieve a record in a remote database object.
   `rdb' specifies the remote database object.
   `pkbuf' specifies the pointer to the region of the primary key.
   `pksiz' specifies the size of the region of the primary key.
   If successful, the return value is a map object of the columns of the corresponding record.
   `NULL' is returned if no record corresponds.
   Because the object of the return value is created with the function `tcmapnew', it should be
   deleted with the function `tcmapdel' when it is no longer in use. */
TCMAP *tcrdbtblget(TCRDB *rdb, const void *pkbuf, int pksiz);


/* Set a column index to a remote database object.
   `rdb' specifies the remote database object connected as a writer.
   `name' specifies the name of a column.  If the name of an existing index is specified, the
   index is rebuilt.  An empty string means the primary key.
   `type' specifies the index type: `RDBITLEXICAL' for lexical string, `RDBITDECIMAL' for decimal
   string.  If it is `RDBITOPT', the index is optimized.  If it is `RDBITVOID', the index is
   removed.  If `RDBITKEEP' is added by bitwise-or and the index exists, this function merely
   returns failure.
   If successful, the return value is true, else, it is false.
   Note that the setting indexes should be set after the database is opened. */
bool tcrdbtblsetindex(TCRDB *rdb, const char *name, int type);


/* Generate a unique ID number of a remote database object.
   `rdb' specifies the remote database object connected as a writer.
   The return value is the new unique ID number or -1 on failure. */
int64_t tcrdbtblgenuid(TCRDB *rdb);


/* Create a query object.
   `rdb' specifies the remote database object.
   The return value is the new query object. */
RDBQRY *tcrdbqrynew(TCRDB *rdb);


/* Delete a query object.
   `qry' specifies the query object. */
void tcrdbqrydel(RDBQRY *qry);


/* Add a narrowing condition to a query object.
   `qry' specifies the query object.
   `name' specifies the name of a column.  An empty string means the primary key.
   `op' specifies an operation type: `RDBQCSTREQ' for string which is equal to the expression,
   `RDBQCSTRINC' for string which is included in the expression, `RDBQCSTRBW' for string which
   begins with the expression, `RDBQCSTREW' for string which ends with the expression,
   `RDBQCSTRAND' for string which includes all tokens in the expression, `RDBQCSTROR' for string
   which includes at least one token in the expression, `RDBQCSTROREQ' for string which is equal
   to at least one token in the expression, `RDBQCSTRRX' for string which matches regular
   expressions of the expression, `RDBQCNUMEQ' for number which is equal to the expression,
   `RDBQCNUMGT' for number which is greater than the expression, `RDBQCNUMGE' for number which is
   greater than or equal to the expression, `RDBQCNUMLT' for number which is less than the
   expression, `RDBQCNUMLE' for number which is less than or equal to the expression, `RDBQCNUMBT'
   for number which is between two tokens of the expression, `RDBQCNUMOREQ' for number which is
   equal to at least one token in the expression.  All operations can be flagged by bitwise-or:
   `RDBQCNEGATE' for negation, `RDBQCNOIDX' for using no index.
   `expr' specifies an operand exression. */
void tcrdbqryaddcond(RDBQRY *qry, const char *name, int op, const char *expr);


/* Set the order of a query object.
   `qry' specifies the query object.
   `name' specifies the name of a column.  An empty string means the primary key.
   `type' specifies the order type: `RDBQOSTRASC' for string ascending, `RDBQOSTRDESC' for
   string descending, `RDBQONUMASC' for number ascending, `RDBQONUMDESC' for number descending. */
void tcrdbqrysetorder(RDBQRY *qry, const char *name, int type);


/* Set the maximum number of records of the result of a query object.
   `qry' specifies the query object.
   `max' specifies the maximum number of records of the result. */
void tcrdbqrysetmax(RDBQRY *qry, int max);


/* Execute the search of a query object.
   `qry' specifies the query object.
   The return value is a list object of the primary keys of the corresponding records.  This
   function does never fail and return an empty list even if no record corresponds.
   Because the object of the return value is created with the function `tclistnew', it should
   be deleted with the function `tclistdel' when it is no longer in use. */
TCLIST *tcrdbqrysearch(RDBQRY *qry);


/* Remove each record corresponding to a query object.
   `qry' specifies the query object of the database connected as a writer.
   If successful, the return value is true, else, it is false. */
bool tcrdbqrysearchout(RDBQRY *qry);


/* Get records corresponding to the search of a query object.
   `qry' specifies the query object.
   The return value is a list object of zero separated columns of the corresponding records.
   This function does never fail and return an empty list even if no record corresponds.
   Because the object of the return value is created with the function `tclistnew', it should
   be deleted with the function `tclistdel' when it is no longer in use. */
TCLIST *tcrdbqrysearchget(RDBQRY *qry);


/* Get columns of a record in a search result.
   `res' specifies a list of zero separated columns of the search result.
   `index' the index of a element of the search result.
   The return value is a map object containing columns.
   Because the object of the return value is created with the function `tcmapnew', it should be
   deleted with the function `tcmapdel' when it is no longer in use. */
TCMAP *tcrdbqryrescols(TCLIST *res, int index);

/*************************************************************************************************
 * API
 *************************************************************************************************/


#define TCULSUFFIX     ".ulog"           /* suffix of update log files */
#define TCULMAGICNUM   0xc9              /* magic number of each command */
#define TCULMAGICNOP   0xca              /* magic number of NOP command */
#define TCULRMTXNUM    31                /* number of mutexes of records */

typedef struct {                         /* type of structure for an update log */
  pthread_mutex_t rmtxs[TCULRMTXNUM];    /* mutex for records */
  pthread_rwlock_t rwlck;                /* mutex for operation */
  pthread_cond_t cnd;                    /* condition variable */
  pthread_mutex_t wmtx;                  /* mutex for waiting condition */
  char *base;                            /* path of the base directory */
  uint64_t limsiz;                       /* limit size */
  int max;                               /* number of maximum ID */
  int fd;                                /* current file descriptor */
  uint64_t size;                         /* current size */
  void *aiocbs;                          /* AIO tasks */
  int aiocbi;                            /* index of AIO tasks */
  uint64_t aioend;                       /* end offset of AIO tasks */
} TCULOG;

typedef struct {                         /* type of structure for a log reader */
  TCULOG *ulog;                          /* update log object */
  uint64_t ts;                           /* beginning timestamp */
  int num;                               /* number of current ID */
  int fd;                                /* current file descriptor */
  char *rbuf;                            /* record buffer */
  int rsiz;                              /* size of the record buffer */
} TCULRD;

typedef struct {                         /* type of structure for a replication */
  int fd;                                /* file descriptor */
  TTSOCK *sock;                          /* socket object */
  char *rbuf;                            /* record buffer */
  int rsiz;                              /* size of the record buffer */
} TCREPL;


/* Create an update log object.
   The return value is the new update log object. */
TCULOG *tculognew(void);


/* Delete an update log object.
   `ulog' specifies the update log object. */
void tculogdel(TCULOG *ulog);


/* Set AIO control of an update log object.
   `ulog' specifies the update log object.
   If successful, the return value is true, else, it is false. */
bool tculogsetaio(TCULOG *ulog);


/* Open files of an update log object.
   `ulog' specifies the update log object.
   `base' specifies the path of the base directory.
   `limsiz' specifies the limit size of each file.  If it is not more than 0, no limit is
   specified.
   If successful, the return value is true, else, it is false. */
bool tculogopen(TCULOG *ulog, const char *base, uint64_t limsiz);


/* Close files of an update log object.
   `ulog' specifies the update log object.
   If successful, the return value is true, else, it is false. */
bool tculogclose(TCULOG *ulog);


/* Get the mutex index of a record.
   `ulog' specifies the update log object.
   `kbuf' specifies the pointer to the region of the key.
   `ksiz' specifies the size of the region of the key.
   The return value is the mutex index of a record. */
int tculogrmtxidx(TCULOG *ulog, const char *kbuf, int ksiz);


/* Begin the critical section of an update log object.
   `ulog' specifies the update log object.
   `idx' specifies the index of the record lock.  -1 means to lock all.
   If successful, the return value is true, else, it is false. */
bool tculogbegin(TCULOG *ulog, int idx);


/* End the critical section of an update log object.
   `ulog' specifies the update log object.
   `idx' specifies the index of the record lock.  -1 means to lock all.
   If successful, the return value is true, else, it is false. */
bool tculogend(TCULOG *ulog, int idx);


/* Write a message into an update log object.
   `ulog' specifies the update log object.
   `ts' specifies the timestamp.  If it is 0, the current time is specified.
   `sid' specifies the server ID of the message.
   `ptr' specifies the pointer to the region of the message.
   `size' specifies the size of the region.
   If successful, the return value is true, else, it is false. */
bool tculogwrite(TCULOG *ulog, uint64_t ts, uint32_t sid, const void *ptr, int size);


/* Create a log reader object.
   `ulog' specifies the update log object.
   `ts' specifies the beginning timestamp.
   The return value is the new log reader object. */
TCULRD *tculrdnew(TCULOG *ulog, uint64_t ts);


/* Delete a log reader object.
   `ulrd' specifies the log reader object. */
void tculrddel(TCULRD *ulrd);


/* Wait the next message is written.
   `ulrd' specifies the log reader object. */
void tculrdwait(TCULRD *ulrd);


/* Read a message from a log reader object.
   `ulrd' specifies the log reader object.
   `sp' specifies the pointer to the variable into which the size of the region of the return
   value is assigned.
   `tsp' specifies the pointer to the variable into which the timestamp of the next message is
   assigned.
   `sidp' specifies the pointer to the variable into which the server ID of the next message is
   assigned.
   If successful, the return value is the pointer to the region of the value of the next message.
   `NULL' is returned if no record is to be read. */
const void *tculrdread(TCULRD *ulrd, int *sp, uint64_t *tsp, uint32_t *sidp);


/* Store a record into an abstract database object.
   `ulog' specifies the update log object.
   `sid' specifies the server ID of the message.
   `adb' specifies the abstract database object.
   `kbuf' specifies the pointer to the region of the key.
   `ksiz' specifies the size of the region of the key.
   `vbuf' specifies the pointer to the region of the value.
   `vsiz' specifies the size of the region of the value.
   If successful, the return value is true, else, it is false.
   If a record with the same key exists in the database, it is overwritten. */
bool tculogadbput(TCULOG *ulog, uint32_t sid, TCADB *adb,
                  const void *kbuf, int ksiz, const void *vbuf, int vsiz);


/* Store a new record into an abstract database object.
   `ulog' specifies the update log object.
   `sid' specifies the server ID of the message.
   `adb' specifies the abstract database object.
   `kbuf' specifies the pointer to the region of the key.
   `ksiz' specifies the size of the region of the key.
   `vbuf' specifies the pointer to the region of the value.
   `vsiz' specifies the size of the region of the value.
   If successful, the return value is true, else, it is false.
   If a record with the same key exists in the database, this function has no effect. */
bool tculogadbputkeep(TCULOG *ulog, uint32_t sid, TCADB *adb,
                      const void *kbuf, int ksiz, const void *vbuf, int vsiz);


/* Concatenate a value at the end of the existing record in an abstract database object.
   `ulog' specifies the update log object.
   `sid' specifies the server ID of the message.
   `adb' specifies the abstract database object.
   `kbuf' specifies the pointer to the region of the key.
   `ksiz' specifies the size of the region of the key.
   `vbuf' specifies the pointer to the region of the value.
   `vsiz' specifies the size of the region of the value.
   If successful, the return value is true, else, it is false.
   If there is no corresponding record, a new record is created. */
bool tculogadbputcat(TCULOG *ulog, uint32_t sid, TCADB *adb,
                     const void *kbuf, int ksiz, const void *vbuf, int vsiz);


/* Remove a record of an abstract database object.
   `ulog' specifies the update log object.
   `sid' specifies the server ID of the message.
   `adb' specifies the abstract database object.
   `kbuf' specifies the pointer to the region of the key.
   `ksiz' specifies the size of the region of the key.
   If successful, the return value is true, else, it is false. */
bool tculogadbout(TCULOG *ulog, uint32_t sid, TCADB *adb, const void *kbuf, int ksiz);


/* Add an integer to a record in an abstract database object.
   `ulog' specifies the update log object.
   `sid' specifies the server ID of the message.
   `adb' specifies the abstract database object connected as a writer.
   `kbuf' specifies the pointer to the region of the key.
   `ksiz' specifies the size of the region of the key.
   `num' specifies the additional value.
   If successful, the return value is the summation value, else, it is `INT_MIN'.
   If the corresponding record exists, the value is treated as an integer and is added to.  If no
   record corresponds, a new record of the additional value is stored. */
int tculogadbaddint(TCULOG *ulog, uint32_t sid, TCADB *adb, const void *kbuf, int ksiz, int num);


/* Add a real number to a record in an abstract database object.
   `ulog' specifies the update log object.
   `sid' specifies the server ID of the message.
   `adb' specifies the abstract database object connected as a writer.
   `kbuf' specifies the pointer to the region of the key.
   `ksiz' specifies the size of the region of the key.
   `num' specifies the additional value.
   If successful, the return value is the summation value, else, it is `NAN'.
   If the corresponding record exists, the value is treated as a real number and is added to.  If
   no record corresponds, a new record of the additional value is stored. */
double tculogadbadddouble(TCULOG *ulog, uint32_t sid, TCADB *adb,
                          const void *kbuf, int ksiz, double num);


/* Remove all records of an abstract database object.
   `ulog' specifies the update log object.
   `sid' specifies the server ID of the message.
   `adb' specifies the abstract database object.
   If successful, the return value is true, else, it is false. */
bool tculogadbvanish(TCULOG *ulog, uint32_t sid, TCADB *adb);


/* Call a versatile function for miscellaneous operations of an abstract database object.
   `ulog' specifies the update log object.
   `sid' specifies the server ID of the message.
   `adb' specifies the abstract database object.
   `name' specifies the name of the function.
   `args' specifies a list object containing arguments.
   If successful, the return value is a list object of the result.  `NULL' is returned on failure.
   All databases support "putlist", "outlist", and "getlist".  "putdup" is to store records.  It
   receives keys and values one after the other, and returns an empty list.  "outlist" is to
   remove records.  It receives keys, and returns an empty list.  "getlist" is to retrieve
   records.  It receives keys, and returns values.  Because the object of the return value is
   created with the function `tclistnew', it should be deleted with the function `tclistdel' when
   it is no longer in use. */
TCLIST *tculogadbmisc(TCULOG *ulog, uint32_t sid,
                      TCADB *adb, const char *name, const TCLIST *args);


/* Restore an abstract database object.
   `adb' specifies the abstract database object.
   `path' specifies the path of the update log directory.
   `ts' specifies the beginning time stamp.
   `con' specifies whether consistency checking is performed.
   `ulog' specifies the update log object.
   If successful, the return value is true, else, it is false. */
bool tculogadbrestore(TCADB *adb, const char *path, uint64_t ts, bool con, TCULOG *ulog);


/* Redo an update log message.
   `adb' specifies the abstract database object.
   `ptr' specifies the pointer to the region of the message.
   `size' specifies the size of the region.
   `con' specifies whether consistency checking is performed.
   `ulog' specifies the update log object.
   `sid' specifies the server ID of the message.
   If successful, the return value is true, else, it is false. */
bool tculogadbredo(TCADB *adb, const char *ptr, int size, bool con, TCULOG *ulog, uint32_t sid);


/* Create a replication object.
   The return value is the new replicatoin object. */
TCREPL *tcreplnew(void);


/* Delete a replication object.
   `repl' specifies the replication object. */
void tcrepldel(TCREPL *repl);


/* Open a replication object.
   `repl' specifies the replication object.
   `host' specifies the name or the address of the server.
   `port' specifies the port number.
   `sid' specifies the server ID of self messages.
   If successful, the return value is true, else, it is false. */
bool tcreplopen(TCREPL *repl, const char *host, int port, uint64_t ts, uint32_t sid);


/* Close a remote database object.
   `rdb' specifies the remote database object.
   If successful, the return value is true, else, it is false. */
bool tcreplclose(TCREPL *repl);


/* Read a message from a replication object.
   `repl' specifies the replication object.
   `sp' specifies the pointer to the variable into which the size of the region of the return
   value is assigned.
   `tsp' specifies the pointer to the variable into which the timestamp of the next message is
   assigned.
   `sidp' specifies the pointer to the variable into which the server ID of the next message is
   assigned.
   If successful, the return value is the pointer to the region of the value of the next message.
   `NULL' is returned if no record is to be read.  Empty string is returned when the no-operation
   command has been received. */
const char *tcreplread(TCREPL *repl, int *sp, uint64_t *tsp, uint32_t *sidp);


