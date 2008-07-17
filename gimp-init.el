;; This is gimp-init.el
;;; gimp-init.el --- $Id: gimp-init.el,v 1.15 2008-07-17 13:01:13 sharik Exp $
;; Copyright (C) 2008 Niels Giesen.

;; Author: Niels Giesen <nielsforkgiesen@gmailspooncom, but please
;; replace the kitchen utensils with a dot before hitting "Send">
;; Keywords: processes, multimedia, extensions, tools, gimp, scheme
;; Homepage: http://niels.kicks-ass.org/gimpmode

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
;; 02110-1301, USA.

 ;; Check whether first time
;; Put this in your .emacs (load-file "~/.emacs.d/gimp/gimp-init.el")
(defvar gimp-mode-dir 
  (file-name-directory
   (or load-file-name buffer-file-name)))

(condition-case err
    (load (concat gimp-mode-dir "gimp-vars.el"))
  (error (load-file (concat gimp-mode-dir "gimp-install.el"))))

(let* ((related-dir (file-name-as-directory
		     (expand-file-name "related"
				       gimp-mode-dir))))
  (add-to-list 'load-path gimp-mode-dir)
  (add-to-list 'load-path related-dir))

(mapc (lambda (command)
	(autoload command "gimp-mode" "" t))
      '(run-gimp
	gimp-mode
	gimp-help
	gimp-selector
	gimp-open-image
	gimp-cl-connect))    
;; Uncomment the following line to have a nice selector:
;(global-set-key "\C-cg" 'gimp-selector)

(mapc (lambda (hook)
	(add-hook hook
	  (lambda ()
	    (require 'snippet)
	    (require 'scheme-complete)
	    (autoload 'eldoc-current-symbol "eldoc"))))
      '(gimp-mode-hook gimp-help-mode-hook inferior-gimp-mode-hook)) 

