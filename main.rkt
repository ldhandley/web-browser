#lang at-exp codespells

(provide uri-encode)

(require web-browser/mod-info
         net/uri-codec
         website-js)

(require-mod dev-runes)
(require-mod hierarchy)

(provide serve-html-url
         show-location)

(define (serve-html-url html)
  (~a "http://localhost:8081/serve-html?html=" (uri-encode (element->string html))))

(define-classic-rune (web-browser url)
  #:background "blue"
  #:foreground (rectangle 50 40 'solid 'blue)
 (thunk
   @unreal-js{
 (function(){
  const uclass = require('uclass')().bind(this,global);
  class ThreeDWidget extends Root.ResolveClass("3DWidget") {
                                                     
  }      
  let ThreeDWidget_C = uclass(ThreeDWidget);
  var widget = new ThreeDWidget_C(GWorld,{X:@(current-x), Y:@(current-z), Z:@(current-y)});
  widget.GetComponentByClass(WidgetComponent).Widget.WebBrowser.InitialURL = "@url";
  return widget;
  })()})
  )

; create-location-shower and show-location are demos of how
; you can create UI that is aware of the state of the game in Unreal.
; TODO: cleanup and document the message queue in codespells-server/lang.
(define (create-location-shower)
  (web-browser
   (serve-html-url
    (enclose
     (div id: (id 'output))
     (script ([construct (call 'constructor)])
             (function (constructor)
                       @js{
 fetch("http://localhost:8081/messages/last")
 .then(response => response.json())
 .then(data => {document.getElementById(@(~j "NAMESPACE_output")).innerHTML = JSON.stringify(data)});
 }))))))

(define (show-location)
  @unreal-js{
 (function(){ 
  var ret = @(create-location-shower);

  let HttpHelper = Root.ResolveClass("HttpHelper");
  let helper = new HttpHelper(GWorld);
  helper.Post("http://localhost:8081/messages",
              JSON.stringify({message:{location: ret.GetActorLocation()}}));
 
  return ret
  })()
  })

(define-classic-rune-lang my-mod-lang #:eval-from main.rkt
  (web-browser))

(module+ main
  (codespells-workspace ;TODO: Change this to your local workspace if different
   (build-path (current-directory) ".." ".."))
  
  (once-upon-a-time
   #:world (arena-world)
   #:aether (demo-aether
             #:lang (append-rune-langs #:name main.rkt
                                       (my-mod-lang #:with-paren-runes? #t)
                                       (dev-runes:my-mod-lang)
                                       (hierarchy:my-mod-lang)))))
