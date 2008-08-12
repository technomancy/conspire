;;; conspire.el --- Collaborative real-time editing

;; Copyright (C) 2008 Phil Hagelberg

;; Author: Phil Hagelberg <technomancy@gmail.com>
;; URL: http://github.com/technomancy/conspire
;; Version: 0.2
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

;;; Installation:

;; Copy to your .emacs.d directory and add this to your init file:
;;
;;   (autoload 'conspire-mode "conspire" "Collaborative editing" t)

;; TODO: For some reason conspire-sync-buffer only runs on cursor movement
;; TODO: Gracefully kill shell process so it can clean up
;; TODO: Don't bother with *Async Shell Command* output buffer
;; TODO: Color lines based on which conspirator wrote them?

;;; Code:

(defcustom conspire-interval 0.25
  "Number of seconds to wait before syncing with conspire.")

(defcustom conspire-arguments ""
  "Arguments to pass the `conspire' executable, like port, name, etc.")

(defvar conspire-timer nil
  "A timer to activate conspire synchronizing.")

(defun conspire-sync-buffer ()
  "Synchronize buffer with Conspire repository."
  (when conspire-mode
    (when (buffer-modified-p)
      (save-buffer)
      (shell-command (format "git add %s && git commit -m \"conspire\""
                             buffer-file-name)))
    (revert-buffer nil t) ;; revert resets local variables; heh
    (cancel-timer conspire-timer)
    (conspire-mode t)))

;;;###autoload
(define-minor-mode conspire-mode
  "Toggle conspire-mode for real-time collaborative editing.

If the current buffer isn't part of a conspiracy session, a new
session will be started."
  :lighter "-conspire"
  (unless (file-exists-p (concat (file-name-directory buffer-file-name)
                                 ".conspire"))
    (save-window-excursion
      (shell-command (format "conspire %s %s >& /dev/null &"
                             (file-name-directory buffer-file-name)
                             conspire-arguments))))
  (setq conspire-timer
        (or conspire-timer
            (run-with-idle-timer conspire-interval :repeat
                                 'conspire-sync-buffer))))

(provide 'conspire)
;;; conspire.el ends here