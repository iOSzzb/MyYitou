//
//  RechargeCtrl.m
//  Yitou
//
//  Created by Xiaohui on 15/8/20.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "RechargeCtrl.h"
#import "BankListView.h"
#import "WebBrower.h"
#import "InputMoneyText.h"

@interface RechargeCtrl ()<InputTextDelegate,UIGestureRecognizerDelegate,BankListDelegate>

@end

@implementation RechargeCtrl{
    UIScrollView *baseView;
    UIButton *cardDepost;
    UIButton *cardFast;
    BankListView *bankView;
    WebBrower *webBrower;
    UILabel *inputDesc;
    UIButton *rechargeBtn;
    InputMoneyText *moneyTextField;

    UILabel  *balanceLabel;
    CustomNavigation *customNav;
}

#pragma mark System Function

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BG_BLUEColor];
    _HFData =  [_HFData objectForKey:@"data"];
    self.title = @"充值";
    [self loadAllView];
}

- (void)touchedScrollview{
    [moneyTextField shouldHideKeyBoard];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchedScrollview];
}

#pragma mark BankListDelegate

- (void)bankListChangedBank{

}

- (void)bankListChangeHeight{
    [bankView setFrame:CGRectMake(0, VIEWFOY(bankView), SCREENWidth, bankView.viewHeight)];
    [self loadUserInfo:VIEWFH_Y(bankView)];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    // 输出点击的view的类名
    NSLOG(@"%@", NSStringFromClass([touch.view class]));

    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if (![NSStringFromClass([touch.view class]) isEqualToString:@"UITextField"]) {
        [self touchedScrollview];
        return NO;
    }
    return  NO;
}

#pragma mark 加载视图控件

- (void)loadAllView{
    baseView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
    [baseView setShowsVerticalScrollIndicator:NO];
    UIGestureRecognizer *gesture = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(touchedScrollview)];
    [baseView addGestureRecognizer:gesture];
    [gesture setDelegate:self];
    [baseView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:baseView];
    [self loadTopView];
}

- (void)loadTopView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREENWidth, 140)];
    [topView setBackgroundColor:[UIColor whiteColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 4, VIEWFSW(topView)-20, 15)];
    [label setText:@"温馨提示"];
    [label setFont:[UIFont fontWithName:SYSTEMFONTName size:14]];
    [label setTextColor:COLORWithRGB(255, 144, 2, 1)];
    [topView addSubview:label];

    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(VIEWFOX(label), VIEWFH_Y(label)-5, VIEWFSW(label), VIEWFSH(topView)- (VIEWFH_Y(label)+12))];
    NSString *str = @"1.为了您的账户安全,请在充值前进行身份认证丶手机绑定以及提现密码设置.\n2.您的账户资金将通过第三方平台进行充值.\n3.请注意您的银行卡充值限制,以免造成不变.\n4.禁止洗钱丶信用卡套现丶虚假交易等行为,一经发现并确认,将终止该账户的使用\n5.如果充值金额没有及时到账,请联系客服:400-027-8080";
    [textView setText:str];
    [textView setUserInteractionEnabled:NO];
    [textView setBackgroundColor:[UIColor clearColor]];
    [textView setFont:[UIFont fontWithName:SYSTEMFONTName size:11]];
    [textView setTextColor:COLORWithRGB(103, 103, 103, 1)];
    [textView setTextAlignment:NSTextAlignmentLeft];
    [topView addSubview:textView];
    [baseView addSubview:topView];
    [self loadBankListView:VIEWFH_Y(topView)];
}

- (void)loadBankListView:(float)orignY{
    bankView = [[BankListView alloc] initWithFrame:CGRectMake(0, orignY+10, SCREENWidth, 240)];
    [bankView loadBankList];

    [bankView setFrame:CGRectMake(VIEWFOX(bankView), VIEWFOY(bankView), VIEWFSW(bankView), bankView.viewHeight)];
    [bankView setDelegate:self];
    [baseView addSubview:bankView];
    [self loadUserInfo:VIEWFH_Y(bankView)];
}

- (void)loadUserInfo:(float)orignY{
    orignY = VIEWFH_Y(bankView);

    [self loadInputMoney:orignY];
}

- (void)loadInputMoney:(float)orignY{
    if (moneyTextField == nil){
        moneyTextField = [[InputMoneyText alloc] initWithFrame:CGRectMake(70, orignY + 20, SCREENWidth-90, 30)];
        [moneyTextField loadTextField];
        [moneyTextField setDelegate:self];
        [baseView addSubview:moneyTextField];
    }else{
        [moneyTextField setFrame:CGRectMake(VIEWFOX(moneyTextField), orignY + 20, VIEWFSW(moneyTextField), VIEWFSH(moneyTextField))];
    }
    [inputDesc removeFromSuperview];
    inputDesc = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEWFOY(moneyTextField), 70, VIEWFSH(moneyTextField)) ];
    inputDesc.text = @"充值金额";
    [inputDesc setTextAlignment:NSTextAlignmentCenter];
    [inputDesc setFont:[UIFont fontWithName:SYSTEMFONTName size:12]];
    [inputDesc setTextColor:COLORWithRGB(85, 85, 85, 1)];
    [baseView addSubview:inputDesc];
    [self loadBalanceAndButton];
}

