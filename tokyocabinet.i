%module tokyocabinet
%insert("lisphead") %{
(in-package :tokyocabinet-sys)
(define-foreign-library tokyocabinet
  (:unix (:or "libtokyocabinet.so.7" "libtokyocabinet.so"))
  (t (:default "libtokyocabinet")))
(use-foreign-library tokyocabinet)

%}
/* Utility functions and typedefs */

typedef int (*TCCMP)(const char *aptr, int asiz, const char *bptr, int bsiz, void *op);
typedef void *(*TCCODEC)(const void *ptr, int size, int *sp, void *op);
typedef void *(*TCPDPROC)(const void *vbuf, int vsiz, int *sp, void *op);
typedef bool (*TCITER)(const void *kbuf, int ksiz, const void *vbuf, int vsiz, void *op);
TCXSTR *tcxstrnew(void);
TCXSTR *tcxstrnew2(const char *str);
TCXSTR *tcxstrnew3(int asiz);
TCXSTR *tcxstrdup(const TCXSTR *xstr);
void tcxstrdel(TCXSTR *xstr);
void tcxstrcat(TCXSTR *xstr, const void *ptr, int size);
void tcxstrcat2(TCXSTR *xstr, const char *str);
const void *tcxstrptr(const TCXSTR *xstr);
int tcxstrsize(const TCXSTR *xstr);
void tcxstrclear(TCXSTR *xstr);
//void tcxstrprintf(TCXSTR *xstr, const char *format, ...);
//char *tcsprintf(const char *format, ...);

TCLIST *tclistnew(void);
TCLIST *tclistnew2(int anum);
TCLIST *tclistnew3(const char *str, ...);
TCLIST *tclistdup(const TCLIST *list);
void tclistdel(TCLIST *list);
int tclistnum(const TCLIST *list);
const void *tclistval(const TCLIST *list, int index, int *sp);
const char *tclistval2(const TCLIST *list, int index);
void tclistpush(TCLIST *list, const void *ptr, int size);
void tclistpush2(TCLIST *list, const char *str);
void *tclistpop(TCLIST *list, int *sp);
char *tclistpop2(TCLIST *list);
void tclistunshift(TCLIST *list, const void *ptr, int size);
void tclistunshift2(TCLIST *list, const char *str);
void *tclistshift(TCLIST *list, int *sp);
char *tclistshift2(TCLIST *list);
void tclistinsert(TCLIST *list, int index, const void *ptr, int size);
void tclistinsert2(TCLIST *list, int index, const char *str);
void *tclistremove(TCLIST *list, int index, int *sp);
char *tclistremove2(TCLIST *list, int index);
void tclistover(TCLIST *list, int index, const void *ptr, int size);
void tclistover2(TCLIST *list, int index, const char *str);
void tclistsort(TCLIST *list);
int tclistlsearch(const TCLIST *list, const void *ptr, int size);
int tclistbsearch(const TCLIST *list, const void *ptr, int size);
void tclistclear(TCLIST *list);
void *tclistdump(const TCLIST *list, int *sp);
TCLIST *tclistload(const void *ptr, int size);
void tclistsortci(TCLIST *list);
void tclistsortex(TCLIST *list, int (*cmp)(const TCLISTDATUM *, const TCLISTDATUM *));
void tclistinvert(TCLIST *list);

