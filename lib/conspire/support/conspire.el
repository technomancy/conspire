;;; conspire.el --- Collaborative real-time editing

;; Copyright (C) 2008 Phil Hagelberg

;; Author: Phil Hagelberg <technomancy@gmail.com>
;; URL: http://www.emacswiki.org/cgi-bin/wiki/Conspire
;; Version: 0.1
;; Created: 2008-07-22
;; Keywords: collaboration

;; This file is NOT part of GNU Emacs.

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; Let's use git for real-time collaborative editing!

;;; Code:

(defvar conspire-interval 0.33
  "Number of seconds to wait before syncing with conspire.")

(defvar conspire-timer nil
  "A timer to activate conspire synchronizing.")

(defun conspire-mode ()
  "Activate conspire-mode for real-time collaborative editing."
  (interactive)
  (set (make-local-variable 'conspire-timer)
       (run-with-idle-timer conspire-interval
                            :repeat 'conspire-sync-buffer)))

(defun conspire-sync-buffer ()
  "Synchronize buffer with Conspire repository."
  (when (buffer-modified-p)
    (save-buffer)
    (shell-command (format "git add %s && git commit -m \"conspire\""
                           buffer-file-name)))
  (revert-buffer nil t))b


;;; conspire.el ends here