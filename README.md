# JSBridgeOC
JS和OC的交互By WebViewJavascriptBridge

    //实例化WebViewJavascriptBridge并定义native端的默认消息处理器
    /*
     * 默认必须写的，JS调用OC，返回一个参数 data
     * 如果不想返回参数 则将handler的参数制成null
     */
      _javascriptBridge = [WebViewJavascriptBridge bridgeForWebView:webView handler:^(id data, WVJBResponseCallback responseCallback) {
        //返回的参数在这里进行OC的代码编写
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    }];
    
    /*
     *JS调用OC时必须写的，注册一个JS调用OC的方法
     */
    //注册一个供UI端调用的名为testObjcCallback的处理器，并定义用于响应的处理逻辑
    [_javascriptBridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        //
        NSLog(@"testObjcCallback called: %@", data);
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"收到JS的消息" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
        
        responseCallback(@"Response from testObjcCallback");
    }];

    //发送一条消息给UI端并定义回调处理逻辑
    //    [_javascriptBridge send:@"A string sent from ObjC before Webview has loaded." responseCallback:^(id responseData) {
    //        NSLog(@"objc got response! %@", responseData);
    //    }];
    
    //调用一个在UI端定义的名为testJavascriptHandler的处理器，没有定义回调
    //    [_javascriptBridge callHandler:@"testJavascriptHandler" data:[NSDictionary dictionaryWithObject:@"before ready" forKey:@"foo"]];
    
    //单纯发送一条消息给UI端
    //    [_javascriptBridge send:@"A string sent from ObjC after Webview has loaded."];

参考：[http://blog.csdn.net/zyjn2014/article/details/25074611](http://blog.csdn.net/zyjn2014/article/details/25074611)

使用的库：[WebViewJavascriptBridge](https://github.com/marcuswestin/WebViewJavascriptBridge)
