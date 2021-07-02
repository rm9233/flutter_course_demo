import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class KWebView extends StatefulWidget {
  final String url;
  final Function callback;
  final Function onWebViewCreated;

  const KWebView({Key key, this.url, this.callback,this.onWebViewCreated}) : super(key: key);
  @override
  _KWebViewState createState() => _KWebViewState();
}

class _KWebViewState extends State<KWebView> {

  WebViewController _controller;

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }


  Map<String,String> getParms(String url){
    // ? &
    Map<String,String> map = new Map();
    String parmsUrl = url.substring(url.indexOf("?")+1,url.length);
    if(parmsUrl.indexOf("&")!=-1){
      List<String> list = parmsUrl.split("&");
      for(int i =0;i<list.length;i++){
        List l = list[i].split("=");
        map[l[0]] = l[1];
      }

      print(map.toString());
    }else{
      List l = parmsUrl.split("=");
      map[l[0]] = l[1];
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return  WebView(
      initialUrl: widget.url, // 加载的url
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (controller) {
        _controller = controller;
        if(widget.onWebViewCreated!=null){
          widget.onWebViewCreated(controller);
        }
      },
      navigationDelegate: (NavigationRequest request) {
        if (request.url.startsWith('js://webview')) {
          print('blocking navigation to $request}');
          Map parms = getParms(request.url);
          if(parms.containsKey("type")){
            if(parms["type"] == "loaded"){
              widget.callback(parms["type"],"");
            }
            if(parms["type"] == "star"){
              widget.callback(parms["type"],"");
            }
            if(parms["type"] == "canvas"){
              widget.callback(parms["type"],parms["url"]);
            }
            if(parms["type"] == "word"){
              widget.callback(parms["type"],{"index":parms["index"],"parms":parms["parms"]});
            }
            if(parms["type"] == "sentence"){
              widget.callback(parms["type"],{"index":parms["index"],"parms":parms["parms"]});
            }
            if(parms["type"] == "stop"){
              widget.callback(parms["type"],"");
            }
            if(parms["type"] == "play"){
              widget.callback(parms["type"],parms["index"]);
            }
            if(parms["type"] == "total"){
              widget.callback(parms["type"],"");
            }
            if(parms["type"] == "restart"){
              widget.callback(parms["type"],"");
            }
            if(parms["type"] == "word_star"){
              widget.callback(parms["type"],{"index":parms["index"],"parms":parms["parms"]});
            }
            if(parms["type"] == "close"){
              widget.callback(parms["type"],"");
            }
          }
          return NavigationDecision.prevent;
        }
        print('allowing navigation to $request');
        return NavigationDecision.navigate;
      },
      onPageFinished: (String value) {
        // webview 页面加载调用
      },
    );


  }
}
