;;; vague-theme.el --- Vague theme -*- lexical-binding: t; -*-

;; Author: Perplexity
;; Version: 0.1.0
;; Package-Requires: ((emacs "24.3"))
;; Keywords: faces, theme
;; URL: https://example.invalid/vague-theme

;;; Commentary:
;; A muted dark Emacs theme based on the provided Vague palette.

;;; Code:

(deftheme vague
  "A muted dark theme built from the Vague palette.")

(let* ((class '((class color) (min-colors 89)))
       (bg        "#141415")
       (bg-alt    "#1c1c24")
       (bg-alt-2  "#252530")
       (bg-alt-3  "#333738")
       (fg        "#cdcdcd")
       (fg-muted  "#c3c3d5")
       (fg-dim    "#878787")
       (comment   "#606079")
       (cursor    "#f3be7c")
       (accent    "#7e98e8")
       (accent-2  "#6e94b2")
       (accent-3  "#aeaed1")
       (cyan      "#b4d4cf")
       (teal      "#9bb4bc")
       (green     "#7fa563")
       (yellow    "#f3be7c")
       (amber     "#e8b589")
       (orange    "#e0a363")
       (red       "#d8647e")
       (peach     "#c48282")
       (magenta   "#bb9dbd")
       (lavender  "#90a0b5")
       (storm     "#405065")
       (diff-add  "#293125")
       (diff-chg  "#41362a")
       (diff-del  "#3b242a")
       (diff-text "#6D583E")
       (line      "#252530")
       (line-alt  "#1c1c24")
       (selection "#333738")
       (search    "#41362a")
       (search-lazy "#405065")
       (err-bg    "#3b242a")
       (warn-bg   "#41362a")
       (ok-bg     "#293125"))
  (custom-theme-set-faces
   'vague

   ;; Core UI
   `(default ((,class (:background ,bg :foreground ,fg))))
   `(cursor ((,class (:background ,cursor))))
   `(region ((,class (:background ,selection))))
   `(highlight ((,class (:background ,bg-alt-2))))
   `(shadow ((,class (:foreground ,comment))))
   `(minibuffer-prompt ((,class (:foreground ,accent :weight bold))))
   `(link ((,class (:foreground ,accent :underline t))))
   `(link-visited ((,class (:foreground ,magenta :underline t))))
   `(button ((,class (:foreground ,accent :underline t))))
   `(fringe ((,class (:background ,bg :foreground ,comment))))
   `(vertical-border ((,class (:foreground ,line))))
   `(window-divider ((,class (:foreground ,line))))
   `(header-line ((,class (:background ,bg-alt :foreground ,fg-muted :box nil))))
   `(mode-line ((,class (:background ,bg-alt-2 :foreground ,fg :box (:line-width 1 :color ,line)))))
   `(mode-line-inactive ((,class (:background ,bg-alt :foreground ,fg-dim :box (:line-width 1 :color ,line-alt)))))
   `(success ((,class (:foreground ,green :weight bold))))
   `(warning ((,class (:foreground ,yellow :weight bold))))
   `(error ((,class (:foreground ,red :weight bold))))
   `(trailing-whitespace ((,class (:background ,red))))
   `(escape-glyph ((,class (:foreground ,orange))))
   `(homoglyph ((,class (:foreground ,orange))))

   ;; Font lock
   `(font-lock-builtin-face ((,class (:foreground ,magenta))))
   `(font-lock-comment-face ((,class (:foreground ,comment :slant italic))))
   `(font-lock-comment-delimiter-face ((,class (:foreground ,comment :slant italic))))
   `(font-lock-constant-face ((,class (:foreground ,amber))))
   `(font-lock-doc-face ((,class (:foreground ,lavender))))
   `(font-lock-function-name-face ((,class (:foreground ,accent))))
   `(font-lock-keyword-face ((,class (:foreground ,red :weight semi-bold))))
   `(font-lock-negation-char-face ((,class (:foreground ,red))))
   `(font-lock-preprocessor-face ((,class (:foreground ,magenta))))
   `(font-lock-regexp-grouping-backslash ((,class (:foreground ,yellow))))
   `(font-lock-regexp-grouping-construct ((,class (:foreground ,orange))))
   `(font-lock-string-face ((,class (:foreground ,green))))
   `(font-lock-type-face ((,class (:foreground ,cyan))))
   `(font-lock-variable-name-face ((,class (:foreground ,teal))))
   `(font-lock-warning-face ((,class (:foreground ,yellow :weight bold))))

   ;; Search / isearch
   `(isearch ((,class (:background ,search :foreground ,yellow :weight bold))))
   `(lazy-highlight ((,class (:background ,search-lazy :foreground ,fg))))
   `(match ((,class (:background ,bg-alt-3 :foreground ,cyan :weight bold))))

   ;; Line numbers
   `(line-number ((,class (:background ,bg :foreground ,comment))))
   `(line-number-current-line ((,class (:background ,bg :foreground ,fg-muted))))

   ;; Parens
   `(show-paren-match ((,class (:background ,storm :foreground ,fg :weight bold))))
   `(show-paren-mismatch ((,class (:background ,red :foreground ,bg :weight bold))))

   ;; Whitespace / hl-line
   `(hl-line ((,class (:background ,bg-alt))))
   `(whitespace-space ((,class (:background ,bg :foreground ,bg-alt-3))))
   `(whitespace-tab ((,class (:background ,bg :foreground ,bg-alt-3))))
   `(whitespace-trailing ((,class (:background ,red :foreground ,bg))))

   ;; Compilation / diagnostics
   `(compilation-info ((,class (:foreground ,accent))))
   `(compilation-warning ((,class (:foreground ,yellow))))
   `(compilation-error ((,class (:foreground ,red))))
   `(compilation-mode-line-exit ((,class (:foreground ,green))))
   `(compilation-mode-line-fail ((,class (:foreground ,red))))

   ;; Diff / VC / Magit basics
   `(diff-added ((,class (:background ,diff-add :foreground ,green))))
   `(diff-removed ((,class (:background ,diff-del :foreground ,red))))
   `(diff-changed ((,class (:background ,diff-chg :foreground ,yellow))))
   `(diff-refine-added ((,class (:background ,ok-bg :foreground ,green :weight bold))))
   `(diff-refine-removed ((,class (:background ,err-bg :foreground ,red :weight bold))))
   `(diff-refine-changed ((,class (:background ,diff-text :foreground ,fg :weight bold))))
   `(diff-header ((,class (:background ,bg-alt :foreground ,fg-muted))))
   `(diff-file-header ((,class (:background ,bg-alt-2 :foreground ,accent :weight bold))))
   `(vc-conflict-state ((,class (:foreground ,yellow))))
   `(vc-edited-state ((,class (:foreground ,orange))))
   `(vc-locally-added-state ((,class (:foreground ,green))))
   `(vc-removed-state ((,class (:foreground ,red))))
   `(vc-up-to-date-state ((,class (:foreground ,cyan))))

   ;; Org
   `(org-document-title ((,class (:foreground ,fg :weight bold :height 1.3))))
   `(org-document-info ((,class (:foreground ,fg-muted))))
   `(org-level-1 ((,class (:foreground ,accent :weight bold :height 1.2))))
   `(org-level-2 ((,class (:foreground ,cyan :weight bold :height 1.1))))
   `(org-level-3 ((,class (:foreground ,magenta :weight bold))))
   `(org-level-4 ((,class (:foreground ,yellow :weight bold))))
   `(org-code ((,class (:foreground ,green))))
   `(org-verbatim ((,class (:foreground ,amber))))
   `(org-block ((,class (:background ,bg-alt :foreground ,fg))))
   `(org-block-begin-line ((,class (:background ,bg-alt-2 :foreground ,comment))))
   `(org-block-end-line ((,class (:background ,bg-alt-2 :foreground ,comment))))
   `(org-quote ((,class (:background ,bg-alt :slant italic))))
   `(org-todo ((,class (:foreground ,red :weight bold))))
   `(org-done ((,class (:foreground ,green :weight bold))))
   `(org-headline-done ((,class (:foreground ,comment))))
   `(org-date ((,class (:foreground ,teal :underline t))))
   `(org-special-keyword ((,class (:foreground ,comment))))

   ;; Completion / company / ivy-ish
   `(completions-common-part ((,class (:foreground ,accent :weight bold))))
   `(completions-first-difference ((,class (:foreground ,yellow :weight bold))))
   `(tooltip ((,class (:background ,bg-alt-2 :foreground ,fg))))
   `(company-tooltip ((,class (:background ,bg-alt-2 :foreground ,fg))))
   `(company-tooltip-selection ((,class (:background ,bg-alt-3 :foreground ,fg))))
   `(company-tooltip-common ((,class (:foreground ,accent :weight bold))))
   `(company-scrollbar-bg ((,class (:background ,bg-alt))))
   `(company-scrollbar-fg ((,class (:background ,bg-alt-3))))
   `(company-preview ((,class (:background ,bg-alt :foreground ,accent))))
   `(company-preview-common ((,class (:foreground ,accent :weight bold))))
   `(ivy-current-match ((,class (:background ,bg-alt-3 :foreground ,accent :weight bold))))
   `(ivy-minibuffer-match-face-1 ((,class (:foreground ,fg))))
   `(ivy-minibuffer-match-face-2 ((,class (:foreground ,accent :weight bold))))
   `(ivy-minibuffer-match-face-3 ((,class (:foreground ,cyan :weight bold))))
   `(ivy-minibuffer-match-face-4 ((,class (:foreground ,magenta :weight bold))))

   ;; Flycheck / Flymake
   `(flycheck-error ((,class (:underline (:style wave :color ,red)))))
   `(flycheck-warning ((,class (:underline (:style wave :color ,yellow)))))
   `(flycheck-info ((,class (:underline (:style wave :color ,accent)))))
   `(flymake-error ((,class (:underline (:style wave :color ,red)))))
   `(flymake-warning ((,class (:underline (:style wave :color ,yellow)))))
   `(flymake-note ((,class (:underline (:style wave :color ,accent)))))

   ;; Terminal / ansi
   `(ansi-color-black ((,class (:background ,bg-alt-2 :foreground ,bg-alt-2))))
   `(ansi-color-red ((,class (:background ,red :foreground ,red))))
   `(ansi-color-green ((,class (:background ,green :foreground ,green))))
   `(ansi-color-yellow ((,class (:background ,yellow :foreground ,yellow))))
   `(ansi-color-blue ((,class (:background ,accent-2 :foreground ,accent-2))))
   `(ansi-color-magenta ((,class (:background ,magenta :foreground ,magenta))))
   `(ansi-color-cyan ((,class (:background ,accent-3 :foreground ,accent-3))))
   `(ansi-color-white ((,class (:background ,fg :foreground ,fg))))

   ;; Rainbow delimiters
   `(rainbow-delimiters-depth-1-face ((,class (:foreground ,fg))))
   `(rainbow-delimiters-depth-2-face ((,class (:foreground ,accent))))
   `(rainbow-delimiters-depth-3-face ((,class (:foreground ,cyan))))
   `(rainbow-delimiters-depth-4-face ((,class (:foreground ,magenta))))
   `(rainbow-delimiters-depth-5-face ((,class (:foreground ,yellow))))
   `(rainbow-delimiters-depth-6-face ((,class (:foreground ,green))))
   `(rainbow-delimiters-depth-7-face ((,class (:foreground ,teal))))
   `(rainbow-delimiters-depth-8-face ((,class (:foreground ,amber))))
   `(rainbow-delimiters-depth-9-face ((,class (:foreground ,lavender))))
   `(rainbow-delimiters-unmatched-face ((,class (:foreground ,red :weight bold))))))

;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'vague)

;;; vague-theme.el ends here
