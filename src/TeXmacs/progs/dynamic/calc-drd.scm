
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MODULE      : calc-drd.scm
;; DESCRIPTION : data relation definitions for spreadsheet related tags
;; COPYRIGHT   : (C) 2012  Joris van der Hoeven
;;
;; This software falls under the GNU general public license version 3 or later.
;; It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
;; in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (texmacs-module (dynamic calc-drd)
;;   (:use (dynamic dynamic-drd)))

(define-module (dynamic calc-drd)
  :use-module (texmacs-core))

(use-modules (dynamic dynamic-drd))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Groups
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-group calc-table-tag
  textual-table numeric-dot-table numeric-comma-table)

(define-group variant-tag (calc-table-tag))
(define-group similar-tag (calc-table-tag))

(define-toggle calc-input calc-output)
(define-toggle cell-input cell-output)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Contexts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (calc-table-search t)
  (:synopsis "Return calc-table ancestor for @t or #f")
  (or (and (tree-is? t 'calc-table) t)
      (and (tree-ref t :up)
	   (not (tree-is? t :up 'table))
	   (calc-table-search (tree-up t)))))

(tm-define (calc-table-context? t)
  (:synopsis "Check whether @t is a table inside a calc-table")
  (and (tree-is? t 'table)
       (nnot (calc-table-search (tree-up t)))))

(tm-define (calc-data-context? t)
  (tree-in? t '(calc-inert calc-input calc-output
                cell-inert cell-input cell-output)))

(tm-define (calc-inert-context? t)
  (tree-in? t '(calc-inert cell-inert)))

(tm-define (calc-toggle-context? t)
  (tree-in? t '(calc-input calc-output cell-input cell-output)))

(tm-define (calc-ref-context? t)
  (tree-in? t '(calc-ref cell-ref)))

(tm-define (calc-range-context? t)
  (and (tree-is? t 'cell-range)
       (tree-is? t 0 'cell-ref)
       (tree-is? t 1 'cell-ref)))

(tm-define (calc-cell-context? t)
  (tree-in? t '(cell-inert cell-input cell-output cell-ref cell-range)))
