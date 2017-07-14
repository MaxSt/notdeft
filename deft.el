;;; deft.el --- quickly browse, filter, and edit plain text notes

;; Copyright (C) 2011 Jason R. Blevins <jrblevin@sdf.org>
;; All rights reserved.

;; Redistribution and use in source and binary forms, with or without
;; modification, are permitted provided that the following conditions are met:
;; 1. Redistributions of source code must retain the above copyright
;;    notice, this list of conditions and the following disclaimer.
;; 2. Redistributions in binary form must reproduce the above copyright
;;    notice, this list of conditions and the following disclaimer in the
;;    documentation  and/or other materials provided with the distribution.
;; 3. Neither the names of the copyright holders nor the names of any
;;    contributors may be used to endorse or promote products derived from
;;    this software without specific prior written permission.

;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
;; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
;; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
;; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
;; SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
;; CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
;; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;; POSSIBILITY OF SUCH DAMAGE.

;; Author: Jason R. Blevins <jrblevin@sdf.org>
;; Keywords: plain text, notes, Simplenote, Notational Velocity
;; URL: http://jblevins.org/projects/deft/

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Deft is an Emacs mode for quickly browsing, filtering, and editing
;; directories of plain text notes, inspired by Notational Velocity.
;; It was designed for increased productivity when writing and taking
;; notes by making it fast and simple to find the right file at the
;; right time and by automating many of the usual tasks such as
;; creating new files and saving files.

;; Deft is open source software and may be freely distributed and
;; modified under the BSD license.  Version 0.3 is the latest stable
;; version, released on September 11, 2011.  You may download it
;; directly here:

