;;; morlock.el --- More font-lock keywords for elisp  -*- lexical-binding:t -*-

;; Copyright (C) 2013-2025 Jonas Bernoulli

;; Author: Jonas Bernoulli <emacs.morlock@jonas.bernoulli.dev>
;; Homepage: https://github.com/tarsius/morlock
;; Keywords: convenience

;; Package-Version: 2.0.1
;; Package-Requires: ((emacs "29.1"))

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

;; This package provides `morlock-mode' which highlights additional
;; expressions in Emacs Lisp mode.

;; Symbols are highlighted if their `morlock-font-lock-keyword' symbol
;; property is non-nil.  This package does this for a few symbols, and
;; you can do it yourself for additional symbols.

;; The `morlock-font-lock-keywords' variable is used for more complex
;; expressions.

;;; Code:

(defvar morlock-font-lock-symbols
  '( not null xor
     with-no-warnings
     )
  "More symbols to highlight in Emacs Lisp mode.")

(defvar morlock-font-lock-keywords
  (eval-when-compile
    `((,(concat "(\\(define-button-type\\)\\_>"
                "[ \t'\(]*"
                "\\(\\(?:\\sw\\|\\s_\\)+\\)?")
       (1 'font-lock-keyword-face)
       (2 'font-lock-variable-name-face nil t))))
  "More expressions to highlight in Emacs Lisp mode.")

(defun lisp--el-match-keyword@morlock (limit)
  "Highlight keywords whose `morlock-font-lock-keyword' property is non-nil."
  (catch 'found
    (while (re-search-forward
            (concat "(\\(" (rx lisp-mode-symbol) "\\)\\_>")
            limit t)
      (let ((sym (intern-soft (match-string 1))))
        (when (and (or (special-form-p sym)
                       (macrop sym)
                       (get sym 'morlock-font-lock-keyword))
                   (not (get sym 'no-font-lock-keyword))
                   (lisp--el-funcall-position-p (match-beginning 0)))
          (throw 'found t))))))

;;;###autoload
(define-minor-mode morlock-mode
  "Highlight more expressions in Emacs Lisp mode."
  :lighter ""
  :group 'font-lock
  :global t
  (cond
   (morlock-mode
    (dolist (symbol morlock-font-lock-symbols)
      (put symbol 'morlock-font-lock-keyword t))
    (advice-add 'lisp--el-match-keyword :override
                #'lisp--el-match-keyword@morlock)
    (add-hook 'emacs-lisp-mode-hook #'morlock--add-font-lock-keywords))
   (t
    (advice-remove 'lisp--el-match-keyword
                   #'lisp--el-match-keyword@morlock)
    (remove-hook 'emacs-lisp-mode-hook #'morlock--add-font-lock-keywords)))
  (dolist (buffer (buffer-list))
    (with-current-buffer buffer
      (when (derived-mode-p 'emacs-lisp-mode)
        (if morlock-mode
            (font-lock-add-keywords  nil morlock-font-lock-keywords t)
          (font-lock-remove-keywords nil morlock-font-lock-keywords))
        (font-lock-flush)))))

(defun morlock--add-font-lock-keywords ()
  (font-lock-add-keywords nil morlock-font-lock-keywords t))

(provide 'morlock)
;; Local Variables:
;; indent-tabs-mode: nil
;; End:
;;; morlock.el ends here
