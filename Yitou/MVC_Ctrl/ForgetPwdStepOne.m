//
//  ForgetPwdStepOne.m
//  Yitou
//
//  Created by Xiaohui on 15/9/24.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import "ForgetPwdStepOne.h"
#import "LXHTextField.h"
#import "ForgetPwdStepTwo.h"
#import "LXHCountDownButton.h"

@interface ForgetPwdStepOne (){
    LXHTextField *tfUsrName;
    LXHTextField *tfMobile;
    LXHTextField *tfVerify;
    LXHCountDownButton *sendBtn;
    NSString *codeMobile;
    NSTimer  *msgTime;
    CustomNavigation *customNav;
}

@end

@implementation ForgetPwdStepOne

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BG_BLUEColor];
    [self loadAllView];
    self.title = @"找回密码";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEdit];
}

- (void)endEdit{
    [tfUsrName hideKeyboard];
    [tfVerify hideKeyboard];
    [tfMobile hideKeyboard];
}

- (void)loadAllView{
    tfUsrName = [[LXHTextField alloc] initWithFrame:CGRectMake(20, 96, SCREENWidth-40, 50)];
    [tfUsrName loadLXHTextFieldWithLeftImageName:@"login_userName" defaultText:@"请输入您的用户名"];
    [self.view addSubview:tfUsrName];
    [tfUsrName setBackgroundColor:[UIColor whiteColor]];

    tfMobile = [[LXHTextField alloc] initWithFrame:CGRectMake(20, VIEWFH_Y(tfUsrName)-1, VIEWFSW(tfUsrName), 50)];
    [tfMobile loadLXHTextFieldWithLeftImageName:@"login_mobile" defaultText:@"请输入您的手机号"];
    [tfMobile lxhTextFieldSetKeyboardType:UIKeyboardTypeNumberPad andLength:11];
    [self.view addSubview:tfMobile];
    [tfMobile setBackgroundColor:[UIColor whiteColor]];

    tfVerify = [[LXHTextField alloc] initWithFrame:CGRectMake(20, VIEWFH_Y(tfMobile)-1, SCREENWidth-40, 50)];
    [tfVerify loadLXHTextFieldWithLeftImageName:@"login_mobile" defaultText:@"请输入验证码"];
    [tfVerify lxhTextFieldSetKeyboardType:UIKeyboardTypeNumberPad andLength:6];
    [self.view addSubview:tfVerify];
    [tfVerify setBackgroundColor:[UIColor whiteColor]];

    sendBtn = [[LXHCountDownButton alloc] initWithFrame:CGRectMake(VIEWFW_X(tfVerify)-130, (VIEWFSH(tfVerify)-30)/2, 100, 30) time:SEND_SMS_INTERVAL];
    [sendBtn setNormalColor:COLORWithRGB(251, 66, 36, 1)];
    [sendBtn.titleLabel setFont:[UIFont fontWithName:SYSTEMFONTName size:14]];

    [sendBtn addTarget:self action:@selector(clickGetCodeBtn) forControlEvents:UIControlEventTouchUpInside];
    [tfVerify  addSubview:sendBtn];

    [self loadButton];
}

- (void)loadButton{
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(VIEWFOX(tfVerify), VIEWFH_Y(tfVerify)+46, VIEWFSW(tfVerify), 40)];
    [loginBtn setBackgroundImage:IMAGENAMED(@"login_btn_bg") forState:UIControlStateHighlighted];
    [loginBtn setBackgroundColor:COLORWithRGB(62, 158, 245, 1)];
    [loginBtn setTitle:@"下一步" forState:UIControlStateNormal];
    //    [loginBtn setTitleColor:COLORWithRGB(42, 138, 225, 1) forState:UIControlStateNormal];
    [loginBtn setTitleColor:COLORWithRGB(62, 158, 245, 1) forState:UIControlStateHighlighted];
    [self.view addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(clickNextStep) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickNextStep{
    [self endEdit];
    NSString *usrValue = [NSString stringWithFormat:@"%@%@",tfMobile.text,tfVerify.text];
    if (!STRCMP(usrValue, codeMobile)||[usrValue length]<12){
        [SVProgressHUD showErrorWithStatus:@"短信验证码不正确"];
        return;
    }
    ForgetPwdStepTwo *forgetCtrl = [[ForgetPwdStepTwo alloc] init];
    forgetCtrl.usrName = tfUsrName.text;
    forgetCtrl.mobile =tfMobile.text;
    [self.navigationController pushViewController:forgetCtrl animated:YES];
}

- (void)clickGetCodeBtn{
    [self endEdit];
    if (!CHECKMobile(tfMobile.text)){
        [SVProgressHUD showErrorWithStatus:@"手机号码格式不正确,请重试!"];
        return;
    }
    [self requestSendPwd];
}

- (void)requestSendPwd{
    [self endEdit];
    NSMutableDictionary *paraDict = [NSMutableDictionary new];
    [paraDict setObject:@"send_mobile_get_pwd" forKey:@"cmdid"];
    [paraDict setObject:@{@"mobile":tfMobile.text,@"client_id":KEY_CLIENTID,@"user_name":tfUsrName.text} forKey:@"data"];
    [sendBtn waitStatus];
    [HttpManager hmRequestWithPara:paraDict Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        if (rqCode != rqSuccess){
            [SVProgressHUD showErrorWithStatus:describle];
            [sendBtn endTimeCount];
            return ;
        }
        [sendBtn startTimeCount];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"成功" message:@"已发送短信验证码到手机,请注意查收" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
        codeMobile = [NSString stringWithFormat:@"%@%@",tfMobile.text,[receiveData objectForKey:@"sms_code"]];
        NSLOG(@"%@",[receiveData objectForKey:@"sms_code"]);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
