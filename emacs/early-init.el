;;; early-init.el --- Early initialization -*- lexical-binding: t; -*-

;; Increase garbage collection threshold during startup for speed
(setq gc-cons-threshold (* 50 1000 1000))

;; Disable UI chrome before it even renders
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; Prevent package.el from activating packages before init.el loads
(setq package-enable-at-startup nil)

(provide 'early-init)
;;; early-init.el ends here
