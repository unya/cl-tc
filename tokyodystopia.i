%module tokyodystopia
%insert("lisphead") %{
(in-package :tokyodystopia-sys)
(define-foreign-library tokyodystopia
  (:unix (:or "libtokyodystopia.so.7" "libtokyodystopia.so"))
  (t (:default "libtokyodystopia")))
(use-foreign-library tokyodystopia)

%}

/*************************************************************************************************
 * API
 *************************************************************************************************/


#define IDBQDBMAX      32                /* maximum number of the internal databases */

typedef struct {                         /* type of structure for an indexed database object */
  void *mmtx;                            /* mutex for method */
  char *path;                            /* path of the database directory */
  bool wmode;                            /* whether to be writable */
  uint8_t qopts;                         /* tuning options of q-gram databases */
  int qomode;                            /* open mode of q-gram databases */
  TCHDB *txdb;                           /* text database object */
  TCQDB *idxs[IDBQDBMAX];                /* q-gram database objects */
  uint8_t inum;                          /* number of the q-gram database objects */
  uint8_t cnum;                          /* current number of the q-gram database */
  uint32_t ernum;                        /* expected number of records */
  uint32_t etnum;                        /* expected number of tokens */
  uint64_t iusiz;                        /* unit size of each index file */
  uint8_t opts;                          /* options */
  bool (*synccb)(int, int, const char *, void *);  /* callback function for sync progression */
  void *syncopq;                         /* opaque for the sync callback function */
  uint8_t exopts;                        /* expert options */
} TCIDB;

enum {                                   /* enumeration for tuning options */
  IDBTLARGE = 1 << 0,                    /* use 64-bit bucket array */
  IDBTDEFLATE = 1 << 1,                  /* compress each page with Deflate */
  IDBTBZIP = 1 << 2,                     /* compress each record with BZIP2 */
  IDBTTCBS = 1 << 3                      /* compress each page with TCBS */
};

enum {                                   /* enumeration for open modes */
  IDBOREADER = 1 << 0,                   /* open as a reader */
  IDBOWRITER = 1 << 1,                   /* open as a writer */
  IDBOCREAT = 1 << 2,                    /* writer creating */
  IDBOTRUNC = 1 << 3,                    /* writer truncating */
  IDBONOLCK = 1 << 4,                    /* open without locking */
  IDBOLCKNB = 1 << 5                     /* lock without blocking */
};

enum {                                   /* enumeration for get modes */
  IDBSSUBSTR = QDBSSUBSTR,               /* substring matching */
  IDBSPREFIX = QDBSPREFIX,               /* prefix matching */
  IDBSSUFFIX = QDBSSUFFIX,               /* suffix matching */
  IDBSFULL = QDBSFULL,                   /* full matching */
  IDBSTOKEN,                             /* token matching */
  IDBSTOKPRE,                            /* token prefix matching */
  IDBSTOKSUF                             /* token suffix matching */
};


/* Get the message string corresponding to an error code.
   `ecode' specifies the error code.
   The return value is the message string of the error code. */
const char *tcidberrmsg(int ecode);


/* Create an indexed database object.
   The return value is the new indexed database object. */
TCIDB *tcidbnew(void);


/* Delete an indexed database object.
   `idb' specifies the indexed database object.
   If the database is not closed, it is closed implicitly.  Note that the deleted object and its
   derivatives can not be used anymore. */
void tcidbdel(TCIDB *idb);


/* Get the last happened error code of an indexed database object.
   `idb' specifies the indexed database object.
   The return value is the last happened error code.
   The following error code is defined: `TCESUCCESS' for success, `TCETHREAD' for threading
   error, `TCEINVALID' for invalid operation, `TCENOFILE' for file not found, `TCENOPERM' for no
   permission, `TCEMETA' for invalid meta data, `TCERHEAD' for invalid record header, `TCEOPEN'
   for open error, `TCECLOSE' for close error, `TCETRUNC' for trunc error, `TCESYNC' for sync
   error, `TCESTAT' for stat error, `TCESEEK' for seek error, `TCEREAD' for read error,
   `TCEWRITE' for write error, `TCEMMAP' for mmap error, `TCELOCK' for lock error, `TCEUNLINK'
   for unlink error, `TCERENAME' for rename error, `TCEMKDIR' for mkdir error, `TCERMDIR' for
   rmdir error, `TCEKEEP' for existing record, `TCENOREC' for no record found, and `TCEMISC' for
   miscellaneous error. */
int tcidbecode(TCIDB *idb);


/* Set the tuning parameters of an indexed database object.
   `idb' specifies the indexed database object which is not opened.
   `ernum' specifies the expected number of records to be stored.  If it is not more than 0, the
   default value is specified.  The default value is 1000000.
   `etnum' specifies the expected number of tokens to be stored.  If it is not more than 0, the
   default value is specified.  The default value is 1000000.
   `iusiz' specifies the unit size of each index file.  If it is not more than 0, the default
   value is specified.  The default value is 536870912.
   `opts' specifies options by bitwise or: `IDBTLARGE' specifies that the size of the database
   can be larger than 2GB by using 64-bit bucket array, `IDBTDEFLATE' specifies that each page
   is compressed with Deflate encoding, `IDBTBZIP' specifies that each page is compressed with
   BZIP2 encoding, `IDBTTCBS' specifies that each page is compressed with TCBS encoding.
   If successful, the return value is true, else, it is false.
   Note that the tuning parameters should be set before the database is opened. */
bool tcidbtune(TCIDB *idb, int64_t ernum, int64_t etnum, int64_t iusiz, uint8_t opts);


/* Set the caching parameters of an indexed database object.
   `idb' specifies the indexed database object which is not opened.
   `icsiz' specifies the capacity size of the token cache.  If it is not more than 0, the default
   value is specified.  The default value is 134217728.
   `lcnum' specifies the maximum number of cached leaf nodes of B+ tree.  If it is not more than
   0, the default value is specified.  The default value is 64 for writer or 1024 for reader.
   If successful, the return value is true, else, it is false.
   Note that the caching parameters should be set before the database is opened. */
bool tcidbsetcache(TCIDB *idb, int64_t icsiz, int32_t lcnum);


/* Set the maximum number of forward matching expansion of an indexed database object.
   `idb' specifies the indexed database object.
   `fwmmax' specifies the maximum number of forward matching expansion.
   If successful, the return value is true, else, it is false.
   Note that the matching parameters should be set before the database is opened. */
bool tcidbsetfwmmax(TCIDB *idb, uint32_t fwmmax);


/* Open an indexed database object.
   `idb' specifies the indexed database object.
   `path' specifies the path of the database directory.
   `omode' specifies the connection mode: `IDBOWRITER' as a writer, `IDBOREADER' as a reader.
   If the mode is `IDBOWRITER', the following may be added by bitwise or: `IDBOCREAT', which
   means it creates a new database if not exist, `IDBOTRUNC', which means it creates a new
   database regardless if one exists.  Both of `IDBOREADER' and `IDBOWRITER' can be added to by
   bitwise or: `IDBONOLCK', which means it opens the database directory without file locking, or
   `IDBOLCKNB', which means locking is performed without blocking.
   If successful, the return value is true, else, it is false. */
bool tcidbopen(TCIDB *idb, const char *path, int omode);


/* Close an indexed database object.
   `idb' specifies the indexed database object.
   If successful, the return value is true, else, it is false.
   Update of a database is assured to be written when the database is closed.  If a writer opens
   a database but does not close it appropriately, the database will be broken. */
bool tcidbclose(TCIDB *idb);


