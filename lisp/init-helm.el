;;; package --- Summary
;;; code:
;;; Commentary:

(use-package helm
  :ensure t
  :diminish helm-mode
  :init (progn
	  ;; Extra helm configs
	  ;; Use fuzzy match in helm
	  (setq helm-M-x-fuzzy-match t)
	  (setq helm-buffers-fuzzy-matching t)
	  (setq helm-recentf-fuzzy-match t)
	  (setq helm-semantic-fuzzy-match t
		helm-imenu-fuzzy-match    t)
	  ;; Make helm can select anything even not match
	  (setq helm-move-to-line-cycle-in-source nil)
	  (setq helm-ff-search-library-in-sexp t)
	  (setq helm-ff-file-name-history-use-recentf t)
	  (setq helm-mini-default-sources '(helm-source-buffers-list
					    helm-source-recentf
					    helm-source-bookmarks
					    helm-source-buffer-not-found))
	  (when (executable-find "curl")
	    (setq helm-google-suggest-use-curl-p t))

	  (setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
		helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
		helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
		helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
		helm-ff-file-name-history-use-recentf t
		helm-echo-input-in-header-line t)

	  (setq helm-autoresize-max-height 0)
	  (setq helm-autoresize-min-height 20)
	  (setq helm-grep-ag-command "rg --color=always --colors 'match:fg:black' --colors 'match:bg:yellow' --smart-case --no-heading --line-number %s %s %s")
	  )
  :config (progn
	    ;; enable helm globally
	    (helm-mode 1)
	    (helm-autoresize-mode 1)
	    (defun samray/helm-find-files-navigate-back (orig-fun &rest args)
	      (if (= (length helm-pattern) (length (helm-find-files-initial-input)))
		  (helm-find-files-up-one-level 1)
		(apply orig-fun args)))
	    (advice-add 'helm-ff-delete-char-backward :around #'samray/helm-find-files-navigate-back)
	    )
  )
(use-package helm-projectile
  :ensure t
  :init (progn
	  ;; make projectile use helm as completion system
	  (setq projectile-completion-system 'helm)
	  )
  :config(progn
	   ;; start helm-projectile
	   (helm-projectile-on)
	   )
  )

(use-package helm-swoop
  :ensure t
  :config (progn
	    (defun samray/helm-swoop ()
	      "Use helm-swoop dependen on buffer size."
	      (interactive)
	      (if (samray/buffer-too-big-p)
		  (progn
		    (if (samray/buffer-too-large-p)
			(isearch-forward)
		      (progn
			;; Disable pre-input to improve `helm-swoop` preformance.
			(setq helm-swoop-pre-input-function
			      (lambda () ""))
			;; Disable color to improve performance
			(setq helm-swoop-speed-or-color nil)
			(helm-swoop)
			))
		    )
		(progn
		  (setq helm-swoop-speed-or-color t)
		  (helm-swoop))
		)
	      )
	    )
  )

(use-package helm-themes
  :ensure t
  )
(use-package helm-xref
  :ensure t
  :config (progn
	    (setq xref-show-xrefs-function 'helm-xref-show-xrefs)
	    ))
(provide 'init-helm)

;;; init-helm.el ends here
