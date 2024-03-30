(require 'prettier-js)

(use-package web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode)
         ("\\.css\\'" . web-mode)
         ("\\.js\\'" . web-mode))
  :config
  (add-hook 'web-mode-hook 'prettier-js-mode)
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-enable-auto-pairing t
        web-mode-enable-auto-opening t
        )
  ;; eval lsp after web-mode is loaded
  (eval-after-load 'web-mode
    '(progn
       (require 'lsp)
       (add-hook 'web-mode-hook #'lsp-deferred)))
)