/* Store a record into an indexed database object.
   `idb' specifies the indexed database object connected as a writer.
   `id' specifies the ID number of the record.  It should be positive.
   `text' specifies the string of the record, whose encoding should be UTF-8.
   If successful, the return value is true, else, it is false. */
bool tcidbput(TCIDB *idb, int64_t id, const char *text);


/* Remove a record of an indexed database object.
   `idb' specifies the indexed database object connected as a writer.
   `id' specifies the ID number of the record.  It should be positive.
   If successful, the return value is true, else, it is false. */
bool tcidbout(TCIDB *idb, int64_t id);


/* Retrieve a record of an indexed database object.
   `idb' specifies the indexed database object connected as a writer.
   `id' specifies the ID number of the record.  It should be positive.
   If successful, the return value is the string of the corresponding record, else, it is `NULL'.
   Because the region of the return value is allocated with the `malloc' call, it should be
   released with the `free' call when it is no longer in use. */
char *tcidbget(TCIDB *idb, int64_t id);


/* Search an indexed database.
   `idb' specifies the indexed database object.
   `word' specifies the string of the word to be matched to.
   `smode' specifies the matching mode: `IDBSSUBSTR' as substring matching, `IDBSPREFIX' as prefix
   matching, `IDBSSUFFIX' as suffix matching, `IDBSFULL' as full matching, `IDBSTOKEN' as token
   matching, `IDBSTOKPRE' as token prefix matching, or `IDBSTOKSUF' as token suffix matching.
   `np' specifies the pointer to the variable into which the number of elements of the return
   value is assigned.
   If successful, the return value is the pointer to an array of ID numbers of the corresponding
   records.  `NULL' is returned on failure.
   Because the region of the return value is allocated with the `malloc' call, it should be
   released with the `free' call when it is no longer in use. */
uint64_t *tcidbsearch(TCIDB *idb, const char *word, int smode, int *np);


/* Search an indexed database with a compound expression.
   `idb' specifies the indexed database object.
   `expr' specifies the string of the compound expression.
   `np' specifies the pointer to the variable into which the number of elements of the return
   value is assigned.
   If successful, the return value is the pointer to an array of ID numbers of the corresponding
   records.  `NULL' is returned on failure.
   Because the region of the return value is allocated with the `malloc' call, it should be
   released with the `free' call when it is no longer in use. */
uint64_t *tcidbsearch2(TCIDB *idb, const char *expr, int *np);


/* Initialize the iterator of an indexed database object.
   `idb' specifies the indexed database object.
   If successful, the return value is true, else, it is false.
   The iterator is used in order to access the ID number of every record stored in a database. */
bool tcidbiterinit(TCIDB *idb);


/* Get the next ID number of the iterator of an indexed database object.
   `idb' specifies the indexed database object.
   If successful, the return value is the ID number of the next record, else, it is 0.  0 is
   returned when no record is to be get out of the iterator.
   It is possible to access every record by iteration of calling this function.  It is allowed to
   update or remove records whose keys are fetched while the iteration.  However, it is not
   assured if updating the database is occurred while the iteration.  Besides, the order of this
   traversal access method is arbitrary, so it is not assured that the order of storing matches
   the one of the traversal access. */
uint64_t tcidbiternext(TCIDB *idb);


/* Synchronize updated contents of an indexed database object with the files and the device.
   `idb' specifies the indexed database object connected as a writer.
   If successful, the return value is true, else, it is false.
   This function is useful when another process connects the same database directory. */
bool tcidbsync(TCIDB *idb);


/* Optimize the files of an indexed database object.
   `idb' specifies the indexed database object connected as a writer.
   If successful, the return value is true, else, it is false.
   This function is useful to reduce the size of the database files with data fragmentation by
   successive updating. */
bool tcidboptimize(TCIDB *idb);


/* Remove all records of an indexed database object.
   `idb' specifies the indexed database object connected as a writer.
   If successful, the return value is true, else, it is false. */
bool tcidbvanish(TCIDB *idb);


/* Copy the database directory of an indexed database object.
   `idb' specifies the indexed database object.
   `path' specifies the path of the destination directory.  If it begins with `@', the trailing
   substring is executed as a command line.
   If successful, the return value is true, else, it is false.  False is returned if the executed
   command returns non-zero code.
   The database directory is assured to be kept synchronized and not modified while the copying or
   executing operation is in progress.  So, this function is useful to create a backup directory
   of the database directory. */
bool tcidbcopy(TCIDB *idb, const char *path);


/* Get the directory path of an indexed database object.
   `idb' specifies the indexed database object.
   The return value is the path of the database directory or `NULL' if the object does not
   connect to any database directory. */
const char *tcidbpath(TCIDB *idb);


/* Get the number of records of an indexed database object.
   `idb' specifies the indexed database object.
   The return value is the number of records or 0 if the object does not connect to any database
   directory. */
uint64_t tcidbrnum(TCIDB *idb);


/* Get the total size of the database files of an indexed database object.
   `idb' specifies the indexed database object.
   The return value is the size of the database files or 0 if the object does not connect to any
   database directory. */
uint64_t tcidbfsiz(TCIDB *idb);



/*************************************************************************************************
 * features for experts
 *************************************************************************************************/


enum {                                   /* enumeration for expert options */
  IDBXNOTXT = 1 << 0                     /* no text mode */
};


/* Set the file descriptor for debugging output.
   `idb' specifies the indexed database object.
   `fd' specifies the file descriptor for debugging output. */
void tcidbsetdbgfd(TCIDB *idb, int fd);


/* Get the file descriptor for debugging output.
   `idb' specifies the indexed database object.
   The return value is the file descriptor for debugging output. */
int tcidbdbgfd(TCIDB *idb);


/* Synchronize updating contents on memory of an indexed database object.
   `idb' specifies the indexed database object.
   `level' specifies the synchronization lavel; 0 means cache synchronization, 1 means database
   synchronization, and 2 means file synchronization.
   If successful, the return value is true, else, it is false. */
bool tcidbmemsync(TCIDB *idb, int level);


/* Get the inode number of the database directory of an indexed database object.
   `idb' specifies the indexed database object.
   The return value is the inode number of the database directory or 0 the object does not
   connect to any database directory. */
uint64_t tcidbinode(TCIDB *idb);


/* Get the modification time of the database directory of an indexed database object.
   `idb' specifies the indexed database object.
   The return value is the inode number of the database directory or 0 the object does not
   connect to any database directory. */
time_t tcidbmtime(TCIDB *idb);


/* Get the options of an indexed database object.
   `idb' specifies the indexed database object.
   The return value is the options. */
uint8_t tcidbopts(TCIDB *idb);


/* Set the callback function for sync progression of an indexed database object.
   `idb' specifies the indexed database object.
   `cb' specifies the pointer to the callback function for sync progression.  Its first argument
   specifies the number of tokens to be synchronized.  Its second argument specifies the number
   of processed tokens.  Its third argument specifies the message string.  The fourth argument
   specifies an arbitrary pointer.  Its return value should be true usually, or false if the sync
   operation should be terminated.
   `opq' specifies the arbitrary pointer to be given to the callback function. */
void tcidbsetsynccb(TCIDB *idb, bool (*cb)(int, int, const char *, void *), void *opq);


/* Set the expert options of an indexed database object.
   `idb' specifies the indexed database object.
   `exopts' specifies options by bitwise or: `IDBXNOTXT' specifies that the text database does
   not record any record. */
void tcidbsetexopts(TCIDB *idb, uint32_t exopts);


/* tcwdb.h follows */


