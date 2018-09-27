;;; package --- Summary:
;;; Commentary:
;;; Code:
;;; Commentary:

;;; enhanced gud
(use-package realgud
  :ensure t
  :commands (realgud:gdb realgud:pdb)
  :config (progn
	    (defvar menubar-last
	      (make-ring 20))
	    (ring-insert menubar-last "dummy")
	    ;; Enable menu-bar and tool-bar in specified mode.
	    (defadvice select-window (after select-window-menubar activate)
	      (unless (equal (buffer-name) (ring-ref menubar-last 0))
		(ring-insert menubar-last (buffer-name))
		(let ((yes-or-no
		       (if (memq major-mode '(comint-mode))
			   1 -1)))
		  (menu-bar-mode yes-or-no)
		  (tool-bar-mode yes-or-no))))
	    )
  )

(use-package yasnippet
  :ensure t
  :diminish (yas-minor-mode . " Ya")
  :commands (yas-expand-snippet yas-insert-snippet yas-new-snippet)
  :init (add-hook 'prog-mode-hook #'yas-minor-mode)
  :config (progn
	    (yas-reload-all)
	    (add-to-list 'yas-snippet-dirs "~/.emacs.d/snippets")
	    ))

;;; similar with fill-column-indicator,but a little bit different
(use-package column-enforce-mode
  :ensure t
  :diminish column-enforce-mode
  :defer t
  :config
  (setq column-enforce-column 79)
  (add-hook 'prog-mode-hook 'column-enforce-mode))

(use-package yaml-mode
  :ensure t
  :mode "\\.yml$")
(use-package es-mode
  :ensure t
  :mode "\\.es$"
  :config (progn
	    (setq es-always-pretty-print t)
	    ))

(use-package dockerfile-mode
  :ensure t
  :mode ("Dockerfile\\'" . dockerfile-mode))
(use-package docker
  :ensure t
  :commands (docker-images docker-containers docker-volumes docker-networks docker-machines))

(use-package json-mode
  :ensure t
  :mode "\\.json$"
  :init (remove-hook 'json-mode 'tern-mode)
  )

(use-package nginx-mode
  :ensure t
  :commands (nginx-mode))

;; Make Emacs use the $PATH set up by the user's shell
(use-package exec-path-from-shell
  :ensure t
  :init (progn
	  (if (eq system-type 'darwin)
	      (exec-path-from-shell-initialize))
	  (setq exec-path-from-shell-variables '("RUST_SRC_PATH" "PYTHONPATH" "GOPATH"))
	  ;; when it is nil, exec-path-from-shell will read environment variable
	  ;; from .zshenv instead of .zshrc, but makes sure that you put all
	  ;; environment variable you need in .zshenv rather than .zshrc
	  (setq exec-path-from-shell-check-startup-files nil) ;
	  (setq exec-path-from-shell-arguments '("-l")) ;remove -i read form .zshenv
	  )
  )

;; Emacs extension to increate selected region by semantic units
(use-package expand-region
  :ensure t
  :commands er/expand-region
  )
;; Projectile
(use-package projectile
  :ensure t
  :init (progn
	  (setq projectile-mode-line '(:eval(format " P(%s)"
						    (projectile-project-name))))
	  )
  :commands (counsel-projectile-switch-project counsel-projectile-find-file)
  :config
  (progn
    (projectile-mode)
    (setq projectile-completion-system 'ivy)
    (add-to-list 'projectile-globally-ignored-directories "*.ccls-cache")
    (add-to-list 'projectile-globally-ignored-directories "*.cquery_cached_index")
    (add-to-list 'projectile-globally-ignored-directories "*CMakeFiles")
    )
  )

;;; Rest client in Emacs
(use-package restclient
  :ensure t
  :mode ("\\.rest\\'" . restclient-mode))

;;; Evil is not especilly useful in the terminal,so
;; (evil-set-initial-state 'term-mode 'emacs)

(use-package symbol-overlay
  :ensure t
  :commands (symbol-overlay-put)
  )

(use-package treemacs
  :ensure t
  :defer t
  :config
  (progn
    (use-package treemacs-evil
      :ensure t
      :demand t)
    (setq treemacs-follow-after-init          t
          treemacs-width                      30
          treemacs-indentation                2
          treemacs-git-integration            t
          treemacs-collapse-dirs              3
          treemacs-silent-refresh             nil
          treemacs-change-root-without-asking nil
          treemacs-sorting                    'alphabetic-desc
          treemacs-show-hidden-files          t
          treemacs-never-persist              nil
          treemacs-is-never-other-window      nil
          treemacs-goto-tag-strategy          'refetch-index)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t))
  :bind
  (:map global-map
        ("C-c t t"        . treemacs-toggle)
        ("C-c t e"    . treemacs)
	))
(use-package treemacs-projectile
  :defer t
  :ensure t
  :config
  (setq treemacs-header-function #'treemacs-projectile-create-header)
  :bind (:map global-map
              ("C-c t p" . treemacs-projectile)
              ))
(defun samray/speedbar-contract-all-lines ()
  "Contract all items in the speedbar buffer."
  (interactive)
  (goto-char (point-min))
  (while (not (eobp))
    (forward-line)
    (speedbar-contract-line)))

(defun samray/projectile-speedbar-toggle ()
  "Improve the default projectile speedbar toggle."
  (interactive)
  (if (buffer-file-name)
      (let ((current-buffer (buffer-name)))
	(sr-speedbar-toggle)
	(if (sr-speedbar-exist-p)
	    (progn
	      (set-buffer current-buffer)
	      (projectile-speedbar-open-current-buffer-in-tree)
	      )
	  ))
    (progn
      (sr-speedbar-toggle)
      (sr-speedbar-refresh)
      )))

(defun samray/term-paste (&optional string)
  "Yanking in the term-mode doesn't quit work The text from the
   paste appears in the buffer but isn't sent to the shell."
  (interactive)
  (process-send-string
   (get-buffer-process (current-buffer))
   (if string string
     (current-kill 0)))
  )
(add-hook 'term-mode-hook
	  (lambda ()
	    (goto-address-mode)
	    (setq yas-dont-activate-functions t)))

;;; https://www.emacswiki.org/emacs/AutoFillMode
;;; auto format comment to 80-char long
(setq-default fill-column 80)

(defun comment-auto-fill ()
  "Auto fill comments but not code in programmingModes."
  (setq-local comment-auto-fill-only-comments t)
  (auto-fill-mode 1))
(with-eval-after-load 'prog-mode
  (add-hook 'prog-mode-hook 'comment-auto-fill))

(defun samray/switch-to-buffer (repl-buffer-name)
  "Run REPL and switch to the  buffer REPL-BUFFER-NAME.
similar to shell-pop"
  (interactive)
  (if (get-buffer repl-buffer-name)
      (if (string= (buffer-name) repl-buffer-name)
	  (if (not (one-window-p))
	      (progn (bury-buffer)
		     (delete-window)))

	(progn
	  (samray/split-window-below-and-move)
	  (switch-to-buffer repl-buffer-name)
	  (goto-char (point-max))
	  (evil-insert-state))
	)
    (progn
      (run-python)
      (samray/split-window-below-and-move)
      (switch-to-buffer repl-buffer-name)
      (goto-char (point-max)))))

(defun samray/repl-pop ()
  "Run REPL for different major mode and switch to the repl buffer.
similar to shell-pop"
  (interactive)
  (let* ((repl-modes '((python-mode . "*Python*")
		       (scheme-mode . "* Mit REPL *"))))
    (cond ((or (derived-mode-p 'python-mode) (derived-mode-p 'inferior-python-mode))
	   (progn
;;; To fix issue that there is weird eshell output with ipython
	     (samray/switch-to-buffer (cdr (assoc 'python-mode repl-modes)))))
	  ((or (derived-mode-p 'scheme-mode) (derived-mode-p 'geiser-repl-mode))
	   (samray/switch-to-buffer (cdr (assoc 'scheme-mode repl-modes))))
	  ((or (derived-mode-p 'prog-mode)(derived-mode-p 'inferior-python-mode))
	   (progn
	     (samray/switch-to-buffer (cdr (assoc 'python-mode repl-modes)))))
	  )))
;;; Treating terms in CamelCase symbols as separate words makes editing a
;;; little easier for me, so I like to use subword-mode everywhere.
;;;  Nomenclature           Subwords
;; ===========================================================
;; GtkWindow          =>  "Gtk" and "Window"
;; EmacsFrameClass    =>  "Emacs", "Frame" and "Class"
;; NSGraphicsContext  =>  "NS", "Graphics" and "Context"
(global-subword-mode t)
;;; Put *compilation* buffer in the bottom of window which will disappears
;;; automatically,instead shows in other window
(setq compilation-scroll-output t)


(defun samray/imenu ()
  "Call lsp-ui-imenu firstly, if lsp-mode is disable, call counsel-imenu instead."
  (interactive)
  (if lsp-mode
      (lsp-ui-imenu)
    (counsel-imenu)))

(defun samray/get-buffer-name ()
  "Get current buffer name."
  (interactive)
  (kill-new (buffer-name))
  )
(provide 'init-programming)

;;; init-programming.el ends here
