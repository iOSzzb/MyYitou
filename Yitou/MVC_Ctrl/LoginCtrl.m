//
//  LoginCtrl.m
//  Yitou
//
//  Created by Xiaohui on 15/7/28.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "LoginCtrl.h"
#import "RegistFirstStepCtrl.h"
#import "LXHTextField.h"
#import "RegistThreeStepCtrl.h"
#import "ForgetPwdStepOne.h"
#import "CLLockVC.h"
#import "JPUSHService.h"

@interface LoginCtrl ()

@end

@implementation LoginCtrl{
    LXHTextField  *tfUserName;
    LXHTextField  *tfPassword;
    CustomNavigation *customNav;
    NSString *lastLoginName;
}

- (void)back{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.barTintColor = NAVIGATIONColor;
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
    self.title = @"登录";
    [self.view setBackgroundColor:BG_BLUEColor];
    [self loadTextField];
    [self loadButton];

    customNav = [[CustomNavigation alloc] init];
    [customNav customNavigationTitle:self.navigationController];
    tfUserName.text = USERDefineGet(KEY_LOGIN_NAME);
    if (!self.hidesBottomBarWhenPushed){
        [self.navigationItem setHidesBackButton:YES];
        return;
    }
    [customNav customNavigation:self.navigationItem block:^(NSInteger indx) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)gestureLogin{
        [CLLockVC showVerifyLockVCInVC:self forgetPwdBlock:^{
        } successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            NSLOG(@"密码正确");
            [lockVC dismiss:0];
            if ([pwd length]>3){
                tfPassword.text = USERDefineGet(KEY_LOGIN_PWD);
                [self clickLoginButton:nil];
            }
            else if(STRCMP(@"111", pwd)){
                [CLLockVC cleanPwd];
                [SVProgressHUD showSuccessWithStatus:@"请登录后前往我->安全中心->手势密码 中重新设置新的手势密码"];
            }
            else if(STRCMP(@"222", pwd)){

            }
            else if (STRCMP(@"333", pwd)){

            }
        }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.hidesBottomBarWhenPushed&&[UserModel shareUserManager].isLogin){
        [self performSelector:@selector(back) withObject:nil afterDelay:0.2];
        return;
    }
    tfUserName.text = USERDefineGet(KEY_LOGIN_NAME);
    lastLoginName = tfUserName.text;
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)clickForgetPwdBtn{
    ForgetPwdStepOne *forgetCtrl = [[ForgetPwdStepOne alloc] init];
    forgetCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:forgetCtrl animated:YES];
}

- (void)loadButton{

    UIButton *forgetBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWidth*2/3, VIEWFH_Y(tfPassword)+16, SCREENWidth/3, 14)];
    [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];

    [forgetBtn setTitleColor:[UIColor colorWithRed:0.3 green:0.66 blue:0.98 alpha:1] forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(clickForgetPwdBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];

    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(VIEWFOX(tfUserName), VIEWFH_Y(tfPassword)+46, VIEWFSW(tfUserName), 40)];
    [loginBtn setBackgroundImage:IMAGENAMED(@"login_btn_bg") forState:UIControlStateHighlighted];
    [loginBtn setBackgroundColor:COLORWithRGB(62, 158, 245, 1)];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];

    [loginBtn setTitleColor:COLORWithRGB(62, 158, 245, 1) forState:UIControlStateHighlighted];
    [self.view addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(clickLoginButton:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *regisBtn = [[UIButton alloc]initWithFrame:CGRectMake(VIEWFOX(loginBtn), VIEWFH_Y(loginBtn)+14, VIEWFSW(loginBtn), VIEWFSH(loginBtn))];
    [regisBtn setTitle:@"注册新用户" forState:UIControlStateNormal];
    [regisBtn setTitleColor:COLORWithRGB(42, 138, 225, 1) forState:UIControlStateNormal];
    [regisBtn setBackgroundImage:IMAGENAMED(@"login_btn_bg1") forState:UIControlStateNormal];
    [regisBtn addTarget:self action:@selector(clickRegisterBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regisBtn];
}

- (void)loadTextField{
    tfUserName = [[LXHTextField alloc] initWithFrame:CGRectMake(20, 96, SCREENWidth-40, 40)];
    [tfUserName loadLXHTextFieldWithLeftImageName:@"login_userName" defaultText:@"用户名"];
    [self.view addSubview:tfUserName];

    tfPassword = [[LXHTextField alloc] initWithFrame:CGRectMake(VIEWFOX(tfUserName), VIEWFH_Y(tfUserName)-1, VIEWFSW(tfUserName), VIEWFSH(tfUserName))];
    [tfPassword loadLXHTextFieldWithLeftImageName:@"login_pwd" defaultText:@"密码"];
    [tfPassword hideContent];
    [self.view addSubview:tfPassword];

    [tfUserName setBackgroundColor:[UIColor whiteColor]];
    [tfPassword setBackgroundColor:[UIColor whiteColor]];
}

- (BOOL)checkInputInvalue{
    [tfUserName hideKeyboard];
    [tfPassword hideKeyboard];
    NSString *regex = @"[a-zA-Z0-9_]{6,15}";
    if (!REGEXStr(regex, tfUserName.text)){
        [SVProgressHUD showErrorWithStatus:@"用户名/手机号格式不正确"];
        return NO;
    }
    if (!REGEXStr(regex, tfPassword.text)){
        [SVProgressHUD showErrorWithStatus:@"密码输入格式不正确,请输入6-16位密码"];
        return NO;
    }
    return YES;
}

- (void)clickRegisterBtn:(id)sender{
    RegistFirstStepCtrl *registCtrl = [[RegistFirstStepCtrl alloc]initWithNibName:nil bundle:nil];
    registCtrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registCtrl animated:YES];
}

- (void)clickLoginButton:(id)sender{
    if (![self checkInputInvalue]){
        return;
    }
    [SVProgressHUD showWithStatus:@"正在登录" maskType:SVProgressHUDMaskTypeBlack];
    [HttpManager loginWithUserName:tfUserName.text password:tfPassword.text Block:^(RequestResult rqCode, NSString *describle) {
        [SVProgressHUD dismiss];

        if (rqCode == rqSuccess){
            [self loginSuccess];
            return ;
        }
        [SVProgressHUD showErrorWithStatus:describle];
    }];
}

- (void)loginSuccess{
    [JPUSHService setAlias:[UserModel shareUserManager].userName callbackSelector:nil object:nil];
    [HttpManager getUserInformationByUserName:[UserModel shareUserManager].userName pwd:[UserModel shareUserManager].password Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        
    }];
    [HttpManager getHFInformationWithUserName:tfUserName.text pwd:tfPassword.text Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {

    }];
    if (STRCMP(lastLoginName, tfUserName.text)&&[lastLoginName length] > 1){
        [self performSelector:@selector(popToRootView) withObject:nil afterDelay:0.21];
        return;
    }
    [CLLockVC showSettingLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
        [lockVC dismiss:0.0f];
        [self performSelector:@selector(popToRootView) withObject:nil afterDelay:0.22];
    }];
}

- (void)popToRootView{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