#define WDBSPCCHARS    "\b\t\n\v\f\r "   /* space characters */

typedef struct {                         /* type of structure for a word database */
  void *mmtx;                            /* mutex for method */
  TCBDB *idx;                            /* internal database object */
  bool open;                             /* whether the internal database is opened */
  TCMAP *cc;                             /* cache of word tokens */
  uint64_t icsiz;                        /* capacity of the cache */
  uint32_t lcnum;                        /* max number of cached leaves */
  TCMAP *dtokens;                        /* deleted tokens */
  struct _TCIDSET *dids;                 /* deleted ID numbers */
  uint32_t etnum;                        /* expected number of tokens */
  uint8_t opts;                          /* options */
  uint32_t fwmmax;                       /* maximum number of forward matching expansion */
  bool (*synccb)(int, int, const char *, void *);  /* callback function for sync progression */
  void *syncopq;                         /* opaque for the sync callback function */
  bool (*addcb)(const char *, void *);   /* callback function for word addition progression */
  void *addopq;                          /* opaque for the word addition callback function */
} TCWDB;

enum {                                   /* enumeration for tuning options */
  WDBTLARGE = 1 << 0,                    /* use 64-bit bucket array */
  WDBTDEFLATE = 1 << 1,                  /* compress each page with Deflate */
  WDBTBZIP = 1 << 2,                     /* compress each record with BZIP2 */
  WDBTTCBS = 1 << 3                      /* compress each page with TCBS */
};

enum {                                   /* enumeration for open modes */
  WDBOREADER = 1 << 0,                   /* open as a reader */
  WDBOWRITER = 1 << 1,                   /* open as a writer */
  WDBOCREAT = 1 << 2,                    /* writer creating */
  WDBOTRUNC = 1 << 3,                    /* writer truncating */
  WDBONOLCK = 1 << 4,                    /* open without locking */
  WDBOLCKNB = 1 << 5                     /* lock without blocking */
};

enum {                                   /* enumeration for get modes */
  WDBSSUBSTR,                            /* substring matching */
  WDBSPREFIX,                            /* prefix matching */
  WDBSSUFFIX,                            /* suffix matching */
  WDBSFULL                               /* full matching */
};


/* Get the message string corresponding to an error code.
   `ecode' specifies the error code.
   The return value is the message string of the error code. */
const char *tcwdberrmsg(int ecode);


/* Create a word database object.
   The return value is the new word database object. */
TCWDB *tcwdbnew(void);


/* Delete a word database object.
   `wdb' specifies the word database object.
   If the database is not closed, it is closed implicitly.  Note that the deleted object and its
   derivatives can not be used anymore. */
void tcwdbdel(TCWDB *wdb);


/* Get the last happened error code of a word database object.
   `wdb' specifies the word database object.
   The return value is the last happened error code.
   The following error code is defined: `TCESUCCESS' for success, `TCETHREAD' for threading
   error, `TCEINVALID' for invalid operation, `TCENOFILE' for file not found, `TCENOPERM' for no
   permission, `TCEMETA' for invalid meta data, `TCERHEAD' for invalid record header, `TCEOPEN'
   for open error, `TCECLOSE' for close error, `TCETRUNC' for trunc error, `TCESYNC' for sync
   error, `TCESTAT' for stat error, `TCESEEK' for seek error, `TCEREAD' for read error,
   `TCEWRITE' for write error, `TCEMMAP' for mmap error, `TCELOCK' for lock error, `TCEUNLINK'
   for unlink error, `TCERENAME' for rename error, `TCEMKDIR' for mkdir error, `TCERMDIR' for
   rmdir error, `TCEKEEP' for existing record, `TCENOREC' for no record found, and `TCEMISC' for
   miscellaneous error. */
int tcwdbecode(TCWDB *wdb);


/* Set the tuning parameters of a word database object.
   `wdb' specifies the word database object which is not opened.
   `etnum' specifies the expected number of tokens to be stored.  If it is not more than 0, the
   default value is specified.  The default value is 1000000.
   `opts' specifies options by bitwise or: `WDBTLARGE' specifies that the size of the database
   can be larger than 2GB by using 64-bit bucket array, `WDBTDEFLATE' specifies that each page
   is compressed with Deflate encoding, `WDBTBZIP' specifies that each page is compressed with
   BZIP2 encoding, `WDBTTCBS' specifies that each page is compressed with TCBS encoding.
   If successful, the return value is true, else, it is false.
   Note that the tuning parameters should be set before the database is opened. */
bool tcwdbtune(TCWDB *wdb, int64_t etnum, uint8_t opts);


/* Set the caching parameters of a word database object.
   `wdb' specifies the word database object which is not opened.
   `icsiz' specifies the capacity size of the token cache.  If it is not more than 0, the default
   value is specified.  The default value is 134217728.
   `lcnum' specifies the maximum number of cached leaf nodes of B+ tree.  If it is not more than
   0, the default value is specified.  The default value is 64 for writer or 1024 for reader.
   If successful, the return value is true, else, it is false.
   Note that the caching parameters should be set before the database is opened. */
bool tcwdbsetcache(TCWDB *wdb, int64_t icsiz, int32_t lcnum);


/* Set the maximum number of forward matching expansion of a word database object.
   `wdb' specifies the word database object.
   `fwmmax' specifies the maximum number of forward matching expansion.
   If successful, the return value is true, else, it is false.
   Note that the matching parameters should be set before the database is opened. */
bool tcwdbsetfwmmax(TCWDB *wdb, uint32_t fwmmax);


/* Open a word database object.
   `wdb' specifies the word database object.
   `path' specifies the path of the database file.
   `omode' specifies the connection mode: `WDBOWRITER' as a writer, `WDBOREADER' as a reader.
   If the mode is `WDBOWRITER', the following may be added by bitwise or: `WDBOCREAT', which
   means it creates a new database if not exist, `WDBOTRUNC', which means it creates a new
   database regardless if one exists.  Both of `WDBOREADER' and `WDBOWRITER' can be added to by
   bitwise or: `WDBONOLCK', which means it opens the database file without file locking, or
   `WDBOLCKNB', which means locking is performed without blocking.
   If successful, the return value is true, else, it is false. */
bool tcwdbopen(TCWDB *wdb, const char *path, int omode);


/* Close a word database object.
   `wdb' specifies the word database object.
   If successful, the return value is true, else, it is false.
   Update of a database is assured to be written when the database is closed.  If a writer opens
   a database but does not close it appropriately, the database will be broken. */
bool tcwdbclose(TCWDB *wdb);


/* Store a record into a word database object.
   `wdb' specifies the word database object connected as a writer.
   `id' specifies the ID number of the record.  It should be positive.
   `words' specifies a list object contains the words of the record, whose encoding should be
   UTF-8.
   If successful, the return value is true, else, it is false. */
bool tcwdbput(TCWDB *wdb, int64_t id, const TCLIST *words);


/* Store a record with a text string into a word database object.
   `wdb' specifies the word database object connected as a writer.
   `id' specifies the ID number of the record.  It should be positive.
   `text' specifies the string of the record, whose encoding should be UTF-8.
   `delims' specifies a string containing delimiting characters of the text.  If it is `NULL',
   space characters are specified.
   If successful, the return value is true, else, it is false. */
bool tcwdbput2(TCWDB *wdb, int64_t id, const char *text, const char *delims);


/* Remove a record of a word database object.
   `wdb' specifies the word database object connected as a writer.
   `id' specifies the ID number of the record.  It should be positive.
   `words' specifies a list object contains the words of the record, which should be same as the
   stored ones.
   If successful, the return value is true, else, it is false. */
