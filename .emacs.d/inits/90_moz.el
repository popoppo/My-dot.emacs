(autoload 'moz-minor-mode "moz" "Mozilla Minor and Inferior Mozilla Modes" t)
(moz-minor-mode t)

(setq moz-repl-host "dhcp044.local.hde.co.jp")

(defun moz-send-message (moz-command)
  (comint-send-string
   (inferior-moz-process)
   (concat moz-repl-name ".pushenv('printPrompt', 'inputMode'); "
           moz-repl-name ".setenv('inputMode', 'line'); "
           moz-repl-name ".setenv('printPrompt', false); undefined; "))
  (comint-send-string
   (inferior-moz-process)
   (concat moz-command
           moz-repl-name ".popenv('inputMode', 'printPrompt'); undefined;\n")))

(defun moz-scrolldown ()
  (interactive)
   (moz-send-message "goDoCommand('cmd_scrollLineDown');\n"))
(global-set-key (kbd "<C-next>") 'moz-scrolldown)

(defun moz-scrollup ()
  (interactive)
   (moz-send-message "goDoCommand('cmd_scrollLineUp');\n"))
(global-set-key (kbd "C-<prior>") 'moz-scrollup)

(defun moz-close-tab-or-window ()
  (interactive)
  (comint-send-string (inferior-moz-process) "BrowserCloseTabOrWindow();"))
;(global-set-key (kbd "C-M-c") 'moz-close-tab-or-window)
(global-set-key (kbd "C-<f6>") 'moz-close-tab-or-window)

(defun moz-undo-close-tab ()
  (interactive)
  (comint-send-string (inferior-moz-process) "undoCloseTab();"))
;(global-set-key (kbd "C-M-u") 'moz-undo-close-tab)

(defun moz-reload ()
  (interactive)
  (comint-send-string (inferior-moz-process) "BrowserReload();"))
(global-set-key (kbd "C-<f5>") 'moz-reload)

(defun moz-next-tab ()
  (interactive)
  (moz-send-message "getBrowser().mTabContainer.advanceSelectedTab(1, true);\n"))
(global-set-key (kbd "<C-S-next>") 'moz-next-tab)

(defun moz-prev-tab ()
  (interactive)
  (moz-send-message "getBrowser().mTabContainer.advanceSelectedTab(-1, true);\n"))
(global-set-key (kbd "<C-S-prior>") 'moz-prev-tab)

(defun my:http-url-encode (str content-type)
  "URL encode STR using CONTENT-TYPE as the coding system."
  (apply 'concat
     (mapcar (lambda (c)
           (if (or (and (>= c ?a) (<= c ?z))
               (and (>= c ?A) (<= c ?Z))
               (and (>= c ?0) (<= c ?9)))
               (string c)
               (format "%%%02x" c)))
         (encode-coding-string str content-type))))

(defun moz-open-uri-in-new-tab (uri &optional param)
  (interactive)
  (let ((p (if param param "")))
    (moz-send-message
     (concat
      "gBrowser.selectedTab = gBrowser.addTab();\n"
      (format
       "content.location=\"%s%s\";\n"
       uri
       (my:http-url-encode p 'utf-8))))))

(defun moz-google-search (word)
  (interactive "sSearch Word @ googlc : ")
  (moz-open-uri-in-new-tab "http://www.google.co.jp/search?hl=ja&q=" word))
(global-set-key (kbd "<C-f11>") 'moz-google-search)
(key-chord-define-global (kbd "zg") 'moz-google-search)

(defun moz-alc-search (word)
  (interactive "sSearch Word @ alc: ")
  (moz-open-uri-in-new-tab "http://eow.alc.co.jp/search?q=" word))
(global-set-key (kbd "<C-f12>") 'moz-alc-search)
(key-chord-define-global (kbd "zw") 'moz-alc-search)


(defun moz-hok ()
  (interactive)
  (moz-send-message "KeySnail.modules.ext.exec(\"hok-start-foreground-mode\", null);"))
(key-chord-define-global (kbd "zh") 'moz-hok)

(defun moz-send-chars ()
  (interactive)
  (let ((chars (string-to-list (read-from-minibuffer "chars:")))
        (cnt 0))
    (while chars
      (sleep-for 0.3)
      (moz-send-message (format "var event = document.createEvent(\"KeyboardEvent\");event.initKeyEvent(\"keypress\", true, false, null, false, false, false, false, %d, %d);document.dispatchEvent(event);" (car chars) (car chars)))
      (setq chars (cdr chars))
      )))
(key-chord-define-global (kbd "zm") 'moz-send-chars)