TCMAP *tcmapnew(void);
TCMAP *tcmapnew2(uint32_t bnum);
TCMAP *tcmapnew3(const char *str, ...);
TCMAP *tcmapdup(const TCMAP *map);
void tcmapdel(TCMAP *map);
void tcmapput(TCMAP *map, const void *kbuf, int ksiz, const void *vbuf, int vsiz);
void tcmapput2(TCMAP *map, const char *kstr, const char *vstr);
bool tcmapputkeep(TCMAP *map, const void *kbuf, int ksiz, const void *vbuf, int vsiz);
bool tcmapputkeep2(TCMAP *map, const char *kstr, const char *vstr);
void tcmapputcat(TCMAP *map, const void *kbuf, int ksiz, const void *vbuf, int vsiz);
void tcmapputcat2(TCMAP *map, const char *kstr, const char *vstr);
bool tcmapout(TCMAP *map, const void *kbuf, int ksiz);
bool tcmapout2(TCMAP *map, const char *kstr);
const void *tcmapget(const TCMAP *map, const void *kbuf, int ksiz, int *sp);
const char *tcmapget2(const TCMAP *map, const char *kstr);
bool tcmapmove(TCMAP *map, const void *kbuf, int ksiz, bool head);
bool tcmapmove2(TCMAP *map, const char *kstr, bool head);
void tcmapiterinit(TCMAP *map);
const void *tcmapiternext(TCMAP *map, int *sp);
const char *tcmapiternext2(TCMAP *map);
uint64_t tcmaprnum(const TCMAP *map);
uint64_t tcmapmsiz(const TCMAP *map);
TCLIST *tcmapkeys(const TCMAP *map);
TCLIST *tcmapvals(const TCMAP *map);
int tcmapaddint(TCMAP *map, const void *kbuf, int ksiz, int num);
double tcmapadddouble(TCMAP *map, const void *kbuf, int ksiz, double num);
void tcmapclear(TCMAP *map);
void tcmapcutfront(TCMAP *map, int num);
void *tcmapdump(const TCMAP *map, int *sp);
TCMAP *tcmapload(const void *ptr, int size);

/* Hash database API */

enum {                                   /* enumeration for additional flags */
  HDBFOPEN = 1 << 0,                     /* whether opened */
  HDBFFATAL = 1 << 1                     /* whetehr with fatal error */
};

enum {                                   /* enumeration for tuning options */
  HDBTLARGE = 1 << 0,                    /* use 64-bit bucket array */
  HDBTDEFLATE = 1 << 1,                  /* compress each record with Deflate */
  HDBTBZIP = 1 << 2,                     /* compress each record with BZIP2 */
  HDBTTCBS = 1 << 3,                     /* compress each record with TCBS */
  HDBTEXCODEC = 1 << 4                   /* compress each record with custom functions */
};

enum {                                   /* enumeration for open modes */
  HDBOREADER = 1 << 0,                   /* open as a reader */
  HDBOWRITER = 1 << 1,                   /* open as a writer */
  HDBOCREAT = 1 << 2,                    /* writer creating */
  HDBOTRUNC = 1 << 3,                    /* writer truncating */
  HDBONOLCK = 1 << 4,                    /* open without locking */
  HDBOLCKNB = 1 << 5,                    /* lock without blocking */
  HDBOTSYNC = 1 << 6                     /* synchronize every transaction */
};

bool tchdbmemsync(TCHDB *hdb, bool phys);
bool tchdbhasmutex(TCHDB *hdb);
bool tchdbcacheclear(TCHDB *hdb);
const char *tchdberrmsg(int ecode);
TCHDB *tchdbnew(void);
void tchdbdel(TCHDB *hdb);
int tchdbecode(TCHDB *hdb);
bool tchdbsetmutex(TCHDB *hdb);
bool tchdbtune(TCHDB *hdb, int64_t bnum, int8_t apow,
 int8_t fpow, uint8_t opts);
bool tchdbsetcache(TCHDB *hdb, int32_t rcnum);
bool tchdbsetxmsiz(TCHDB *hdb, int64_t xmsiz);
bool tchdbopen(TCHDB *hdb, const char *path, int omode);
bool tchdbclose(TCHDB *hdb);
bool tchdbput(TCHDB *hdb, const void *kbuf,
 int ksiz, const void *vbuf, int vsiz);
bool tchdbput2(TCHDB *hdb, const char *kstr, const char *vstr);
bool tchdbputkeep(TCHDB *hdb, const void *kbuf,
 int ksiz, const void *vbuf, int vsiz);
bool tchdbputkeep2(TCHDB *hdb, const char *kstr, const char *vstr);
bool tchdbputcat(TCHDB *hdb, const void *kbuf,
 int ksiz, const void *vbuf, int vsiz);
bool tchdbputcat2(TCHDB *hdb, const char *kstr, const char *vstr);
bool tchdbputasync(TCHDB *hdb, const void *kbuf,
 int ksiz, const void *vbuf, int vsiz);
bool tchdbputasync2(TCHDB *hdb, const char *kstr, const char *vstr);
bool tchdbout(TCHDB *hdb, const void *kbuf, int ksiz);
bool tchdbout2(TCHDB *hdb, const char *kstr);
void *tchdbget(TCHDB *hdb, const void *kbuf, int ksiz, int *sp);
char *tchdbget2(TCHDB *hdb, const char *kstr);
int tchdbget3(TCHDB *hdb, const void *kbuf, int ksiz, void
    *vbuf, int max);
