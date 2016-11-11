//
//  ForgetPwdStepTwo.m
//  Yitou
//
//  Created by Xiaohui on 15/9/25.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import "ForgetPwdStepTwo.h"
#import "LXHTextField.h"

@interface ForgetPwdStepTwo ()

@end

@implementation ForgetPwdStepTwo{
    CustomNavigation *customNav;
    LXHTextField *tfPassword;
    LXHTextField *tfNewPwd;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEdit];
}

- (void)endEdit{
    [tfPassword resignFirstResponder];
    [tfNewPwd resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BG_BLUEColor];
    [self loadAllView];
    self.title = @"设置新密码";
}

- (void)loadAllView{
    [self loadTextField];
    [self loadButton];
}

- (void)loadButton{
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(VIEWFOX(tfNewPwd), VIEWFH_Y(tfNewPwd)+26, VIEWFSW(tfNewPwd), 40)];
    [loginBtn setBackgroundImage:IMAGENAMED(@"login_btn_bg") forState:UIControlStateHighlighted];
    [loginBtn setBackgroundColor:COLORWithRGB(62, 158, 245, 1)];
    [loginBtn setTitle:@"确认修改" forState:UIControlStateNormal];

    [loginBtn setTitleColor:COLORWithRGB(62, 158, 245, 1) forState:UIControlStateHighlighted];
    [self.view addSubview:loginBtn];
    [loginBtn addTarget:self action:@selector(clickResetPassworkBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickResetPassworkBtn{
    [self endEdit];
    if (![self checkInput])
        return;
    NSDictionary *para = @{@"cmdid":@"user_phone_get_password",@"data":@{@"user_name":_usrName,@"mobile":_mobile,@"password":tfNewPwd.text,@"client_id":KEY_CLIENTID}};
    [HttpManager hmRequestWithPara:para Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {

        if (rqCode != rqSuccess){
            [SVProgressHUD showErrorWithStatus:describle];
            return ;
        }

        UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"" message:@"密码设置成功,请牢记您的新密码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];

    }];
}

- (BOOL)checkInput{
    if ([tfPassword.text length]<6||[tfPassword.text length]>16){
        [SVProgressHUD showErrorWithStatus:@"请输入6-16位长度的密码"];
        return NO;
    }
    if (!STRCMP(tfPassword.text, tfNewPwd.text)){
        [SVProgressHUD showErrorWithStatus:@"两次密码输入不一致,请重新输入"];
        return NO;
    }
    return YES;
}

- (void)loadTextField{
    tfPassword = [[LXHTextField alloc] initWithFrame:CGRectMake(20, 80, SCREENWidth - 40, 40)];
    [tfPassword loadLXHTextFieldWithLeftImageName:@"login_pwd" defaultText:@"请输入新的密码"];
    [tfPassword hideContent];
    [tfPassword lxhTextFieldSetKeyboardType:UIKeyboardTypeDefault andLength:16];
    [self.view addSubview:tfPassword];

    tfNewPwd = [[LXHTextField alloc] initWithFrame:CGRectMake(20, VIEWFH_Y(tfPassword)+20, SCREENWidth - 40, 40)];
    [tfNewPwd loadLXHTextFieldWithLeftImageName:@"login_pwd" defaultText:@"请再次输入新的密码"];
    [tfNewPwd hideContent];
    [tfNewPwd lxhTextFieldSetKeyboardType:UIKeyboardTypeDefault andLength:16];
    [self.view addSubview:tfNewPwd];

    [tfNewPwd setBackgroundColor:[UIColor whiteColor]];
    [tfPassword setBackgroundColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
