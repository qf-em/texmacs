
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MODULE      : init-eukleides.scm
;; DESCRIPTION : Initialize Eukleides plugin
;; COPYRIGHT   : (C) 2003 Joris van der Hoeven.
;;
;; This software falls under the GNU general public license version 3 or later.
;; It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
;; in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (eukleides-serialize lan t)
  (with u (pre-serialize lan t)
    (with s (texmacs->code u)
      (string-append (escape-verbatim (string-replace s "\n" "~")) "\n"))))

(plugin-configure eukleides
  (:require (url-exists-in-path? "eukleides"))
  (:launch "tm_eukleides --texmacs")
  (:serializer ,eukleides-serialize)
  (:session "Eukleides")
  (:scripts "Eukleides"))

(when (supports-eukleides?)
  ;;(import-from (eukleides-menus))
  (import-from (utils plugins plugin-convert)))
