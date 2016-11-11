//
//  RegistSecondStepCtrl.m
//  Yitou
//
//  Created by Xiaohui on 15/8/17.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "RegistSecondStepCtrl.h"
#import "LXHTextField.h"
#import "RegistThreeStepCtrl.h"
#import "ProtocolWebCtrl.h"
#import "LXHCountDownButton.h"

@interface RegistSecondStepCtrl ()<UIAlertViewDelegate>

@end

@implementation RegistSecondStepCtrl{
    LXHTextField *tfPhone;
    LXHTextField *tfMsgCode;
    NSTimer *timer;
    UIImageView *agreeImgv;
    BOOL  isAgree;
    NSString *msgCode;
    NSString *phoneNum;//用来防止获取验证码后修改手机号再提交
    LXHCountDownButton *senderBtn;
    CustomNavigation *customNav;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self endEdit];
}

- (void)endEdit{
    [tfPhone hideKeyboard];
    [tfMsgCode hideKeyboard];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isAgree = NO;
    [self.view setBackgroundColor:BG_BLUEColor];
    [self loadAllView];
    self.title = @"绑定手机号码";
    [self performSelector:@selector(clickAgreeBtn) withObject:nil afterDelay:0.6];
}

- (void)loadAllView{
    tfPhone = [[LXHTextField alloc] initWithFrame:CGRectMake(20, 96, SCREENWidth-40, 44)];
    [tfPhone loadLXHTextFieldWithLeftImageName:@"login_userName" defaultText:@"手机号码"];
    [tfPhone lxhTextFieldSetKeyboardType:UIKeyboardTypeNumberPad andLength:16];
    tfPhone.isValid = NO;
    [self.view addSubview:tfPhone];

    tfMsgCode = [[LXHTextField alloc] initWithFrame:CGRectMake(VIEWFOX(tfPhone), VIEWFH_Y(tfPhone)-1, VIEWFSW(tfPhone), VIEWFSH(tfPhone))];
    [tfMsgCode loadLXHTextFieldWithLeftImageName:@"login_mobile" defaultText:@"验证码"];
    [tfMsgCode lxhTextFieldSetKeyboardType:UIKeyboardTypeNumberPad andLength:6];
    [self.view addSubview:tfMsgCode];
    [self loadSendMsgBtn];
    [self loadRegisterButton];
    [self loadAgreeView];
    [self loadLoginBtn];
}

- (void)loadLoginBtn{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 14)];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"已有账号?登录"];
    [attri addAttribute:NSForegroundColorAttributeName value:COLORWithRGB(85, 85, 85, 1) range:NSMakeRange(0, 5)];
    [attri addAttribute:NSForegroundColorAttributeName value:COLORWithRGB(62, 146, 227, 1) range:NSMakeRange(5, 2)];
    [attri addAttribute:NSFontAttributeName value:[UIFont fontWithName:SYSTEMFONTName size:12] range:NSMakeRange(0, 7)];

    [label setTextAlignment:NSTextAlignmentRight];
    [label setAttributedText:attri];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWidth-VIEWFOX(tfPhone)-90, VIEWFH_Y(tfMsgCode)+14, 90, 20)];
    [btn addSubview:label];
    [btn addTarget:self action:@selector(clickLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)loadAgreeView{
    agreeImgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    [agreeImgv setImage:IMAGENAMED(@"login_unCheck")];
    UILabel *agreeLB = [[UILabel alloc] initWithFrame:CGRectMake(VIEWFSW(agreeImgv)+4, 0, 145, 12)];
    [agreeLB setText:@"已阅读并同意《服务协议》"];
    [agreeLB setFont:[UIFont fontWithName:SYSTEMFONTName size:12]];
    [agreeLB setTextColor:COLORWithRGB(42, 138, 225, 1)];

    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(VIEWFOX(tfMsgCode), VIEWFH_Y(tfMsgCode)+14, 155, 25)];
    [btn addSubview:agreeLB];
    [btn addSubview:agreeImgv];
    [btn addTarget:self action:@selector(clickReadText) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    UIButton *checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(VIEWFOX(btn)-15, VIEWFOY(btn)-10, 40, 40)];
    [checkBtn addTarget:self action:@selector(clickAgreeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkBtn];
}

- (void)loadSendMsgBtn{
    senderBtn = [[LXHCountDownButton alloc] initWithFrame:CGRectMake(VIEWFW_X(tfMsgCode)-130, (VIEWFSH(tfMsgCode)-30)/2, 100, 30) time:SEND_SMS_INTERVAL];
    [senderBtn setBackgroundColor:COLORWithRGB(251, 66, 36, 1)];
    [senderBtn.titleLabel setFont:[UIFont fontWithName:SYSTEMFONTName size:14]];
    [senderBtn addTarget:self action:@selector(clickGetCodeBtn) forControlEvents:UIControlEventTouchUpInside];
    [tfMsgCode addSubview:senderBtn];
}

- (void)loadRegisterButton{
    UIButton *registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(VIEWFOX(tfMsgCode), VIEWFH_Y(tfMsgCode)+60, VIEWFSW(tfMsgCode), 40)];
    [registerBtn setBackgroundColor:COLORWithRGB(62, 158, 245, 1)];
    [registerBtn setBackgroundImage:IMAGENAMED(@"login_btn_bg") forState:UIControlStateHighlighted];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(clickRegisterBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];

    UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEWFH_Y(registerBtn)+14, SCREENWidth, 20)];
    [telLabel setText:@"客户热线:4008-650-760"];
    [telLabel setTextAlignment:NSTextAlignmentCenter];
    [telLabel setFont:[UIFont fontWithName:SYSTEMFONTName size:12]];
    [telLabel setTextColor:COLORWithRGB(85, 85, 85, 1)];
    [self.view addSubview:telLabel];
}