int tchdbvsiz(TCHDB *hdb, const void *kbuf, int ksiz);
int tchdbvsiz2(TCHDB *hdb, const char *kstr);
bool tchdbiterinit(TCHDB *hdb);
void *tchdbiternext(TCHDB *hdb, int *sp);
char *tchdbiternext2(TCHDB *hdb);
bool tchdbiternext3(TCHDB *hdb, TCXSTR *kxstr, TCXSTR
    *vxstr);
TCLIST *tchdbfwmkeys(TCHDB *hdb, const void *pbuf, int
    psiz, int max);
TCLIST *tchdbfwmkeys2(TCHDB *hdb, const char *pstr, int
    max);
int tchdbaddint(TCHDB *hdb, const void *kbuf, int ksiz,
    int num);
double tchdbadddouble(TCHDB *hdb, const void *kbuf, int
    ksiz, double num);
bool tchdbsync(TCHDB *hdb);
bool tchdboptimize(TCHDB *hdb, int64_t bnum, int8_t apow,
    int8_t fpow, uint8_t opts);
bool tchdbvanish(TCHDB *hdb);
bool tchdbcopy(TCHDB *hdb, const char *path);
bool tchdbtranbegin(TCHDB *hdb);
bool tchdbtrancommit(TCHDB *hdb);
bool tchdbtranabort(TCHDB *hdb);
const char *tchdbpath(TCHDB *hdb);
uint64_t tchdbrnum(TCHDB *hdb);
uint64_t tchdbfsiz(TCHDB *hdb);

enum {                                   /* enumeration for additional flags */
  BDBFOPEN = 1 << 0,                   /* whether opened */
  BDBFFATAL = 1 << 1                  /* whetehr with fatal error */
};

enum {                                   /* enumeration for tuning options */
  BDBTLARGE = 1 << 0,                    /* use 64-bit bucket array */
  BDBTDEFLATE = 1 << 1,                  /* compress each page with Deflate */
  BDBTBZIP = 1 << 2,                     /* compress each record with BZIP2 */
  BDBTTCBS = 1 << 3,                     /* compress each page with TCBS */
  BDBTEXCODEC = 1 << 4                   /* compress each record with outer functions */
};

enum {                                   /* enumeration for open modes */
  BDBOREADER = 1 << 0,                   /* open as a reader */
  BDBOWRITER = 1 << 1,                   /* open as a writer */
  BDBOCREAT = 1 << 2,                    /* writer creating */
  BDBOTRUNC = 1 << 3,                    /* writer truncating */
  BDBONOLCK = 1 << 4,                    /* open without locking */
  BDBOLCKNB = 1 << 5,                    /* lock without blocking */
  BDBOTSYNC = 1 << 6                     /* synchronize every transaction */
};

typedef struct {                         /* type of structure for a B+ tree cursor */
  TCBDB *bdb;                            /* database object */
  uint64_t id;                           /* ID number of the leaf */
  int32_t kidx;                          /* number of the key */
  int32_t vidx;                          /* number of the value */
} BDBCUR;


enum {                                   /* enumeration for cursor put mode */
  BDBCPCURRENT,                          /* current */
  BDBCPBEFORE,                           /* before */
  BDBCPAFTER                             /* after */
};

const char *tcbdberrmsg(int ecode);
TCBDB *tcbdbnew(void);
void tcbdbdel(TCBDB *bdb);
int tcbdbecode(TCBDB *bdb);
bool tcbdbsetmutex(TCBDB *bdb);
bool tcbdbsetcmpfunc(TCBDB *bdb, TCCMP cmp, void *cmpop);
bool tcbdbtune(TCBDB *bdb, int32_t lmemb, int32_t nmemb,
               int64_t bnum, int8_t apow, int8_t fpow, uint8_t opts);
