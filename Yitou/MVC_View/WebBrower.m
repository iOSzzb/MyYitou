//
//  WebBrower.m
//  Analysize
//
//  Created by Xiaohui on 15/7/27.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "WebBrower.h"
#import "LXHDefine.h"


#define TOOLHeight  0

@implementation WebBrower{
    UIView *toolView;
    WebBrowerBlock block__;
    UIWebView *webView__;
}

- (id)loadWebBrowerWithPostStr:(NSString *)postStr andBlock:(WebBrowerBlock)block{
    postStr = [postStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    postStr = [postStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:postStr]];
//    postStr = [postStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    webView__ = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, VIEWFSW(self), VIEWFSH(self)-TOOLHeight)];
    block__ = block;
    NSURL *url = [NSURL URLWithString:postStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    [request setHTTPMethod:@"POST"];
    [webView__ loadRequest:request];
    [webView__ setDelegate:self];
    [webView__ setScalesPageToFit:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap:)];
    [self addGestureRecognizer:tap];

    [self addSubview:webView__];
    return self;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
// 先留着这段代码 汇付结果页可能会用到
//    NSString * JsToGetHTMLSource = @"top.location.href";
//    NSString * pageSource = [webView__ stringByEvaluatingJavaScriptFromString:JsToGetHTMLSource];
//    NSLOG(@"pageSource = %@",pageSource);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeBlack];
//    NSURL *url = [request URL];
    NSLOG(@"new url : %@",[[request URL] absoluteString]);
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
    NSString *strA = [webView stringByEvaluatingJavaScriptFromString: @"document.documentElement.innerHTML"];
    NSLOG(@"%@",strA);
    NSInteger strLen = strA.length;
    strA = [strA stringByReplacingOccurrencesOfString:SUCCESS_REGISTER withString:@""];
    strA = [strA stringByReplacingOccurrencesOfString:SUCCESS_PAY withString:@""];
    if (strA.length != strLen){
        block__(0,SUCCESS_REGISTER);
        return;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [SVProgressHUD showErrorWithStatus:@"加载失败..."];
    [self removeFromSuperview];
}

@end
