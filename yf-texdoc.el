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
  (interactive (list (ido-completing-read "Package: " (yf/texdoc-packages))))
  (call-process-shell-command "texdoc" nil 0 nil package))

(defvar yf/texdoc-path-to-tlpdb "/usr/local/texlive/2012/texmf-dist/scripts/texdoc/"
  "Path to the \"Data.tlpdb.lua\" file")

(defvar yf/texdoc--packages nil "Cache for package list")
(defun yf/texdoc--packages ()
  (or yf/texdoc--packages
      (setq yf/texdoc-packages
            (split-string
             (shell-command-to-string
              (format
               "cd \"%s\"; lua  -e 'a,b,c = dofile(\"Data.tlpdb.lua\")' -e \"for k,v in pairs(c) do print(k) end\""
               yf/texdoc-path-to-tlpdb))))))

(defun yf/texdoc-packages ()
  "Return a list of known packages."
  (yf/texdoc--packages))

(provide 'yf-texdoc)
;;; yf-texdoc.el ends here