bool tcbdbsetcache(TCBDB *bdb, int32_t lcnum, int32_t ncnum);
bool tcbdbsetxmsiz(TCBDB *bdb, int64_t xmsiz);
bool tcbdbopen(TCBDB *bdb, const char *path, int omode);
bool tcbdbclose(TCBDB *bdb);
bool tcbdbput(TCBDB *bdb, const void *kbuf, int ksiz, const void *vbuf, int vsiz);
bool tcbdbput2(TCBDB *bdb, const char *kstr, const char *vstr);
bool tcbdbputkeep(TCBDB *bdb, const void *kbuf, int ksiz, const void *vbuf, int vsiz);
bool tcbdbputkeep2(TCBDB *bdb, const char *kstr, const char *vstr);
bool tcbdbputcat(TCBDB *bdb, const void *kbuf, int ksiz, const void *vbuf, int vsiz);
bool tcbdbputcat2(TCBDB *bdb, const char *kstr, const char *vstr);
bool tcbdbputdup(TCBDB *bdb, const void *kbuf, int ksiz, const void *vbuf, int vsiz);
bool tcbdbputdup2(TCBDB *bdb, const char *kstr, const char *vstr);
bool tcbdbputdup3(TCBDB *bdb, const void *kbuf, int ksiz, const TCLIST *vals);
bool tcbdbout(TCBDB *bdb, const void *kbuf, int ksiz);
bool tcbdbout2(TCBDB *bdb, const char *kstr);
bool tcbdbout3(TCBDB *bdb, const void *kbuf, int ksiz);
void *tcbdbget(TCBDB *bdb, const void *kbuf, int ksiz, int *sp);
char *tcbdbget2(TCBDB *bdb, const char *kstr);
const void *tcbdbget3(TCBDB *bdb, const void *kbuf, int ksiz, int *sp);
TCLIST *tcbdbget4(TCBDB *bdb, const void *kbuf, int ksiz);
int tcbdbvnum(TCBDB *bdb, const void *kbuf, int ksiz);
int tcbdbvnum2(TCBDB *bdb, const char *kstr);
int tcbdbvsiz(TCBDB *bdb, const void *kbuf, int ksiz);
int tcbdbvsiz2(TCBDB *bdb, const char *kstr);
TCLIST *tcbdbrange(TCBDB *bdb, const void *bkbuf, int bksiz, bool binc,
                   const void *ekbuf, int eksiz, bool einc, int max);
TCLIST *tcbdbrange2(TCBDB *bdb, const char *bkstr, bool binc,
                    const char *ekstr, bool einc, int max);
TCLIST *tcbdbfwmkeys(TCBDB *bdb, const void *pbuf, int psiz, int max);
TCLIST *tcbdbfwmkeys2(TCBDB *bdb, const char *pstr, int max);
int tcbdbaddint(TCBDB *bdb, const void *kbuf, int ksiz, int num);
double tcbdbadddouble(TCBDB *bdb, const void *kbuf, int ksiz, double num);
bool tcbdbsync(TCBDB *bdb);
bool tcbdboptimize(TCBDB *bdb, int32_t lmemb, int32_t nmemb,
                   int64_t bnum, int8_t apow, int8_t fpow, uint8_t opts);
bool tcbdbvanish(TCBDB *bdb);
bool tcbdbcopy(TCBDB *bdb, const char *path);
bool tcbdbtranbegin(TCBDB *bdb);
bool tcbdbtrancommit(TCBDB *bdb);
bool tcbdbtranabort(TCBDB *bdb);
const char *tcbdbpath(TCBDB *bdb);
uint64_t tcbdbrnum(TCBDB *bdb);
uint64_t tcbdbfsiz(TCBDB *bdb);
BDBCUR *tcbdbcurnew(TCBDB *bdb);
void tcbdbcurdel(BDBCUR *cur);
bool tcbdbcurfirst(BDBCUR *cur);
bool tcbdbcurlast(BDBCUR *cur);
bool tcbdbcurjump(BDBCUR *cur, const void *kbuf, int ksiz);
bool tcbdbcurjump2(BDBCUR *cur, const char *kstr);
bool tcbdbcurprev(BDBCUR *cur);
bool tcbdbcurnext(BDBCUR *cur);
bool tcbdbcurput(BDBCUR *cur, const void *vbuf, int vsiz, int cpmode);
bool tcbdbcurput2(BDBCUR *cur, const char *vstr, int cpmode);
bool tcbdbcurout(BDBCUR *cur);
void *tcbdbcurkey(BDBCUR *cur, int *sp);
char *tcbdbcurkey2(BDBCUR *cur);
const void *tcbdbcurkey3(BDBCUR *cur, int *sp);
void *tcbdbcurval(BDBCUR *cur, int *sp);
char *tcbdbcurval2(BDBCUR *cur);
const void *tcbdbcurval3(BDBCUR *cur, int *sp);
bool tcbdbcurrec(BDBCUR *cur, TCXSTR *kxstr, TCXSTR *vxstr);
bool tcbdbhasmutex(TCBDB *bdb);
bool tcbdbmemsync(TCBDB *bdb, bool phys);
bool tcbdbcacheclear(TCBDB *bdb);
TCCMP tcbdbcmpfunc(TCBDB *bdb);
bool tcbdbforeach(TCBDB *bdb, TCITER iter, void *op);