#pragma mark 点击事件
//点击了返回
- (void)clickLoginBtn{
    [self.navigationController popToViewController: [self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -3)] animated:YES];
}

//点击了服务协议
- (void)clickReadText{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"registerPro" ofType:@"html"];
    ProtocolWebCtrl *proWeb = [[ProtocolWebCtrl alloc] init];
    [proWeb loadWebViewWithProtocolPath:filePath baseUrl:@""];
    [self.navigationController pushViewController:proWeb animated:YES];
}

//点击了同意框框
- (void)clickAgreeBtn{
    isAgree = isAgree?NO:YES;
    NSString *imgName = isAgree?@"login_checked":@"login_unCheck";
    [agreeImgv setImage:IMAGENAMED(imgName)];

}

//点击了注册按钮
- (void)clickRegisterBtn{
    if (!STRCMP(tfPhone.text, phoneNum)||!STRCMP(tfMsgCode.text, msgCode)){
        [SVProgressHUD showErrorWithStatus:@"验证码错误,请重新获取验证码"];
        return;
    }
    if (!isAgree){
        [SVProgressHUD showErrorWithStatus:@"请阅读并接受《服务协议》!"];
        return;
    }
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc]initWithDictionary:_dataInfo];

    [postDict setValue:tfPhone.text forKey:@"mobile"];
    [postDict setValue:tfMsgCode.text forKey:@"msgcode"];
    [postDict setValue:KEY_CLIENTID forKey:@"client_id"];
    NSDictionary *para = @{@"cmdid":@"register",@"data":postDict};
    [SVProgressHUD showWithStatus:@"正在注册..." maskType:SVProgressHUDMaskTypeBlack];

    [HttpManager hmRequestWithPara:para Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        if (rqCode == rqSuccess)
            [self registerSuccess];
        else
            [SVProgressHUD showErrorWithStatus:describle];
    }];
}

//点击了发送短信验证码按钮
- (void)clickGetCodeBtn{
    [self endEdit];
    if (![self checkMobileInvild])
        return;
    [senderBtn waitStatus];
    [SVProgressHUD showWithStatus:@"正在检测手机号码是否有效" maskType:SVProgressHUDMaskTypeBlack];
    [senderBtn setUserInteractionEnabled:NO];
    [HttpManager checkPhoneNum:tfPhone.text Block:^(RequestResult rqCode, NSString *describle) {
        [SVProgressHUD dismiss];
        if (rqCode == rqSuccess){
            [SVProgressHUD showWithStatus:@"正在发送验证短信" maskType:SVProgressHUDMaskTypeBlack];
            [self startSendVerfiyCode];
        }
        else {
            [senderBtn endTimeCount];
            [SVProgressHUD showErrorWithStatus:describle];
            [senderBtn setUserInteractionEnabled:YES];
        }
    }];
}

- (void)startSendVerfiyCode{

    [HttpManager sendMsgcodeWithPhone:tfPhone.text Block:^(RequestResult rqCode, NSString *describle) {
        [SVProgressHUD dismiss];
        if (rqCode == rqSuccess){
            [SVProgressHUD showSuccessWithStatus:@"已发送短信验证码"];
            [senderBtn startTimeCount];
            phoneNum = tfPhone.text;
            msgCode = describle;
            return ;
        }
        [senderBtn endTimeCount];
        [SVProgressHUD showErrorWithStatus:describle];
    }];
}

- (BOOL)checkMobileInvild{
    [self endEdit];
    NSString *regex = @"[1][0-9]{10}";
    if (!REGEXStr(regex, tfPhone.text)){
        [SVProgressHUD showErrorWithStatus:@"无效的手机号码"];
        return NO;
    }
    return YES;
}

- (BOOL)checkInput{
    return YES;
}

- (void)checkMobileUnuse{
    [SVProgressHUD showWithStatus:@"正在检查手机号是否可用" maskType:SVProgressHUDMaskTypeBlack];
    [HttpManager checkPhoneNum:tfPhone.text Block:^(RequestResult rqCode, NSString *describle) {

        [SVProgressHUD dismiss];
        switch (rqCode) {
            case rqSuccess:tfPhone.isValid = YES;break;
            default:tfPhone.isValid = NO;[SVProgressHUD showSuccessWithStatus:describle];break;
        }
    }];
}

- (void)registerSuccess{
    [HttpManager loginWithUserName:[_dataInfo objectForKey:@"user_name"] password:[_dataInfo objectForKey:@"password"] Block:^(RequestResult rqCode, NSString *describle) {
        [SVProgressHUD dismiss];
        if (rqCode == rqSuccess){
            USERDefineSet([_dataInfo objectForKey:@"user_name"], KEY_LOGIN_NAME);
            RegistThreeStepCtrl *endCtrl = [[RegistThreeStepCtrl alloc] init];
            [self.navigationController pushViewController:endCtrl animated:YES];
        }
        else{
            [SVProgressHUD showErrorWithStatus:describle];
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView tag] == 1024){
        [self clickLoginBtn];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
