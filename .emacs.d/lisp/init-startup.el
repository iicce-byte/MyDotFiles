(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-hl-line-mode 1)

(setq inhibit-startup-screen t)
(set-face-foreground 'hl-line nil)
(add-to-list 'default-frame-alist '(undecorated . t))

(defalias 'yes-or-no-p 'y-or-n-p)
(setq create-lockfiles nil
      make-backup-files nil)

(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)
(setq display-line-numbers-current-absolute t
      display-line-numbers-width 3
      display-line-numbers-minimum-width 3)


(setq-default indent-tabs-mode nil
              tab-width 4)
(setq-default c-basic-offset 4)    ;; C/C++/Java
(setq-default js-indent-level 4)   ;; JS/TS
(setq-default python-indent-offset 4) ;; Python
(setq-default sgml-basic-offset 4) ;; HTML
(setq-default css-indent-offset 4) ;; CSS
(setq-default go-indent-level 4)   ;; Go

(electric-pair-mode 1)

(setq electric-pair-inhibit-predicate
      (lambda (c)
        (eq c ?<)))

(defun my-enable-angle-brackets ()
  (setq-local electric-pair-inhibit-predicate
              (lambda (c) nil)))

(add-hook 'html-mode-hook       #'my-enable-angle-brackets)
(add-hook 'nxml-mode-hook       #'my-enable-angle-brackets)
(add-hook 'xml-mode-hook        #'my-enable-angle-brackets)
(add-hook 'web-mode-hook        #'my-enable-angle-brackets)
; JetbrainsMono Nerd Font
(add-to-list 'default-frame-alist '(font . "DejaVuSansM Nerd Font Mono"))
(set-face-attribute 'fixed-pitch nil :font "DejaVuSansM Nerd Font Mono")
(set-face-attribute 'variable-pitch nil :font "DejaVuSansM Nerd Font Mono")

; (add-hook 'prog-mode-hook 'whitespace-mode)
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(provide 'init-startup)
