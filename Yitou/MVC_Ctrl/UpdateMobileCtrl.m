//
//  UpdateMobileCtrl.m
//  Yitou
//
//  Created by Xiaohui on 15/9/14.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "UpdateMobileCtrl.h"

#import "LXHCountDownButton.h"
#import <XHHTextField.h>



#define CELLHeight   45

@interface UpdateMobileCtrl ()<UITextFieldDelegate,UIAlertViewDelegate,XHHTextFieldDelegate>

@end

@implementation UpdateMobileCtrl{
    XHHTextField *nowMobile;
    XHHTextField *newMobile;
    XHHTextField *newSmsCode;//旧手机验证码的textField
    XHHTextField *oldSmsCode;//新手机验证码的textField

    UserModel   *usrModel;
    float       orignY;
    NSTimer     *msgTime;
    CustomNavigation *customNav;
    LXHCountDownButton    *codeBtn;
    LXHCountDownButton    *oldBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BG_BLUEColor];
    self.title = @"更换手机";
    usrModel = [UserModel shareUserManager];
    [self loadAllView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEdit];
}

- (void)endEdit{
    [newMobile resignFirstResponder];
    [oldSmsCode resignFirstResponder];
    [newSmsCode resignFirstResponder];
}

- (void)loadAllView{
    orignY  = 75;
    nowMobile  = [[XHHTextField alloc] initWithFrame:CGRectMake(130, 0, SCREENWidth - 130, CELLHeight) image:nil];
    oldSmsCode = [[XHHTextField alloc] initWithFrame:CGRectMake(130, 0, SCREENWidth - 130, CELLHeight) image:nil];
    newMobile  = [[XHHTextField alloc] initWithFrame:CGRectMake(130, 0, SCREENWidth - 130, CELLHeight) image:nil];
    newSmsCode = [[XHHTextField alloc] initWithFrame:CGRectMake(130, 0, SCREENWidth- 130-120, CELLHeight) image:nil];
    [nowMobile setMaxLength:11];
    [newMobile setMaxLength:11];
    [newSmsCode setMaxLength:6];
    [oldSmsCode setMaxLength:6];
    [self loadViewWithTitle:@"当前绑定手机号" textField:nowMobile];
    [self loadViewWithTitle:@"当前手机验证码"    textField:oldSmsCode];
    [self loadViewWithTitle:@"请输入新手机号" textField:newMobile];
    [self loadViewWithTitle:@"新手机验证码"    textField:newSmsCode];

    [nowMobile setText:usrModel.mobile];
    nowMobile.text = usrModel.mobile;
    [nowMobile setUserInteractionEnabled:NO];

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
    if (!STRCMP(oldSmsCode.text,oldSmsCode.expectText)){
        [SVProgressHUD showErrorWithStatus:@"原手机验证码错误,请检查验证码或重新获取验证码"];
        return;
    }
    if (!STRCMP(newSmsCode.text, newSmsCode.expectText)||!newMobile.isCheck){
        [SVProgressHUD showErrorWithStatus:@"新手机的验证码错误,请检查验证码或重新获取验证码"];
        return;
    }

    NSMutableDictionary *paraDict = [NSMutableDictionary new];
    [paraDict setObject:@"set_verify_mobile" forKey:@"cmdid"];
    [paraDict setObject:@{@"new_mobile":newMobile.text,@"old_mobile":usrModel.mobile,@"client_id":KEY_CLIENTID,@"user_name":usrModel.userName,@"password":usrModel.password} forKey:@"data"];

   [HttpManager hmRequestWithPara:paraDict Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {

       if (rqCode != rqSuccess){
           [SVProgressHUD showErrorWithStatus:describle];
           return ;
       }
       [usrModel userDidChangeMobile:newMobile.text];
       if (STRCMP(USERDefineGet(KEY_LOGIN_NAME), usrModel.mobile)){
           USERDefineSet(newMobile.text, KEY_LOGIN_NAME);
       }
       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"修改成功" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
       [alertView show];
   }];
}

- (void)loadViewWithTitle:(NSString *)title textField:(XHHTextField *)tf{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, CELLHeight)];
    [view setBackgroundColor:[UIColor whiteColor]];
    UILabel *label = [FastFactory loadLabelWith:NSTextAlignmentLeft Frame:CGRectMake(10, 0, 120, CELLHeight) TextColor:[UIColor grayColor] fontSize:16];
    if (SCREENHeight < 500 && tf == newSmsCode)
        [tf setDelegate:self];
    [label setText:title];
    [view addSubview:label];
    [view addSubview:tf];
    [tf.textField setKeyboardType:UIKeyboardTypeNumberPad];

    if (tf == newSmsCode){
        codeBtn = [[LXHCountDownButton alloc] initWithFrame:CGRectMake(SCREENWidth - 120, 8, 100, VIEWFSH(newSmsCode) - 16) time:SEND_SMS_INTERVAL];
        [codeBtn addTarget:self action:@selector(sendVerifyNewMobile) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:codeBtn];
    }
    if (tf == oldSmsCode){
        oldBtn = [[LXHCountDownButton alloc] initWithFrame:CGRectMake(SCREENWidth - 120, 8, 100, VIEWFSH(newSmsCode) - 16) time:SEND_SMS_INTERVAL];
        [oldBtn addTarget:self action:@selector(sendVerifyOldMobile) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:oldBtn];
    }

    [self.view addSubview:view];
    orignY = VIEWFH_Y(view)+10;
}

//发送验证码给新手机
- (void)sendVerifyNewMobile{
    if (!CHECKMobile(newMobile.text)){
        [SVProgressHUD showErrorWithStatus:@"无效的手机号码"];
        return;
    }
    [newMobile setIsCheck:YES];
    [codeBtn waitStatus];
    [HttpManager sendMsgcodeWithPhone:newMobile.text Block:^(RequestResult rqCode, NSString *describle) {
        if (rqCode == rqSuccess){
            [SVProgressHUD showSuccessWithStatus:@"已发送"];
            newSmsCode.expectText = describle;
            [codeBtn startTimeCount];
            return ;
        }
        [codeBtn endTimeCount];
        [SVProgressHUD showErrorWithStatus:describle];
    }];
}

//发送验证码给当前的手机
- (void)sendVerifyOldMobile{
    [oldBtn waitStatus];
    [HttpManager sendMsgcodeWithPhone:nowMobile.text Block:^(RequestResult rqCode, NSString *describle) {
        if (rqCode == rqSuccess){
            [SVProgressHUD showSuccessWithStatus:@"已发送"];
            oldSmsCode.expectText = describle;
            [oldBtn startTimeCount];
            return ;
        }
        [oldBtn endTimeCount];
        [SVProgressHUD showErrorWithStatus:describle];
    }];
}

- (void)xhhTextFieldDidBeginEditing:(id)textField{
    [self.view setFrame:CGRectMake(0, -30, VIEWFSW(self.view), VIEWFSH(self.view))];
}

- (void)xhhTextFieldDidEndEditing:(id)textField{
    [self.view setFrame:CGRectMake(0, 0, VIEWFSW(self.view), VIEWFSH(self.view))];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
