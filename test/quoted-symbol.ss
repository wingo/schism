(library
    (trivial)
  (export do-test)
  (import (rnrs))
  
  (define (do-test)
    (eq? 'abc 'abc)))