;;; init.el --- User Configuration -*- lexical-binding: t; -*-

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file 'noerror))
(setq create-lockfiles nil)

;; -----------------------------------------------------------------------------
;; 1. Package Manager Setup
;; -----------------------------------------------------------------------------
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu"   . "https://elpa.gnu.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(setq use-package-always-ensure t)

;; -----------------------------------------------------------------------------
;; 2. Font Setup: Iosevka Nerd Font
;; -----------------------------------------------------------------------------
(defun my/set-font (frame)
  "Apply font settings to a specific frame."
  (with-selected-frame frame
    (when (display-graphic-p frame)
      (if (find-font (font-spec :name "Iosevka Nerd Font"))
          (set-face-attribute 'default frame :font "Iosevka Nerd Font" :height 140)
        (set-face-attribute 'default frame :family "monospace" :height 140)))))

(add-hook 'after-make-frame-functions #'my/set-font)

(when (display-graphic-p)
  (my/set-font (selected-frame)))

(add-to-list 'warning-suppress-types '(face))

;; -----------------------------------------------------------------------------
;; 3. Theme: Gruber Darker
;; -----------------------------------------------------------------------------
(use-package gruber-darker-theme
  :config
  (defun my/load-theme (frame)
    (with-selected-frame frame
      (load-theme 'gruber-darker t)))

  (if (daemonp)
      (add-hook 'after-make-frame-functions #'my/load-theme)
    (load-theme 'gruber-darker t)))

;; -----------------------------------------------------------------------------
;; 4. Sensible Defaults
;; -----------------------------------------------------------------------------
(setq inhibit-startup-message t)
(setq ring-bell-function 'ignore)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(setq select-enable-clipboard t)
(setq select-enable-primary t)

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode t)

(global-hl-line-mode t)
(show-paren-mode t)

;; -----------------------------------------------------------------------------
;; 5. Modal Editing: Evil Mode
;; -----------------------------------------------------------------------------
(use-package undo-tree
  :init
  (global-undo-tree-mode)
  :config
  (setq undo-tree-auto-save-history nil))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-undo-system 'undo-tree)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; -----------------------------------------------------------------------------
;; 6. Completion UI: Vertico + Orderless + Marginalia + Consult
;; -----------------------------------------------------------------------------
(use-package vertico
  :init
  (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :init
  (marginalia-mode))

(use-package consult
  :bind (("C-s"   . consult-line)
         ("C-x b" . consult-buffer)))

;; -----------------------------------------------------------------------------
;; 7. File Explorer (Dired)
;; -----------------------------------------------------------------------------
(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :custom
  (dired-listing-switches "-lahv --group-directories-first")
  (dired-dwim-target t)
  (dired-recursive-copies 'always)
  (dired-recursive-deletes 'always)
  :config
  (put 'dired-find-alternate-file 'disabled nil))

;; -----------------------------------------------------------------------------
;; 8. In-Buffer Completion (Corfu + Cape)
;; -----------------------------------------------------------------------------
(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 2)
  (corfu-cycle t)
  :init
  (global-corfu-mode))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))

;; -----------------------------------------------------------------------------
;; 9. Built-in LSP Client (Eglot)
;; -----------------------------------------------------------------------------
(use-package eglot
  :ensure nil
  :hook
  ((python-mode       . eglot-ensure)
   (python-ts-mode    . eglot-ensure)
   (rust-mode         . eglot-ensure)
   (c-mode            . eglot-ensure)
   (c++-mode          . eglot-ensure)
   (js-mode           . eglot-ensure)
   (typescript-mode   . eglot-ensure)
   (go-mode           . eglot-ensure))
  :custom
  (eglot-autoshutdown t)
  (eglot-sync-connect nil)
  :config
  (evil-define-key 'normal eglot-mode-map
    (kbd "gd") #'xref-find-definitions
    (kbd "gr") #'xref-find-references
    (kbd "gi") #'eglot-find-implementation
    (kbd "K")  #'eldoc))

;; -----------------------------------------------------------------------------
;; 10.1 Compilação e Execução
;; -----------------------------------------------------------------------------
(defun my/run-pygame-project ()
  "Run the project using the virtual environment without sourcing."
  (interactive)
  (let* ((proj (project-current))
         (root (if proj (project-root proj) default-directory))
         (venv-py (expand-file-name ".venv/bin/python" root))
         (py-bin (if (file-executable-p venv-py) venv-py "python3"))
         (target-file (buffer-file-name)))
    (compile (format "%s %s" py-bin (shell-quote-argument target-file)))))

;; Forçar o buffer de compilação a abrir sempre num split horizontal inferior
(add-to-list 'display-buffer-alist
             '("\\*compilation\\*"
               (display-buffer-reuse-window display-buffer-at-bottom)
               (window-height . 0.35)         ; Ocupa 35% da altura do ecrã
               (inhibit-same-window . t)))

;; -----------------------------------------------------------------------------
;; 10.2 Terminal
;; -----------------------------------------------------------------------------
(defun my/split-terminal ()
  "Equivalente a: belowright split | terminal"
  (interactive)
  (let* ((proj (project-current))
         (dir (if proj (project-root proj) default-directory)))
    (select-window (split-window-below -15))
    (let ((default-directory dir))
      (term (getenv "SHELL")))))

(defun my/full-terminal ()
  "Equivalente a: :terminal (na mesma janela)"
  (interactive)
  (let* ((proj (project-current))
         (dir (if proj (project-root proj) default-directory)))
    (let ((default-directory dir))
      (term (getenv "SHELL")))))

;; -----------------------------------------------------------------------------
;; 11. Keybinding Infrastructure (which-key + general.el)
;; -----------------------------------------------------------------------------
(use-package which-key
  :init
  (which-key-mode)
  :config
  (setq which-key-idle-delay 0.3)
  (setq which-key-popup-type 'side-window))

(use-package general
  :config
  (general-evil-setup t)

  (general-create-definer my/leader-keys
    :states '(normal visual motion emacs)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "C-SPC")

  (my/leader-keys
    ;; Ações rápidas de topo
    "SPC" '(consult-line :which-key "search in buffer")
    ":"   '(execute-extended-command :which-key "M-x")
    "/"   '(consult-ripgrep :which-key "ripgrep project")

    ;; File Explorer
    "e"   '(dired-jump :which-key "open file manager")
    "E"   '(dired :which-key "open dired at path")

    ;; Execução
    "r"   '(my/run-pygame-project :which-key "run pygame file")
    "R"   '(recompile :which-key "rerun")

    ;; Terminal (Neovim equivalent)
    "tt" '(my/split-terminal :which-key "split terminal")
    "ft" '(my/full-terminal  :which-key "full terminal")

    ;; Código / LSP (<SPC> v)
    "v"   '(:ignore t :which-key "code")
    "va"  '(eglot-code-actions :which-key "code action")
    "vrn"  '(eglot-rename :which-key "rename symbol")
    "vf"  '(eglot-format :which-key "format buffer")
    "vd"  '(consult-flymake :which-key "diagnostics list")
    "ve"  '(flymake-show-buffer-diagnostics :which-key "buffer diagnostics")

    ;; Ficheiros (<SPC> f)
    "f"   '(:ignore t :which-key "files")
    "ff"  '(find-file :which-key "find file")
    "fs"  '(save-buffer :which-key "save buffer")
    "fr"  '(consult-recent-file :which-key "recent files")
    "fp"  '((lambda () (interactive) (find-file user-init-file)) :which-key "open init.el")

    ;; Buffers (<SPC> b)
    "b"   '(:ignore t :which-key "buffers")
    "bb"  '(consult-buffer :which-key "switch buffer")
    "bk"  '(kill-current-buffer :which-key "kill buffer")
    "bd"  '(kill-current-buffer :which-key "delete buffer")
    "bn"  '(next-buffer :which-key "next buffer")
    "bp"  '(previous-buffer :which-key "prev buffer")

    ;; Janelas (<SPC> w)
    "w"   '(:ignore t :which-key "windows")
    "wv"  '(split-window-right :which-key "split vertical")
    "ws"  '(split-window-below :which-key "split horizontal")
    "wd"  '(delete-window :which-key "delete window")
    "wo"  '(delete-other-windows :which-key "maximize window")
    "wh"  '(evil-window-left :which-key "focus left")
    "wj"  '(evil-window-down :which-key "focus down")
    "wk"  '(evil-window-up :which-key "focus up")
    "wl"  '(evil-window-right :which-key "focus right")

    ;; Sair (<SPC> q)
    "q"   '(:ignore t :which-key "quit")
    "qq"  '(save-buffers-kill-terminal :which-key "close client frame")
    "qQ"  '(kill-emacs :which-key "kill emacs daemon")))

;; Reposição do Garbage Collector no final do arranque
(setq gc-cons-threshold (* 2 1000 1000))

(provide 'init)
;;; init.el ends here