;;   * [deft.el](http://jblevins.org/projects/deft/deft.el)

;; To follow or contribute to Deft development, you can either
;; [browse](http://jblevins.org/git/deft.git) or clone the Git
;; repository:

;;     git clone git://jblevins.org/git/deft.git

;; ![File Browser](http://jblevins.org/projects/deft/browser.png)

;; The Deft buffer is simply a file browser which lists the titles of
;; all text files in the Deft directory followed by short summaries
;; and last modified times.  The title is taken to be the first line
;; of the file and the summary is extracted from the text that
;; follows.  Files are sorted in terms of the last modified date, from
;; newest to oldest.

;; All Deft files or notes are simple plain text files where the first
;; line contains a title.  As an example, the following directory
;; structure generated the screenshot above.
;;
;;     % ls ~/.deft
;;     about.txt    browser.txt     directory.txt   operations.txt
;;     ack.txt      completion.txt  extensions.txt  text-mode.txt
;;     binding.txt  creation.txt    filtering.txt
;;
;;     % cat ~/.deft/about.txt
;;     About
;;
;;     An Emacs mode for slicing and dicing plain text files.

;; ![Filtering](http://jblevins.org/projects/deft/filter.png)

;; Deft's primary operation is searching and filtering.  The list of
;; files can be limited or filtered using a search string, which will
;; match both the title and the body text.  To initiate a filter,
;; simply start typing.  Filtering happens on the fly.  As you type,
;; the file browser is updated to include only files that match the
;; current string.

;; To open the first matching file, simply press `RET`.  If no files
;; match your search string, pressing `RET` will create a new file
;; using the string as the title.  This is a very fast way to start
;; writing new notes.  The filename will be generated automatically.
;; If you prefer to provide a specific filename, use `C-RET` instead.

;; To open files other than the first match, navigate up and down
;; using `C-p` and `C-n` and press `RET` on the file you want to open.

;; Press `C-c C-c` to clear the filter string and display all files
;; and `C-c C-g` to refresh the file browser using the current filter
;; string.

;; Static filtering is also possible by pressing `C-c C-l`.  This is
;; sometimes useful on its own, and it may be preferable in some
;; situations, such as over slow connections or on older systems,
;; where interactive filtering performance is poor.

;; Common file operations can also be carried out from within Deft.
;; Files can be renamed using `C-c C-r` or deleted using `C-c C-d`.
;; New files can also be created using `C-c C-n` for quick creation or
;; `C-c C-m` for a filename prompt.  You can leave Deft at any time
;; with `C-c C-q`.

;; Files opened with deft are automatically saved after Emacs has been
;; idle for a customizable number of seconds.  This value is a floating
;; point number given by `deft-auto-save-interval'.

;; Getting Started
;; ---------------

;; To start using it, place it somewhere in your Emacs load-path and
;; add the line

;;     (require 'deft)

;; in your `.emacs` file.  Then run `M-x deft` to start.  It is useful
;; to create a global keybinding for the `deft` function (e.g., a
;; function key) to start it quickly (see below for details).

;; One useful way to use Deft is to keep a directory of notes in a
;; Dropbox folder.  This can be used with other applications and
;; mobile devices, for example, Notational Velocity or Simplenote
;; on OS X, Elements on iOS, or Epistle on Android.

;; Customization
;; -------------

;; Customize the `deft` group to change the functionality.

;; By default, Deft looks for notes by searching for files with the
;; extension `.txt` in the `~/.deft` directory.  You can customize
;; both the file extension and the Deft directory by running
;; `M-x customize-group` and typing `deft`.  Alternatively, you can
;; configure them in your `.emacs` file:

;;     (setq deft-extension "txt")
;;     (setq deft-directory "~/Dropbox/notes")

;; You can also customize the major mode that Deft uses to edit files,
;; either through `M-x customize-group` or by adding something like
;; the following to your `.emacs` file:

;;     (setq deft-text-mode 'markdown-mode)

;; Note that the mode need not be a traditional text mode.  If you
;; prefer to write notes as LaTeX fragments, for example, you could
;; set `deft-extension' to "tex" and `deft-text-mode' to `latex-mode'.

;; If you prefer `org-mode', then simply use

;;     (setq deft-extension "org")
;;     (setq deft-text-mode 'org-mode)

;; You can easily set up a global keyboard binding for Deft.  For
;; example, to bind it to F8, add the following code to your `.emacs`
;; file:

;;     (global-set-key [f8] 'deft)

;; The faces used for highlighting various parts of the screen can
;; also be customized.  By default, these faces inherit their
;; properties from the standard font-lock faces defined by your current
;; color theme.

;; Acknowledgments
;; ---------------

;; Thanks to Konstantinos Efstathiou for writing simplnote.el, from
;; which I borrowed liberally, and to Zachary Schneirov for writing
;; Notational Velocity, which I have never had the pleasure of using,
;; but whose functionality and spirit I wanted to bring to other
;; platforms, such as Linux, via Emacs.

;; History
;; -------

;; Version 0.3 (2011-09-11):

;; * Internationalization: support filtering with multibyte characters.

;; Version 0.2 (2011-08-22):

;; * Match filenames when filtering.
;; * Automatically save opened files (optional).
;; * Address some byte-compilation warnings.

;; Deft was originally written by Jason Blevins.
;; The initial version, 0.1, was released on August 6, 2011.

;;; Code:

(require 'widget)

;; Customization

(defgroup deft nil
  "Emacs Deft mode."
  :group 'local)

(defcustom deft-path 
  `(,(expand-file-name "~/.deft/"))
  "Deft directory search path."
  :type '(repeat (string :tag "Directory"))
  :group 'deft)

(defcustom deft-extension "org"
  "Deft file extension."
  :type 'string
  :safe 'stringp
  :group 'deft)

(defcustom deft-text-mode 'org-mode
  "Default mode used for editing files."
  :type 'function
  :group 'deft)

(defcustom deft-auto-save-interval 0.0
  "Idle time in seconds before automatically saving buffers opened by Deft.
Set to zero to disable."
  :type 'float
  :group 'deft)

(defcustom deft-time-format " %Y-%m-%d %H:%M"
  "Format string for modification times in the Deft browser.
Set to nil to hide."
  :type '(choice (string :tag "Time format")
		 (const :tag "Hide" nil))
  :group 'deft)

;; Faces

(defgroup deft-faces nil
  "Faces used in Deft mode"
  :group 'deft
  :group 'faces)

(defface deft-header-face
  '((t :inherit font-lock-keyword-face :bold t))
  "Face for Deft header."
  :group 'deft-faces)

(defface deft-filter-string-face
  '((t :inherit font-lock-string-face))
  "Face for Deft filter string."
  :group 'deft-faces)

(defface deft-title-face
  '((t :inherit font-lock-function-name-face :bold t))
  "Face for Deft file titles."
  :group 'deft-faces)

(defface deft-separator-face
  '((t :inherit font-lock-comment-delimiter-face))
  "Face for Deft separator string."
  :group 'deft-faces)

(defface deft-summary-face
  '((t :inherit font-lock-comment-face))
  "Face for Deft file summary strings."
  :group 'deft-faces)

(defface deft-time-face
  '((t :inherit font-lock-variable-name-face))
  "Face for Deft last modified times."
  :group 'deft-faces)

;; Constants

(defconst deft-version "0.3c")

(defconst deft-buffer "*Deft*"
  "Deft buffer name.")

(defconst deft-separator " --- "
  "Text used to separate file titles and summaries.")

;; Global variables

(defvar deft-directory nil
  "Chosen Deft data directory.")

(defvar deft-mode-hook nil
  "Hook run when entering Deft mode.")

(defvar deft-filter-regexp nil
  "Current filter regexp used by Deft.")

(defvar deft-current-files nil
  "List of files matching current filter.")

(defvar deft-all-files nil
  "List of all files in the data directory.")

(defvar deft-hash-contents nil
  "Hash containing complete cached file contents, keyed by filename.")

(defvar deft-hash-mtimes nil
  "Hash containing cached file modification times, keyed by filename.")

(defvar deft-hash-titles nil
  "Hash containing cached file titles, keyed by filename.")

(defvar deft-hash-summaries nil
  "Hash containing cached file summaries, keyed by filename.")

(defvar deft-auto-save-buffers nil
  "List of buffers that will be automatically saved.")

(defvar deft-window-width nil
  "Width of Deft buffer.")

(defun deft-reset-state ()
  "Resets Deft internal state, but not configuration settings."
  (setq deft-directory nil)
  (setq deft-filter-regexp nil)
  (setq deft-current-files nil)
  (setq deft-all-files nil)
  (setq deft-hash-contents nil)
  (setq deft-hash-mtimes nil)
  (setq deft-hash-titles nil)
  (setq deft-hash-summaries nil)
  (setq deft-auto-save-buffers nil)
  (setq deft-window-width nil))

;; File processing

(defun deft-title-to-base-filename (s)
  "Turn a title string to a base filename."
  (when (string-match "^[^a-zA-Z0-9-]+" s)
    (setq s (replace-match "" t t s)))
  (when (string-match "[^a-zA-Z0-9-]+$" s)
    (setq s (replace-match "" t t s)))
  (while (string-match "[^a-zA-Z0-9-]+" s)
    (setq s (replace-match "-" t t s)))
  (setq s (downcase s))
  s)

(defun deft-format-time-for-filename (tm)
  "Format a time suitably for filenames."
  (format-time-string "%Y-%m-%d-%H-%M-%S" tm t)) ; UTC

(defun deft-generate-filename ()
  "Generate a new unique filename without being given any
information about note title or content."
  (let (filename)
    (while (or (not filename)
	       (file-exists-p filename))
      (let* ((ctime (current-time))
	     (ctime-s (deft-format-time-for-filename ctime))
	     (base-filename (format "Deft--%s" ctime-s)))
	(setq filename (deft-make-filename base-filename))))
    filename))

(defun deft-make-filename (base-filename &optional dir)
  (concat (file-name-as-directory (or dir deft-directory))
	  base-filename "." deft-extension))

(defun deft-filename-from-title (title &optional in-subdir)
  (let ((base-filename (deft-title-to-base-filename title)))
    (deft-make-filename
      base-filename
      (if in-subdir
	  (concat (file-name-as-directory deft-directory)
		  base-filename)
	deft-directory))))

(defun deft-file-readable-p (file)
  (and (file-readable-p file)
       (not (file-directory-p file))))

(defun deft-title-from-file-content (file)
  "Extracts a title from FILE, returning nil on failure."
  (and (deft-file-readable-p file)
       (let* ((contents
	       (with-temp-buffer
		 (insert-file-contents file)
		 (buffer-string)))
	      (title
	       (deft-parse-title file contents)))
	 title)))

(defun deft-chomp (str)
  "Trim leading and trailing whitespace from STR."
  (replace-regexp-in-string "\\(^[[:space:]\n]*\\|[[:space:]\n]*$\\)" "" str))

(defun deft-base-filename (file)
  "Strip the path and extension from filename FILE.
Use `file-name-directory' to get the directory component."
  (setq file (file-name-nondirectory file))
  (unless (string= "" deft-extension)
    (setq file (replace-regexp-in-string
		(concat "\." deft-extension "$")
		""
		file)))
  file)

(defun deft-find-all-files-in-dir (directory full)
  "Return a list of all Deft files in the specified Deft DIRECTORY.
Returns them as absolute paths if FULL is true."
  (and
   (file-exists-p directory)
   (let* ((files (directory-files directory nil nil t))
	  (file-re (concat "\." deft-extension "$"))
	  result)
     (dolist (filename files result)
       (cond
	((string= "." filename))
	((string= ".." filename))
	(t
	 (let ((file (concat (file-name-as-directory directory)
			     filename)))
	   (cond
	    ((file-directory-p file)
	     (let ((sub-file (deft-make-filename filename file)))
	       (when (file-exists-p sub-file)
		 (let ((x (if full
			      sub-file
			    (file-name-nondirectory sub-file))))
		   (setq result (cons x result))))))
	    ((string-match-p file-re filename)
	     (setq result (cons (if full file filename) result)))))))))))

(defun deft-find-all-files ()
  "Return a list of all readable Deft files in the specified
Deft directory, as absolute paths."
  (let ((files (deft-find-all-files-in-dir deft-directory t))
	result)
    ;; Filter out files that are not readable or are directories.
    (dolist (file files)
      (when (deft-file-readable-p file)
	(setq result (cons file result))))
    result))

;;;###autoload
(defun deft-make-note-basename-list ()
  "Returns the non-directory components of all Deft files
in all of the existing `deft-path' directories.
The result list is sorted by the `string-lessp' relation."
  (let ((dir-lst deft-path)
	(fn-lst '()))
    (dolist (dir dir-lst)
      (setq fn-lst
	    (append fn-lst
		    (deft-find-all-files-in-dir dir nil))))
    ;; `sort` may modify `fn-lst`
    (sort fn-lst 'string-lessp)))

(defun deft-parse-title (file contents)
  "Parse the given FILE and CONTENTS and determine the title.
The title is taken to be the first non-empty line of a file.
Returns nil if there is no non-empty, not-just-whitespace
title in CONTENTS."
  (let ((begin (string-match "^.+$" contents)))
    (and begin
	 (let* ((line (substring contents begin (match-end 0)))
		(title (deft-chomp line)))
	   (and (not (string= "" title)) title)))))

(defun deft-parse-summary (contents title)
  "Parse the file CONTENTS, given the TITLE, and extract a summary.
The summary is a string extracted from the contents following the
title."
  (unless (string-match (regexp-quote title) contents)
    (error "Title not found in file contents"))
  (let* ((me (match-end 0))
	 (summary (deft-chomp (substring contents me (length contents)))))
    (replace-regexp-in-string "[\n\t]" " " summary)))

(defun deft-cache-file (file)
  "Update file cache if FILE exists."
  (when (file-exists-p file)
    (let ((mtime-cache (deft-file-mtime file))
          (mtime-file (nth 5 (file-attributes file))))
      (when (or (not mtime-cache)
		(time-less-p mtime-cache mtime-file))
          (deft-cache-newer-file file mtime-file)
	  ))))

(defun deft-cache-newer-file (file mtime)
  "Update cached information for FILE with given MTIME."
  ;; Modification time
  (puthash file mtime deft-hash-mtimes)
  (let (contents title)
    ;; Contents
    (with-current-buffer (get-buffer-create "*Deft temp*")
      (insert-file-contents file nil nil nil t)
      (setq contents (concat (buffer-string))))
    (puthash file contents deft-hash-contents)
    ;; Title
    (setq title (or (deft-parse-title file contents) ""))
    (puthash file title deft-hash-titles)
    ;; Summary
    (puthash file (deft-parse-summary contents title) deft-hash-summaries))
  (kill-buffer "*Deft temp*"))

(defun deft-file-newer-p (file1 file2)
  "Return non-nil if FILE1 was modified since FILE2 and nil otherwise."
  (let (time1 time2)
    (setq time1 (deft-file-mtime file1))
    (setq time2 (deft-file-mtime file2))
    (time-less-p time2 time1)))

(defun deft-cache-initialize ()
  "Initialize hash tables for caching files."
  (setq deft-hash-contents (make-hash-table :test 'equal))
  (setq deft-hash-mtimes (make-hash-table :test 'equal))
  (setq deft-hash-titles (make-hash-table :test 'equal))
  (setq deft-hash-summaries (make-hash-table :test 'equal)))

(defun deft-cache-update ()
  "Update cached file information."
  (setq deft-all-files (deft-find-all-files))
  (mapc 'deft-cache-file deft-all-files)                  ; Cache contents
  (setq deft-all-files (deft-sort-files deft-all-files))  ; Sort by mtime
  )

;; Cache access

(defun deft-file-contents (file)
  "Retrieve complete contents of FILE from cache."
  (gethash file deft-hash-contents))

(defun deft-file-mtime (file)
  "Retrieve modified time of FILE from cache."
  (gethash file deft-hash-mtimes))

(defun deft-file-title (file)
  "Retrieve title of FILE from cache."
  (gethash file deft-hash-titles))

(defun deft-file-summary (file)
  "Retrieve summary of FILE from cache."
  (gethash file deft-hash-summaries))

;; File list display

(defun deft-print-header ()
  "Prints the *Deft* buffer header."
  (if deft-filter-regexp
      (progn
        (widget-insert
         (propertize "Deft: " 'face 'deft-header-face))
        (widget-insert
         (propertize deft-filter-regexp 'face 'deft-filter-string-face)))
    (widget-insert
         (propertize "Deft" 'face 'deft-header-face)))
  (widget-insert "\n\n"))

(defun deft-buffer-setup ()
  "Render the file browser in the *Deft* buffer."
  (setq deft-window-width (window-width))
  (let ((inhibit-read-only t))
    (erase-buffer))
  (remove-overlays)
  (deft-print-header)

  ;; Print the files list
  (if (not (file-exists-p deft-directory))
      (widget-insert (deft-no-directory-message))
    (if deft-current-files
        (progn
          (mapc 'deft-file-widget deft-current-files))
      (widget-insert (deft-no-files-message))))

  (use-local-map deft-mode-map)
  (widget-setup)
  (goto-char 1)
  (forward-line 2))

(defun deft-file-widget (file)
  "Add a line to the file browser for the given FILE."
  (when file
    (let* ((key (file-name-nondirectory file))
	   (text (deft-file-contents file))
	   (title (deft-file-title file))
	   (summary (deft-file-summary file))
	   (mtime (and deft-time-format
		    (format-time-string deft-time-format
					(deft-file-mtime file))))
	   (mtime-width (length mtime))
	   (line-width (- deft-window-width mtime-width))
	   (title-width (min line-width (length title)))
	   (summary-width (min (length summary)
			       (- line-width
				  title-width
				  (length deft-separator)))))
      (widget-create 'link
                     :button-prefix ""
                     :button-suffix ""
                     :button-face 'deft-title-face
                     :format "%[%v%]"
                     :tag file
                     :help-echo "Edit this file"
                     :notify (lambda (widget &rest ignore)
                               (deft-open-file (widget-get widget :tag)))
                     (if title (substring title 0 title-width) "[Empty file]"))
      (when (> summary-width 0)
        (widget-insert (propertize deft-separator 'face 'deft-separator-face))
        (widget-insert (propertize (substring summary 0 summary-width)
				   'face 'deft-summary-face)))
      (when mtime
	(while (< (current-column) line-width)
	  (widget-insert " "))
	(widget-insert (propertize mtime 'face 'deft-time-face)))
      (widget-insert "\n"))))

(add-hook 'window-configuration-change-hook
	  (lambda ()
	    (when (and (eq (current-buffer) (get-buffer deft-buffer))
                       (not (eq deft-window-width (window-width))))
              (deft-buffer-setup))))

(defun deft-refresh ()
  "Refresh the *Deft* buffer in the background."
  (interactive)
  (when (get-buffer deft-buffer)
    (set-buffer deft-buffer)
    (deft-cache-update)
    (deft-filter-update)
    (deft-buffer-setup)))

(defun deft-no-directory-message ()
  "Return a short message to display when the Deft directory does not exist."
  (concat "Directory " deft-directory " does not exist.\n"))

(defun deft-no-files-message ()
  "Return a short message to display if no files are found."
  (if deft-filter-regexp
      "No files match the current filter string.\n"
    "No files found."))

;; File list file management actions

(defun deft-open-file (file)
  "Open FILE in a new buffer and setting its mode."
  (prog1 (find-file file)
    (funcall deft-text-mode)
    (add-to-list 'deft-auto-save-buffers (buffer-name))
    (add-hook 'after-save-hook
              (lambda () (save-excursion (deft-refresh)))
              nil t)))

(defun deft-find-file (file)
  "Find FILE interactively using the minibuffer."
  (interactive "F")
  (deft-open-file file))

(defun deft-new-file-named (title)
  "Create a new file named based on TITLE,
or prompting for a title when called interactively."
  (interactive "sNew title: ")
  (if (not (string-match "[a-zA-Z0-9]" title))
      (message "Aborting, unsuitable title: '%s'" title)
    (let ((file (deft-filename-from-title title)))
      (if (file-exists-p file)
	  (message "Aborting, file already exists: '%s'" file)
	(progn
	 (write-region title nil file nil)
	 (deft-open-file file))))))

(defun deft-new-file ()
  "Create a new file quickly, with an automatically generated filename,
based on the filter string if it is non-nil."
  (interactive)
  (let ((file
	 (if deft-filter-regexp
	     (deft-filename-from-title deft-filter-regexp)
	   (deft-generate-filename))))
    (when deft-filter-regexp
      (write-region (concat deft-filter-regexp "\n\n") nil file nil))
    (deft-open-file file)
    (with-current-buffer (get-file-buffer file)
      (goto-char (point-max)))))

(defun deft-delete-file ()
  "Delete the file represented by the widget at the point.
If the point is not on a file widget, do nothing. Prompts before
proceeding."
  (interactive)
  (let ((filename (widget-get (widget-at) :tag)))
    (if filename
	(let ((filename-nd 
	       (file-name-nondirectory filename)))
	  (when (y-or-n-p
		 (concat "Delete file " filename-nd "? "))
	    (delete-file filename)
	    (delq filename deft-current-files)
	    (delq filename deft-all-files)
	    (deft-refresh)
	    (message (concat "Deleted " filename-nd))))
      (error "Not on a file"))))

(defun deft-direct-file-p (file)
  (let ((cand-dirs deft-path)
	(file-dir (file-name-directory file))
	result)
    (while (and cand-dirs (not result))
      (let ((dir (car cand-dirs)))
	(setq cand-dirs (cdr cand-dirs))
	(when (file-equal-p (expand-file-name dir) file-dir)
	  (setq result t))))
    result))

(defun deft-move-into-subdir ()
  "Move the file at point into a subdirectory of the same name."
  (interactive)
  (let ((old-file (widget-get (widget-at) :tag)))
    (cond
     ((not old-file)
      (error "Not on a file"))
     ((not (deft-direct-file-p old-file))
      (error "Cannot move into a subdir"))
     (t
      (let ((new-file
	     (concat
	      (file-name-directory old-file)
	      (file-name-as-directory (deft-base-filename old-file))
	      (file-name-nondirectory old-file))))
	(ignore-errors
	  (make-directory (file-name-directory new-file nil)))
	(rename-file old-file new-file nil)
	(deft-refresh)
	(message "Renamed as `%s`" new-file))))))

(defun deft-rename-file (pfx)
  "Rename the file represented by the widget at the point.
If the point is not on a file widget, do nothing.
Defaults to a content-derived file name if called with
a prefix argument, rather than the old file name."
  (interactive "P")
  (let ((old-filename (widget-get (widget-at) :tag)))
    (if (not old-filename)
	(error "Not on a file")
      (let* ((old-name (deft-base-filename old-filename))
	     (def-name
	       (or (and
		    pfx
		    (let ((title
			   (deft-title-from-file-content old-filename)))
		      (and title
			   (deft-title-to-base-filename title))))
		   old-name))
	     (history (list def-name))
	     (new-name
	      (read-string
	       (concat "Rename " old-name " to (without extension): ")
	       (car history) ;; INITIAL-INPUT
	       '(history . 1) ;; HISTORY
	       nil ;; DEFAULT-VALUE
	       ))
	     (new-filename
	      (deft-make-filename new-name
		(file-name-directory old-filename))))
	;; Fails if `new-filename` already exists.
	(rename-file old-filename new-filename nil)
	(deft-refresh)))))

;; File list filtering

(defun deft-sort-files (files)
  "Sort FILES in reverse order by modified time."
  (sort files (lambda (f1 f2) (deft-file-newer-p f1 f2))))

(defun deft-filter-initialize ()
  "Initialize the filter string (nil) and files list (all files)."
  (interactive)
  (setq deft-filter-regexp nil)
  (setq deft-current-files deft-all-files))

(defun deft-filter-update ()
  "Update the filtered files list using the current filter regexp."
  (if (not deft-filter-regexp)
      (setq deft-current-files deft-all-files)
    (setq deft-current-files (mapcar 'deft-filter-match-file deft-all-files))
    (setq deft-current-files (delq nil deft-current-files))))

(defun deft-filter-match-file (file)
  "Return FILE if FILE matches the current filter regexp."
  (with-temp-buffer
    (insert file)
    (insert (deft-file-title file))
    (insert (deft-file-contents file))
    (goto-char (point-min))
    (when (search-forward deft-filter-regexp nil t)
        file)))

;; Filters that cause a refresh

(defun deft-filter-clear ()
  "Clear the current filter string and refresh the file browser."
  (interactive)
  (when deft-filter-regexp
    (setq deft-filter-regexp nil)
    (setq deft-current-files deft-all-files)
    (deft-refresh))
  (message "Filter cleared."))

(defun deft-filter (str)
  "Set the filter string to STR and update the file browser."
  (interactive "sFilter: ")
  (if (= (length str) 0)
      (setq deft-filter-regexp nil)
    (setq deft-filter-regexp str)
    (setq deft-current-files (mapcar 'deft-filter-match-file deft-all-files))
    (setq deft-current-files (delq nil deft-current-files)))
  (deft-refresh))

(defun deft-filter-increment ()
  "Append character to the filter regexp and update `deft-current-files'."
  (interactive)
  (let ((char last-command-event))
    (if (= char ?\S-\ )
	(setq char ?\s))
    (setq char (char-to-string char))
    (setq deft-filter-regexp (concat deft-filter-regexp char))
    (setq deft-current-files (mapcar 'deft-filter-match-file deft-current-files))
    (setq deft-current-files (delq nil deft-current-files)))
  (deft-refresh))

(defun deft-filter-decrement ()
  "Remove last character from the filter regexp and update `deft-current-files'."
  (interactive)
  (if (> (length deft-filter-regexp) 1)
      (deft-filter (substring deft-filter-regexp 0 -1))
    (deft-filter-clear)))

(defun deft-complete ()
  "Complete the current action.
If there is a widget at the point, press it.  If a filter is
applied and there is at least one match, open the first matching
file.  If there is an active filter but there are no matches,
quick create a new file using the filter string as the title.
Otherwise, quick create a new file."
  (interactive)
  (cond
   ;; Activate widget
   ((widget-at)
    (widget-button-press (point)))
   ;; Active filter string with match
   ((and deft-filter-regexp deft-current-files)
    (deft-open-file (car deft-current-files)))
   ;; Default
   (t
    (deft-new-file))))

;;; Automatic File Saving

(defun deft-auto-save ()
  (save-excursion
    (dolist (buf deft-auto-save-buffers)
      (if (get-buffer buf)
          ;; Save open buffers that have been modified.
          (progn
            (set-buffer buf)
            (when (buffer-modified-p)
              (basic-save-buffer)))
        ;; If a buffer is no longer open, remove it from auto save list.
        (delq buf deft-auto-save-buffers)))))

;;; Mode definition

(defun deft-show-version ()
  "Show the version number in the minibuffer."
  (interactive)
  (message "Deft %s" deft-version))

(defvar deft-mode-map
  (let ((i 0)
        (map (make-keymap)))
    ;; Make multibyte characters extend the filter string.
    (set-char-table-range (nth 1 map) (cons #x100 (max-char))
                          'deft-filter-increment)
    ;; Extend the filter string by default.
    (setq i ?\s)
    (while (< i 256)
      (define-key map (vector i) 'deft-filter-increment)
      (setq i (1+ i)))
    ;; Handle backspace and delete
    (define-key map (kbd "DEL") 'deft-filter-decrement)
    ;; Handle return via completion or opening file
    (define-key map (kbd "RET") 'deft-complete)
    ;; Filtering
    (define-key map (kbd "C-c C-l") 'deft-filter)
    (define-key map (kbd "C-c C-c") 'deft-filter-clear)
    ;; File creation
    (define-key map (kbd "C-c C-n") 'deft-new-file)
    (define-key map (kbd "C-c C-m") 'deft-new-file-named)
    ;; File management
    (define-key map (kbd "C-c C-d") 'deft-delete-file)
    (define-key map (kbd "C-c C-r") 'deft-rename-file)
    (define-key map (kbd "C-c C-f") 'deft-find-file)
    (define-key map (kbd "C-c C-b") 'deft-move-into-subdir)
    ;; Miscellaneous
    (define-key map (kbd "C-c C-g") 'deft-refresh)
    (define-key map (kbd "C-c C-q") 'quit-window)
    ;; Widgets
    (define-key map [down-mouse-1] 'widget-button-click)
    (define-key map [down-mouse-2] 'widget-button-click)
    (define-key map (kbd "<tab>") 'widget-forward)
    (define-key map (kbd "<backtab>") 'widget-backward)
    (define-key map (kbd "<S-tab>") 'widget-backward)
    map)
  "Keymap for Deft mode.")

(defun deft-mode ()
  "Major mode for quickly browsing, filtering, and editing plain text notes.
Turning on `deft-mode' runs the hook `deft-mode-hook'.

\\{deft-mode-map}."
  (kill-all-local-variables)
  (setq truncate-lines t)
  (setq buffer-read-only t)
  (setq default-directory deft-directory)
  (use-local-map deft-mode-map)
  (deft-cache-initialize)
  (deft-cache-update)
  (deft-filter-initialize)
  (setq major-mode 'deft-mode)
  (setq mode-name "Deft")
  (deft-buffer-setup)
  (when (> deft-auto-save-interval 0)
    (run-with-idle-timer deft-auto-save-interval t 'deft-auto-save))
  (run-mode-hooks 'deft-mode-hook))

(put 'deft-mode 'mode-class 'special)

(defun deft-select-existing-dirs (in-lst)
  "Filters the given IN-LST, rejecting anything except for names
of existing directories."
  (let (lst)
    (mapc (lambda (d) 
	    (when (file-directory-p d)
	      (setq lst (cons d lst))))
	  (reverse in-lst))
    lst))

(defun drop-nth-cons (n lst)
  (let* ((len (length lst))
	 (rst (- len n)))
    (cons (nth n lst) (append (butlast lst rst) (last lst (- rst 1))))))

;;;###autoload
(defun deft-select-directory ()
  "Tries to select and according to the configured list of directories, possibly user assisted. If `default-directory' is a Deft one, then uses that as the default choice. Returns the selected directory, or nil if nothing was selected. Non-existing directories cannot be selected."
  (if (not deft-path)
      (progn (message "No configured Deft data directories.") nil)
    (let ((lst (deft-select-existing-dirs deft-path)))
      (if (not lst)
	  (progn (message "No existing Deft data directories.") nil)
	(if (= (length lst) 1)
	    (first lst)
	  (let* ((ix
		  (cl-position-if
		   (lambda (x) (file-equal-p default-directory x))
		   lst))
		 (choice-lst
		  (if ix (drop-nth-cons ix lst) lst))
		 (d (ido-completing-read
		     "Data directory: " choice-lst
		     nil 'confirm-after-completion 
		     nil nil nil t)))
	    (if (not d)
		(progn (message "Nothing selected.") nil)
	      (if (not (file-directory-p d))
		  (progn (message "Not a directory.") nil)
		d))))))))

(defun deft-with-directory (dir)
  "Sets `deft-directory' to DIR, and opens that directory in Deft."
  (setq deft-directory dir)
  (when deft-directory
    (setq deft-directory (expand-file-name deft-directory))
    (message "Using Deft data directory '%s'" deft-directory)
    (switch-to-buffer deft-buffer)
    (deft-mode)))

;;;###autoload
(defun deft-expand-file-name (filename)
  "Expands a basename (with extension) to a full pathname
under a Deft directory, if such a file indeed exists.
If multiple such files exist, returns one of them.
If none exist, returns nil."
  (let ((subdir-filename
	 (concat (file-name-as-directory
		  (deft-base-filename filename))
		 filename))
        (cand-dirs deft-path)
        result)
    (while (and cand-dirs (not result))
      (let* ((dir (car cand-dirs))
	     (full-dir (file-name-as-directory
			(expand-file-name dir))))
	(setq cand-dirs (cdr cand-dirs))
	(let ((cand-fn (concat full-dir filename)))
	  (if (file-exists-p cand-fn)
	    (setq result cand-fn)
            (let ((cand-fn (concat full-dir subdir-filename)))
	      (when (file-exists-p cand-fn)
		(setq result cand-fn)))))))
    result))

;;;###autoload
(defun deft-open-file-by-basename (filename)
  (let ((fn (deft-expand-file-name filename)))
    (if (not fn)
	(message "No Deft file '%s'" filename)
      (deft-open-file fn))))

;;;###autoload
(defun deft ()
  "Switch to *Deft* buffer and load files."
  (interactive)
  (deft-with-directory (deft-select-directory)))

(provide 'deft)

;;; deft.el ends here
