//
//  WebViewCtrl.m
//  Yitou
//
//  Created by mac on 15/11/27.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import "WebViewCtrl.h"
#import "MyBoxCtrl.h"
#import "InvestDetailCtrl.h"
#import "LoginCtrl.h"

#import <JavaScriptCore/JavaScriptCore.h>

//typedef void(^CallBack)(NSInteger code);

#define SUCCESS_REGISTER        @"成功"
#define SUCCESS_PAY             @"充值成功"

@interface WebViewCtrl ()<UIWebViewDelegate>

@end

@implementation WebViewCtrl{
    UIWebView *webView;
    BOOL isStart;
//    ValueIntegerBlock valueIntegerBlock;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

//- (void)webViewBlock:(void (^)(NSInteger))block{
//    callBack = block;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.barTintColor = NAVIGATIONColor;

    isStart = NO;
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
    [self.view setBackgroundColor:BG_BLUEColor];
    [self.navigationController.navigationBar setHidden:NO];
    [self setTitle:_name];

    [self loadAllView];

}

- (void)loadAllView{
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];

    [self.view addSubview:webView];

    NSURL *url = [NSURL URLWithString:_url];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [webView loadRequest:request];
    [webView setDelegate:self];
    [webView setScalesPageToFit:YES];
}

//- (void)sendCallBack:(NSInteger)code{
//    if (!callBack)
//        return;
//    callBack(code);
//}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView_{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    __weak typeof(self) weakSelf = self;
    context[@"Jump"] = ^(){
        NSLOG(@"立即投标");
        NSArray *args = [JSContext currentArguments];
        NSString *parameter = [NSString stringWithFormat:@"%@",args[0]];
       
        [weakSelf loadInvertDetailCtrlWithParameter:parameter];
    };
    context[@"Coupon"] = ^(){
        NSLOG(@"我的礼券");
        MyBoxCtrl *myBoxCtrl = [[MyBoxCtrl alloc] init];
        [self.navigationController pushViewController:myBoxCtrl animated:YES];
    };
    
    context[@"Join"] = ^(){
        if ([UserModel shareUserManager].isLogin){
//            [self.navigationController popToRootViewControllerAnimated:YES];
            self.tabBarController.selectedIndex = 0;
            return;
        }
        LoginCtrl *loginCtrl = [[LoginCtrl alloc] init];
        [loginCtrl setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:loginCtrl animated:YES];
    };
}

- (void)loadInvertDetailCtrlWithParameter:(NSString *)parameter{
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeBlack];
    __weak typeof(self) weakSelf = self;
    [HttpManager getInvestDetailWithID:parameter Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        [SVProgressHUD dismiss];
        if (rqCode == rqSuccess){
            Tender *tender = [[Tender alloc] init];
            [tender createTenderModel:receiveData];
            InvestDetailCtrl *invest = [[InvestDetailCtrl alloc] init];
            invest.tender = tender;
            invest.detail = receiveData;
            [invest setHidesBottomBarWhenPushed:YES];
            [weakSelf.navigationController pushViewController:invest animated:YES];
        }
        else{
            [SVProgressHUD showErrorWithStatus:describle];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