/* Fixed-size db */
enum {                                   /* enumeration for additional flags */
  FDBFOPEN = 1 << 0,                     /* whether opened */
  FDBFFATAL = 1 << 1                     /* whetehr with fatal error */
};

enum {                                   /* enumeration for open modes */
  FDBOREADER = 1 << 0,                   /* open as a reader */
  FDBOWRITER = 1 << 1,                   /* open as a writer */
  FDBOCREAT = 1 << 2,                    /* writer creating */
  FDBOTRUNC = 1 << 3,                    /* writer truncating */
  FDBONOLCK = 1 << 4,                    /* open without locking */
  FDBOLCKNB = 1 << 5                     /* lock without blocking */
};

enum {                                   /* enumeration for ID constants */
  FDBIDMIN = -1,                         /* minimum number */
  FDBIDPREV = -2,                        /* less by one than the minimum */
  FDBIDMAX = -3,                         /* maximum number */
  FDBIDNEXT = -4                         /* greater by one than the miximum */
};
const char *tcfdberrmsg(int ecode);
TCFDB *tcfdbnew(void);
void tcfdbdel(TCFDB *fdb);
int tcfdbecode(TCFDB *fdb);
bool tcfdbsetmutex(TCFDB *fdb);
bool tcfdbtune(TCFDB *fdb, int32_t width, int64_t limsiz);
bool tcfdbopen(TCFDB *fdb, const char *path, int omode);
bool tcfdbclose(TCFDB *fdb);
bool tcfdbput(TCFDB *fdb, int64_t id, const void *vbuf, int vsiz);
bool tcfdbput2(TCFDB *fdb, const void *kbuf, int ksiz, const void *vbuf, int vsiz);
bool tcfdbput3(TCFDB *fdb, const char *kstr, const void *vstr);
bool tcfdbputkeep(TCFDB *fdb, int64_t id, const void *vbuf, int vsiz);
bool tcfdbputkeep2(TCFDB *fdb, const void *kbuf, int ksiz, const void *vbuf, int vsiz);
bool tcfdbputkeep3(TCFDB *fdb, const char *kstr, const void *vstr);
bool tcfdbputcat(TCFDB *fdb, int64_t id, const void *vbuf, int vsiz);
bool tcfdbputcat2(TCFDB *fdb, const void *kbuf, int ksiz, const void *vbuf, int vsiz);
bool tcfdbputcat3(TCFDB *fdb, const char *kstr, const void *vstr);
bool tcfdbout(TCFDB *fdb, int64_t id);
bool tcfdbout2(TCFDB *fdb, const void *kbuf, int ksiz);
bool tcfdbout3(TCFDB *fdb, const char *kstr);
void *tcfdbget(TCFDB *fdb, int64_t id, int *sp);
void *tcfdbget2(TCFDB *fdb, const void *kbuf, int ksiz, int *sp);
char *tcfdbget3(TCFDB *fdb, const char *kstr);
int tcfdbget4(TCFDB *fdb, int64_t id, void *vbuf, int max);
int tcfdbvsiz(TCFDB *fdb, int64_t id);
int tcfdbvsiz2(TCFDB *fdb, const void *kbuf, int ksiz);
int tcfdbvsiz3(TCFDB *fdb, const char *kstr);
bool tcfdbiterinit(TCFDB *fdb);
uint64_t tcfdbiternext(TCFDB *fdb);
void *tcfdbiternext2(TCFDB *fdb, int *sp);
char *tcfdbiternext3(TCFDB *fdb);
uint64_t *tcfdbrange(TCFDB *fdb, int64_t lower, int64_t upper, int max, int *np);
TCLIST *tcfdbrange2(TCFDB *fdb, const void *lbuf, int lsiz, const void *ubuf, int usiz, int max);
TCLIST *tcfdbrange3(TCFDB *fdb, const char *lstr, const char *ustr, int max);
TCLIST *tcfdbrange4(TCFDB *fdb, const void *ibuf, int isiz, int max);
TCLIST *tcfdbrange5(TCFDB *fdb, const void *istr, int max);
int tcfdbaddint(TCFDB *fdb, int64_t id, int num);
double tcfdbadddouble(TCFDB *fdb, int64_t id, double num);
bool tcfdbsync(TCFDB *fdb);
bool tcfdboptimize(TCFDB *fdb, int32_t width, int64_t limsiz);
bool tcfdbvanish(TCFDB *fdb);
bool tcfdbcopy(TCFDB *fdb, const char *path);
const char *tcfdbpath(TCFDB *fdb);
uint64_t tcfdbrnum(TCFDB *fdb);
uint64_t tcfdbfsiz(TCFDB *fdb);
bool tcfdbhasmutex(TCFDB *fdb);
bool tcfdbmemsync(TCFDB *fdb, bool phys);
bool tcfdbputproc(TCFDB *fdb, int64_t id, const void *vbuf, int vsiz, TCPDPROC proc, void *op);
bool tcfdbforeach(TCFDB *fdb, TCITER iter, void *op);

