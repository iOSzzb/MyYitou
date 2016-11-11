//
//  BulletinContentCtrl.m
//  Yitou
//
//  Created by imac on 16/1/30.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "BulletinContentCtrl.h"

@interface BulletinContentCtrl ()

@end

@implementation BulletinContentCtrl{
    UIWebView *webview;
    CustomNavigation *customNav;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"公告详情";
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREENWidth, RELATIVE_Y(80))];
    [self.view addSubview:backView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, RELATIVE_Y(15), SCREENWidth, RELATIVE_Y(20))];
    [titleLab setText:self.titleStr];
    [titleLab setTextColor:[UIColor blackColor]];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [titleLab setFont:[UIFont systemFontOfSize:18]];
    [backView addSubview:titleLab];
    
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, RELATIVE_Y(40), SCREENWidth, RELATIVE_Y(20))];
    [timeLab setText:self.timeStr];
    [timeLab setTextColor:[UIColor grayColor]];
    [timeLab setTextAlignment:NSTextAlignmentCenter];
    [timeLab setFont:[UIFont systemFontOfSize:14]];
    [backView addSubview:timeLab];
    
    UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, RELATIVE_Y(80)-1, SCREENWidth, 1)];
    [lineLab setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1]];
    [backView addSubview:lineLab];

    webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, VIEWFH_Y(backView), SCREENWidth, SCREENHeight-RELATIVE_Y(80)-64)];
    [webview loadHTMLString:self.htmlContent baseURL:nil];
    webview.scalesPageToFit = YES;
    [self.view addSubview:webview];
    [webview.scrollView setAlwaysBounceVertical:YES];
    [webview.scrollView setAlwaysBounceHorizontal:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
