//
//  ViewController.m
//  JSBridgeOC
//
//  Created by 尹现伟 on 15/4/17.
//  Copyright (c) 2015年 尹现伟. All rights reserved.
//

#import "ViewController.h"
#import "WebViewJavascriptBridge.h"

@interface ViewController ()
@property (strong, nonatomic) WebViewJavascriptBridge *javascriptBridge;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    UIWebView* webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    
    [self.view insertSubview:webView atIndex:0];
    
    [self loadExamplePage:webView];
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
    
}

- (IBAction)sendMsg:(id)sender {
    
    [_javascriptBridge send:@"从OC发送一条消息" responseCallback:^(id response) {
        
        NSLog(@"send返回结果是: %@", response);
        
    }];
}

- (void)loadExamplePage:(UIWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp2" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    [webView loadHTMLString:appHtml baseURL:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
