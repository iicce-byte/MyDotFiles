(use-package treesit
  :ensure nil
  :config
  (setq treesit-language-source-alist
        '(
          ; (bash . ("https://github.com/tree-sitter/tree-sitter-bash"))
          (c . ("https://github.com/tree-sitter/tree-sitter-c"))
          (cpp . ("https://github.com/tree-sitter/tree-sitter-cpp"))
          ; (css . ("https://github.com/tree-sitter/tree-sitter-css"))
          ; (go . ("https://github.com/tree-sitter/tree-sitter-go"))
          ; (html . ("https://github.com/tree-sitter/tree-sitter-html"))
          ; (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript"))
          ; (json . ("https://github.com/tree-sitter/tree-sitter-json"))
          ; (lua . ("https://github.com/tree-sitter/tree-sitter-lua"))
          ; (make . ("https://github.com/tree-sitter/tree-sitter-make"))
          (python . ("https://github.com/tree-sitter/tree-sitter-python"))
          ; (rust . ("https://github.com/tree-sitter/tree-sitter-rust"))
          ; (toml . ("https://github.com/tree-sitter/tree-sitter-toml"))
          ; (yaml . ("https://github.com/tree-sitter/tree-sitter-yaml"))
          ))

  ;; 安装缺失的语法库
  (dolist (lang '(python c cpp))
    (unless (treesit-language-available-p lang)
      (treesit-install-language-grammar lang)))

  ;; 默认使用 ts-mode
  (setq major-mode-remap-alist
        '((python-mode . python-ts-mode)
          (bash-mode . bash-ts-mode)
          (js-mode . js-ts-mode)
          (css-mode . css-ts-mode)
          (c-mode . c-ts-mode)
          (cpp-mode . c++-ts-mode)
          (html-mode . html-ts-mode)
          (json-mode . json-ts-mode))))

(provide 'init-treesit)