bool tcwdbout(TCWDB *wdb, int64_t id, const TCLIST *words);


/* Remove a record with a text string of a word database object.
   `wdb' specifies the word database object connected as a writer.
   `id' specifies the ID number of the record.  It should be positive.
   `text' specifies the string of the record, which should be same as the stored one.
   `delims' specifies a string containing delimiting characters of the text.  If it is `NULL',
   space characters are specified.
   If successful, the return value is true, else, it is false. */
bool tcwdbout2(TCWDB *wdb, int64_t id, const char *text, const char *delims);


/* Search a word database.
   `wdb' specifies the word database object.
   `word' specifies the string of the word to be matched to.
   `np' specifies the pointer to the variable into which the number of elements of the return
   value is assigned.
   If successful, the return value is the pointer to an array of ID numbers of the corresponding
   records.  `NULL' is returned on failure.
   Because the region of the return value is allocated with the `malloc' call, it should be
   released with the `free' call when it is no longer in use. */
uint64_t *tcwdbsearch(TCWDB *wdb, const char *word, int *np);


/* Synchronize updated contents of a word database object with the file and the device.
   `wdb' specifies the word database object connected as a writer.
   If successful, the return value is true, else, it is false.
   This function is useful when another process connects the same database file. */
bool tcwdbsync(TCWDB *wdb);


/* Optimize the file of a word database object.
   `wdb' specifies the word database object connected as a writer.
   If successful, the return value is true, else, it is false.
   This function is useful to reduce the size of the database file with data fragmentation by
   successive updating. */
bool tcwdboptimize(TCWDB *wdb);


/* Remove all records of a word database object.
   `wdb' specifies the word database object connected as a writer.
   If successful, the return value is true, else, it is false. */
bool tcwdbvanish(TCWDB *wdb);


/* Copy the database file of a word database object.
   `wdb' specifies the word database object.
   `path' specifies the path of the destination file.  If it begins with `@', the trailing
   substring is executed as a command line.
   If successful, the return value is true, else, it is false.  False is returned if the executed
   command returns non-zero code.
   The database file is assured to be kept synchronized and not modified while the copying or
   executing operation is in progress.  So, this function is useful to create a backup file of
   the database file. */
bool tcwdbcopy(TCWDB *wdb, const char *path);


/* Get the file path of a word database object.
   `wdb' specifies the word database object.
   The return value is the path of the database file or `NULL' if the object does not connect to
   any database file. */
const char *tcwdbpath(TCWDB *wdb);


/* Get the number of tokens of a word database object.
   `wdb' specifies the word database object.
   The return value is the number of tokens or 0 if the object does not connect to any database
   file. */
uint64_t tcwdbtnum(TCWDB *wdb);


/* Get the size of the database file of a word database object.
   `wdb' specifies the word database object.
   The return value is the size of the database file or 0 if the object does not connect to any
   database file. */
uint64_t tcwdbfsiz(TCWDB *wdb);



/*************************************************************************************************
 * features for experts
 *************************************************************************************************/


/* Set the file descriptor for debugging output.
   `wdb' specifies the word database object.
   `fd' specifies the file descriptor for debugging output. */
void tcwdbsetdbgfd(TCWDB *wdb, int fd);


/* Get the file descriptor for debugging output.
   `wdb' specifies the word database object.
   The return value is the file descriptor for debugging output. */
int tcwdbdbgfd(TCWDB *wdb);


/* Synchronize updating contents on memory of a word database object.
   `wdb' specifies the word database object.
   `level' specifies the synchronization lavel; 0 means cache synchronization, 1 means database
   synchronization, and 2 means file synchronization.
   If successful, the return value is true, else, it is false. */
bool tcwdbmemsync(TCWDB *wdb, int level);


/* Clear the cache of a word database object.
   `qdb' specifies the word database object.
   If successful, the return value is true, else, it is false. */
bool tcwdbcacheclear(TCWDB *wdb);


/* Get the inode number of the database file of a word database object.
   `wdb' specifies the word database object.
   The return value is the inode number of the database file or 0 the object does not connect to
   any database file. */
uint64_t tcwdbinode(TCWDB *wdb);


/* Get the modification time of the database file of a word database object.
   `wdb' specifies the word database object.
   The return value is the inode number of the database file or 0 the object does not connect to
   any database file. */
time_t tcwdbmtime(TCWDB *wdb);


/* Get the options of a word database object.
   `wdb' specifies the word database object.
   The return value is the options. */
uint8_t tcwdbopts(TCWDB *wdb);


/* Get the maximum number of forward matching expansion of a word database object.
   `wdb' specifies the word database object.
   The return value is the maximum number of forward matching expansion. */
uint32_t tcwdbfwmmax(TCWDB *wdb);


/* Get the number of records in the cache of a word database object.
   `wdb' specifies the word database object.
   The return value is the number of records in the cache. */
uint32_t tcwdbcnum(TCWDB *wdb);


/* Set the callback function for sync progression of a word database object.
   `wdb' specifies the word database object.
   `cb' specifies the pointer to the callback function for sync progression.  Its first argument
   specifies the number of tokens to be synchronized.  Its second argument specifies the number
   of processed tokens.  Its third argument specifies the message string.  The fourth argument
   specifies an arbitrary pointer.  Its return value should be true usually, or false if the sync
   operation should be terminated.
   `opq' specifies the arbitrary pointer to be given to the callback function. */
void tcwdbsetsynccb(TCWDB *wdb, bool (*cb)(int, int, const char *, void *), void *opq);


/* Set the callback function for word addition of a word database object.
   `wdb' specifies the word database object.
   `cb' specifies the pointer to the callback function for sync progression.  Its first argument
   specifies the pointer to the region of a word.  Its second argument specifies an arbitrary
   pointer.  Its return value should be true usually, or false if the word addition operation
   should be terminated.
   `opq' specifies the arbitrary pointer to be given to the callback function. */
void tcwdbsetaddcb(TCWDB *wdb, bool (*cb)(const char *, void *), void *opq);


/* laputa.h follows */
#define JDBWDBMAX      32                /* maximum number of the internal databases */

typedef struct {                         /* type of structure for a tagged database object */
  void *mmtx;                            /* mutex for method */
  char *path;                            /* path of the database directory */
  bool wmode;                            /* whether to be writable */
  uint8_t wopts;                         /* tuning options of word databases */
  int womode;                            /* open mode of word databases */
  TCHDB *txdb;                           /* text database object */
  TCBDB *lsdb;                           /* word list database object */
  TCWDB *idxs[JDBWDBMAX];                /* word database objects */
  uint8_t inum;                          /* number of the word database objects */
  uint8_t cnum;                          /* current number of the word database */
  uint32_t ernum;                        /* expected number of records */
  uint32_t etnum;                        /* expected number of tokens */
  uint64_t iusiz;                        /* unit size of each index file */
  uint8_t opts;                          /* options */
  bool (*synccb)(int, int, const char *, void *);  /* callback function for sync progression */
  void *syncopq;                         /* opaque for the sync callback function */
  uint8_t exopts;                        /* expert options */
} TCJDB;

enum {                                   /* enumeration for tuning options */
  JDBTLARGE = 1 << 0,                    /* use 64-bit bucket array */
  JDBTDEFLATE = 1 << 1,                  /* compress each page with Deflate */
  JDBTBZIP = 1 << 2,                     /* compress each record with BZIP2 */
  JDBTTCBS = 1 << 3                      /* compress each page with TCBS */
};

