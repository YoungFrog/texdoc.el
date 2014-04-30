;;; yf-texdoc.el --- Use texdoc from within emacs    -*- lexical-binding: t; -*-

;; Copyright (C) 2014  Nicolas Richard

;; Author: Nicolas Richard <theonewiththeevillook@yahoo.fr>
;; Keywords: 

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:

(defun yf/texdoc (package)
  "Opens the LaTeX PACKAGE documentation via the texdoc utility."
  (interactive (list (ido-completing-read "Package: " (mapcar #'car (yf/texdoc-packages)))))
  (call-process-shell-command "texdoc" nil 0 nil package))
(defvar yf/texdoc-packages nil "Alist of tlmgr packages")

(defun yf/texdoc-packages ()
  (or yf/texdoc-packages
      (with-temp-buffer
        ;; (call-process "tlmgr" nil t nil "info" "--list" "--only-installed")
        ;; (goto-char (point-min))
        ;; (while (re-search-forward "^i \\([^:]+\\): \\(.*\\)$" nil t)
        ;;   (push (cons (match-string 1) (match-string 2))
        ;;         yf/texdoc-packages))
        (call-process "texdoc" nil t nil "-M" "-l" "")
        (goto-char (point-min))
        (while (not (eobp))
          (let (file package desc)
            (search-forward "\t" nil nil 2)
            (setq file (buffer-substring
                        (point)
                        (progn (search-forward "\t") (1- (point)))))
            (setq package (file-name-nondirectory file))
            (search-forward "\t") ; skip over lang
            (buffer-substring (point) (progn (forward-line) (1- (point))))
            (push (cons package desc) yf/texdoc-packages))))
      (setq yf/texdoc-packages (nreverse yf/texdoc-packages))))

(provide 'yf-texdoc)
;;; yf-texdoc.el ends here
