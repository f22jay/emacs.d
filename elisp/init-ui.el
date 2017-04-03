;;; package --- Summary
;;; Code:
;;; Commentary:
;;;----------------;;;
;;; User Interface ;;;
;;;----------------;;;

;;;ignore case when searching
(setq case-fold-search t)

;;;------------------;;;
;;; Windows & Frames ;;;
;;;------------------;;;
;; language
;;; always split windows horizontally rather than vertically
;; (setq split-height-threshold nil)
(setq current-language-environment "English")
;;; Automatic resizing of Emacs windows to the golden radion
;; (use-package golden-ratio
;;   :ensure t
;;   :init (progn
;;           (golden-ratio-mode t)
;;           ))
;; popwin is a popup window manager for Emacs which makes you free from the hell
;; of annoying buffers such like *Help*, *Completions*, *compilation*, and etc.
(use-package popwin
  :ensure t
  :config (progn
	    (popwin-mode t)
	    (push '(compilation-mode :noselect t) popwin:special-display-config)
	    (push '(" *undo-tree*" :width 0.3 :position right) popwin:special-display-config)
	    (push "*slime-apropos*" popwin:special-display-config)
	    (push "*slime-macroexpansion*" popwin:special-display-config)
	    (push "*slime-description*" popwin:special-display-config)
	    (push '("*slime-compilation*" :noselect t) popwin:special-display-config)
	    (push "*slime-xref*" popwin:special-display-config)
	    (push '(sldb-mode :stick t) popwin:special-display-config)
	    (push 'slime-repl-mode popwin:special-display-config)
	    (push 'slime-connection-list-mode popwin:special-display-config)
	    (push "*vc-diff*" popwin:special-display-config)
	    (push "*vc-change-log*" popwin:special-display-config)
	    (push '("*Youdao Dictionary*" :noselect t :width 0.2 :position bottom) popwin:special-display-config)
	    ))

;;; https://www.emacswiki.org/emacs/ToggleWindowSplit
(defun samray/toggle-window-split ()
  "Vertical split show more of each line, horizontal split show more lines.
This code toggles between them."
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
	     (next-win-buffer (window-buffer (next-window)))
	     (this-win-edges (window-edges (selected-window)))
	     (next-win-edges (window-edges (next-window)))
	     (this-win-2nd (not (and (<= (car this-win-edges)
					 (car next-win-edges))
				     (<= (cadr this-win-edges)
					 (cadr next-win-edges)))))
	     (splitter
	      (if (= (car this-win-edges)
		     (car (window-edges (next-window))))
		  'split-window-horizontally
		'split-window-vertically)))
	(delete-other-windows)
	(let ((first-win (selected-window)))
	  (funcall splitter)
	  (if this-win-2nd (other-window 1))
	  (set-window-buffer (selected-window) this-win-buffer)
	  (set-window-buffer (next-window) next-win-buffer)
	  (select-window first-win)
	  (if this-win-2nd (other-window 1))))))
(when window-system
  ;;turn off tool bar
  (tool-bar-mode -1)
  ;; turn off file scroll bar
  (scroll-bar-mode -1)
  ;; specify the fringe width for windows -- this sets both the left and
  ;; right fringes to 10
  (fringe-mode 8)
  )

;; no menubar
(menu-bar-mode -1)
;; turn off startup help menu
(setq inhibit-splash-screen t)
;; show line number
(global-linum-mode t)
;; number of characters until the fill column
(setq fill-column 80)
;; show the current line and column numbers in the stats bar as well
(line-number-mode t)
(column-number-mode t)
;;; make sure my code stays within 100 characters always and prefer the soft line wrap while writing prose
;;; https://www.emacswiki.org/emacs/TruncateLines
;; (setq-default truncate-lines t)
;; (setq truncate-partial-width-windows nil)
;; make emacs full-screen at startup
(setq initial-frame-alist (quote ((fullscreen . maximized))))
;;; show customized phrase in scratch
;;; From Purcell https://github.com/purcell/emacs.d
(setq-default initial-scratch-message
              (concat ";; Happy hacking, " user-login-name " - Emacs ♥ you!\n\n"))

;;----------;;
;;  Cursor  ;;
;;----------;;
;; highlight current line
(global-hl-line-mode t)
(setq highlight-current-line-globally t)
(setq highlight-current-line-high-faces nil)
(setq highlight-current-line-whole-line nil)
(setq hl-line-face (quote highlight))
;; don't blink the cursor
(blink-cursor-mode -1)

;;set the cursor shape to bar
(setq-default cursor-type 'bar)
;; make sure transient mark mode is enabled (it should be by default,
;; but just in case)
(transient-mark-mode t)
;; turn on mouse wheel support for scrolling
;; (mouse-wheel-mode t)

;;----------------------;;
;; Syntax Highlighting  ;;
;;----------------------;;
;; text decoration
(setq font-lock-maximum-decoration t)
(global-font-lock-mode t)
(global-hi-lock-mode nil)
(setq jit-lock-contextually t)
(setq jit-lock-stealth-verbose t)
;; if there is size information associated with text, change the text
;; size to reflect it
(size-indication-mode t)

;; highlight parentheses when the cursor is next to them
(show-paren-mode t)
;;---------------;;
;;  Color Theme  ;;
;;---------------;;
;; (use-package monokai-theme
;;   :ensure t
;;   )
(use-package zenburn-theme
  :ensure t
  )
(use-package gruvbox-theme
  :ensure t
  :disabled t
  )
;; Cycle through this set of themes
(defvar samray-theme-list '(zenburn gruvbox ))

(defvar samray-current-theme nil)
(defun samray/cycle-theme ()
  "Cycle through a list of themes, samray-theme-list."
  (interactive)
  (when samray-current-theme
    (disable-theme samray-current-theme)
    (setq samray-theme-list (append samray-theme-list (list samray-current-theme))))
  (setq samray-current-theme (pop samray-theme-list))
  (load-theme samray-current-theme t)
  )

;; Switch to the first theme in the list above
(samray/cycle-theme)
(defvar after-load-theme-hook nil
  "Hook run after a color theme is loaded using `load-theme'.")
(defadvice load-theme (after run-after-load-theme-hook activate)
  "Run `after-load-theme-hook'."
  (run-hooks 'after-load-theme-hook))

;;---------------;;
;;      Font     ;;
;;---------------;;

(defun samray/font-exists-p (font)
  "Check if FONT exists."
  (when window-system
    (if (null (x-list-fonts font)) nil t)))
;; (defun samray/get-valid-font (font-list)
;;   "Return valid font in FONT-LIST."
;;   (let ((current-font (pop font-list)))
;;     (if (samray/font-exists-p current-font )
;; 	current-font
;;       (samray/get-valid-font font-list)))
;;   )
(defvar samray-font-list '("Inconsolata-11" "Consolas" "Source Code Pro-11" "Fira Code-11" ))
(defvar samray-current-font nil)
(defun samray/cycle-font ()
  "Cycle through a list of fonts,samray-font-list."
  (interactive)
  (when samray-current-font
    (setq samray-font-list (append samray-font-list (list samray-current-font))))
  (let ((current-font (pop samray-font-list)))
    (when (not (samray/font-exists-p current-font))
      (setq current-font (pop samray-font-list)))
    (setq samray-current-font current-font)
    (cond ((eq system-type 'gnu/linux)
	   (set-frame-font samray-current-font))
	  ((eq system-type 'darwin)
	   (set-frame-font samray-current-font))
	  ((eq system-type 'windows-nt)
	   (set-frame-font samray-current-font))))
  )
;;; switch to the first font in the list above
(samray/cycle-font)
;; customize font
(defun samray/set-font ()
  "Set different font for different os."
  (interactive)
  (cond ((eq system-type 'gnu/linux)
         (set-frame-font "Source Code Pro-11"))
        ((eq system-type 'darwin)
         (set-frame-font "Monaco"))
        ((eq system-type 'windows-nt)
         (set-frame-font "Consolas")))
  )

;;----------------;;
;;Major/Minor Mode;;
;;----------------;;
(use-package spaceline
  :ensure t
  :demand t
  :config
  (require 'spaceline-config)
  (setq powerline-default-separator 'nil)
  (spaceline-emacs-theme)
  )
;;; Use Miminish minor modes to change the mode line
;;; The mode line map:
;;; paredit-mode -> "π"
;;; wakatime-mode -> "ω"
;;; flycheck-mode -> "ψ"
;;; yasnippet-mode -> "γ"
;;; company-mode -> "Φ"
;;; smarthparence-mode -> "ρ"
;;; hungrydelete-mode -> ""
;;; lisp-interaction-mode -> "λ"
;;; abbrev-mode -> ""  "" means hide this minor mode from mode line
;;; undo-tree-mode -> ""
;;; whichkey-mode -> ""
(use-package diminish
  :ensure t
  :demand t
  :diminish hs-minor-mode
  :diminish abbrev-mode
  :diminish auto-revert-mode
  :diminish auto-fill-function
  :diminish mail-abbrevs-mode
  :diminish highlight-indentation-mode
  :diminish subword-mode)
;;; Stolen From https://github.com/hrs/dotfiles/blob/master/emacs.d/configuration.org
(defmacro diminish-minor-mode (filename mode &optional abbrev)
  `(eval-after-load (symbol-name ,filename)
     '(diminish ,mode ,abbrev)))

(defmacro diminish-major-mode (mode-hook abbrev)
  `(add-hook ,mode-hook
             (lambda () (setq mode-name ,abbrev))))
(diminish-minor-mode 'highlight-indentation 'highlight-indentation-mode )
(diminish-minor-mode 'mail-abbrevs 'mail-abbrevs-mode )
(diminish-minor-mode 'auto-revert 'auto-revert-mode)
(diminish-minor-mode 'simple 'auto-fill-function )
(diminish-minor-mode 'eldoc 'eldoc-mode)
;; (diminish-minor-mode 'global-whitespace 'global-whitespace-mode)
;; (diminish-minor-mode 'subword 'subword-mode)
(diminish-major-mode 'emacs-lisp-mode-hook "el")
(diminish-major-mode 'lisp-interaction-mode-hook "λ")
(diminish-major-mode 'python-mode-hook "Py")
(provide 'init-ui)
;;; init-ui.el ends here
