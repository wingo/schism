;; Copyright 2019 Google LLC
;;
;; Licensed under the Apache License, Version 2.0 (the "License");
;; you may not use this file except in compliance with the License.
;; You may obtain a copy of the License at
;;
;;     http://www.apache.org/licenses/LICENSE-2.0
;;
;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;; See the License for the specific language governing permissions and
;; limitations under the License.

(add-to-load-path ".")
(eval-when (expand load compile)
  (set! %load-extensions (cons ".ss" %load-extensions)))

;; Schism has the property that:
;;
;;   (equal? str (symbol->string (gensym str))) => #t
;;
;; Guile's make-symbol has this property; Guile's gensym does not.  Use
;; make-symbol as gensym, then.
;;
(define-module (chezscheme) #:re-export ((make-symbol . gensym)))

(define-module (bootstrap)
  #:use-module (schism compiler))

(define* (main #:optional (out "schism-stage0.wasm") (in "schism/compiler.ss"))
  (let ((package (with-input-from-file in compile-stdin->module-package)))
    (with-output-to-file out
      (lambda ()
        ;; Schism uses write-char to write bytes, so install the
        ;; encoding that ensures that writing (integer->char C) writes
        ;; the byte C, for C < 256.
        (set-port-encoding! (current-output-port) "ISO-8859-1")
        (compile-module-package->stdout package)))))

(apply main (cdr (program-arguments)))
