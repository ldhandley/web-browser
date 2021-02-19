#lang codespells

(provide mod-name pak-folder main.rkt)

(require racket/runtime-path)

(define
  mod-name
  "WebBrowser")

(define-runtime-path
  pak-folder
  "BuildUnreal/WindowsNoEditor/WebBrowser/Content/Paks/")

(define-runtime-path
  main.rkt
  "main.rkt")

(setup-mod mod-name pak-folder)