enum {                                   /* enumeration for open modes */
  JDBOREADER = 1 << 0,                   /* open as a reader */
  JDBOWRITER = 1 << 1,                   /* open as a writer */
  JDBOCREAT = 1 << 2,                    /* writer creating */
  JDBOTRUNC = 1 << 3,                    /* writer truncating */
  JDBONOLCK = 1 << 4,                    /* open without locking */
  JDBOLCKNB = 1 << 5                     /* lock without blocking */
};

enum {                                   /* enumeration for get modes */
  JDBSSUBSTR,                            /* substring matching */
  JDBSPREFIX,                            /* prefix matching */
  JDBSSUFFIX,                            /* suffix matching */
  JDBSFULL                               /* full matching */
};


/* Get the message string corresponding to an error code.
   `ecode' specifies the error code.
   The return value is the message string of the error code. */
const char *tcjdberrmsg(int ecode);


/* Create a tagged database object.
   The return value is the new tagged database object. */
TCJDB *tcjdbnew(void);


/* Delete a tagged database object.
   `jdb' specifies the tagged database object.
   If the database is not closed, it is closed implicitly.  Note that the deleted object and its
   derivatives can not be used anymore. */
void tcjdbdel(TCJDB *jdb);


/* Get the last happened error code of a tagged database object.
   `jdb' specifies the tagged database object.
   The return value is the last happened error code.
   The following error code is defined: `TCESUCCESS' for success, `TCETHREAD' for threading
   error, `TCEINVALID' for invalid operation, `TCENOFILE' for file not found, `TCENOPERM' for no
   permission, `TCEMETA' for invalid meta data, `TCERHEAD' for invalid record header, `TCEOPEN'
   for open error, `TCECLOSE' for close error, `TCETRUNC' for trunc error, `TCESYNC' for sync
   error, `TCESTAT' for stat error, `TCESEEK' for seek error, `TCEREAD' for read error,
   `TCEWRITE' for write error, `TCEMMAP' for mmap error, `TCELOCK' for lock error, `TCEUNLINK'
   for unlink error, `TCERENAME' for rename error, `TCEMKDIR' for mkdir error, `TCERMDIR' for
   rmdir error, `TCEKEEP' for existing record, `TCENOREC' for no record found, and `TCEMISC' for
   miscellaneous error. */
int tcjdbecode(TCJDB *jdb);


/* Set the tuning parameters of a tagged database object.
   `jdb' specifies the tagged database object which is not opened.
   `ernum' specifies the expected number of records to be stored.  If it is not more than 0, the
   default value is specified.  The default value is 1000000.
   `etnum' specifies the expected number of tokens to be stored.  If it is not more than 0, the
   default value is specified.  The default value is 1000000.
   `iusiz' specifies the unit size of each index file.  If it is not more than 0, the default
   value is specified.  The default value is 536870912.
   `opts' specifies options by bitwise or: `JDBTLARGE' specifies that the size of the database
   can be larger than 2GB by using 64-bit bucket array, `JDBTDEFLATE' specifies that each page
   is compressed with Deflate encoding, `JDBTBZIP' specifies that each page is compressed with
   BZIP2 encoding, `JDBTTCBS' specifies that each page is compressed with TCBS encoding.
   If successful, the return value is true, else, it is false.
   Note that the tuning parameters should be set before the database is opened. */
bool tcjdbtune(TCJDB *jdb, int64_t ernum, int64_t etnum, int64_t iusiz, uint8_t opts);


/* Set the caching parameters of a tagged database object.
   `jdb' specifies the tagged database object which is not opened.
   `icsiz' specifies the capacity size of the token cache.  If it is not more than 0, the default
   value is specified.  The default value is 134217728.
   `lcnum' specifies the maximum number of cached leaf nodes of B+ tree.  If it is not more than
   0, the default value is specified.  The default value is 64 for writer or 1024 for reader.
   If successful, the return value is true, else, it is false.
   Note that the caching parameters should be set before the database is opened. */
bool tcjdbsetcache(TCJDB *jdb, int64_t icsiz, int32_t lcnum);


/* Set the maximum number of forward matching expansion of a tagged database object.
   `jdb' specifies the tagged database object.
   `fwmmax' specifies the maximum number of forward matching expansion.
   If successful, the return value is true, else, it is false.
   Note that the matching parameters should be set before the database is opened. */
bool tcjdbsetfwmmax(TCJDB *jdb, uint32_t fwmmax);


/* Open a tagged database object.
   `jdb' specifies the tagged database object.
   `path' specifies the path of the database directory.
   `omode' specifies the connection mode: `JDBOWRITER' as a writer, `JDBOREADER' as a reader.
   If the mode is `JDBOWRITER', the following may be added by bitwise or: `JDBOCREAT', which
   means it creates a new database if not exist, `JDBOTRUNC', which means it creates a new
   database regardless if one exists.  Both of `JDBOREADER' and `JDBOWRITER' can be added to by
   bitwise or: `JDBONOLCK', which means it opens the database directory without file locking, or
   `JDBOLCKNB', which means locking is performed without blocking.
   If successful, the return value is true, else, it is false. */
bool tcjdbopen(TCJDB *jdb, const char *path, int omode);


/* Close a tagged database object.
   `jdb' specifies the tagged database object.
   If successful, the return value is true, else, it is false.
   Update of a database is assured to be written when the database is closed.  If a writer opens
   a database but does not close it appropriately, the database will be broken. */
bool tcjdbclose(TCJDB *jdb);


/* Store a record into a tagged database object.
   `jdb' specifies the tagged database object connected as a writer.
   `id' specifies the ID number of the record.  It should be positive.
   `words' specifies a list object contains the words of the record, whose encoding should be
   UTF-8.
   If successful, the return value is true, else, it is false. */
bool tcjdbput(TCJDB *jdb, int64_t id, const TCLIST *words);


/* Store a record with a text string into a tagged database object.
   `jdb' specifies the tagged database object connected as a writer.
   `id' specifies the ID number of the record.  It should be positive.
   `text' specifies the string of the record, whose encoding should be UTF-8.
   `delims' specifies a string containing delimiting characters of the text.  If it is `NULL',
   space characters are specified.
   If successful, the return value is true, else, it is false. */
bool tcjdbput2(TCJDB *jdb, int64_t id, const char *text, const char *delims);


/* Remove a record of a tagged database object.
   `jdb' specifies the tagged database object connected as a writer.
   `id' specifies the ID number of the record.  It should be positive.
   If successful, the return value is true, else, it is false. */
bool tcjdbout(TCJDB *jdb, int64_t id);


/* Retrieve a record of a tagged database object.
   `jdb' specifies the tagged database object connected as a writer.
   `id' specifies the ID number of the record.  It should be positive.
   If successful, the return value is the string of the corresponding record, else, it is `NULL'.
   Because the object of the return value is created with the function `tclistnew', it should be
   deleted with the function `tclistdel' when it is no longer in use. */
TCLIST *tcjdbget(TCJDB *jdb, int64_t id);


/* Retrieve a record as a string of a tagged database object.
   `jdb' specifies the tagged database object connected as a writer.
   `id' specifies the ID number of the record.  It should be positive.
   If successful, the return value is the string of the corresponding record, else, it is `NULL'.
   Each word is separated by a tab character.
   Because the region of the return value is allocated with the `malloc' call, it should be
   released with the `free' call when it is no longer in use. */
char *tcjdbget2(TCJDB *jdb, int64_t id);


