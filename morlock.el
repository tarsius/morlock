;;; morlock.el --- more font-lock keywords for elisp

;; Copyright (C) 2013  Jonas Bernoulli

;; Author: Jonas Bernoulli <jonas@bernoul.li>
;; Created: 20130624
;; Version: 0.1.0
;; Homepage: http://github.com/tarsius/morlock
;; Keywords: convenience

;; This file is not part of GNU Emacs.

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; For a full copy of the GNU General Public License
;; see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This library defines more font-lock keywords for Emacs lisp.

;; These keyword variables are available:

;; `morlock-el-font-lock-keywords' new expressions that aren't
;;     covered by the default keywords yet (?).
;; `morlock-cl-font-lock-keywords' expressions that used to be
;;     covered by the default keywords but aren't anymore since
;;     the `cl-' prefix was added.
;; `morlock-font-lock-keywords' combines the above two.

;; To use these keywords require `morlock' and activate the keywords
;; in one of the variables using `font-lock-add-keywords'.  E.g.:

;; (font-lock-add-keywords 'emacs-lisp-mode morlock-font-lock-keywords)

;; Please let me know if you think anything should be added here.

;;; Code:

(defconst morlock-el-font-lock-keywords
  (eval-when-compile
    `(;; Definitions.
      ("(\\(defun-local\\)\\>[ \t]*\\(\\sw+\\)?"
       (1 font-lock-keyword-face)
       (2 font-lock-function-name-face nil t))))
  "Fresh expressions to highlight in Emacs-Lisp mode.")

(defconst morlock-cl-font-lock-keywords
  (eval-when-compile
    `(;; Definitions.
      ("(\\(cl-def\\(?:un\\|macro\\)\\)\\>[ \t]*\\(\\sw+\\)?"
       (1 font-lock-keyword-face)
       (2 font-lock-function-name-face nil t))
      ;; Control structures.
      (,(concat
         "(\\(cl-"
         (regexp-opt
          '("case" "ecase" "typecase" "etypecase"
            "loop" "do" "do*" "dotimes" "dolist" "the" "locally"
            "proclaim" "declaim" "declare" "symbol-macrolet" "letf"
            "flet" "labels"
            "destructuring-bind" "macrolet" "block"
            "multiple-value-bind"
            "return" "return-from"))
         "\\)\\>")
       . 1)))
  "Exiled expressions to highlight in Emacs-Lisp mode.")

(defconst morlock-font-lock-keywords
  (append morlock-el-font-lock-keywords
          morlock-cl-font-lock-keywords)
  "More expressions to highlight in Emacs-Lisp mode.
This variable combines the keywords defined in
`morlock-el-font-lock-keywords' and
`morlock-cl-font-lock-keywords'.")

(provide 'morlock)
;; Local Variables:
;; indent-tabs-mode: nil
;; End:
;;; morlock.el ends here
