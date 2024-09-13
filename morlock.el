;;; morlock.el --- More font-lock keywords for elisp  -*- lexical-binding:t -*-

;; Copyright (C) 2013-2024 Jonas Bernoulli

;; Author: Jonas Bernoulli <emacs.morlock@jonas.bernoulli.dev>
;; Homepage: https://github.com/tarsius/morlock
;; Keywords: convenience

;; Package-Version: 1.1.1
;; Package-Requires: ((emacs "26.1") (compat "30.0.0.0"))

;; SPDX-License-Identifier: GPL-3.0-or-later

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published
;; by the Free Software Foundation, either version 3 of the License,
;; or (at your option) any later version.
;;
;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this file.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This library defines more font-lock keywords for Emacs Lisp.

;; These keyword variables are available:
;;
;; `morlock-el-font-lock-keywords' expressions that aren't
;;     covered by the default keywords.
;; `morlock-op-font-lock-keywords' expressions that would be
;;     operators in other languages: `xor', `not' and `null'.
;; `morlock-font-lock-keywords' combines the above two.

;; To use `morlock-font-lock-keywords' in `emacs-lisp-mode' and
;; `lisp-interaction-mode' enable `global-morlock-mode'.

;; If you want to only enable some of the keywords and/or only in
;; `emacs-lisp-mode', then require `morlock' and activate the keywords
;; in one of the variables using `font-lock-add-keywords'.  Doing so
;; is also slightly more efficient.
;;
;;     (font-lock-add-keywords 'emacs-lisp-mode
;;                              morlock-el-font-lock-keywords)

;;; Code:

(require 'compat)

(defconst morlock-el-font-lock-keywords
  (eval-when-compile
    `(("(\\(with-no-warnings\\)\\_>" 1 'font-lock-keyword-face)
      (,(concat "(\\(define-button-type\\)\\_>"
                "[ \t'\(]*"
                "\\(\\(?:\\sw\\|\\s_\\)+\\)?")
       (1 'font-lock-keyword-face)
       (2 'font-lock-variable-name-face nil t))))
  "Fresh expressions to highlight in Emacs-Lisp mode.")

(defconst morlock-op-font-lock-keywords
  '(("(\\(xor\\|not\\|null\\)\\_>" 1 'font-lock-keyword-face)))

(defconst morlock-font-lock-keywords
  (append morlock-el-font-lock-keywords
          morlock-op-font-lock-keywords)
  "More expressions to highlight in Emacs-Lisp mode.
This variable combines the keywords defined in
`morlock-el-font-lock-keywords' and `morlock-op-font-lock-keywords'.")

;;;###autoload
(define-minor-mode morlock-mode
  "Highlight more font-lock keywords."
  :lighter ""
  (if morlock-mode
      (font-lock-add-keywords  nil morlock-font-lock-keywords 'append)
    (font-lock-remove-keywords nil morlock-font-lock-keywords))
  (font-lock-flush))

;;;###autoload
(define-globalized-minor-mode global-morlock-mode
  morlock-mode morlock-mode--turn-on
  :group 'font-lock-extra-types)

(defun morlock-mode--turn-on ()
  (when (derived-mode-p 'emacs-lisp-mode)
    (morlock-mode 1)))

(provide 'morlock)
;; Local Variables:
;; indent-tabs-mode: nil
;; End:
;;; morlock.el ends here
