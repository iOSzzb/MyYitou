//
//  RegistThreeStepCtrl.m
//  Yitou
//
//  Created by Xiaohui on 15/8/31.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "RegistThreeStepCtrl.h"
#import "WebBrower.h"

@interface RegistThreeStepCtrl ()<UIAlertViewDelegate>

@end

@implementation RegistThreeStepCtrl{
    UIView *baseView;
    WebBrower *webBrower;
    CustomNavigation *customNav;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BG_BLUEColor];
    [self loadAllView];
    self.title = @"注册成功";
    
    customNav = [[CustomNavigation alloc] init];
    [customNav customNavigationTitle:self.navigationController];
    [customNav customNavigation:self.navigationItem block:^(NSInteger indx) {
        if ([webBrower tag] == 111){
            [webBrower removeFromSuperview];
            [webBrower setTag:100];
            return ;
        }
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (void)loadAllView{
    baseView = [[UIView alloc] initWithFrame:CGRectMake(20, 140, SCREENWidth - 40, 160)];
    [baseView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:baseView];
    [self loadTextView];
}

- (void)loadTextView{
    NSInteger orignX = (VIEWFSW(baseView)-10-140-30)/2;
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(orignX, 40, 30, 30)];
    [imgv setImage:IMAGENAMED(@"status_success")];
    [baseView addSubview:imgv];
    UILabel *textLB = [FastFactory loadLabelWith:NSTextAlignmentLeft Frame:CGRectMake(orignX+30+10, 40, 140, 30) TextColor:[UIColor blackColor] fontSize:16];
    textLB.text = @"恭喜你,已注册成功!";
    [baseView addSubview:textLB];

    UIButton *lfBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, VIEWFSW(baseView)/2-40, 30)];
    [lfBtn setTitle:@"返回首页" forState:UIControlStateNormal];
    [lfBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lfBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [lfBtn setBackgroundColor:COLORWithRGB(49, 140, 222, 1)];
    [lfBtn addTarget:self action:@selector(clickLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self loadBorderForBtn:lfBtn];
    [baseView addSubview:lfBtn];

    UIButton *rtBtn = [[UIButton alloc] initWithFrame:CGRectMake(VIEWFSW(baseView)/2+20, 100, VIEWFSW(baseView)/2-40, 30)];
    [rtBtn setTitle:@"汇付开户" forState:UIControlStateNormal];
    [rtBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rtBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [rtBtn setBackgroundColor:COLORWithRGB(248, 68, 48, 1)];
    [rtBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self loadBorderForBtn:rtBtn];
    [baseView addSubview:rtBtn];
}

- (void)loadBorderForBtn:(UIButton *)btn{
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:4];
}

- (void)clickLeftBtn:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)clickRightBtn:(id)sender{
    UserModel *usrModel = [UserModel shareUserManager];
    [HttpManager getHFInformationWithUserName:usrModel.userName pwd:usrModel.password Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        if ([[receiveData objectForKey:@"result_code"] integerValue] == 58){
            webBrower = [[WebBrower alloc] initWithFrame:CGRectMake(0, 64, SCREENWidth, SCREENHeight-64)];
            [self.view addSubview:webBrower];
            [webBrower setTag:111];
            [webBrower loadWebBrowerWithPostStr:[[receiveData objectForKey:@"data"] objectForKey:@"r_url"] andBlock:^(NSInteger rtCode,NSString *newUrlStr) {
                NSLOG(@"newUrl:%@",newUrlStr);
                if (rtCode == 0){
                    [self loadAlertView];
                }
                if (rtCode == 11){
                    [webBrower removeFromSuperview];
                    webBrower = nil;
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"汇付开户失败" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                    [alertView show];
                    [webBrower removeFromSuperview];
                    webBrower = nil;
                }
            }];
        }
    }];
}

- (void)loadAlertView{
    [webBrower removeFromSuperview];

    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"注册完成" message:@"恭喜你已完成实名认证" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alertCtrl addAction:okAction];
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self clickLeftBtn:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
