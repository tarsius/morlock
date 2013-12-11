;;; morlock.el --- more font-lock keywords for elisp

;; Copyright (C) 2013  Jonas Bernoulli

;; Author: Jonas Bernoulli <jonas@bernoul.li>
;; Created: 20130624
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
;;     the `cl-' prefix was added.  And then some that never
;;     were.
;; `morlock-font-lock-keywords' combines the above two.

;; To use `morlock-font-lock-keywords' in `emacs-lisp-mode' and
;; `lisp-interaction-mode' enable `global-morlock-mode'.

;; If you want to only enable one some of the keywords and/or only in
;; `emacs-lisp-mode', then require `morlock' and activate the keywords
;; in one of the variables using `font-lock-add-keywords'.  Doing so
;; is also slightly more efficient.

;;     (font-lock-add-keywords 'emacs-lisp-mode
;;                              morlock-el-font-lock-keywords)

;; Please let me know if you think anything should be added here.

;;; Code:

(defconst morlock-el-font-lock-keywords
  (eval-when-compile
    `(;; Definitions.
      ("(\\(defvar-local\\)\\>[ \t]*\\(\\sw+\\)?"
       (1 font-lock-keyword-face)
       (2 font-lock-variable-name-face nil t))))
  "Fresh expressions to highlight in Emacs-Lisp mode.")

(defconst morlock-cl-font-lock-keywords
  (eval-when-compile
    `(;; Definitions.
      ("(\\(cl-def\\(?:un\\|macro\\|struct\\)\\)\\>[ \t]*\\(\\sw+\\)?"
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

;;;###autoload
(define-minor-mode morlock-mode
  "Highlight more font-lock keywords."
  :lighter ""
  (if morlock-mode
      (font-lock-add-keywords  nil morlock-font-lock-keywords 'append)
    (font-lock-remove-keywords nil morlock-font-lock-keywords))
  (font-lock-fontify-buffer))

;;;###autoload
(define-globalized-minor-mode global-morlock-mode
  hl-todo-mode turn-on-morlock-mode-if-desired)

(defun turn-on-morlock-mode-if-desired ()
  (when (derived-mode-p 'emacs-lisp-mode)
    (morlock-mode 1)))

(provide 'morlock)
;; Local Variables:
;; indent-tabs-mode: nil
;; End:
;;; morlock.el ends here
