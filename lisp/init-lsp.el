;;; init-lsp.el ---                                  -*- lexical-binding: t; -*-

;;; package --- Summary
;;; Commentary:
;;; Code:
(use-package lsp-mode
  :ensure t
  :defer t
  :config (progn
	    (add-hook 'python-mode-hook 'lsp-mode)
	    (add-hook 'rust-mode-hook 'lsp-mode)
	    (set-face-attribute 'lsp-face-highlight-textual nil
				:background "#666" :foreground "#ffffff"
				)
	    ))
<<<<<<< HEAD
;; (use-package lsp-python
;;   :ensure t
;;   :config(progn
;; 	   (add-hook 'python-mode-hook #'lsp-python-enable)
;; 	   ))
=======
(use-package lsp-python
  :ensure t
  :config(progn
	   (add-hook 'python-mode-hook 'lsp-python-enable)
	   ))
>>>>>>> 1612f61c9735671accac7b2f7b931e8ea7e2fe2e
(use-package lsp-rust
  :ensure t
  :config (progn
	    (add-hook 'rust-mode-hook 'lsp-rust-enable)
	    (add-hook 'rust-mode-hook 'flycheck-mode)
	    (setq lsp-rust-rls-command "/home/samray/Code/rust/rls/target/debug/rls")
	    ))

(use-package lsp-ui
  :ensure t
  :defer t
  :config (progn
  	    (add-hook 'lsp-mode-hook 'lsp-ui-mode)
  	    )
  )
(provide 'init-lsp)
;;; init-lsp.el ends here
