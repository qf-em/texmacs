
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MODULE      : tm-preferences.scm
;; DESCRIPTION : management of the user preferences
;; COPYRIGHT   : (C) 1999  Joris van der Hoeven
;;
;; This software falls under the GNU general public license version 3 or later.
;; It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
;; in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (texmacs-module (kernel texmacs tm-preferences)
;;   (:use (kernel texmacs tm-define)))

(define-module (kernel texmacs tm-preferences)
  :use-module (texmacs-core))

(use-modules (kernel boot abbrevs)
             (kernel boot ahash-table)
             (kernel boot debug)
             (kernel texmacs tm-define))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Defining preference call back routines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-public preferences-default (make-ahash-table))
(define-public preferences-call-back (make-ahash-table))

(define (define-preference x)
  (with (which value call-back) x
    `(if (not (ahash-ref preferences-default ,which))
         (ahash-set! preferences-default ,which ,value))))

(define (define-preference-call-back x)
  (with (which value call-back) x
    `(begin
       (ahash-set! preferences-call-back ,which ,call-back)
       (notify-preference ,which))))

(define-public-macro (define-preferences . l)
  (append '(begin)
          (map-in-order define-preference l)
          (map-in-order define-preference-call-back l)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Setting and getting preferences
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (test-preference? which what)
  (== (get-preference which)
      (if (!= what "default") what
          (ahash-ref preferences-default which))))

(tm-define (set-preference which what)
  (:synopsis "Set preference @which to @what")
  (:check-mark "*" test-preference?)
  ;;(display* "set-preference " which " := " what "\n")
  (cpp-set-preference which (if (string? what) what (object->string what)))
  (notify-preference which)
  (save-preferences))

(tm-define (reset-preference which)
  (:synopsis "Revert preference @which to default setting")
  ;;(display* "reset-preference " which "\n")
  (cpp-reset-preference which)
  (notify-preference which)
  (save-preferences))

(define (get-call-back what)
  (let ((r (ahash-ref preferences-call-back what)))
    (if r r (lambda args (noop)))))

(tm-define (notify-preference which)
  (:synopsis "Notify that the preference @which was changed")
  ;;(display* "notify-preference " which ", " (get-preference which) "\n")
  ((get-call-back which) which (get-preference which)))

(tm-define (get-preference which)
  (:synopsis "Get preference @which")
  (let* ((def (or (ahash-ref preferences-default which) "default"))
         (s? (string? def))
         (r (cpp-get-preference which (if s? def (object->string def)))))
    (if s? r (string->object r))))

(define (preference-on? which)
  (test-preference? which "on"))

(tm-define (toggle-preference which)
  (:synopsis "Toggle the preference @which")
  (:check-mark "v" preference-on?)
  (with what (get-preference which)
    (set-preference which (cond ((== what "on") "off")
                                ((== what "off") "on")
                                (else what)))))

(tm-define (append-preference which val)
  (:synopsis "Appends @val to the list of values of preference @which")
  (with cur (get-preference which)
    (if (== cur "default") (set! cur '()))
    (set-preference which (rcons cur val))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Nicer names for preference values
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-public preference-decode-table (make-ahash-table))
(define-public preference-encode-table (make-ahash-table))

(tm-define (set-pretty-preference which pretty-val)
  (with val (ahash-ref preference-decode-table (cons which pretty-val))
    (set-preference which (or val pretty-val))))

(tm-define (get-pretty-preference which)
  (with val (get-preference which)
    (with pretty-val (ahash-ref preference-encode-table (cons which val))
      ;;(display* "Get: " which ", " val " -> " pretty-val "\n")
      (or pretty-val val "Default"))))

(tm-define (set-boolean-preference which val)
  (set-preference which (if val "on" "off")))

(tm-define (get-boolean-preference which)
  (== (get-preference which) "on"))

(define-public (set-preference-name which var val)
  (ahash-set! preference-encode-table (cons which var) val)
  (ahash-set! preference-decode-table (cons which val) var))

(define-public (set-preference-encode which x)
   `(ahash-set! preference-encode-table
                (cons ,which ,(car x)) ,(cadr x)))

(define-public (set-preference-decode which x)
   `(ahash-set! preference-decode-table
                (cons ,which ,(cadr x)) ,(car x)))

(define-public-macro (define-preference-names which . l)
  `(begin
     ,@(map (lambda (x) (set-preference-encode which x)) l)
     ,@(map (lambda (x) (set-preference-decode which x)) l)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Look and feel
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-public (look-and-feel)
  (with s (get-preference "look and feel")
    (if (== s "default") (default-look-and-feel) s)))

(define (test-look-and-feel t)
  ;;(display* "Check look and feel " t "\n")
  (cond ((list? t) (list-or (map test-look-and-feel t)))
        ((symbol? t) (test-look-and-feel (symbol->string t)))
        (else
          (with s (look-and-feel)
            (or (== t s) (and (== t "std") (!= s "emacs")))))))

(set! has-look-and-feel? test-look-and-feel)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Notify that the Scheme preferences system has been started
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(notify-preferences-booted)
