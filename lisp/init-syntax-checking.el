;;; package --- Summary:
;;; Commentary:
;;; Code:

(use-package flycheck
  :ensure t
  :demand t
  :config(progn
	   (setq flycheck-mode-line-prefix "FC")
	   (global-flycheck-mode t)))

(use-package flycheck-rust
  :ensure t
  :defer t
  :init (progn
	  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)
	  ))

(add-hook 'c++-mode-hook (lambda ()
			   (setq flycheck-clang-language-standard "c++17")
			   (setq flycheck-gcc-language-standard "c++17")
			   ))
(use-package flycheck-posframe
  :ensure t
  :hook (flycheck-mode . flycheck-posframe-mode)
  :config (progn
	    (defun samray/set-flycheck-face-attribute()
	      (set-face-attribute 'flycheck-posframe-warning-face nil
				  :inherit nil
				  :stipple nil
				  :background (face-attribute 'default :background)
				  :foreground (face-attribute 'flycheck-fringe-warning :foreground))

	      (set-face-attribute 'flycheck-posframe-error-face nil
				  :inherit nil
				  :stipple nil
				  :background (face-attribute 'default :background)
				  :foreground (face-attribute 'flycheck-fringe-error :foreground)))
	    (samray/set-flycheck-face-attribute)

	    (defun load-theme@after (&rest _)
	      (when flycheck-mode
		(when (not flycheck-posframe-mode)
		  (flycheck-posframe-mode))
		(samray/set-flycheck-face-attribute)))
	    (advice-add 'load-theme :after 'load-theme@after)
	    )
  )

(message "loading init-syntax-checking")
(provide 'init-syntax-checking)
;;; init-syntax-checking.el ends here