/* Search a tagged database.
   `jdb' specifies the tagged database object.
   `word' specifies the string of the word to be matched to.
   `smode' specifies the matching mode: `JDBSSUBSTR' as substring matching, `JDBSPREFIX' as prefix
   matching, `JDBSSUFFIX' as suffix matching, `JDBSFULL' as full matching.
   `np' specifies the pointer to the variable into which the number of elements of the return
   value is assigned.
   If successful, the return value is the pointer to an array of ID numbers of the corresponding
   records.  `NULL' is returned on failure.
   Because the region of the return value is allocated with the `malloc' call, it should be
   released with the `free' call when it is no longer in use. */
uint64_t *tcjdbsearch(TCJDB *jdb, const char *word, int smode, int *np);


/* Search a tagged database with a compound expression.
   `jdb' specifies the tagged database object.
   `expr' specifies the string of the compound expression.
   `np' specifies the pointer to the variable into which the number of elements of the return
   value is assigned.
   If successful, the return value is the pointer to an array of ID numbers of the corresponding
   records.  `NULL' is returned on failure.
   Because the region of the return value is allocated with the `malloc' call, it should be
   released with the `free' call when it is no longer in use. */
uint64_t *tcjdbsearch2(TCJDB *jdb, const char *expr, int *np);


/* Initialize the iterator of a tagged database object.
   `jdb' specifies the tagged database object.
   If successful, the return value is true, else, it is false.
   The iterator is used in order to access the ID number of every record stored in a database. */
bool tcjdbiterinit(TCJDB *jdb);


/* Get the next ID number of the iterator of a tagged database object.
   `jdb' specifies the tagged database object.
   If successful, the return value is the ID number of the next record, else, it is 0.  0 is
   returned when no record is to be get out of the iterator.
   It is possible to access every record by iteration of calling this function.  It is allowed to
   update or remove records whose keys are fetched while the iteration.  However, it is not
   assured if updating the database is occurred while the iteration.  Besides, the order of this
   traversal access method is arbitrary, so it is not assured that the order of storing matches
   the one of the traversal access. */
uint64_t tcjdbiternext(TCJDB *jdb);


/* Synchronize updated contents of a tagged database object with the files and the device.
   `jdb' specifies the tagged database object connected as a writer.
   If successful, the return value is true, else, it is false.
   This function is useful when another process connects the same database directory. */
bool tcjdbsync(TCJDB *jdb);


/* Optimize the files of a tagged database object.
   `jdb' specifies the tagged database object connected as a writer.
   If successful, the return value is true, else, it is false.
   This function is useful to reduce the size of the database files with data fragmentation by
   successive updating. */
bool tcjdboptimize(TCJDB *jdb);


/* Remove all records of a tagged database object.
   `jdb' specifies the tagged database object connected as a writer.
   If successful, the return value is true, else, it is false. */
bool tcjdbvanish(TCJDB *jdb);


/* Copy the database directory of a tagged database object.
   `jdb' specifies the tagged database object.
   `path' specifies the path of the destination directory.  If it begins with `@', the trailing
   substring is executed as a command line.
   If successful, the return value is true, else, it is false.  False is returned if the executed
   command returns non-zero code.
   The database directory is assured to be kept synchronized and not modified while the copying or
   executing operation is in progress.  So, this function is useful to create a backup directory
   of the database directory. */
bool tcjdbcopy(TCJDB *jdb, const char *path);


/* Get the directory path of a tagged database object.
   `jdb' specifies the tagged database object.
   The return value is the path of the database directory or `NULL' if the object does not
   connect to any database directory. */
const char *tcjdbpath(TCJDB *jdb);


/* Get the number of records of a tagged database object.
   `jdb' specifies the tagged database object.
   The return value is the number of records or 0 if the object does not connect to any database
   directory. */
uint64_t tcjdbrnum(TCJDB *jdb);


/* Get the total size of the database files of a tagged database object.
   `jdb' specifies the tagged database object.
   The return value is the size of the database files or 0 if the object does not connect to any
   database directory. */
uint64_t tcjdbfsiz(TCJDB *jdb);



/*************************************************************************************************
 * features for experts
 *************************************************************************************************/


enum {                                   /* enumeration for expert options */
  JDBXNOTXT = 1 << 0                     /* no text mode */
};


/* Set the file descriptor for debugging output.
   `jdb' specifies the tagged database object.
   `fd' specifies the file descriptor for debugging output. */
void tcjdbsetdbgfd(TCJDB *jdb, int fd);


/* Get the file descriptor for debugging output.
   `jdb' specifies the tagged database object.
   The return value is the file descriptor for debugging output. */
int tcjdbdbgfd(TCJDB *jdb);


/* Synchronize updating contents on memory of a tagged database object.
   `jdb' specifies the tagged database object.
   `level' specifies the synchronization lavel; 0 means cache synchronization, 1 means database
   synchronization, and 2 means file synchronization.
   If successful, the return value is true, else, it is false. */
bool tcjdbmemsync(TCJDB *jdb, int level);


/* Get the inode number of the database directory of a tagged database object.
   `jdb' specifies the tagged database object.
   The return value is the inode number of the database directory or 0 the object does not
   connect to any database directory. */
uint64_t tcjdbinode(TCJDB *jdb);


/* Get the modification time of the database directory of a tagged database object.
   `jdb' specifies the tagged database object.
   The return value is the inode number of the database directory or 0 the object does not
   connect to any database directory. */
time_t tcjdbmtime(TCJDB *jdb);


/* Get the options of a tagged database object.
   `jdb' specifies the tagged database object.
   The return value is the options. */
uint8_t tcjdbopts(TCJDB *jdb);


/* Set the callback function for sync progression of a tagged database object.
   `jdb' specifies the tagged database object.
   `cb' specifies the pointer to the callback function for sync progression.  Its first argument
   specifies the number of tokens to be synchronized.  Its second argument specifies the number
   of processed tokens.  Its third argument specifies the message string.  The fourth argument
   specifies an arbitrary pointer.  Its return value should be true usually, or false if the sync
   operation should be terminated.
   `opq' specifies the arbitrary pointer to be given to the callback function. */
void tcjdbsetsynccb(TCJDB *jdb, bool (*cb)(int, int, const char *, void *), void *opq);


/* Set the expert options of a tagged database object.
   `jdb' specifies the tagged database object.
   `exopts' specifies options by bitwise or: `JDBXNOTXT' specifies that the text database does
   not record any record. */
void tcjdbsetexopts(TCJDB *jdb, uint32_t exopts);


/* tcqdb.h follows */


typedef struct {                         /* type of structure for a q-gram database */
  void *mmtx;                            /* mutex for method */
  TCBDB *idx;                            /* internal database object */
  bool open;                             /* whether the internal database is opened */
  TCMAP *cc;                             /* cache of q-gram tokens */
  uint64_t icsiz;                        /* capacity of the cache */
  uint32_t lcnum;                        /* max number of cached leaves */
  TCMAP *dtokens;                        /* deleted tokens */
  struct _TCIDSET *dids;                 /* deleted ID numbers */
  uint32_t etnum;                        /* expected number of tokens */
  uint8_t opts;                          /* options */
  uint32_t fwmmax;                       /* maximum number of forward matching expansion */
  bool (*synccb)(int, int, const char *, void *);  /* callback function for sync progression */
  void *syncopq;                         /* opaque for the sync callback function */
} TCQDB;

enum {                                   /* enumeration for tuning options */
  QDBTLARGE = 1 << 0,                    /* use 64-bit bucket array */
  QDBTDEFLATE = 1 << 1,                  /* compress each page with Deflate */
  QDBTBZIP = 1 << 2,                     /* compress each record with BZIP2 */
  QDBTTCBS = 1 << 3                      /* compress each page with TCBS */
};

