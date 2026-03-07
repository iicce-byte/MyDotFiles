(use-package evil
  :demand t
  :ensure t
  :init
  ; (setq evil-default-state 'normal)
  (setq evil-want-integration t)        ; 与 other packages 集成
  (setq evil-want-keybinding nil)       ; 避免与 evil-collection 冲突
  (setq evil-undo-system 'undo-redo)
  (setq evil-leader/leader "SPC")
  :config
  (evil-mode 1)
  (evil-set-leader 'normal (kbd "SPC"))
  (evil-set-leader 'visual (kbd "SPC"))

  (evil-define-key 'normal 'global
    (kbd "S") 'evil-write
    (kbd "Q") 'evil-window-delete
    (kbd "h") 'evil-insert
    (kbd "H") 'evil-insert-line

    (kbd "j") 'evil-backward-char
    (kbd "l") 'evil-forward-char
    (kbd "i") 'evil-previous-line
    (kbd "k") 'evil-next-line

    (kbd "J") (lambda () (interactive) (evil-backward-char 5))
    (kbd "L") (lambda () (interactive) (evil-forward-char 5))
    (kbd "I") (lambda () (interactive) (evil-previous-line 5))
    (kbd "K") (lambda () (interactive) (evil-next-line 5))
    (kbd "<leader>i") 'evil-window-up
    (kbd "<leader>j") 'evil-window-left
    (kbd "<leader>k") 'evil-window-down
    (kbd "<leader>l") 'evil-window-right

    (kbd "s") nil

    (kbd "s s") (lambda() (interactive) (evil-window-vsplit))
    (kbd "s d") (lambda() (interactive) (evil-window-split))

    (kbd "s e") 'tab-new
    (kbd "s j") 'tab-previous
    (kbd "s l") 'tab-next

    (kbd "s f") 'evil-end-of-line
    (kbd "s a") 'evil-beginning-of-line
    (kbd "s c") 'find-file

    (kbd "<") (lambda() (interactive) (tab-bar-move-tab -1))
    (kbd ">") (lambda() (interactive) (tab-bar-move-tab 1))
    (kbd ";") 'evil-ex)
 (evil-define-key 'visual 'global
    (kbd "h") 'evil-insert
    (kbd "j") 'evil-backward-char
    (kbd "l") 'evil-forward-char
    (kbd "i") 'evil-previous-line
    (kbd "k") 'evil-next-line)
)

(use-package company
  :hook (after-init . global-company-mode)
  :config (setq company-minimum-prefix-length 1
		company-quick-access t))

; (use-package conda
;   :config
;   (conda-env-autoactivate-mode t)
;   (setq conda-anaconda-home (expand-file-name "/opt/homebrew/Caskroom/miniconda/base")))
;;; ~/.emacs.d/init.el --- Doom-style LSP Configuration
;; ============================================
;; Doom 风格：延迟优化模式
;; ============================================

(defvar +lsp-defer-shutdown 3
  "延迟关闭 LSP 服务器的时间（秒）")

(defvar +lsp--default-read-process-output-max nil)
(defvar +lsp--default-gcmh-high-cons-threshold nil)

(define-minor-mode +lsp-optimization-mode
  "Doom 风格的 LSP 性能优化"
  :global t
  :init-value nil
  (if (not +lsp-optimization-mode)
      (when +lsp--optimization-init-p
	(setq-default read-process-output-max +lsp--default-read-process-output-max)
	(setq +lsp--optimization-init-p nil))
    (unless +lsp--optimization-init-p
      (setq +lsp--default-read-process-output-max (default-value 'read-process-output-max))
      (setq-default read-process-output-max (* 1024 1024))
      (setq +lsp--optimization-init-p t))))
(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook ((python-mode c-mode c++-mode js-mode) . lsp-deferred)
  :hook (lsp-before-initialize . +lsp-optimization-mode)

  :init
  ;; Doom 风格的保守设置
  (setq lsp-session-file (expand-file-name ".local/cache/lsp-session" user-emacs-directory)
	lsp-server-install-dir (expand-file-name ".local/etc/lsp" user-emacs-directory)
	lsp-keep-workspace-alive nil)

  ;; 禁用侵入性功能 (Doom 风格)
  (setq lsp-enable-folding nil
	lsp-enable-text-document-color nil
	lsp-enable-on-type-formatting nil
	lsp-headerline-breadcrumb-enable nil) ; Doom 默认关闭面包屑

  :config
  ;; 延迟关闭服务器 (Doom 特色功能)
  (defvar +lsp--deferred-shutdown-timer nil)
  (advice-add 'lsp--shutdown-workspace :around
    (lambda (fn &optional restart)
      (if (or restart (null +lsp-defer-shutdown) (= +lsp-defer-shutdown 0))
	  (funcall fn restart)
	(when (timerp +lsp--deferred-shutdown-timer)
	  (cancel-timer +lsp--deferred-shutdown-timer))
	(setq +lsp--deferred-shutdown-timer
	      (run-at-time +lsp-defer-shutdown nil
		(lambda (workspaces)
		  (dolist (ws workspaces)
		    (unless (cl-some #'buffer-live-p (lsp--workspace-buffers ws))
		      (with-lsp-workspace ws
			(let ((lsp-restart 'ignore))
			  (funcall fn))))))
		lsp--buffer-workspaces))))))

(use-package lsp-ui
  :ensure t
  :hook (lsp-mode . lsp-ui-mode)
  :config
  ;; Doom 风格的保守 UI 设置
  (setq lsp-ui-doc-max-height 8
	lsp-ui-doc-max-width 72
	lsp-ui-doc-delay 0.75
	lsp-ui-doc-show-with-mouse nil
	lsp-ui-doc-position 'at-point
	lsp-ui-sideline-show-hover nil
	lsp-ui-sideline-ignore-duplicate t))

(provide 'init-packages)