- (void)loadBalanceAndButton{
    [balanceLabel removeFromSuperview];
    [rechargeBtn removeFromSuperview];
    UserModel *usrModel = [UserModel shareUserManager];
    balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, VIEWFH_Y(moneyTextField)+10, 200, 14)];
    [balanceLabel setFont:[UIFont fontWithName:SYSTEMFONTName size:12]];
    [balanceLabel setTextColor:COLORWithRGB(85, 85, 85, 1)];
    [balanceLabel setTextAlignment:NSTextAlignmentLeft];
    balanceLabel.text = [NSString stringWithFormat:@"当前可用余额:%@元",usrModel.balance];
    [baseView addSubview:balanceLabel];
    rechargeBtn = [[UIButton alloc] initWithFrame:CGRectMake(VIEWFOX(balanceLabel), VIEWFH_Y(balanceLabel)+10, SCREENWidth - VIEWFOX(balanceLabel)*2, 45)];
    [rechargeBtn setBackgroundColor:COLORWithRGB(52, 148, 245, 1)];
    [rechargeBtn setBackgroundImage:IMAGENAMED(@"login_btn_bg") forState:UIControlStateHighlighted];
    [rechargeBtn addTarget:self action:@selector(startRecharge:) forControlEvents:UIControlEventTouchUpInside];
    [rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
    [baseView addSubview:rechargeBtn];

    [baseView setContentSize:CGSizeMake(SCREENWidth, VIEWFH_Y(rechargeBtn)+80)];
}

- (void)startRecharge:(id)sender{
    if (![self checkInput])
        return;
    BankBtn *bank = bankView.bank;
    UserModel *usrModel = [UserModel shareUserManager];
    NSMutableDictionary *paraDict = [NSMutableDictionary new];
    [paraDict setValue:KEY_CLIENTID forKey:@"client_id"];
    [paraDict setValue:bank.bankCode forKey:@"open_bank_id"];
    [paraDict setValue:bank.bsCode forKey:@"gate_busi_id"];
    [paraDict setValue:moneyTextField.text forKey:@"trans_amt"];
    [paraDict setValue:usrModel.userID forKey:@"user_id"];

    NSDictionary *para = @{@"client_id":KEY_CLIENTID,@"open_bank_id":bank.bankCode,@"gate_busi_id":bank.bsCode,@"trans_amt":moneyTextField.text,@"user_id":usrModel.userID};
    para = @{@"cmdid":@"netsave",@"data":para};

    [HttpManager hmRequestWithPara:para Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        [SVProgressHUD dismiss];
        if (rqCode != rqSuccess){
            [SVProgressHUD showErrorWithStatus:describle];
            return ;
        }
        [self loadWebBrowerWithUrl:[[receiveData objectForKey:@"data"] objectForKey:@"r_url"]];
        NSLOG(@"receiveData = %@",receiveData);
    }];
}

- (void)loadWebBrowerWithUrl:(NSString*)url{
    webBrower = [[WebBrower alloc]initWithFrame:CGRectMake(0, 64, SCREENWidth, SCREENHeight-64)];
    [self.view addSubview:webBrower];
    [webBrower loadWebBrowerWithPostStr:url andBlock:^(NSInteger rtCode,NSString *newUrlStr) {
        NSLOG(@"%@",newUrlStr);
        NSString *desc;
        if (rtCode == 0){
            desc = @"充值成功";
        }
        if (rtCode == 11){
            desc = @"充值失败";
        }
        [webBrower removeFromSuperview];
        webBrower = nil;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:desc delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
    }];
}

- (void)InputTextEndEdit{
    [baseView setContentOffset:CGPointMake(0, VIEWFH_Y(moneyTextField)-400) animated:YES];
}

- (void)InputTextStartEdit{
    float h = VIEWFH_Y(moneyTextField)+286-SCREENHeight;
    [baseView setContentOffset:CGPointMake(0, h) animated:YES];
}

- (BOOL)checkInput{
    if (bankView.bank == nil){
        [SVProgressHUD showErrorWithStatus:@"请先选择银行!"];
        return NO;
    }
    if (!REGEXStr(@"^(-)?(([1-9]{1}\\d*)|([0]{1}))(\\.(\\d){1,2})?$", moneyTextField.text)){
        [SVProgressHUD showErrorWithStatus:@"输入的金额格式不正确"];
        return NO;
    }
    if ([moneyTextField.text floatValue]<1||[moneyTextField.text floatValue]>500000){
        [SVProgressHUD showErrorWithStatus:@"单笔充值金额请在1-500000之间"];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
