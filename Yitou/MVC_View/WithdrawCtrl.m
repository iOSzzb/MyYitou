//
//  WithdrawCtrl.m
//  Yitou
//
//  Created by Xiaohui on 15/8/21.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "WithdrawCtrl.h"
#import "InputMoneyText.h"
#import "WebBrower.h"

@interface WithdrawCtrl ()

@end

@implementation WithdrawCtrl{
    InputMoneyText *moneyText;
    UILabel *balanceLB;
    WebBrower *webBrower;
    float   balance;//余额
    CustomNavigation *customNav;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    balance = 133.00;
    [self.view setBackgroundColor:BG_BLUEColor];
    self.title = @"提现";
    [self loadAllView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [moneyText shouldHideKeyBoard];
}

- (void)loadAllView{
    UIView *baseView = [[ UIView alloc] initWithFrame:CGRectMake(0, 74, SCREENWidth, 100)];
    [baseView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:baseView];
    UserModel *usrModel = [UserModel shareUserManager];
    balanceLB = [FastFactory loadLabelWith:NSTextAlignmentLeft Frame:CGRectMake(20, 10, SCREENWidth-20, 20) TextColor:COLORWithRGB(85, 85, 85, 1) fontSize:14];
    [balanceLB setText:[NSString stringWithFormat:@"当前可用余额:%@元",usrModel.balance]];
    [baseView addSubview:balanceLB];

    UILabel *msgLB = [FastFactory loadLabelWith:NSTextAlignmentLeft Frame:CGRectMake(VIEWFOX(balanceLB), VIEWFSH(baseView)/2+4, 60, 30) TextColor:COLORWithRGB(85, 85, 85, 1) fontSize:14];
    [msgLB setText:@"取现金额"];
    [baseView addSubview:msgLB];

    float sizeWidth = SCREENWidth;
    sizeWidth -= VIEWFW_X(msgLB);
    sizeWidth -= 20;

    moneyText = [[InputMoneyText alloc] initWithFrame:CGRectMake(VIEWFW_X(msgLB), VIEWFSH(baseView)/2, sizeWidth, 35)];
    [moneyText loadTextField];
    [moneyText setInputMax:[usrModel.balance floatValue]];
    [baseView addSubview:moneyText];

    UIButton *rechargeBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, VIEWFH_Y(baseView)+10, SCREENWidth-40, 45)];
    [rechargeBtn setBackgroundColor:COLORWithRGB(52, 148, 245, 1)];
    [rechargeBtn setBackgroundImage:IMAGENAMED(@"login_btn_bg") forState:UIControlStateHighlighted];
    [rechargeBtn addTarget:self action:@selector(startWithdraw:) forControlEvents:UIControlEventTouchUpInside];
    [rechargeBtn setTitle:@"提现" forState:UIControlStateNormal];
    [self.view addSubview:rechargeBtn];
}

- (void)startWithdraw:(id)sender{
    [moneyText shouldHideKeyBoard];
    if (![self checkInput])
        return;
    NSDictionary *para;

    para = @{@"client_id":KEY_CLIENTID,@"user_name":[UserModel shareUserManager].mobile,@"password":[UserModel shareUserManager].password,@"trans_amt":moneyText.text};
    para = @{@"cmdid":@"usercash",@"data":para};
    [HttpManager hmRequestWithPara:para Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        [SVProgressHUD dismiss];
        if (rqCode != rqSuccess){
            [SVProgressHUD showErrorWithStatus:describle];
            return ;
        }
        [self loadWebBrowerWithUrl:[[receiveData objectForKey:@"data"] objectForKey:@"r_url"]];
        NSLOG(@"%@",receiveData);
    }];

}

- (void)loadWebBrowerWithUrl:(NSString*)url{
    webBrower = [[WebBrower alloc]initWithFrame:CGRectMake(0, 64, SCREENWidth, SCREENHeight-64)];
    [self.view addSubview:webBrower];
    [webBrower loadWebBrowerWithPostStr:url andBlock:^(NSInteger rtCode,NSString *newUrlStr) {
        NSLOG(@"%@",newUrlStr);
        NSString *desc;
        if (rtCode == 0){
            desc = @"提现申请成功,请耐心等待";
            [webBrower removeFromSuperview];
            webBrower = nil;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:desc delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}

- (BOOL)checkInput{
    if (!REGEXStr(@"^(-)?(([1-9]{1}\\d*)|([0]{1}))(\\.(\\d){1,2})?$", moneyText.text)){
        [SVProgressHUD showErrorWithStatus:@"输入的金额格式不正确"];
        return NO;
    }
    if ([moneyText.text floatValue]<2){
        [SVProgressHUD showErrorWithStatus:@"提现金额应不低于2元"];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
