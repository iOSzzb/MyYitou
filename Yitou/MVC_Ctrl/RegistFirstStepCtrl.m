//
//  RegistFirstStepCtrl.m
//  Yitou
//
//  Created by Xiaohui on 15/8/14.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "RegistFirstStepCtrl.h"
#import "RegistSecondStepCtrl.h"
#import "IPDetector.h"

@interface RegistFirstStepCtrl ()

@end

@implementation RegistFirstStepCtrl{
    LXHTextField *tfUserName;
    LXHTextField *tfPassword;
    LXHTextField *tfVerifyPw;
    LXHTextField *tfFriendID;
    NSString *ipAdress;
    CustomNavigation *customNav;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BG_BLUEColor];
    [self loadTextField];
    [self loadButton];
    ipAdress = @"0.0.0.0";
    [IPDetector getWANIPAddressWithCompletion:^(NSString *IPAddress) {
        ipAdress = IPAddress;
    }];
    self.title = @"设置个人信息";
}

- (void)loadButton{
    UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(VIEWFOX(tfUserName), VIEWFH_Y(tfFriendID)+36, VIEWFSW(tfUserName), 40)];
    [nextBtn setBackgroundImage:IMAGENAMED(@"login_btn_bg") forState:UIControlStateHighlighted];
    [nextBtn setBackgroundColor:COLORWithRGB(62, 158, 245, 1)];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];

    [nextBtn setTitleColor:COLORWithRGB(62, 158, 245, 1) forState:UIControlStateHighlighted];
    [nextBtn addTarget:self action:@selector(clickNextStepButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
}

- (void)clickNextStepButton{
    [self endEdit];
    if (![self checkInput])
        return;
    NSMutableDictionary *userDict = [NSMutableDictionary new];
    [userDict setObject:tfUserName.text forKey:@"user_name"];
    [userDict setObject:tfPassword.text forKey:@"password"];

    [userDict setObject:ipAdress forKey:@"reg_ip"];
    if ([tfFriendID.text length] != 0)
        [userDict setObject:tfFriendID.text forKey:@"from_user"];
    RegistSecondStepCtrl *nextStep = [[RegistSecondStepCtrl alloc] initWithNibName:nil bundle:nil];

    nextStep.dataInfo = userDict;
    [self.navigationController pushViewController:nextStep animated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self endEdit];
}

- (void)endEdit{
    [tfUserName hideKeyboard];
    [tfPassword hideKeyboard];
    [tfVerifyPw hideKeyboard];
    [tfFriendID hideKeyboard];
}

- (void)loadTextField{
    tfUserName = [[LXHTextField alloc] initWithFrame:CGRectMake(20, 96, SCREENWidth-40, 44)];
    [tfUserName loadLXHTextFieldWithLeftImageName:@"login_userName" defaultText:@"用户名"];
    [tfUserName lxhTextFieldSetKeyboardType:UIKeyboardTypeDefault andLength:16];
    [self.view addSubview:tfUserName];

    tfPassword = [[LXHTextField alloc] initWithFrame:CGRectMake(VIEWFOX(tfUserName), VIEWFH_Y(tfUserName)-1, VIEWFSW(tfUserName), VIEWFSH(tfUserName))];
    [tfPassword loadLXHTextFieldWithLeftImageName:@"login_pwd" defaultText:@"输入密码"];
    [tfPassword lxhTextFieldSetKeyboardType:UIKeyboardTypeDefault andLength:16];
    [tfPassword hideContent];
    [self.view addSubview:tfPassword];

    tfVerifyPw = [[LXHTextField alloc] initWithFrame:CGRectMake(VIEWFOX(tfPassword), VIEWFH_Y(tfPassword)-1, VIEWFSW(tfPassword), VIEWFSH(tfPassword))];
    [tfVerifyPw loadLXHTextFieldWithLeftImageName:@"login_pwd" defaultText:@"确认密码"];
    [tfVerifyPw lxhTextFieldSetKeyboardType:UIKeyboardTypeDefault andLength:16];
    [tfVerifyPw hideContent];
    [self.view addSubview:tfVerifyPw];

    tfFriendID = [[LXHTextField alloc] initWithFrame:CGRectMake(VIEWFOX(tfVerifyPw), VIEWFH_Y(tfVerifyPw)-1, VIEWFSW(tfVerifyPw), VIEWFSH(tfVerifyPw))];
    [tfFriendID loadLXHTextFieldWithLeftImageName:@"login_invitedFriend" defaultText:@"邀请人"];
    [self.view addSubview:tfFriendID];

    [tfUserName setBackgroundColor:[UIColor whiteColor]];
    [tfPassword setBackgroundColor:[UIColor whiteColor]];
    [tfVerifyPw setBackgroundColor:[UIColor whiteColor]];
    [tfFriendID setBackgroundColor:[UIColor whiteColor]];

    [tfUserName setTag:0];
    [tfPassword setTag:1];
    [tfVerifyPw setTag:2];
    [tfFriendID setTag:3];

    [tfUserName setIsValid:NO];
    [tfPassword setIsValid:NO];
    [tfVerifyPw setIsValid:NO];
    [tfFriendID setIsValid:YES];//默认为空

    [tfUserName setDelegate:self];
    [tfPassword setDelegate:self];
    [tfVerifyPw setDelegate:self];
    [tfFriendID setDelegate:self];
}

- (void)LXHTextFieldDidEndEdit:(NSInteger)tag{
    if (tfUserName.tag == tag && [self checkUserNameInvalid]){
        [HttpManager checkUserName:tfUserName.text Block:^(RequestResult rqCode, NSString *describle) {
            switch (rqCode) {
                case rqSuccess:tfUserName.isValid = YES;NSLOG(@"changed validUserNameValue = yes");break;
                case rqError:tfUserName.isValid = NO;NSLOG(@"3 validUserNameValue = no");[SVProgressHUD showErrorWithStatus:describle];break;
                default:tfUserName.isValid = NO;[SVProgressHUD showErrorWithStatus:describle];break;
            }
        }];
    }
    if (tfFriendID.tag == tag && [self checkFriendID]){
        [HttpManager checkUserName:tfFriendID.text Block:^(RequestResult rqCode, NSString *describle) {
            switch (rqCode) {
                case rqSuccess:tfFriendID.isValid = NO;[SVProgressHUD showErrorWithStatus:@"推荐人不存在!"];break;//推荐人未注册
                case rqError:tfFriendID.isValid = YES;break;//推荐人已注册
                default:tfFriendID.isValid = NO;[SVProgressHUD showErrorWithStatus:describle];break;
            }
        }];
    }
}

- (BOOL)checkUserNameInvalid{
    NSString *regStr = @"[0-9a-zA-Z_]{6,16}";
    if (!REGEXStr(regStr, tfUserName.text)){
        [SVProgressHUD showErrorWithStatus:@"用户名格式不正确,请使用6-16位数字/字母/下划线"];
        tfUserName.isValid = NO;
        return NO;
    }
    return YES;
}

- (BOOL)checkFriendID{
    if ([tfFriendID.text length]==0){
        tfFriendID.isValid = YES;
        return NO;
    }
    return YES;
}

- (BOOL)checkPasswordInvalid{
    NSString *regex = @"[a-zA-Z0-9_]{6,15}";
    if (!REGEXStr(regex, tfPassword.text)){
        [SVProgressHUD showErrorWithStatus:@"请输入6-16位密码,由数字/大小写字母组成"];
        return NO;
    }
    if (!STRCMP(tfPassword.text, tfVerifyPw.text)){
        [SVProgressHUD showErrorWithStatus:@"两次密码输入不一致!"];
        return NO;
    }
    return YES;
}

- (BOOL)checkMsgcodeInvalid{
    return YES;
}

- (BOOL)checkInput{
    if (!tfUserName.isValid){
        [SVProgressHUD showErrorWithStatus:@"用户名已注册了,请重新输入"];
        return NO;
    }
    if (!tfFriendID.isValid){
        [SVProgressHUD showErrorWithStatus:@"邀请人不存在!"];
        return NO;
    }
    return [self checkPasswordInvalid];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
