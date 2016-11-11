//
//  UpdateEmailCtrl.m
//  Yitou
//
//  Created by Xiaohui on 15/9/14.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "UpdateEmailCtrl.h"
#import "LXHCountDownButton.h"
#import <XHHTextField.h>


#define CELLHeight   45

@interface UpdateEmailCtrl ()<XHHTextFieldDelegate>

@end

@implementation UpdateEmailCtrl{
    XHHTextField *oldEmailTextField;
    XHHTextField *newEmailTextField;
    XHHTextField *emailCodeTextField;
    XHHTextField *smsCodeTextField;
    UserModel   *usrModel;
    float       orignY;
    NSString *mailCode;
    LXHCountDownButton *codeBtn;
    LXHCountDownButton *smsBtn;
    CustomNavigation *customNav;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BG_BLUEColor];
    self.title = @"邮箱绑定";
    usrModel = [UserModel shareUserManager];
    [self loadAllView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEdit];
}

- (void)endEdit{
    [newEmailTextField resignFirstResponder];
    [emailCodeTextField resignFirstResponder];
    [smsCodeTextField resignFirstResponder];
}

- (void)loadAllView{
    orignY  = 75;
    oldEmailTextField  = [[XHHTextField alloc] initWithFrame:CGRectMake(130, 0, SCREENWidth - 130, CELLHeight) image:nil];
    newEmailTextField  = [[XHHTextField alloc] initWithFrame:CGRectMake(130, 0, SCREENWidth - 130, CELLHeight) image:nil];
    emailCodeTextField = [[XHHTextField alloc] initWithFrame:CGRectMake(130, 0, SCREENWidth- 130-120, CELLHeight) image:nil];
    smsCodeTextField = [[XHHTextField alloc] initWithFrame:CGRectMake(130, 0, SCREENWidth- 130-120, CELLHeight) image:nil];
    [self loadViewWithTitle:@"当前邮箱" textField:oldEmailTextField];
    [self loadViewWithTitle:@"请输入新邮箱" textField:newEmailTextField];
    [self loadViewWithTitle:@"新邮箱验证码"    textField:emailCodeTextField];
    [self loadViewWithTitle:@"手机短信验证码"    textField:smsCodeTextField];

    [oldEmailTextField setText:usrModel.userEmail];
    [oldEmailTextField setUserInteractionEnabled:NO];

    UIButton *investBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, orignY+30, SCREENWidth - 40, 45)];
    [investBtn setBackgroundColor:COLORWithRGB(52, 148, 245, 1)];
    [investBtn setBackgroundImage:IMAGENAMED(@"login_btn_bg") forState:UIControlStateHighlighted];
    [investBtn addTarget:self action:@selector(clickUpdateBtn) forControlEvents:UIControlEventTouchUpInside];
    [investBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    [self.view addSubview:investBtn];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickUpdateBtn{
    if (!STRCMP(emailCodeTextField.text,emailCodeTextField.expectText)){
        [SVProgressHUD showErrorWithStatus:@"新邮箱验证码错误,请检查验证码或重新获取验证码"];
        return;
    }
    if (!STRCMP(smsCodeTextField.text, smsCodeTextField.expectText)){
        [SVProgressHUD showErrorWithStatus:@"手机短信验证码错误,请检查验证码或重新获取验证码"];
        return;
    }
    NSMutableDictionary *paraDict = [NSMutableDictionary new];
    [paraDict setObject:@"set_verify_email" forKey:@"cmdid"];
    [paraDict setObject:@{@"new_email":newEmailTextField.text,@"old_email":usrModel.userEmail,@"client_id":KEY_CLIENTID,@"user_name":usrModel.userName,@"password":usrModel.password} forKey:@"data"];

    [HttpManager hmRequestWithPara:paraDict Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {

        if (rqCode != rqSuccess) {
            [SVProgressHUD showErrorWithStatus:describle];
            return ;
        }
        usrModel.userEmail = newEmailTextField.text;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"修改成功" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
    }];
}

- (void)loadViewWithTitle:(NSString *)title textField:(XHHTextField *)tf{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, CELLHeight)];
    [view setBackgroundColor:[UIColor whiteColor]];
    UILabel *label = [FastFactory loadLabelWith:NSTextAlignmentLeft Frame:CGRectMake(10, 0, 120, CELLHeight) TextColor:[UIColor grayColor] fontSize:16];    
    [label setText:title];
    [view addSubview:label];
    [view addSubview:tf];
    if (SCREENHeight < 500 && tf == smsCodeTextField)
        [tf setDelegate:self];
    if (tf == emailCodeTextField){
        codeBtn = [[LXHCountDownButton alloc] initWithFrame:CGRectMake(SCREENWidth - 120, 8, 100, VIEWFSH(emailCodeTextField) - 16) time:SEND_EMAIL_INTERVAL];
        [codeBtn addTarget:self action:@selector(clickSendMsgCodeBtn) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:codeBtn];
    }
    if (tf == smsCodeTextField){
        smsBtn = [[LXHCountDownButton alloc] initWithFrame:CGRectMake(SCREENWidth - 120, 8, 100, VIEWFSH(emailCodeTextField) - 16) time:SEND_SMS_INTERVAL];
        [smsBtn addTarget:self action:@selector(clickSendSMSBtn) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:smsBtn];
    }
    [self.view addSubview:view];
    orignY = VIEWFH_Y(view)+10;
}