/* Table DB API */

enum {                                   /* enumeration for additional flags */
  TDBFOPEN = 1 << 0,                   /* whether opened */
  TDBFFATAL = 1 << 1                  /* whetehr with fatal error */
};

enum {                                   /* enumeration for tuning options */
  TDBTLARGE = 1 << 0,                    /* use 64-bit bucket array */
  TDBTDEFLATE = 1 << 1,                  /* compress each page with Deflate */
  TDBTBZIP = 1 << 2,                     /* compress each record with BZIP2 */
  TDBTTCBS = 1 << 3,                     /* compress each page with TCBS */
  TDBTEXCODEC = 1 << 4                   /* compress each record with outer functions */
};

enum {                                   /* enumeration for open modes */
  TDBOREADER = 1 << 0,                   /* open as a reader */
  TDBOWRITER = 1 << 1,                   /* open as a writer */
  TDBOCREAT = 1 << 2,                    /* writer creating */
  TDBOTRUNC = 1 << 3,                    /* writer truncating */
  TDBONOLCK = 1 << 4,                    /* open without locking */
  TDBOLCKNB = 1 << 5,                    /* lock without blocking */
  TDBOTSYNC = 1 << 6                     /* synchronize every transaction */
};

enum {                                   /* enumeration for index types */
  TDBITLEXICAL,                          /* lexical string */
  TDBITDECIMAL,                          /* decimal string */
  TDBITOPT = 9998,                       /* optimize */
  TDBITVOID = 9999,                      /* void */
  TDBITKEEP = 1 << 24                    /* keep existing index */
};

typedef struct {                         /* type of structure for a condition */
  char *name;                            /* column name */
  int nsiz;                              /* size of the column name */
  int op;                                /* operation type */
  bool sign;                             /* positive sign */
  bool noidx;                            /* no index flag */
  char *expr;                            /* operand expression */
  int esiz;                              /* size of the operand expression */
  bool alive;                            /* alive flag */
} TDBCOND;

typedef struct {                         /* type of structure for a query */
  TCTDB *tdb;                            /* database object */
  TDBCOND *conds;                        /* condition objects */
  int cnum;                              /* number of conditions */
  char *oname;                           /* column name for ordering */
  int otype;                             /* type of order */
  int max;                               /* limit of retrieval */
  TCXSTR *hint;                          /* hint string */
} TDBQRY;

enum {                                   /* enumeration for query conditions */
  TDBQCSTREQ,                            /* string is equal to */
  TDBQCSTRINC,                           /* string is included in */
  TDBQCSTRBW,                            /* string begins with */
  TDBQCSTREW,                            /* string ends with */
  TDBQCSTRAND,                           /* string includes all tokens in */
  TDBQCSTROR,                            /* string includes at least one token in */
  TDBQCSTROREQ,                          /* string is equal to at least one token in */
  TDBQCSTRRX,                            /* string matches regular expressions of */
  TDBQCNUMEQ,                            /* number is equal to */
  TDBQCNUMGT,                            /* number is greater than */
  TDBQCNUMGE,                            /* number is greater than or equal to */
  TDBQCNUMLT,                            /* number is less than */
  TDBQCNUMLE,                            /* number is less than or equal to */
  TDBQCNUMBT,                            /* number is between two tokens of */
  TDBQCNUMOREQ,                          /* number is equal to at least one token in */
  TDBQCNEGATE = 1 << 24,                 /* negation flag */
  TDBQCNOIDX = 1 << 25                   /* no index flag */
};

