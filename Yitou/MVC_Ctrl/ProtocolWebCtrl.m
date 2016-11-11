//
//  ProtocolWebCtrl.m
//  Yitou
//
//  Created by Xiaohui on 15/11/3.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import "ProtocolWebCtrl.h"

@interface ProtocolWebCtrl ()

@end

@implementation ProtocolWebCtrl{
    UIWebView *webview;
    CustomNavigation *customNav;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"合同协议";
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.barTintColor = NAVIGATIONColor;

    customNav = [[CustomNavigation alloc] init];
    [customNav customNavigationTitle:self.navigationController];
    [customNav customNavigation:self.navigationItem block:^(NSInteger indx) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)loadWebViewWithProtocolPath:(NSString *)path baseUrl:(NSString *)baseUrl{
    webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
    NSString *filePath = path;
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [webview loadHTMLString:htmlString baseURL:[NSURL URLWithString:baseUrl]];
    [self.view addSubview:webview];
    [webview.scrollView setAlwaysBounceVertical:YES];
    [webview.scrollView setAlwaysBounceHorizontal:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