- (void)clickSendSMSBtn{
    [smsBtn waitStatus];
    
    [HttpManager sendMsgcodeWithPhone:[UserModel shareUserManager].mobile Block:^(RequestResult rqCode, NSString *describle) {
        if (rqCode == rqSuccess){
            [SVProgressHUD showSuccessWithStatus:@"已发送"];
            smsCodeTextField.expectText = describle;
            [smsBtn startTimeCount];
            return ;
        }
        [smsBtn endTimeCount];
        [SVProgressHUD showErrorWithStatus:describle];
    }];
}

- (void)clickSendMsgCodeBtn{
    NSString *rulls = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
    if (!REGEXStr(rulls, newEmailTextField.text)){
        [SVProgressHUD showErrorWithStatus:@"无效的邮箱"];
        return;
    }
    [newEmailTextField setIsCheck:YES];
    [emailCodeTextField becomeFirstResponder];
    NSMutableDictionary *paraDict = [NSMutableDictionary new];
    [paraDict setObject:@"send_email_verify_code" forKey:@"cmdid"];
    [paraDict setObject:@{@"email":newEmailTextField.text,@"client_id":KEY_CLIENTID,@"type":@"update",@"user_name":usrModel.userName,@"password":usrModel.password} forKey:@"data"];

    [SVProgressHUD showWithStatus:@"正在发送验证码到新的邮箱" maskType:SVProgressHUDMaskTypeBlack];
    [newEmailTextField setIsCheck:YES];
    [codeBtn waitStatus];
    [HttpManager hmRequestWithPara:paraDict Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {

        [SVProgressHUD dismiss];
        if (rqCode != rqSuccess) {
            [SVProgressHUD showErrorWithStatus:describle];
            [codeBtn endTimeCount];
            return ;
        }
        emailCodeTextField.expectText = [receiveData objectForKey:@"mail_code"];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"验证码已发送到您的新邮箱,请注意查收" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [codeBtn startTimeCount];
        [alert show];
    }];
}

- (BOOL)xhhTextFieldShouldBeginEditing:(id)textField{
    return YES;
}

- (void)xhhTextFieldDidBeginEditing:(id)textField{
    [self.view setFrame:CGRectMake(0, -50, VIEWFSW(self.view), VIEWFSH(self.view))];
}

- (void)xhhTextFieldDidEndEditing:(id)textField{
    [self.view setFrame:CGRectMake(0, 0, VIEWFSW(self.view), VIEWFSH(self.view))];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