enum {                                   /* enumeration for order types */
  TDBQOSTRASC,                           /* string ascending */
  TDBQOSTRDESC,                          /* string descending */
  TDBQONUMASC,                           /* number ascending */
  TDBQONUMDESC                           /* number descending */
};

enum {                                   /* enumeration for post treatments */
  TDBQPPUT = 1 << 0,                     /* modify the record */
  TDBQPOUT = 1 << 1,                     /* remove the record */
  TDBQPSTOP = 1 << 24                    /* stop the iteration */
};

typedef int (*TDBQRYPROC)(const void *pkbuf, int pksiz, TCMAP *cols, void *op);

const char *tctdberrmsg(int ecode);
TCTDB *tctdbnew(void);
void tctdbdel(TCTDB *tdb);
int tctdbecode(TCTDB *tdb);
bool tctdbsetmutex(TCTDB *tdb);
bool tctdbtune(TCTDB *tdb, int64_t bnum, int8_t apow, int8_t fpow, uint8_t opts);
bool tctdbsetcache(TCTDB *tdb, int32_t rcnum, int32_t lcnum, int32_t ncnum);
bool tctdbsetxmsiz(TCTDB *tdb, int64_t xmsiz);
bool tctdbopen(TCTDB *tdb, const char *path, int omode);
bool tctdbclose(TCTDB *tdb);
bool tctdbput(TCTDB *tdb, const void *pkbuf, int pksiz, TCMAP *cols);
bool tctdbput2(TCTDB *tdb, const void *pkbuf, int pksiz, const void *cbuf, int csiz);
bool tctdbput3(TCTDB *tdb, const char *pkstr, const char *cstr);
bool tctdbputkeep(TCTDB *tdb, const void *pkbuf, int pksiz, TCMAP *cols);
bool tctdbputkeep2(TCTDB *tdb, const void *pkbuf, int pksiz, const void *cbuf, int csiz);
bool tctdbputkeep3(TCTDB *tdb, const char *pkstr, const char *cstr);
bool tctdbputcat(TCTDB *tdb, const void *pkbuf, int pksiz, TCMAP *cols);
bool tctdbputcat2(TCTDB *tdb, const void *pkbuf, int pksiz, const void *cbuf, int csiz);
bool tctdbputcat3(TCTDB *tdb, const char *pkstr, const char *cstr);
bool tctdbout(TCTDB *tdb, const void *pkbuf, int pksiz);
bool tctdbout2(TCTDB *tdb, const char *pkstr);
TCMAP *tctdbget(TCTDB *tdb, const void *pkbuf, int pksiz);
char *tctdbget2(TCTDB *tdb, const void *pkbuf, int pksiz, int *sp);
char *tctdbget3(TCTDB *tdb, const char *pkstr);
int tctdbvsiz(TCTDB *tdb, const void *pkbuf, int pksiz);
int tctdbvsiz2(TCTDB *tdb, const char *pkstr);
bool tctdbiterinit(TCTDB *tdb);
void *tctdbiternext(TCTDB *tdb, int *sp);
char *tctdbiternext2(TCTDB *tdb);
TCLIST *tctdbfwmkeys(TCTDB *tdb, const void *pbuf, int psiz, int max);
TCLIST *tctdbfwmkeys2(TCTDB *tdb, const char *pstr, int max);
int tctdbaddint(TCTDB *tdb, const void *pkbuf, int pksiz, int num);
double tctdbadddouble(TCTDB *tdb, const void *pkbuf, int pksiz, double num);
bool tctdbsync(TCTDB *tdb);
bool tctdboptimize(TCTDB *tdb, int64_t bnum, int8_t apow, int8_t fpow, uint8_t opts);
bool tctdbvanish(TCTDB *tdb);
bool tctdbcopy(TCTDB *tdb, const char *path);
bool tctdbtranbegin(TCTDB *tdb);
bool tctdbtrancommit(TCTDB *tdb);
bool tctdbtranabort(TCTDB *tdb);
const char *tctdbpath(TCTDB *tdb);
uint64_t tctdbrnum(TCTDB *tdb);
uint64_t tctdbfsiz(TCTDB *tdb);
bool tctdbsetindex(TCTDB *tdb, const char *name, int type);
int64_t tctdbgenuid(TCTDB *tdb);
TDBQRY *tctdbqrynew(TCTDB *tdb);
void tctdbqrydel(TDBQRY *qry);
void tctdbqryaddcond(TDBQRY *qry, const char *name, int op, const char *expr);
void tctdbqrysetorder(TDBQRY *qry, const char *name, int type);
void tctdbqrysetmax(TDBQRY *qry, int max);
TCLIST *tctdbqrysearch(TDBQRY *qry);
bool tctdbqrysearchout(TDBQRY *qry);
bool tctdbqryproc(TDBQRY *qry, TDBQRYPROC proc, void *op);
const char *tctdbqryhint(TDBQRY *qry);
bool tctdbhasmutex(TCTDB *tdb);
bool tctdbmemsync(TCTDB *tdb, bool phys);
bool tctdbforeach(TCTDB *tdb, TCITER iter, void *op);
int tctdbstrtoindextype(const char *str);
int tctdbqrystrtocondop(const char *str);
int tctdbqrystrtoordertype(const char *str);


