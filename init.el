;;; init.el --- My init.el  -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Naoya Yamashita

;; Author: Naoya Yamashita <conao3@gmail.com>

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; My init.el.

;;; Code:

;; this enables this running method
;;   emacs -q -l ~/.debug.emacs.d/{{pkg}}/init.el
(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
          (expand-file-name
           (file-name-directory (or load-file-name byte-compile-current-file))))))

(eval-and-compile
  (customize-set-variable
   'package-archives '(("org"   . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("gnu"   . "https://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))

;; ここにいっぱい設定を書く

(leaf leaf
  :config
  (leaf leaf-convert :ensure t)
  (leaf leaf-tree
    :ensure t
    :custom ((imenu-list-size . 30)
             (imenu-list-position . 'left))))

(leaf macrostep
  :ensure t
  :bind (("C-c e" . macrostep-expand)))

(leaf cus-edit
  :doc "tools for customizing Emacs and Lisp packages"
  :tag "builtin" "faces" "help"
  :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))

(leaf view
  :doc "peruse file or buffer without editing"
  :tag "builtin"
  :added "2022-03-20"
  :bind
  (("C-v" . view-mode)
   (:view-mode-map
    ("h" . backward-char)
    ("t" . next-line)
    ("n" . previous-line)
    ("s" . forward-char)
    ("w" . View-scroll-page-forward-set-page-size)
    ("v" . View-scroll-page-backward-set-page-size))))

(leaf display-line-numbers
  :doc "interface for display-line-numbers"
  :tag "builtin"
  :added "2022-03-20"
  :global-minor-mode global-display-line-numbers-mode)

(leaf startup
  :doc "process Emacs shell arguments"
  :tag "builtin" "internal"
  :added "2022-03-20"
  :custom
  ((inhibit-startup-screen . t)
   (inhibit-startup-message . t)
   (inhibit-startup-echo-area-message . t)
   (initial-scratch-message . nil)))

(leaf window
  :doc "GNU Emacs window commands aside from those written in C"
  :tag "builtin" "internal"
  :added "2022-03-20"
  :bind
  (("C-<tab>" . next-buffer)
   ("C-S-<tab>" . previous-buffer)))

(leaf simple
  :doc "basic editing commands for Emacs"
  :tag "builtin" "internal"
  :added "2022-03-20"
  :custom
  ((column-number-mode . t))
  :bind
  (("C-t" . nil)
   ("¥" . (lambda () (interactive) (insert "\\")))))

(leaf dired
  :doc "directory-browsing commands"
  :tag "builtin" "files"
  :added "2022-03-20"
  :bind
  ((:dired-mode-map
    ("RET" . dired-find-alternate-file) ;;; TODO
    ("q" . (lambda () (interactive) (quit-window t)))
    (" " . dired-toggle-mark)
    ("DEL" . dired-up-directory)
    ("t" . dired-next-line)
    ("n" . dired-previous-line)
    ("C-s" . dired-isearch-filenames)
    ("~" . (lambda () (interactive) (dired "~")))
    ("*" . dired-with-query))))

(leaf files
  :doc "file input and output commands for Emacs"
  :tag "builtin"
  :added "2022-03-20"
  :custom
  ((make-backup-files . nil)
   (auto-save-default . nil)))

(leaf menu-bar
  :doc "define a default menu bar"
  :tag "builtin" "mouse" "internal"
  :added "2022-03-20"
  :custom
  ((menu-bar-mode . nil)))

(leaf tool-bar
  :doc "setting up the tool bar"
  :tag "builtin" "frames" "mouse"
  :added "2022-03-20"
  :custom
  ((tool-bar-mode . nil)))

(leaf cus-start
  :doc "define customization properties of builtins"
  :tag "builtin" "internal"
  :added "2022-03-20"
  :custom
  ((ring-bell-function . 'ignore)))

(leaf auto-save-buffers-enhanced
  :doc "Automatically save buffers in a decent way"
  :added "2022-03-20"
  :ensure t
  :custom
  ((auto-save-buffers-enhanced-interval . 0.5)
   (auto-save-buffers-enhanced-quiet-save-p . t))
  :config
  (auto-save-buffers-enhanced t))

(leaf delsel
  :doc "delete selection if you insert"
  :tag "builtin"
  :added "2022-03-20"
  :global-minor-mode delete-selection-mode)

(leaf paren
  :doc "highlight matching paren"
  :tag "builtin"
  :custom ((show-paren-delay . 0.1))
  :global-minor-mode show-paren-mode)

(leaf solarized-theme
  :doc "The Solarized color theme"
  :req "emacs-24.1"
  :tag "solarized" "themes" "convenience" "emacs>=24.1"
  :url "http://github.com/bbatsov/solarized-emacs"
  :added "2022-03-20"
  :emacs>= 24.1
  :ensure t
  :config
  (load-theme 'solarized-dark t))

(leaf *font
  :config
  (set-face-attribute 'default nil :family "HackGen Console" :height 140)
  (add-to-list 'default-frame-alist '(width . 100)))

(leaf executable
  :hook
  (after-save-hook . executable-make-buffer-file-executable-if-script-p))

(leaf *c-source-code
  :custom
  (indent-tabs-mode . nil)
  (message-log-max . 100000)
  (read-buffer-completion-ignore-case . t)
  (read-file-name-completion-ignore-case . t)
  (scroll-conservatively . 1)
  (scroll-margin . 5)
  (create-lockfiles . nil)
  (frame-title-format .
      '(multiple-frames "%b"
                        ("" invocation-name "@" (:eval (downcase system-name)) ": "
                         (:eval (if (buffer-file-name) "%f" "%b")))))
  :setq-default
  (buffer-file-coding-system . 'utf-8-unix)
  :config
  (setq default-directory "~/"))

(leaf minions
  :doc "A minor-mode menu for the mode line"
  :req "emacs-25.2"
  :tag "emacs>=25.2"
  :url "https://github.com/tarsius/minions"
  :added "2022-03-20"
  :emacs>= 25.2
  :ensure t
  :global-minor-mode t
  :custom
  ((minions-mode-line-lighter . "[+]")))

(provide 'init)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; init.el ends here
