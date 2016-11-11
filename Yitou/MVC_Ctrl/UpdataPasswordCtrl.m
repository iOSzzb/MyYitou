//
//  UpdataPasswordCtrl.m
//  Yitou
//
//  Created by Xiaohui on 15/9/11.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "UpdataPasswordCtrl.h"


#define CELLHeight   45

@interface UpdataPasswordCtrl ()<UIAlertViewDelegate,UITextFieldDelegate>

@end

@implementation UpdataPasswordCtrl{
    UITextField *nowPwd;
    UITextField *newPwd;
    UITextField *surePwd;
    float orignY;
    CustomNavigation *customNav;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BG_BLUEColor];
    self.title = @"修改密码";
    [self loadAllView];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField.text length]<17||[string length] == 0){
        return YES;
    }
    else{
        [SVProgressHUD showErrorWithStatus:@"密码长度不能超过16位数!"];
        return NO;
    }
}

- (void)loadAllView{
    orignY = 75;
    nowPwd  = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, SCREENWidth - 90, CELLHeight)];
    newPwd  = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, SCREENWidth - 90, CELLHeight)];
    surePwd = [[UITextField alloc] initWithFrame:CGRectMake(90, 0, SCREENWidth - 90, CELLHeight)];
    [self loadViewWithTitle:@"当前密码" textField:nowPwd];
    [self loadViewWithTitle:@"新密码" textField:newPwd];
    [self loadViewWithTitle:@"确认密码" textField:surePwd];

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
    [nowPwd resignFirstResponder];
    [newPwd resignFirstResponder];
    [surePwd resignFirstResponder];
    if (!STRCMP(newPwd.text, surePwd.text)){
        [SVProgressHUD showErrorWithStatus:@"两次密码输入不一致,请重新输入"];
        newPwd.text = @"";
        surePwd.text = @"";
        return;
    }
    if ([surePwd.text length]<6||[surePwd.text length]>16){
        [SVProgressHUD showErrorWithStatus:@"密码长度需要大于6位数并且小于16位数"];
        newPwd.text = @"";
        surePwd.text = @"";
        return;
    }
    [self updatePwd:newPwd.text oldPwd:nowPwd.text];
}

- (void)loadViewWithTitle:(NSString *)title textField:(UITextField *)tf{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, CELLHeight)];
    [view setBackgroundColor:[UIColor whiteColor]];
    UILabel *label = [FastFactory loadLabelWith:NSTextAlignmentLeft Frame:CGRectMake(10, 0, 70, CELLHeight) TextColor:[UIColor grayColor] fontSize:16];
    [tf setDelegate:self];
    [label setText:title];
    [view addSubview:label];

    [view addSubview:tf];
    [tf setSecureTextEntry:YES];
    [self.view addSubview:view];
    orignY = VIEWFH_Y(view)+10;
}

- (void)updatePwd:(NSString *)pwd oldPwd:(NSString *)oldPwd{
    UserModel *usrModel = [UserModel shareUserManager];
    NSMutableDictionary *paraDict = [NSMutableDictionary new];
    [paraDict setObject:@"setpassword" forKey:@"cmdid"];
    [paraDict setObject:@{@"user_name":usrModel.userName,@"password":oldPwd,@"new_password":pwd,@"client_id":KEY_CLIENTID} forKey:@"data"];


    [HttpManager hmRequestWithPara:paraDict Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {

        if (rqCode != rqSuccess) {
            [SVProgressHUD showErrorWithStatus:describle];
            return ;
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"修改成功,请使用新密码" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        USERDefineSet(newPwd.text, KEY_LOGIN_PWD);

        [usrModel loginSuccessWithName:usrModel.userName pwd:newPwd.text];
        [alertView show];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