/* Abstract DB API */

enum {                                   /* enumeration for open modes */
  ADBOVOID,                              /* not opened */
  ADBOMDB,                               /* on-memory hash database */
  ADBONDB,                               /* on-memory tree database */
  ADBOHDB,                               /* hash database */
  ADBOBDB,                               /* B+ tree database */
  ADBOFDB,                               /* fixed-length database */
  ADBOTDB                                /* table database */
};

TCADB *tcadbnew(void);
void tcadbdel(TCADB *adb);
bool tcadbopen(TCADB *adb, const char *name);
bool tcadbclose(TCADB *adb);
bool tcadbput(TCADB *adb, const void *kbuf, int ksiz, const void *vbuf, int vsiz);
bool tcadbput2(TCADB *adb, const char *kstr, const char *vstr);
bool tcadbputkeep(TCADB *adb, const void *kbuf, int ksiz, const void *vbuf, int vsiz);
bool tcadbputkeep2(TCADB *adb, const char *kstr, const char *vstr);
bool tcadbputcat(TCADB *adb, const void *kbuf, int ksiz, const void *vbuf, int vsiz);
bool tcadbputcat2(TCADB *adb, const char *kstr, const char *vstr);
bool tcadbout(TCADB *adb, const void *kbuf, int ksiz);
bool tcadbout2(TCADB *adb, const char *kstr);
void *tcadbget(TCADB *adb, const void *kbuf, int ksiz, int *sp);
char *tcadbget2(TCADB *adb, const char *kstr);
int tcadbvsiz(TCADB *adb, const void *kbuf, int ksiz);
int tcadbvsiz2(TCADB *adb, const char *kstr);
bool tcadbiterinit(TCADB *adb);
void *tcadbiternext(TCADB *adb, int *sp);
char *tcadbiternext2(TCADB *adb);
TCLIST *tcadbfwmkeys(TCADB *adb, const void *pbuf, int psiz, int max);
TCLIST *tcadbfwmkeys2(TCADB *adb, const char *pstr, int max);
int tcadbaddint(TCADB *adb, const void *kbuf, int ksiz, int num);
double tcadbadddouble(TCADB *adb, const void *kbuf, int ksiz, double num);
bool tcadbsync(TCADB *adb);
bool tcadbvanish(TCADB *adb);
bool tcadbcopy(TCADB *adb, const char *path);
uint64_t tcadbrnum(TCADB *adb);
uint64_t tcadbsize(TCADB *adb);
TCLIST *tcadbmisc(TCADB *adb, const char *name, const TCLIST *args);
int tcadbomode(TCADB *adb);
void *tcadbreveal(TCADB *adb);
bool tcadbputproc(TCADB *adb, const void *kbuf, int ksiz, const char *vbuf, int vsiz,
                  TCPDPROC proc, void *op);
bool tcadbforeach(TCADB *adb, TCITER iter, void *op);
