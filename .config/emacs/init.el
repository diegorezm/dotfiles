;; --------------------------------
;; Package bootstrap
;; --------------------------------
(require 'package)
(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))
(package-initialize)

(add-to-list 'exec-path (expand-file-name "~/go/bin/"))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(setq use-package-always-ensure t)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode t)
(setq vc-follow-symlinks t)

;; Set transparency to 80% for the current frame
(set-frame-parameter nil 'alpha-background 90)
;; Apply transparency to all future frames
(add-to-list 'default-frame-alist '(alpha-background . 80))


;; --------------------------------
;; Dashboard
;; --------------------------------
(use-package dashboard
  :init
  (setq dashboard-banner-logo-title "Welcome back, Diego"
        dashboard-startup-banner "~/.config/emacs/banner.txt"
        dashboard-center-content t
        dashboard-show-shortcuts nil
        dashboard-set-heading-icons t
        dashboard-set-file-icons t
        dashboard-items '((recents  . 5)
                          (projects . 5)))
  :config
  (dashboard-setup-startup-hook))

(defun my/dashboard-open ()
  (when (require 'dashboard nil t)
    (switch-to-buffer dashboard-buffer-name)
    (dashboard-mode)
    (dashboard-insert-startupify-lists)
    (dashboard-refresh-buffer)))

(add-hook 'server-after-make-frame-hook #'my/dashboard-open)

;; --------------------------------
;; Theme from local directory
;; --------------------------------
(add-to-list 'custom-theme-load-path
             (expand-file-name "themes/" user-emacs-directory))

(load-theme 'noctalia t)

;; --------------------------------
;; Fonts
;; --------------------------------
(defvar my/default-font "JetBrains Mono")
(defvar my/default-font-size 130) ; 13pt = 130

(defun my/apply-fonts ()
  (when (display-graphic-p)
    (set-face-attribute 'default nil
                        :family my/default-font
                        :height my/default-font-size
                        :weight 'regular)
    (set-face-attribute 'fixed-pitch nil
                        :family my/default-font
                        :height 1.0)
    (set-face-attribute 'variable-pitch nil
                        :family "Sans Serif"
                        :height 1.0)))


(setq-default line-spacing 0.2)
(add-to-list 'default-frame-alist `(font . "JetBrains Mono-14"))
(add-hook 'after-init-hook #'my/apply-fonts)
(add-hook 'server-after-make-frame-hook #'my/apply-fonts)

;; --------------------------------
;; Status bar / modeline
;; --------------------------------
(use-package nerd-icons
  :if (display-graphic-p))

(use-package doom-modeline
  :init
  (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 28)
  (doom-modeline-bar-width 4)
  (doom-modeline-buffer-file-name-style 'truncate-upto-project)
  (doom-modeline-buffer-encoding nil)
  (doom-modeline-project-detection 'project)
  (doom-modeline-vcs-max-length 20)
  (doom-modeline-minor-modes nil)
  (doom-modeline-enable-word-count nil)
  (doom-modeline-continuous-word-count-modes '(markdown-mode gfm-mode org-mode))
  (doom-modeline-icon t)
  (doom-modeline-major-mode-icon t)
  (doom-modeline-major-mode-color-icon t)
  (doom-modeline-modal-icon t)
  (doom-modeline-time nil)
  (doom-modeline-lsp t)
  (doom-modeline-github nil)
  (doom-modeline-mu4e nil)
  (doom-modeline-irc nil))

(use-package recentf
  :init
  (recentf-mode 1)
  :custom
  (recentf-max-saved-items 200)
  (recentf-auto-cleanup 'never)
  :config
  (run-at-time nil (* 5 60) #'recentf-save-list))

;; --------------------------------
;; Performance / defaults
;; --------------------------------
(setq gc-cons-threshold (* 100 1024 1024))
(setq read-process-output-max (* 1024 1024))
(setq inhibit-startup-screen t)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq create-lockfiles nil)
(setq ring-bell-function 'ignore)
(setq-default indent-tabs-mode nil)

;; lsp-mode performs better with plists in many setups
(setenv "LSP_USE_PLISTS" "true")

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)
(electric-pair-mode 1)
(save-place-mode 1)
(savehist-mode 1)

;; --------------------------------
;; Core packages
;; --------------------------------
(use-package no-littering)

(use-package which-key
  :init
  (which-key-mode 1)
  :custom
  (which-key-idle-delay 0.4))

;; --------------------------------
;; Evil + Doom-like leader keys
;; --------------------------------
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package general
  :after evil
  :config
  (general-evil-setup t)

  (general-create-definer my/leader
    :states '(normal visual motion emacs)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "C-SPC")

  (general-create-definer my/local-leader
    :states '(normal visual motion emacs)
    :keymaps 'override
    :prefix ","))

;; --------------------------------
;; Completion UI: Vertico stack
;; --------------------------------
(use-package vertico
  :init
  (vertico-mode 1)
  :custom
  (vertico-cycle t)
  :bind
  (:map vertico-map
        ("C-j" . vertico-next)
        ("C-k" . vertico-previous)
        ("C-f" . vertico-exit)
        ("C-l" . vertico-directory-enter)
        ("DEL" . vertico-directory-delete-char)
        ("M-DEL" . vertico-directory-delete-word)))

(use-package vertico-directory
  :ensure nil
  :after vertico
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

(file-name-shadow-mode 1)

(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides
        '((file (styles partial-completion)))))

(use-package marginalia
  :after vertico
  :init
  (marginalia-mode 1))

(use-package consult
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)
         ("M-y" . consult-yank-pop)
         ("M-g g" . consult-goto-line)
         ("M-s r" . consult-ripgrep)
         ("M-s f" . consult-find)))

(use-package embark
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         ("C-h B" . embark-bindings)))

(use-package embark-consult
  :after (embark consult))

;; In-buffer completion
(use-package corfu
  :init
  (global-corfu-mode 1)
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-preview-current nil))

(setq completion-cycle-threshold 3)
(setq tab-always-indent 'complete)

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))

;; --------------------------------
;; Project / Git
;; --------------------------------
(use-package projectile
  :init
  (projectile-mode 1)
  :custom
  (projectile-completion-system 'default)
  (projectile-project-search-path '("~/code/projects" "~/work/")))

(use-package magit
  :commands (magit-status magit-blame magit-log-buffer-file))

;; --------------------------------
;; Dired
;; --------------------------------
(use-package dired-open
  :config
  (setq dired-open-extensions '(("gif" . "sxiv")
                                ("jpg" . "sxiv")
                                ("png" . "sxiv")
                                ("mkv" . "mpv")
                                ("mp4" . "mpv"))))

(use-package peep-dired
  :after dired
  :hook (evil-normalize-keymaps . peep-dired-hook)
  :config
  (evil-define-key 'normal dired-mode-map (kbd "h") 'dired-up-directory)
  (evil-define-key 'normal dired-mode-map (kbd "l") 'dired-open-file) ; use dired-find-file instead if not using dired-open package
  (evil-define-key 'normal peep-dired-mode-map (kbd "j") 'peep-dired-next-file)
  (evil-define-key 'normal peep-dired-mode-map (kbd "k") 'peep-dired-prev-file)
  )

(use-package diminish :ensure t)

;; --------------------------------
;; Org Mode
;; --------------------------------

(setq org-directory "~/docs/org/")
(setq org-agenda-files
      (list (concat org-directory "tasks.org")
            (concat org-directory "notes.org")
            (concat org-directory "journal.org")))

;; Default tags available across all files (searchable via C-c a m)
(setq org-tag-alist
      '((:startgroup)
        ("@work"     . ?w)
        ("@personal" . ?p)
        ("@study"    . ?s)
        (:endgroup)
        ("idea"      . ?i)
        ("reference" . ?r)
        ("project"   . ?P)
        ("fleeting"  . ?f)))  ; ephemeral notes — review and promote or delete

;; Fast tag selection (SPC t in org buffers)
(setq org-use-fast-tag-selection t)

;; Show inherited tags in agenda
(setq org-agenda-show-inherited-tags t)

;; Properties you'll use for metadata (context, source, etc.)
;; Add :PROPERTIES: drawers like :SOURCE:, :CREATED:, :CONTEXT: manually
;; or via capture templates below

;; ---- Capture Templates ----
;; Quick entry from anywhere via SPC n c
(setq org-capture-templates
      '(("t" "Task" entry
         (file+headline (lambda () (concat org-directory "tasks.org")) "Inbox")
         "* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n"
         :empty-lines 1)

        ("n" "Note" entry
         (file+headline (lambda () (concat org-directory "notes.org")) "Inbox")
         "* %?\n:PROPERTIES:\n:CREATED: %U\n:END:\n%i\n"
         :empty-lines 1)

        ("j" "Journal" entry
         (file+datetree (lambda () (concat org-directory "journal.org")))
         "* %U %?\n%i\n"
         :empty-lines 1)

        ("l" "Link/Reference" entry
         (file+headline (lambda () (concat org-directory "notes.org")) "References")
         "* %?\n:PROPERTIES:\n:CREATED: %U\n:SOURCE: %x\n:END:\n%i\n"
         :empty-lines 1)))

;; ---- Refile ----
;; Allows promoting notes from Inbox to proper locations
(setq org-refile-targets
      '((nil :maxlevel . 3)
        (org-agenda-files :maxlevel . 3)))
(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)  ; works nicely with vertico/consult

(add-hook 'org-mode-hook 'org-indent-mode)

(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

(eval-after-load 'org-indent '(diminish 'org-indent-mode))

(require 'org-tempo)

(use-package toc-org
  :commands toc-org-enable
  :init (add-hook 'org-mode-hook 'toc-org-enable))

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (concat org-directory "notes/"))
  (org-roam-capture-templates
   '(("d" "default" plain "%?"
      :target (file+head "${slug}.org"
                         "#+TITLE: ${title}\n#+DATE: %U\n#+FILETAGS: :\n\n")
      :unnarrowed t
      :kill-buffer t)))  ; clean up buffer on abort
  :config
  (org-roam-db-autosync-mode)
  ;; Remove the header-line banner from roam capture buffers
  (add-hook 'org-roam-capture-new-node-hook
            (lambda () (setq-local header-line-format nil))))

(add-hook 'org-mode-hook
          (lambda ()
            (when (org-roam-buffer-p)
              (setq-local header-line-format nil))))

(use-package consult-org-roam
  :ensure t
  :after org-roam
  :config
  (consult-org-roam-mode 1))

(use-package evil-org
  :ensure t
  :after org
  :hook (org-mode . evil-org-mode)
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(setq org-list-indent-offset 2)          ; more visible sub-list indentation
(setq org-return-follows-link t)         ; RET follows links (nice to have)
(setq electric-indent-mode nil)          ; prevents unwanted auto-indent on RET
(setq org-roam-node-display-template
      (concat "${title:*} " (propertize "${tags:20}" 'face 'org-tag)))

(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

(use-package org-view-mode
  :ensure t
  :after org
  :config
  ;; Optional: use a variable-pitch font for a nicer reading experience
  (setq org-view-font-enable t))

(defun my/org-roam-node-has-tag (node tag)
  "Filter function to check if the given NODE has the specified TAG."
  (member tag (org-roam-node-tags node)))

(defun my/org-roam-node-find-by-tag ()
  "Find and open an Org-roam node based on a specified tag."
  (interactive)
  (let ((tag (read-string "Enter tag: ")))
    (org-roam-node-find nil nil (lambda (node) (my/org-roam-node-has-tag node tag)))))

;; --------------------------------
;; Spell Check
;; --------------------------------
(use-package flyspell
  :ensure nil  ; built-in
  :hook (org-mode . flyspell-mode)
  :config
  (setq ispell-program-name "aspell")
  (setq ispell-dictionary "pt_BR")
  (setq ispell-extra-args '("--sug-mode=ultra" "--lang=pt_BR")))

(use-package guess-language
  :ensure t
  :hook (org-mode . guess-language-mode)
  :config
  (setq guess-language-languages '(pt en))
  (setq guess-language-min-paragraph-length 35)
  ;; Map detected language to aspell dictionary names
  (setq guess-language-langcodes
        '((en . ("en_US" "English"))
          (pt . ("pt_BR" "Portuguese")))))

;; --------------------------------
;; PDFs
;; --------------------------------
(use-package pdf-tools
  :defer t
  :commands (pdf-loader-install)
  :mode "\\.pdf\\'"
  :bind (:map pdf-view-mode-map
              ("j" . pdf-view-next-line-or-next-page)
              ("k" . pdf-view-previous-line-or-previous-page)
              ("C-=" . pdf-view-enlarge)
              ("C--" . pdf-view-shrink))
  :init (pdf-loader-install)
  :config (add-to-list 'revert-without-query ".pdf"))

(add-hook 'pdf-view-mode-hook #'(lambda () (interactive) (display-line-numbers-mode -1)
                                  (blink-cursor-mode -1)
                                  (doom-modeline-mode -1)))


;; --------------------------------
;; Tree-sitter
;; --------------------------------
(setq treesit-language-source-alist
      '((bash       . ("https://github.com/tree-sitter/tree-sitter-bash"))
        (css        . ("https://github.com/tree-sitter/tree-sitter-css"))
        (go         . ("https://github.com/tree-sitter/tree-sitter-go"))
        (gomod      . ("https://github.com/camdencheek/tree-sitter-go-mod"))
        (html       . ("https://github.com/tree-sitter/tree-sitter-html"))
        (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript" "master" "src"))
        (json       . ("https://github.com/tree-sitter/tree-sitter-json"))
        (elixir       . ("https://github.com/elixir-lang/tree-sitter-elixir"))
        (heex       . ("https://github.com/phoenixframework/tree-sitter-heex"))
        (tsx        . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src"))
        (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src"))))

(defun my/install-treesit-grammars ()
  (interactive)
  (dolist (lang '(bash css go gomod html javascript json elixir heex tsx typescript))
    (unless (treesit-language-available-p lang)
      (treesit-install-language-grammar lang))))

(setq major-mode-remap-alist
      '((javascript-mode . js-ts-mode)
        (js-mode         . js-ts-mode)
        ;; (elixir-mode         . elixir-ts-mode)
        ;; (typescript-mode . typescript-ts-mode)
        (css-mode        . css-ts-mode)
        (html-mode       . html-ts-mode)
        (json-mode       . json-ts-mode)))

;; (add-to-list 'auto-mode-alist '("\\.ts\\'"  . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'"  . js-ts-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . tsx-ts-mode))
(add-to-list 'auto-mode-alist '("\\.json\\'" . json-ts-mode))
(add-to-list 'auto-mode-alist '("\\.jsonc\\'" . json-ts-mode))
(add-to-list 'auto-mode-alist '("\\.ex\\'" . elixir-mode))
(add-to-list 'auto-mode-alist '("\\.heex\\'" . heex-ts-mode))

;; --------------------------------
;; Syntax checking / formatting
;; --------------------------------
(use-package flycheck
  :ensure t
  :defer t
  :diminish
  :init (global-flycheck-mode))


(use-package apheleia
  :config
  (setf (alist-get 'biome apheleia-formatters)
        '("biome" "format" "--stdin-file-path" filepath))

  (setf (alist-get 'typescript-ts-mode apheleia-mode-alist) 'biome)
  (setf (alist-get 'tsx-ts-mode apheleia-mode-alist) 'biome)
  (setf (alist-get 'js-ts-mode apheleia-mode-alist) 'biome)
  (setf (alist-get 'json-ts-mode apheleia-mode-alist) 'biome)
  (setf (alist-get 'css-ts-mode apheleia-mode-alist) 'biome)

  (setf (alist-get 'typescript-mode apheleia-mode-alist) 'biome)
  (setf (alist-get 'js-mode apheleia-mode-alist) 'biome)
  (setf (alist-get 'web-mode apheleia-mode-alist) 'biome)
  (setf (alist-get 'css-mode apheleia-mode-alist) 'biome)
  (setf (alist-get 'json-mode apheleia-mode-alist) 'biome)

  (apheleia-global-mode +1))

;; --------------------------------
;; LSP
;; --------------------------------
(defun my/eglot-capf ()
  (setq-local completion-at-point-functions
              (list (cape-capf-buster
                     (cape-capf-super
                      #'eglot-completion-at-point
                      #'cape-file
                      #'cape-dabbrev)))))

(use-package eglot
  :ensure nil
  :hook ((typescript-ts-mode . eglot-ensure)
         (tsx-ts-mode        . eglot-ensure)
         (js-ts-mode         . eglot-ensure)
         (css-ts-mode        . eglot-ensure)
         (html-mode          . eglot-ensure)
         (go-mode            . eglot-ensure)
         (go-ts-mode         . eglot-ensure)
         (elixir-mode        . eglot-ensure)
         (heex-ts-mode       . eglot-ensure)
         (eglot-managed-mode . my/eglot-capf))
  :custom
  (eglot-autoshutdown t)
  (eglot-send-changes-idle-time 0.3)
  (eglot-ignored-server-capabilities '(:documentHighlightProvider))
  (eglot-workspace-configuration
   '((:gopls . ((staticcheck         . t)
                (matcher             . "CaseSensitive")
                (completeUnimported  . t)
                (usePlaceholders     . t)
                (analyses . ((unusedparams . t)
                             (shadow       . t)
                             (nilness      . t)))))))
  :config
  (add-to-list 'eglot-server-programs
               '((typescript-ts-mode tsx-ts-mode js-ts-mode)
                 . ("typescript-language-server" "--stdio"))))

(use-package eldoc-box
  :after eglot
  :hook (eglot-managed-mode . eldoc-box-hover-mode))

(with-eval-after-load 'eglot
  (evil-define-key 'normal eglot-mode-map
    (kbd "K") #'eldoc-box-help-at-point))

;; --------------------------------
;; Language-specific helpers
;; --------------------------------
(use-package go-mode
  :hook (before-save . gofmt-before-save))

(use-package typescript-mode
  :mode "\\.ts\\'")

(use-package heex-ts-mode
  :mode "\\.heex\\'")

(use-package elixir-mode
  :mode ("\\.ex\\'"
         "\\.exs\\'"
         "\\.sface\\'"))

(use-package web-mode
  :mode "\\.html?\\'")  

;; Prefer tree-sitter modes when available
(add-hook 'tsx-ts-mode-hook
          (lambda ()
            (setq-local tab-width 2)))
(add-hook 'typescript-ts-mode-hook
          (lambda ()
            (setq-local tab-width 2)))
(add-hook 'js-ts-mode-hook
          (lambda ()
            (setq-local tab-width 2)))
(add-hook 'css-ts-mode-hook
          (lambda ()
            (setq-local tab-width 2)))
(add-hook 'html-ts-mode-hook
          (lambda ()
            (setq-local tab-width 2)))
(add-hook 'go-ts-mode-hook
          (lambda ()
            (setq-local tab-width 4)))

;; --------------------------------
;; Buffers
;; --------------------------------
(use-package ibuffer
  :ensure nil
  :bind ("C-x C-b" . ibuffer)
  :config
  (setq ibuffer-expert t
        ibuffer-show-empty-filter-groups nil
        ibuffer-display-summary nil)

  (setq ibuffer-saved-filter-groups
        '(("default"
           ("dired"    (mode . dired-mode))
           ("org"      (or (mode . org-mode)
                           (name . "^\\*Org")))
           ("magit"    (or (name . "^\\*magit")
                           (mode . magit-mode)))
           ("emacs"    (or (name . "^\\*scratch\\*$")
                           (name . "^\\*Messages\\*$")))
           ("help"     (or (name . "^\\*Help\\*$")
                           (name . "^\\*info\\*$")
                           (name . "^\\*Warnings\\*$")))
           ("code"     (or (mode . go-mode)
                           (mode . go-ts-mode)
                           (mode . typescript-ts-mode)
                           (mode . tsx-ts-mode)
                           (mode . js-ts-mode)))
           ("web"      (or (mode . html-ts-mode)
                           (mode . css-ts-mode)
                           (mode . web-mode))))))

  (add-hook 'ibuffer-mode-hook
            (lambda ()
              (ibuffer-switch-to-saved-filter-groups "default")
              (hl-line-mode 1))))

(with-eval-after-load 'ibuffer
  (evil-define-key 'normal ibuffer-mode-map
    (kbd "j") #'ibuffer-forward-line
    (kbd "k") #'ibuffer-backward-line
    (kbd "gr") #'ibuffer-update
    (kbd "m") #'ibuffer-mark-forward
    (kbd "u") #'ibuffer-unmark-forward
    (kbd "x") #'ibuffer-do-kill-on-deletion-marks
    (kbd "D") #'ibuffer-mark-for-delete
    (kbd "s") #'ibuffer-do-save
    (kbd "/") #'ibuffer-filter-by-name
    (kbd "f c") #'ibuffer-filter-by-content
    (kbd "f d") #'ibuffer-filter-by-directory
    (kbd "f f") #'ibuffer-filter-by-filename
    (kbd "f m") #'ibuffer-filter-by-mode
    (kbd "f n") #'ibuffer-filter-by-name
    (kbd "f x") #'ibuffer-filter-disable
    (kbd "g h") #'ibuffer-do-kill-lines
    (kbd "g H") #'ibuffer-update))

;; --------------------------------
;; AI
;; --------------------------------
(use-package gptel
  :ensure t
  :commands (gptel gptel-send gptel-menu)
  :config
  (setq gptel-default-mode 'org-mode)

  ;; Backends
  (setq my/gptel-ollama-backend
        (gptel-make-ollama "Ollama"
          :host "localhost:11434"
          :stream t
          :models '(qwen3.5:2b)))

  ;; OpenRouter uses an OpenAI-compatible API shape
  (setq my/gptel-openrouter-backend
        (gptel-make-openai "OpenRouter"
          :host "openrouter.ai"
          :endpoint "/api/v1/chat/completions"
          :stream t
          :key (getenv "OPENROUTER_API_KEY")
          :models '(openai/gpt-4o-mini
                    google/gemini-2.0-flash-exp
                    meta-llama/llama-3.1-70b-instruct)))

  ;; Default backend/model
  (setq gptel-backend my/gptel-openrouter-backend
        gptel-model 'openai/gpt-4o-mini)

  ;; Named presets
  (setq my/gptel-presets
        `((ollama . ((backend . ,my/gptel-ollama-backend)
                     (model . qwen2.5-coder:latest)))
          (openrouter . ((backend . ,my/gptel-openrouter-backend)
                         (model . openai/gpt-4o-mini)))))

  (defun my/gptel-use-backend (name)
    "Switch gptel backend preset by NAME."
    (interactive
     (list
      (intern
       (completing-read
        "Backend: "
        (mapcar (lambda (x) (symbol-name (car x))) my/gptel-presets)
        nil t))))
    (let* ((preset (alist-get name my/gptel-presets))
           (backend (alist-get 'backend preset))
           (model (alist-get 'model preset)))
      (setq gptel-backend backend
            gptel-model model)
      (message "gptel backend: %s | model: %s" name model)))

  (defun my/gptel-use-ollama ()
    (interactive)
    (my/gptel-use-backend 'ollama))

  (defun my/gptel-use-openrouter ()
    (interactive)
    (my/gptel-use-backend 'openrouter)))

;; --------------------------------
;; Terminals & Shells
;; --------------------------------
(use-package vterm
  :commands vterm
  :config
  (setq vterm-shell "/bin/zsh"
        vterm-max-scrollback 10000))

(add-hook 'vterm-mode-hook (lambda () (display-line-numbers-mode -1)))

(use-package multi-vterm
  :after vterm
  :commands (multi-vterm multi-vterm-next multi-vterm-prev multi-vterm-project)
  :config
  (setq multi-vterm-buffer-name "vterm"))

(defun my/project-vterm ()
  (interactive)
  (let* ((project (project-current nil))
         (default-directory
          (if project
              (car (project-roots project))
            default-directory)))
    (vterm)))

;; --------------------------------
;; Leader keys
;; --------------------------------
(defun my/reload-init-file ()
  (interactive)
  (load-file user-init-file)
  (message "Reloaded init.el"))

(my/leader
  ;; top-level quick actions
  "."   '(find-file :which-key "find file")
  ","   '(consult-buffer :which-key "switch buffer")
  "/"   '(consult-ripgrep :which-key "ripgrep")
  ":"   '(execute-extended-command :which-key "M-x")
  "SPC" '(projectile-find-file :which-key "project file")

  ;; buffers
  "b"   '(:ignore t :which-key "buffer")
  "bb" '(consult-buffer :which-key "switch buffer")
  "bi" '(ibuffer :which-key "ibuffer")
  "bk" '(kill-current-buffer :which-key "kill current")
  "bn" '(next-buffer :which-key "next buffer")
  "bp" '(previous-buffer :which-key "previous buffer")

  ;; files
  "f"   '(:ignore t :which-key "files")
  "ff"  '(find-file :which-key "find file")
  "fr"  '(consult-recent-file :which-key "recent files")
  "fs"  '(save-buffer :which-key "save file")

  ;; project
  "p"   '(:ignore t :which-key "project")
  "pf"  '(projectile-find-file :which-key "find file")
  "pp"  '(projectile-switch-project :which-key "switch project")
  "ps"  '(consult-ripgrep :which-key "search project")
  "pb"  '(projectile-switch-to-buffer :which-key "project buffer")

  ;; git
  "g"   '(:ignore t :which-key "git")
  "gg"   '(magit t :which-key "git")
  "gs"  '(magit-status :which-key "status")
  "gb"  '(magit-blame :which-key "blame")
  "gl"  '(magit-log-buffer-file :which-key "log file")

  ;; search
  "s"   '(:ignore t :which-key "search")
  "ss"  '(consult-line :which-key "search line")
  "sg"  '(consult-ripgrep :which-key "ripgrep")
  "sf"  '(consult-find :which-key "find in dir")

  ;; code / lsp
  "l"   '(:ignore t :which-key "lsp")
  "la"  '(eglot-code-actions :which-key "code action")
  "ld"  '(xref-find-definitions :which-key "definition")
  "lD"  '(xref-find-definitions :which-key "declaration")     
  "li"  '(eglot-find-implementation :which-key "implementation")
  "lr"  '(xref-find-references :which-key "references")
  "lt"  '(eglot-find-typeDefinition :which-key "type definition")
  "lR"  '(eglot-rename :which-key "rename")
  "lf"  '(eglot-format-buffer :which-key "format buffer")
  "lh"  '(eldoc-box-help-at-point :which-key "describe")
  "le"  '(flymake-show-buffer-diagnostics :which-key "list errors")
  "ln"  '(flymake-goto-next-error :which-key "next error")
  "lp"  '(flymake-goto-prev-error :which-key "previous error")

  ;; org
  "n"   '(:ignore t :which-key "notes")
  "nf"  '(org-roam-node-find :which-key "find/create note")
  "ni"  '(org-roam-node-insert :which-key "insert link")
  "nc"  '(org-capture :which-key "capture")
  "na"  '(org-agenda :which-key "agenda")
  "nt"  '(org-roam-tag-add :which-key "add tag")
  "nr"  '(org-refile :which-key "refile")
  "nb"  '(org-roam-buffer-toggle :which-key "backlinks")
  "nj"  '(my/open-journal :which-key "open journal")
  "ns"  '(consult-org-roam-search :which-key "search notes")

  ;; terminals & shells
  "'"  '(multi-vterm :which-key "new vterm")
  "o"  '(:ignore t :which-key "open")
  "ot" '(my/project-vterm :which-key "project terminal")
  "on" '(multi-vterm-next :which-key "next terminal")
  "op" '(multi-vterm-prev :which-key "previous terminal")
  
  ;; Config
  "hr" '(my/reload-init-file :which-key "Reload config "))

(my/local-leader
  :keymaps 'go-ts-mode-map
  "f" '(gofmt :which-key "gofmt"))

(my/local-leader
  :keymaps 'org-mode-map
  ;; Spell
  "Sb"  '(flyspell-buffer :which-key "check buffer")
  "Ss"  '(consult-flyspell :which-key "list all errors")  ; browse all errors in minibuffer
  "Sn"  '(flyspell-goto-next-error :which-key "next error")
  "Sl"  '(ispell-change-dictionary :which-key "change language")
  "v"   '(org-view-mode :which-key "view/read mode"))

;; --------------------------------
;; Useful extra built-ins
;; --------------------------------
(fset 'yes-or-no-p 'y-or-n-p)

(provide 'init)
;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("3fec76abc5ade433345791d7a5b062e47ac2c6fa0fffcb795a6fb3f404b7bc51"
     default))
 '(package-selected-packages
   '(ace-window apheleia cape cfrs consult-flyspell corfu dashboard
                dired-open doom-modeline eldoc-box elixir-mode
                embark-consult evil-collection evil-org flycheck
                flyspell-correct general go-mode guess-language hydra
                lsp-treemacs lsp-ui magit marginalia no-littering
                orderless org-bullets org-roam org-superstar
                org-view-mode peep-dired pfuture projectile
                shell-maker toc-org typescript-mode vertico vterm
                web-mode)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(dashboard-banner-logo-title ((t (:inherit default :background unspecified))))
 '(dashboard-heading ((t (:inherit default :background unspecified))))
 '(dashboard-items-face ((t (:inherit default :background unspecified))))
 '(dashboard-text-banner ((t (:inherit default :background unspecified))))
 '(org-level-1 ((t (:inherit outline-1 :height 1.7))))
 '(org-level-2 ((t (:inherit outline-2 :height 1.6))))
 '(org-level-3 ((t (:inherit outline-3 :height 1.5))))
 '(org-level-4 ((t (:inherit outline-4 :height 1.4))))
 '(org-level-5 ((t (:inherit outline-5 :height 1.3))))
 '(org-level-6 ((t (:inherit outline-5 :height 1.2))))
 '(org-level-7 ((t (:inherit outline-5 :height 1.1)))))
