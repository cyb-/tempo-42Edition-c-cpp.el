;;; tempo-42Edition-c-cpp.el --- abbrevs for c/c++ programming
;;
;; Copyright (C) 2008  Sebastien Varrette
;;
;; Author: Sebastien Varrette <Sebastien.Varrette@uni.lu>
;; Modified by : Sylvain Conso <sconso@student.42.fr>
;; Maintainer: Sebastien Varrette <Sebastien.Varrette@uni.lu>
;; Created: 18 Jan 2008
;; Modified 07 Jan 2015
;; Version: 0.2
;; Keywords: template, C, C++

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary
;;
;; This is a way to hook tempo into cc-mode. In fact, I merge here many ressources, including:
;; - http://www.lysator.liu.se/~davidk/elisp/tempo-examples.html
;; - http://svn.marc.abramowitz.info/homedir/dotfiles/emacs
;; - http://www.emacswiki.org/cgi-bin/wiki/TempoMode
;; etc...
;;
;; To use this file, just put a (require 'tempo-42Edition-c-cpp) in your .emacs file
;;
;; Note on tempo (from EmacsWiki):
;; templates are defined through tempo-define-template. they uses (p ...) to prompt for variables
;; and (s ...) to insert them again. > indents, n inserts a newline, and r inserts the region, if active.
;;
;; To use the templates defined here:
;; - either run M-x tempo-template-c-<xx> where <xx> is the name of the template (use TAB to have the list)
;; - or start to type the corresponding abbreviation (list follows) and hit C-RET or F5
;;
;; Feel free to adapt the templates to your own programming style.
;;
;; List of abbreviations:
;;  	<abbrev>		<correspondant sequence>
;; ---- Preprocessor statements ---
;;    	include          	#include
;;   	define          	#define
;;    	ifdef           	#ifdef
;;    	ifndef          	#ifndef
;; --- C statements
;;    	if            		if (...) { }
;;    	else  				else { ... }
;;    	ifelse 				if (...) { } else { }
;;    	while				while (...) { }
;;    	for			   		for (...) {;;}
;;      forinc         		for (var=0; var < limit; var++) { }
;;      fordec          	for (var=value; var > 0; var--) { }
;;      foriinc         	for (i=0; i < limit; i++) { }
;;      foridec         	for (i=value; i > 0; i--) { }
;;    	switch				switch() {...}
;;    	case				case: ... break;
;;    	main				int main() { ... }
;;    	malloc				type * var = (type *) malloc(...)
;; --- C++ statements
;;    	class			class xxx { ... }; (For .hpp)
;;      cclass          class xxx { ... }; (For .cpp)
;;    	getset			accessor/mutator   (For .hpp)
;;      cgetset         accessor/mutator   (For .cpp)

(require 'tempo)
(setq tempo-interactive t)

(defvar c-tempo-tags nil
  "Tempo tags for C mode")

(defvar c++-tempo-tags nil
  "Tempo tags for C++ mode")

(defvar c-tempo-keys-alist nil
  "")

(defun my-tempo-c-cpp-bindings ()
  ;;(local-set-key (read-kbd-macro "<f8>") 'tempo-forward-mark)
  (local-set-key (read-kbd-macro "C-<return>")   'tempo-complete-tag)
  (local-set-key (read-kbd-macro "<f5>")   'tempo-complete-tag)
  (tempo-use-tag-list 'c-tempo-tags)
  (tempo-use-tag-list 'c++-tempo-tags))

(add-hook 'c-mode-hook   '(lambda () (my-tempo-c-cpp-bindings)))
(add-hook 'c++-mode-hook '(lambda () (my-tempo-c-cpp-bindings)))

;; the following macros allow to set point using the ~ character in tempo templates
 
(defvar tempo-initial-pos nil
   "Initial position in template after expansion")
 (defadvice tempo-insert( around tempo-insert-pos act )
   "Define initial position."
   (if (eq element '~)
         (setq tempo-initial-pos (point-marker))
     ad-do-it))
 (defadvice tempo-insert-template( around tempo-insert-template-pos act )
   "Set initial position when defined. ChristophConrad"
   (setq tempo-initial-pos nil)
   ad-do-it
   (if tempo-initial-pos
       (progn
         (put template 'no-self-insert t)
         (goto-char tempo-initial-pos))
    (put template 'no-self-insert nil)))

;;; Preprocessor Templates (appended to c-tempo-tags)
(tempo-define-template "c-include"
		       '("#include <" r ".h>" > n
			 )
		       "include"
		       "Insert a #include <> statement"
		       'c-tempo-tags)

(tempo-define-template "c-define"
		       '("#define " r " " > n
			 )
		       "define"
		       "Insert a #define statement"
		       'c-tempo-tags)

(tempo-define-template "c-ifdef"
		       '("#ifdef " (p "ifdef-condition: " clause) > n> p n
			 "#else /* !(" (s clause) ") */" n> p n
			 "#endif // " (s clause) n>
			 )
		       "ifdef"
		       "Insert a #ifdef #else #endif statement"
		       'c-tempo-tags)

(tempo-define-template "c-ifndef"
		       '("#ifndef " (p "ifndef-clause: " clause) > n 
			 "#define " (s clause) n> p n
			 "#endif // " (s clause) n>
			 )
		       "ifndef"
		       "Insert a #ifndef #define #endif statement"
		       'c-tempo-tags)

;;; C-Mode Templates
(tempo-define-template "c-if"
		       '(> "if (" ~ " )" > n
		        	"{" > n
			 		> n
			 		"}" > 
				)
		       "if"
		       "Insert a C if statement"
		       'c-tempo-tags)

(tempo-define-template "c-else"
		       '(> "else" > n
		       		"{" > n
			 		> ~ n 
			 		"}" >
			 )
		       "else"
		       "Insert a C else statement"
		       'c-tempo-tags)

(tempo-define-template "c-if-else"
                       '(> "if (" ~ " )" > n
                       		"{" > n
                         	> n
                         	"}" > n
                         	"else" > n
                         	"{" > n
			 				> n
			 				"}" >     
			 			)
		       "ifelse"
		       "Insert a C if else statement"
		       'c-tempo-tags)

(tempo-define-template "c-while"
                       '(> "while (" ~ " )" > n
                       		"{"  > n
                         	> n
                         	"}" >   
                         )
		       "while"
		       "Insert a C while statement"
		       'c-tempo-tags)

(tempo-define-template "c-for"
                       '(> "for (" ~ ";;)" > n
                       	"{" > n
                         > n
                         "}" >      
                         )
		       "for"
		       "Insert a C for statement"
		       'c-tempo-tags)

(tempo-define-template "c-for-inc"
		       '(> "for (" (p "variable: " var) " = 0; " (s var)
			 " < "(p "upper bound: " ub)"; " (s var) "++)" > n
		       "{" > n 
			 	> r n 
			 	"}" >
			 )
		       "forinc"
		       "Insert a C for loop: for(x = 0; x < ..; x++)"
		       'c-tempo-tags)

(tempo-define-template "c-for-dec"
		       '(> "for (" (p "variable: " var) " = " (p "initial value: " iv) "; " (s var)
			 " > 0; " (s var) "--)" > n
		       "{" > n 
			 	> r n 
			 	"}" >
			 )
		       "fordec"
		       "Insert a C for loop: for(x = 0; x < ..; x++)"
		       'c-tempo-tags)


(tempo-define-template "c-for-i-inc"
		       '(> "for (i = 0; i < "(p "upper bound: " ub)"; i++)" > n
		       "{" > n 
			 	> r n 
			 	"}" >
			 )
		       "foriinc"
		       "Insert a C for loop: for(x = 0; x < ..; x++)"
		       'c-tempo-tags)

(tempo-define-template "c-for-i-dec"
		       '(> "for (i = " (p "initial value: " iv) "; i > 0; i--)" > n
		       "{" > n 
			 	> r n 
			 	"}" >
			 )
		       "foridec"
		       "Insert a C for loop: for(x = 0; x < ..; x++)"
		       'c-tempo-tags)

(tempo-define-template "c-malloc"
		       '(>(p "type: " type) " *" (p "variable name: " var) " = (" (s type) " *) malloc(sizeof(" (s type) "));" n>
			  "if (" (s var) " == NULL) {" n>
			  > r n
			 "}" >
			 )
		       "malloc"
		       "Insert a C malloc statement to define and allocate a pointer"
		       'c-tempo-tags)

(tempo-define-template "c-main"
		       '(> "int main(int ac, char **av)" > n
		       		"{" > n
			 			> r n
			 			"return 0;" > n
			 		"}" >
			 	)
		       "main"
		       "Insert a C main statement"
		       'c-tempo-tags)

(tempo-define-template "c-switch"
		       '(> "switch(" (p "variable to check: " clause) ")" > n
		       		"{" >  n  
			 		"case " > (p "first value: ") ": " ~ > n
			 		" break;" > n
			 		>"default:" > n
			 		"}" >
			 )
		       "switch"
		       "Insert a C switch statement"
		       'c-tempo-tags)

(tempo-define-template "c-case"
		       '("case " (p "value: ") ":" ~ > n>
			   "break;" >
			)
		       "case"
		       "Insert a C case statement"
		       'c-tempo-tags)

;;;C++-Mode Templates
;;(setq max-lisp-eval-depth 500) 

(tempo-define-template "c++-cclass"
		        '(
		        	(p "type: "     type 'noinsert)
			 		(p "variable: " var  'noinsert)
					(tempo-save-named 'fileName (file-name-nondirectory (buffer-file-name)))
					(tempo-save-named 'class (upcase-initials (replace-regexp-in-string "[.].*" "" (tempo-lookup-named 'fileName))))
					(tempo-save-named 'fileName (replace-regexp-in-string "[.]" "_" (tempo-lookup-named 'fileName)))
					(tempo-save-named 'm_var (concat "_" (tempo-lookup-named 'var)))
					(tempo-save-named 'fnBase (upcase-initials (tempo-lookup-named 'var)))

					
		        	> n> (header-insert)

		        	"#include <" (file-name-sans-extension (file-name-nondirectory (buffer-file-name))) ".hpp>" n> n>
			  		
		        	"/* CORE */" > n>
		        	
		        	(s class) "::" (s class) "(void) {" > n>
		        	"return ;" > n>
		        	"}" > n
					(s class) "::" (s class) "(" (s class) " const &src) {" > n>
		        	"*this = src;" > n>
		        	"return ;" > n>
		        	"}" > n
		        	(s class) "::" (s class) "(" (s type) " " (s var) ") : " (s m_var) "(" (s var) ")" > n>
		        	"{" > n>
		        	"return ;" > n>
		        	"}" > n
		        	(s class) "::~" (s class) "(void) {" > n>
		        	"return ;" > n>
		        	"}" > n
		        	n>

		        	"/* Accessors */" > n>
		        	(s type) " " (s class) "::get" (s fnBase) "(void) const {" > n>
		        	"return (this->" (s m_var) ");" > n>
		        	"}" > n
		        	n>
		        	"/* Mutators */" > n>
		        	"bool " (s class) "::set" (s fnBase) "(" (s type) " " (s var) ") {" > n>
		        	"this->" (s m_var) " = " (s var) ";" > n>
		        	"return (true);" > n>
		        	"}" > n
		        	n>
		        	"/* Operator Overload */" > n>
		        	(s class) " &" (s class) "::operator=(" (s class) " const &rhs) {" > n>
		        	"this->" (s m_var) " = rhs.get" (s fnBase) "();" > n>
		        	"return (*this);" > n>
		        	"}" > n
			 	)
		       "cclass"
		       "Insert a class skeleton"
		       'c++-tempo-tags)


(tempo-define-template "c++-class"
		        '(
		        	(p "type: "     type 'noinsert)
			 		(p "variable: " var  'noinsert)
					(tempo-save-named 'fileName (file-name-nondirectory (buffer-file-name)))
					(tempo-save-named 'class (upcase-initials (replace-regexp-in-string "[.].*" "" (tempo-lookup-named 'fileName))))
					(tempo-save-named 'fileName (replace-regexp-in-string "[.]" "_" (tempo-lookup-named 'fileName)))
					(tempo-save-named 'm_var (concat "_" (tempo-lookup-named 'var)))
					(tempo-save-named 'fnBase (upcase-initials (tempo-lookup-named 'var)))

					
		        	> n> (header-insert)

		      		"#ifndef " (upcase (tempo-lookup-named 'fileName)) > n>
		      		"# define " (upcase (tempo-lookup-named 'fileName)) > n
		      		n>
		        	"# include <iostream>" n> n>
			  		
			  		"class " (s class) " {" > n n>

			  		"private:" > n>
			  			(tempo-save-named 'm_var (concat "_" (tempo-lookup-named 'var)))
						(tempo-save-named 'fnBase (upcase-initials (tempo-lookup-named 'var)))

			  			(s type) " " (s m_var) ";" > n
			  			~ n>

			 			"public:" > n>
			  				(s class) "(void);" > n>
			  				(s class) "(const " (s class) " &src);" > n>
			  				(s class) "(" (s type) " " (s var) ");" > n>
			  				"~" (s class) "(void);" > n
			 				n>
							"/* Accessors */" > n>
							(s type) " get" (s fnBase) "(void) const;" > n
							n>
							"/* Mutators */" > n>
							"bool set" (s fnBase) "(" (s type) " " (s var) ");" > n
							n>
							"/* Operator Overload */" > n>
							(s class) " &operator=(" (s class) " const &rhs);" > n>
			 				"};" > n
			 				n>
			 				"#endif" >
			 	)
		       "class"
		       "Insert a class skeleton"
		       'c++-tempo-tags)


(tempo-define-template "c++-cgetset"
		       '(
		       		(p "type: "     type 'noinsert)
			 		(p "variable: " var  'noinsert)
			 		(tempo-save-named 'fileName (file-name-nondirectory (buffer-file-name)))
					(tempo-save-named 'class (upcase-initials (replace-regexp-in-string "[.].*" "" (tempo-lookup-named 'fileName))))

					(tempo-save-named 'virtual (if (y-or-n-p  "virtual?") "virtual " ""))
					(tempo-save-named 'm_var (concat "_" (tempo-lookup-named 'var)))
					(tempo-save-named 'fnBase (upcase-initials (tempo-lookup-named 'var)))

			 		(s virtual) (s type) " "(s class) "::get" (s fnBase) "(void) const {" > n>
			 		"return (this->" (s m_var) ");" > n>
		        	"}" > n>

		        	(s virtual) "bool " (s class) "::set" (s fnBase) "(" (s type) " " (s var) ") {" > n>
		        	"this->" (s m_var) " = " (s var) ";" > n>
		        	"return (true);" > n>
		        	"}" > n
			 	)
		       "cgetset"
		       "Insert get set methods"
		       'c++-tempo-tags)

(tempo-define-template "c++-getset"
		       '(
		       		(p "type: "     type 'noinsert)
			 		(p "variable: " var  'noinsert)
					(tempo-save-named 'virtual (if (y-or-n-p  "virtual?") "virtual " ""))
					(tempo-save-named 'm_var (concat "_" (tempo-lookup-named 'var)))
					(tempo-save-named 'fnBase (upcase-initials (tempo-lookup-named 'var)))

			 		(s type) " " (s m_var) ";" > n>
			 		(s virtual) (s type) " get" (s fnBase) "(void) const;" > n>
			 		(s virtual) "bool set" (s fnBase) "(" (s type) " " (s var) ");" > n
			 )
		       "getset"
		       "Insert get set methods"
		       'c++-tempo-tags)

(provide 'tempo-42Edition-c-cpp)
;;; tempo-c-cpp.el ends here
