(require 'package)
(add-to-list 'package-archives
	          '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

;; Visuals
(load-theme 'gruvbox-dark-hard t)
(load-theme 'nord t)
(menu-bar-mode -1)     ;Remove menubar on top
(tool-bar-mode -1)     ;Remove toolbar in GUI
(scroll-bar-mode -1)   ;Remove scrollbar in GUI
(global-linum-mode -1)  ;Show numbers on left

(setq inhibit-startup-message t ;Remove startup flash screen
      inhibit-startup-echo-area-message t)
(define-key global-map (kbd "RET") 'newline-and-indent)    ;Auto indentation

(setq backup-directory-alist `(("." . "~/.emsaves"))) ; dont locally create backups
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

;; Dont use tabs
(defun infer-indentation-style ()
  ;; if our source file uses tabs, we use tabs, if spaces spaces, and if
  ;; neither, we use the current indent-tabs-mode
  (let ((space-count (how-many "^  " (point-min) (point-max)))
	(tab-count (how-many "^\t" (point-min) (point-max))))
    (if (> space-count tab-count) (setq indent-tabs-mode nil))
        (if (> tab-count space-count) (setq indent-tabs-mode t))))


(require 'ido)
(ido-mode t)

(require 'py-autopep8)
(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)

(require 'gited)
(define-key dired-mode-map "\C-x\C-g" 'gited-list-branches)

(require 'use-package)
(use-package salt-mode
  :ensure t
  :config
  (add-hook 'salt-mode-hook
	    (lambda ()
	      (flyspell-mode 1))))

;; multiple cursors
(require 'multiple-cursors)
(global-set-key (kbd "C-x C-x") 'mc/edit-lines)            ; add cursors to all selected lines
(global-set-key (kbd "C-x n") 'mc/mark-next-like-this)       ; select next words
(global-set-key (kbd "C-x p") 'mc/mark-previous-like-this)   ; select prev words
(global-set-key (kbd "C-x N") 'mc/mark-all-like-this)      ; select all words

(elpy-enable)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (lisp . t)
   (dot . t)
   (sh . t)))

(defun my-org-confirm-babel-evaluate (lang body)
  (not (member lang '("sh" "python"))))

(defun my-org-inline-css-hook (exporter)
  "Insert custom inline css"
  (when (eq exporter 'html)
    (let* ((dir (ignore-errors (file-name-directory (buffer-file-name))))
	   (path (concat dir "readtheorg.css"))
	   (homestyle (or (null dir) (null (file-exists-p path))))
	   (final (if homestyle "~/.emacs.d/readtheorg.css" path))) ;; <- set your own style file path
      (setq org-html-head-include-default-style nil)
      (setq org-html-head (concat
			   "<style type=\"text/css\">\n"
			   "<!--/*--><![CDATA[/*><!--*/\n"
			   (with-temp-buffer
			     (insert-file-contents final)
			     (buffer-string))
			   "/*]]>*/-->\n"
			   "</style>\n")))))

(add-hook 'org-export-before-processing-hook 'my-org-inline-css-hook)

;; (setq org-confirm-babel-evaluate 'my-org-confirm-babel-evaluate)
(setq org-src-fontify-natively t)
(setq-default org-display-custom-times t)
(setq org-time-stamp-custom-formats '("<%e %b %Y %a>" . "<%a %b %e %Y %H:%M>"))
(setq org-export-html-postamble nil)

(require 'org-mime)
(defun org-mime-org-buffer-htmlize ()
    "Create an email buffer containing the current org-mode file
  exported to html and encoded in both html and in org formats as
  mime alternatives."
    (interactive)
    (org-mime-send-buffer 'html)
      (message-goto-to))


;; Key bindings
(fset 'mv_down
   "\C-n\C-n\C-n\C-n\C-n\C-n\C-n\C-n\C-n\C-n")
(fset 'mv_up
   "\C-p\C-p\C-p\C-p\C-p\C-p\C-p\C-p\C-p\C-p")
(fset 'edit-desc
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("<enter descr
	" 0 "%d")) arg)))
(fset 'org-email
   "\C-x\C-s\C-c\C-e\C-shH\C-spostamb\C-m\C-a\C-@\C-n\C-n\C-n\C-n\C-n\C-w\C-x\C-semail.html\C-my\C-xo\C-e\C-m<s\C-ish\C-nmutt -e 'set content_type=text/html' -s \"\" @factset.com -c alella@factset.com < ~/factset-notes/notes/email.html\C-a\C-[f\C-[f\C-[f\C-[f\C-[f\C-[f\C-[f\C-[f\C-f\C-f")

(defun move-line-up ()
  "Move up the current line."
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))

(defun move-line-down ()
  "Move down the current line."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))


(global-set-key (kbd "M-p") 'mv_up)
(global-set-key (kbd "M-n") 'mv_down)
(global-set-key (kbd "C-x /") 'comment-line)
(global-set-key (kbd "C-x r") 'replace-string)
(global-set-key (kbd "C-x P") 'python-shell)
(global-set-key (kbd "C-x d") 'edit-desc)
(global-set-key (kbd "M-9") 'defining-kbd-macro)
(global-set-key (kbd "M-0") 'end-kbd-macro)
(global-set-key (kbd "C-x 8") 'reload-emacs-config)
(global-set-key (kbd "C-x w") 'org-email)
(global-set-key (kbd "C-S-<up>")  'move-line-up)
(global-set-key (kbd "C-S-<down>")  'move-line-down)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("14de8f58ad656af5be374086ae7ab663811633fc1483a02add92f7a1ff1a8455" "1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365" "04dd0236a367865e591927a3810f178e8d33c372ad5bfef48b5ce90d4b476481" "a0feb1322de9e26a4d209d1cfa236deaf64662bb604fa513cca6a057ddf0ef64" "7527f3308a83721f9b6d50a36698baaedc79ded9f6d5bd4e9a28a22ab13b3cb1" "41f90b83fae6e57d37617a9998424cb78fa064fc79706442e677201084ee181d" "bcd8b3fc2d82d764a9692c754485344257caf017d3fbdfb18f4db022a7b9a58f" "3edbdd0ad45cb8f7c2575c0ad8f6625540283c6e928713c328b0bacf4cfbb60f" "f41ecd2c34a9347aeec0a187a87f9668fa8efb843b2606b6d5d92a653abe2439" "a4df5d4a4c343b2712a8ed16bc1488807cd71b25e3108e648d4a26b02bc990b3" "ef98b560dcbd6af86fbe7fd15d56454f3e6046a3a0abd25314cfaaefd3744a9e" "62c81ae32320ceff5228edceeaa6895c029cc8f43c8c98a023f91b5b339d633f" "7d2e7a9a7944fbde74be3e133fc607f59fdbbab798d13bd7a05e38d35ce0db8d" "a5956ec25b719bf325e847864e16578c61d8af3e8a3d95f60f9040d02497e408" "f27c3fcfb19bf38892bc6e72d0046af7a1ded81f54435f9d4d09b3bff9c52fc1" "cd4d1a0656fee24dc062b997f54d6f9b7da8f6dc8053ac858f15820f9a04a679" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" "4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" default)))
 '(describe-char-unidata-list (quote (name old-name general-category decomposition))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
