(load (expand-file-name "packages/dap.el" user-emacs-directory))

(defun find-venv ()
  "Find the python executable in the current project's virtual environment."
  (require 'projectile)
  (let* ((root-dir (or (projectile-project-root) (file-name-directory (buffer-file-name))))
         (found-venv nil)) ; Initialize found-venv here
    (cond ((file-directory-p (concat root-dir "/.venv"))
             (setq found-venv (concat root-dir "/.venv")))
          ((file-directory-p (concat root-dir "/.env"))
             (setq found-venv (concat root-dir "/.env")))
          ((file-directory-p (concat root-dir "/env"))
             (setq found-venv (concat root-dir "/env")))
          ((file-directory-p (concat root-dir "/venv"))
             (setq found-venv (concat root-dir "/venv")))
          ((and root-dir (file-exists-p (concat root-dir "/Pipfile")))
             (setq found-venv (replace-regexp-in-string "\n" "" (shell-command-to-string "pipenv --quiet --venv")))))
    (if (and found-venv (file-exists-p (concat found-venv "/bin/python")))
        (concat (file-truename found-venv) "/bin/python")
      (replace-regexp-in-string "\n" "" (shell-command-to-string "which python3")))))

(add-hook 'python-mode-hook
          (lambda ()
            (message "Find python executable: %s" (find-venv))
            (dap-setup)
            (require 'dap-python)
            (setq dap-python-debugger 'debugpy)
            (defun dap-python--pyenv-executable-find (command)
              (find-venv))))
