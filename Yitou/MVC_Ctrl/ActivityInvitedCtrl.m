//
//  ActivityInvitedCtrl.m
//  Yitou
//
//  Created by mac on 16/1/29.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "ActivityInvitedCtrl.h"
#import <UIImageView+AFNetworking.h>

@interface ActivityInvitedCtrl ()

@end

@implementation ActivityInvitedCtrl{
    float height;
    UIButton *loginButton;
}

@synthesize scrollview;

- (void)viewDidLoad {
    [super viewDidLoad];
    scrollview = [super scrollview];
    [self setTitle:@"邀请好友活动"];
    [self loadAllView];
    [self loadRegisterButton];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [loginButton removeFromSuperview];
    if (![UserModel shareUserManager].isLogin)
        [self loadLoginButton];
    else{
        [self loadDidLoginView];
    }
}

- (void)clickCopyButton{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [UserModel shareUserManager].shareUrl;
    [SVProgressHUD showSuccessWithStatus:@"已经复制邀请链接到您的剪切板了"];
}

- (void)loadDidLoginView{
    height = 4211*SCREENWidth/1242;
    [super setImage:IMAGENAMED(@"actInvitedFri_Logined")];
    [super setImgHeight:height];
    [scrollview setContentSize:CGSizeMake(SCREENWidth, height)];

    UIImageView *qrImgv = [[UIImageView alloc] initWithFrame:CGRectMake((SCREENWidth - 140)/2, height - 180, 140, 140)];
    [qrImgv setBackgroundColor:[UIColor grayColor]];
    [scrollview addSubview:qrImgv];
    if ([UserModel shareUserManager].shareUrl != nil){
        NSString *urlStr = [QRCODE_URL stringByAppendingString:[UserModel shareUserManager].shareUrl];
        [qrImgv setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:nil];
    }else{
        [self loadShareUrlFor:qrImgv];
    }

    [self loadCopyButton];
}

- (void)loadShareUrlFor:(UIImageView *)imgv{
    UserModel *usrModel = [UserModel shareUserManager];
    NSDictionary *para = @{@"client_id":KEY_CLIENTID,@"user_name":usrModel.userName,@"password":usrModel.password};
    para = @{@"cmdid":@"userrecommenditem",@"data":para};
    [HttpManager hmRequestWithPara:para Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        if (rqCode != rqSuccess)
            return ;
        receiveData = [receiveData objectForKey:@"data"];
        NSString *shareStr = [receiveData objectForKey:@"fromUrl"];
        shareStr = [QRCODE_URL stringByAppendingString:shareStr];
        [[UserModel shareUserManager] setShareUrl:shareStr];
        [imgv setImageWithURL:[NSURL URLWithString:shareStr] placeholderImage:nil];
    }];
}

- (void)loadCopyButton{
    float orignY = 3272*SCREENWidth/1242;
    float orignX = 800*SCREENWidth/1242;
    UIButton *copyBtn = [[UIButton alloc] initWithFrame:CGRectMake(orignX, orignY, 250*SCREENWidth/1242, 40)];
    [copyBtn addTarget:self action:@selector(clickCopyButton) forControlEvents:UIControlEventTouchUpInside];
    [scrollview addSubview:copyBtn];
}

- (void)loadLoginButton{
    float orignY = 370*SCREENWidth/720;
    loginButton = [[UIButton alloc] initWithFrame:CGRectMake(70, height - orignY, 150, 40)];
    [loginButton setBackgroundColor:[UIColor clearColor]];
    [loginButton addTarget:self action:@selector(clickLoginButton) forControlEvents:UIControlEventTouchUpInside];
    [scrollview addSubview:loginButton];
}

- (void)loadRegisterButton{
    float orignY = 2346*SCREENWidth/1242;

//    orignY += 40;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, orignY, SCREENWidth - 200, 50)];
    [button setBackgroundColor:[UIColor clearColor]];
    [scrollview addSubview:button];
    [button addTarget:self action:@selector(clickRegisterButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadAllView{
    height = 3562*SCREENWidth/1242;
    [super setImage:IMAGENAMED(@"actInvitedFri")];
    [super setImgHeight:height];
    [scrollview setContentSize:CGSizeMake(SCREENWidth, height)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