enum {                                   /* enumeration for open modes */
  QDBOREADER = 1 << 0,                   /* open as a reader */
  QDBOWRITER = 1 << 1,                   /* open as a writer */
  QDBOCREAT = 1 << 2,                    /* writer creating */
  QDBOTRUNC = 1 << 3,                    /* writer truncating */
  QDBONOLCK = 1 << 4,                    /* open without locking */
  QDBOLCKNB = 1 << 5                     /* lock without blocking */
};

enum {                                   /* enumeration for get modes */
  QDBSSUBSTR,                            /* substring matching */
  QDBSPREFIX,                            /* prefix matching */
  QDBSSUFFIX,                            /* suffix matching */
  QDBSFULL                               /* full matching */
};


/* String containing the version information. */
extern const char *tdversion;


/* Get the message string corresponding to an error code.
   `ecode' specifies the error code.
   The return value is the message string of the error code. */
const char *tcqdberrmsg(int ecode);


/* Create a q-gram database object.
   The return value is the new q-gram database object. */
TCQDB *tcqdbnew(void);


/* Delete a q-gram database object.
   `qdb' specifies the q-gram database object.
   If the database is not closed, it is closed implicitly.  Note that the deleted object and its
   derivatives can not be used anymore. */
void tcqdbdel(TCQDB *qdb);


/* Get the last happened error code of a q-gram database object.
   `qdb' specifies the q-gram database object.
   The return value is the last happened error code.
   The following error code is defined: `TCESUCCESS' for success, `TCETHREAD' for threading
   error, `TCEINVALID' for invalid operation, `TCENOFILE' for file not found, `TCENOPERM' for no
   permission, `TCEMETA' for invalid meta data, `TCERHEAD' for invalid record header, `TCEOPEN'
   for open error, `TCECLOSE' for close error, `TCETRUNC' for trunc error, `TCESYNC' for sync
   error, `TCESTAT' for stat error, `TCESEEK' for seek error, `TCEREAD' for read error,
   `TCEWRITE' for write error, `TCEMMAP' for mmap error, `TCELOCK' for lock error, `TCEUNLINK'
   for unlink error, `TCERENAME' for rename error, `TCEMKDIR' for mkdir error, `TCERMDIR' for
   rmdir error, `TCEKEEP' for existing record, `TCENOREC' for no record found, and `TCEMISC' for
   miscellaneous error. */
int tcqdbecode(TCQDB *qdb);


/* Set the tuning parameters of a q-gram database object.
   `qdb' specifies the q-gram database object which is not opened.
   `etnum' specifies the expected number of tokens to be stored.  If it is not more than 0, the
   default value is specified.  The default value is 1000000.
   `opts' specifies options by bitwise or: `QDBTLARGE' specifies that the size of the database
   can be larger than 2GB by using 64-bit bucket array, `QDBTDEFLATE' specifies that each page
   is compressed with Deflate encoding, `QDBTBZIP' specifies that each page is compressed with
   BZIP2 encoding, `QDBTTCBS' specifies that each page is compressed with TCBS encoding.
   If successful, the return value is true, else, it is false.
   Note that the tuning parameters should be set before the database is opened. */
bool tcqdbtune(TCQDB *qdb, int64_t etnum, uint8_t opts);


/* Set the caching parameters of a q-gram database object.
   `qdb' specifies the q-gram database object which is not opened.
   `icsiz' specifies the capacity size of the token cache.  If it is not more than 0, the default
   value is specified.  The default value is 134217728.
   `lcnum' specifies the maximum number of cached leaf nodes of B+ tree.  If it is not more than
   0, the default value is specified.  The default value is 64 for writer or 1024 for reader.
   If successful, the return value is true, else, it is false.
   Note that the caching parameters should be set before the database is opened. */
bool tcqdbsetcache(TCQDB *qdb, int64_t icsiz, int32_t lcnum);


/* Set the maximum number of forward matching expansion of a q-gram database object.
   `qdb' specifies the q-gram database object.
   `fwmmax' specifies the maximum number of forward matching expansion.
   If successful, the return value is true, else, it is false.
   Note that the matching parameters should be set before the database is opened. */
bool tcqdbsetfwmmax(TCQDB *qdb, uint32_t fwmmax);


/* Open a q-gram database object.
   `qdb' specifies the q-gram database object.
   `path' specifies the path of the database file.
   `omode' specifies the connection mode: `QDBOWRITER' as a writer, `QDBOREADER' as a reader.
   If the mode is `QDBOWRITER', the following may be added by bitwise or: `QDBOCREAT', which
   means it creates a new database if not exist, `QDBOTRUNC', which means it creates a new
   database regardless if one exists.  Both of `QDBOREADER' and `QDBOWRITER' can be added to by
   bitwise or: `QDBONOLCK', which means it opens the database file without file locking, or
   `QDBOLCKNB', which means locking is performed without blocking.
   If successful, the return value is true, else, it is false. */
bool tcqdbopen(TCQDB *qdb, const char *path, int omode);


/* Close a q-gram database object.
   `qdb' specifies the q-gram database object.
   If successful, the return value is true, else, it is false.
   Update of a database is assured to be written when the database is closed.  If a writer opens
   a database but does not close it appropriately, the database will be broken. */
bool tcqdbclose(TCQDB *qdb);


/* Store a record into a q-gram database object.
   `qdb' specifies the q-gram database object connected as a writer.
   `id' specifies the ID number of the record.  It should be positive.
   `text' specifies the string of the record, whose encoding should be UTF-8.
   If successful, the return value is true, else, it is false. */
bool tcqdbput(TCQDB *qdb, int64_t id, const char *text);


/* Remove a record of a q-gram database object.
   `qdb' specifies the q-gram database object connected as a writer.
   `id' specifies the ID number of the record.  It should be positive.
   `text' specifies the string of the record, which should be same as the stored one.
   If successful, the return value is true, else, it is false. */
bool tcqdbout(TCQDB *qdb, int64_t id, const char *text);


/* Search a q-gram database.
   `qdb' specifies the q-gram database object.
   `word' specifies the string of the word to be matched to.
   `smode' specifies the matching mode: `QDBSSUBSTR' as substring matching, `QDBSPREFIX' as prefix
   matching, `QDBSSUFFIX' as suffix matching, or `QDBSFULL' as full matching.
   `np' specifies the pointer to the variable into which the number of elements of the return
   value is assigned.
   If successful, the return value is the pointer to an array of ID numbers of the corresponding
   records.  `NULL' is returned on failure.
   Because the region of the return value is allocated with the `malloc' call, it should be
   released with the `free' call when it is no longer in use. */
uint64_t *tcqdbsearch(TCQDB *qdb, const char *word, int smode, int *np);


/* Synchronize updated contents of a q-gram database object with the file and the device.
   `qdb' specifies the q-gram database object connected as a writer.
   If successful, the return value is true, else, it is false.
   This function is useful when another process connects the same database file. */
bool tcqdbsync(TCQDB *qdb);


/* Optimize the file of a q-gram database object.
   `qdb' specifies the q-gram database object connected as a writer.
   If successful, the return value is true, else, it is false.
   This function is useful to reduce the size of the database file with data fragmentation by
   successive updating. */
bool tcqdboptimize(TCQDB *qdb);


/* Remove all records of a q-gram database object.
   `qdb' specifies the q-gram database object connected as a writer.
   If successful, the return value is true, else, it is false. */
bool tcqdbvanish(TCQDB *qdb);


/* Copy the database file of a q-gram database object.
   `qdb' specifies the q-gram database object.
   `path' specifies the path of the destination file.  If it begins with `@', the trailing
   substring is executed as a command line.
   If successful, the return value is true, else, it is false.  False is returned if the executed
   command returns non-zero code.
   The database file is assured to be kept synchronized and not modified while the copying or
   executing operation is in progress.  So, this function is useful to create a backup file of
   the database file. */
bool tcqdbcopy(TCQDB *qdb, const char *path);


/* Get the file path of a q-gram database object.
   `qdb' specifies the q-gram database object.
   The return value is the path of the database file or `NULL' if the object does not connect to
   any database file. */
const char *tcqdbpath(TCQDB *qdb);


/* Get the number of tokens of a q-gram database object.
   `qdb' specifies the q-gram database object.
   The return value is the number of tokens or 0 if the object does not connect to any database
   file. */
uint64_t tcqdbtnum(TCQDB *qdb);


/* Get the size of the database file of a q-gram database object.
   `qdb' specifies the q-gram database object.
   The return value is the size of the database file or 0 if the object does not connect to any
   database file. */
uint64_t tcqdbfsiz(TCQDB *qdb);



/*************************************************************************************************
 * features for experts
 *************************************************************************************************/


#define _TD_VERSION    "0.9.9"
#define _TD_LIBVER     110
#define _TD_FORMATVER  "0.9"

#define QDBSYNCMSGF    "started"         /* first message of sync progression */
#define QDBSYNCMSGL    "finished"        /* last message of sync progression */

typedef struct {                         /* type of structure for a result set */
  uint64_t *ids;                         /* array of ID numbers */
  int num;                               /* number of the array */
} QDBRSET;

typedef struct _TCIDSET {                /* type of structure for an ID set */
  uint64_t *buckets;                     /* bucket array */
  uint32_t bnum;                         /* number of buckets */
  TCMAP *trails;                         /* map of trailing records */
} TCIDSET;

enum {                                   /* enumeration for text normalization options */
  TCTNLOWER = 1 << 0,                    /* into lower cases */
  TCTNNOACC = 1 << 1,                    /* into ASCII alphabets */
  TCTNSPACE = 1 << 2                     /* into ASCII space */
};


/* Set the file descriptor for debugging output.
   `qdb' specifies the q-gram database object.
   `fd' specifies the file descriptor for debugging output. */
void tcqdbsetdbgfd(TCQDB *qdb, int fd);


/* Get the file descriptor for debugging output.
   `qdb' specifies the q-gram database object.
   The return value is the file descriptor for debugging output. */
int tcqdbdbgfd(TCQDB *qdb);


/* Synchronize updating contents on memory of a q-gram database object.
   `qdb' specifies the q-gram database object.
   `level' specifies the synchronization lavel; 0 means cache synchronization, 1 means database
   synchronization, and 2 means file synchronization.
   If successful, the return value is true, else, it is false. */
bool tcqdbmemsync(TCQDB *qdb, int level);


/* Clear the cache of a q-gram database object.
   `qdb' specifies the q-gram database object.
   If successful, the return value is true, else, it is false. */
bool tcqdbcacheclear(TCQDB *qdb);


/* Get the inode number of the database file of a q-gram database object.
   `qdb' specifies the q-gram database object.
   The return value is the inode number of the database file or 0 the object does not connect to
   any database file. */
uint64_t tcqdbinode(TCQDB *qdb);


/* Get the modification time of the database file of a q-gram database object.
   `qdb' specifies the q-gram database object.
   The return value is the inode number of the database file or 0 the object does not connect to
   any database file. */
time_t tcqdbmtime(TCQDB *qdb);


/* Get the options of a q-gram database object.
   `qdb' specifies the q-gram database object.
   The return value is the options. */
uint8_t tcqdbopts(TCQDB *qdb);


/* Get the maximum number of forward matching expansion of a q-gram database object.
   `qdb' specifies the q-gram database object.
   The return value is the maximum number of forward matching expansion. */
uint32_t tcqdbfwmmax(TCQDB *qdb);


/* Get the number of records in the cache of a q-gram database object.
   `wdb' specifies the word database object.
   The return value is the number of records in the cache. */
uint32_t tcqdbcnum(TCQDB *qdb);


/* Set the callback function for sync progression of a q-gram database object.
   `qdb' specifies the q-gram database object.
   `cb' specifies the pointer to the callback function for sync progression.  Its first argument
   specifies the number of tokens to be synchronized.  Its second argument specifies the number
   of processed tokens.  Its third argument specifies the message string.  The fourth argument
   specifies an arbitrary pointer.  Its return value should be true usually, or false if the sync
   operation should be terminated.
   `opq' specifies the arbitrary pointer to be given to the callback function. */
void tcqdbsetsynccb(TCQDB *qdb, bool (*cb)(int, int, const char *, void *), void *opq);


/* Merge multiple result sets by union.
   `rsets' specifies the pointer to the array of result sets.
   `rsnum' specifies the number of the array.
   `np' specifies the pointer to the variable into which the number of elements of the return
   value is assigned.
   If successful, the return value is the pointer to an array of ID numbers of the result.
   Because the region of the return value is allocated with the `malloc' call, it should be
   released with the `free' call when it is no longer in use. */
uint64_t *tcqdbresunion(QDBRSET *rsets, int rsnum, int *np);


/* Merge multiple result sets by intersection.
   `rsets' specifies the pointer to the array of result sets.
   `rsnum' specifies the number of the array.
   `np' specifies the pointer to the variable into which the number of elements of the return
   value is assigned.
   If successful, the return value is the pointer to an array of ID numbers of the result.
   Because the region of the return value is allocated with the `malloc' call, it should be
   released with the `free' call when it is no longer in use. */
uint64_t *tcqdbresisect(QDBRSET *rsets, int rsnum, int *np);


/* Merge multiple result sets by difference.
   `rsets' specifies the pointer to the array of result sets.
   `rsnum' specifies the number of the array.
   `np' specifies the pointer to the variable into which the number of elements of the return
   value is assigned.
   If successful, the return value is the pointer to an array of ID numbers of the result.
   Because the region of the return value is allocated with the `malloc' call, it should be
   released with the `free' call when it is no longer in use. */
uint64_t *tcqdbresdiff(QDBRSET *rsets, int rsnum, int *np);


/* Normalize a text.
   `text' specifies the string of the record, whose encoding should be UTF-8.
   `opts' specifies options by bitwise or: `TCTNLOWER' specifies that alphabetical characters are
   normalized into lower cases, `TCTNNOACC' specifies that alphabetical characters with accent
   marks are normalized without accent marks, `TCTNSPACE' specifies that white space characters
   are normalized into the ASCII space and they are squeezed into one. */
void tctextnormalize(char *text, int opts);


/* Create an ID set object.
   `bnum' specifies the number of the buckets.
   The return value is the new ID set object. */
TCIDSET *tcidsetnew(uint32_t bnum);


/* Delete an ID set object.
   `idset' specifies the ID set object. */
void tcidsetdel(TCIDSET *idset);


/* Mark an ID number of an ID set object.
   `idset' specifies the ID set object.
   `id' specifies the ID number. */
void tcidsetmark(TCIDSET *idset, int64_t id);


/* Check an ID of an ID set object.
   `idset' specifies the ID set object.
   `id' specifies the ID number.
   The return value is true if the ID number is marked, else, it is false. */
bool tcidsetcheck(TCIDSET *idset, int64_t id);


/* Clear an ID set object.
   `idset' specifies the ID set object. */
void tcidsetclear(TCIDSET *idset);


