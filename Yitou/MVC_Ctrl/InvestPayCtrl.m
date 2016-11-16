//
//  InvestPayCtrl.m
//  Yitou
//
//  Created by Xiaohui on 15/8/27.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "InvestPayCtrl.h"
#import "InputMoneyText.h"
#import "CalcualtorMoney.h"
#import "WebBrower.h"
#import "ProtocolWebCtrl.h"
#import "CouponCtrl.h"
#import "ImageLoder.h"
#import "ContractVC.h"

#define CELLHeight  51

@interface InvestPayCtrl ()<InputTextDelegate>

@end

@implementation InvestPayCtrl{
    BOOL            isAgree;
    UIView          *descView;
    WebBrower       *webBrower;
    InputMoneyText  *moneyText;
    CalcualtorMoney *calculator;
    UserModel       *userModel;
    UILabel         *earnRateLB;
    UILabel         *earnCountLB;
    UILabel         *couponLB;
    NSInteger       orignY;
    UIImageView     *agreeImgv;
    UIScrollView    *scrollview;
    NSDictionary    *couponInfo;
    CouponCtrl      *couponCtrl;
    CustomNavigation *customNav;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [calculator loadDataSource:_dataSource coupon:0.0];
    NSString *couponStr = @"";
    if (couponCtrl.addCoupon >0.0){
        couponStr = [NSString stringWithFormat:@"%.2f",couponCtrl.addCoupon];
        if ([couponCtrl.jiaxiTypeId isEqualToString:@"52"]) {
            couponStr = [couponStr stringByAppendingString:@"%黄金加息券"];
        }
        else {
            couponStr = [couponStr stringByAppendingString:@"%加息券"];
        }
        [calculator loadDataSource:_dataSource coupon:couponCtrl.addCoupon];
    }
    if (couponCtrl.addMoney >0.0){
        NSString *temp;
        if (couponCtrl.hongbaoID != nil && couponCtrl.hongbaoID.length > 0) {
            temp = [NSString stringWithFormat:@"%.2f元新手注册红包",couponCtrl.addMoney];

        }
        else {
            temp = [NSString stringWithFormat:@"%.2f元现金券",couponCtrl.addMoney];
        }
        if ([couponStr length]>1){
            couponStr = [NSString stringWithFormat:@"%@,%@",couponStr,temp];
        }
        else
            couponStr = temp;
    }
    if ([couponStr length] == 0){
        couponStr = @"";
    }
    couponLB.text = couponStr;
    [couponLB setTextColor:[UIColor blackColor]];
    if (([[couponInfo objectForKey:@"jiaxijuan"] count] > 0 || [[couponInfo objectForKey:@"xianjinjuan"] count] > 0)&&[couponStr length] == 0){
        [couponLB setText:@"有可用的优惠券"];
        [couponLB setTextColor:[UIColor colorWithRed:0.16 green:0.55 blue:0.88 alpha:1]];
    }
    else if ([couponStr length] == 0){
        [couponLB setText:@"无可用的优惠券"];
    }

    [self InputTextChange];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BG_BLUEColor];
    self.title = @"立即投资";

    userModel = [UserModel shareUserManager];
    calculator = [[CalcualtorMoney alloc] init];
    [calculator loadDataSource:_dataSource coupon:0.0];
    [self loadAllView];
    if (!_tender.isExp)
        [self performSelector:@selector(loadCouponList) withObject:nil afterDelay:0.4];
    [self clickAgreeBtn];
    [self performSelector:@selector(loadBelongView) withObject:nil afterDelay:0.8];
}

- (void)loadBelongView{
    if (![_tender checkBelongValid])
        return;
    if (STRCMP([UserModel shareUserManager].userID, _tender.belongUserID)){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入约标密码" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            [textField setSecureTextEntry:YES];
            [textField setPlaceholder:@"约标密码"];
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textField = [[alert textFields] objectAtIndex:0];
            if (!STRCMP(textField.text, _tender.borrowPassword)){
                [SVProgressHUD showErrorWithStatus:@"约标密码不正确"];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [self showAlert];
    }
}

- (void)showAlert{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法投资该标" message:@"这是一个预约的标,您可以在预约有效期之后进行投资" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 *  加载优惠券数据
 */
- (void)loadCouponList{
    [SVProgressHUD showWithStatus:@"正在加载优惠活动信息" maskType:SVProgressHUDMaskTypeBlack];
    NSDictionary *para = @{@"cmdid":@"prize_use_list",@"data":@{@"user_name":userModel.userName,@"password":userModel.password,@"client_id":KEY_CLIENTID,@"borrow_id":_tender.tenderID}};
    [HttpManager hmRequestWithPara:para Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        [SVProgressHUD dismiss];
        if (rqCode != rqSuccess){
            [SVProgressHUD showErrorWithStatus:describle];
            return ;
        }

        couponInfo = receiveData;
        [calculator loadTouziquanActivity:[receiveData objectForKey:@"touzijuan"]];
        if ([[couponInfo objectForKey:@"jiaxijuan"] count] > 0 || [[couponInfo objectForKey:@"xianjinjuan"] count] > 0){
            [couponLB setText:@"有可用的优惠券"];
            [couponLB setTextColor:[UIColor colorWithRed:0.16 green:0.55 blue:0.88 alpha:1]];
        }

        couponCtrl = [[CouponCtrl alloc] init];
        //[couponCtrl loadCouponWithJiaxiData:[couponInfo objectForKey:@"jiaxijuan"] xianjin:[couponInfo objectForKey:@"xianjinjuan"]];
        [couponCtrl loadCouponWithJiaxiData:[couponInfo objectForKey:@"jiaxijuan"] xianjin:[couponInfo objectForKey:@"xianjinjuan"] hongbao:[couponInfo objectForKey:@"xianjinhongbao"]];
    }];
}

- (void)loadAllView{
    scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
    [scrollview setShowsVerticalScrollIndicator:NO];
    [scrollview setBackgroundColor:BG_BLUEColor];
    [self.view addSubview:scrollview];
    [self loadTopView];
    [self loadAgreeView];
    [self loadButton];
    [self loadSmallText];
    [self loadDescribleView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchScrollview)];
    [scrollview addGestureRecognizer:tapGesture];
}

/**
 *  点击了ScrollView
 */
- (void)touchScrollview{
    [moneyText shouldHideKeyBoard];
}

- (void)loadDescribleView{
    orignY += 10;
    [scrollview setContentSize:CGSizeMake(SCREENWidth, orignY+90)];
    if ([_tender checkBelongValid]||_tender.isExp)
        return;
    descView = [[UIView alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, SCREENHeight)];
    [descView setBackgroundColor:[UIColor whiteColor]];
    [scrollview addSubview:descView];
    float height = orignY;
    orignY = 5;
    //------3.17  ---- 如果是高息标详情界面则不显示下面内容
    if (![[_dataSource objectForKey:@"borrow_type_remark"] isEqualToString:@"高息标"]) {
        BOOL imgBool = [[_dataSource objectForKey:@"initiative_img_bl"] boolValue];
        if (imgBool) {
            [self loadRateImage];
        }
        
        if ([[_dataSource objectForKey:@"initiative_reward_bl"] boolValue]) {
            [self loadCellWithImageName:[_dataSource objectForKey:@"initiative_reward1_img"] text:[_dataSource objectForKey:@"initiative_reward1_content"]];
            [self loadCellWithImageName:[_dataSource objectForKey:@"initiative_reward2_img"] text:[_dataSource objectForKey:@"initiative_reward2_content"]];
//            [self loadCellWithImageName:[_dataSource objectForKey:@"initiative_reward3_img"] text:[_dataSource objectForKey:@"initiative_reward3_content"]];
//            [self loadCellWithImageName:[_dataSource objectForKey:@"initiative_reward4_img"] text:[_dataSource objectForKey:@"initiative_reward4_content"]];
        }
    }
    
    orignY += height;
    [scrollview setContentSize:CGSizeMake(SCREENWidth, orignY+90)];
}

- (NSString *)getImageName{
    NSInteger repaymentType = [[_dataSource objectForKey:@"repayment_type"] integerValue];
    NSInteger borrowDurateion = [[_dataSource objectForKey:@"borrow_duration"] integerValue];
    NSString *str = @"";
    if (repaymentType == 2 || repaymentType == 3){
        switch (borrowDurateion) {
            case 1:str = @"invest_bg_1";break;
            case 2:str = @"invest_bg_2";;break;
            default:str = @"invest_bg_3";;break;
        }
    }
    return str;
}

- (void)loadRateImage{
    if ([[self getImageName] length] == 0){
        return;
    }
    orignY += 20;
    float h = (SCREENWidth-40)*108/1120;
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(20, orignY, SCREENWidth-40, h)];
    [imgv setImage:IMAGENAMED([self getImageName])];
    [descView addSubview:imgv];
    orignY = VIEWFH_Y(imgv);
}

- (void)loadSmallText{
    orignY +=15;
    NSInteger textSize = 12;
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake((SCREENWidth - 12*textSize-6- 48)/2, orignY, 18, 18)];
    [imgv setImage:IMAGENAMED(@"invest_bg_0")];
    [scrollview addSubview:imgv];
    UILabel *lb = [FastFactory loadLabelWith:NSTextAlignmentLeft Frame:CGRectMake(VIEWFW_X(imgv)+5, VIEWFOY(imgv), 220, 18) TextColor:COLORWithRGB(40, 138, 225, 1) fontSize:textSize];
    lb.text = @"理财有风险,投资需谨慎";  //cw 益投网贷提供100%本息保障
    [lb sizeToFit];
    CGRect lbFrame = lb.frame;
    imgv.frame = CGRectMake((SCREENWidth - (18 + lbFrame.size.width + 5))/2, orignY, 18, 18);
    lbFrame.origin.x = VIEWFW_X(imgv)+5;
    lbFrame.size.height = 18;
    lb.frame = lbFrame;
    [scrollview addSubview:lb];
    orignY = VIEWFH_Y(lb);
}

- (void)loadButton{
    UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, orignY, SCREENWidth - 40, 40)];
    [nextBtn setBackgroundImage:IMAGENAMED(@"login_btn_bg") forState:UIControlStateHighlighted];
    [nextBtn setBackgroundColor:COLORWithRGB(62, 158, 245, 1)];
    [nextBtn setTitle:@"确定" forState:UIControlStateNormal];
    //    [loginBtn setTitleColor:COLORWithRGB(42, 138, 225, 1) forState:UIControlStateNormal];
    [nextBtn setTitleColor:COLORWithRGB(62, 158, 245, 1) forState:UIControlStateHighlighted];
    [nextBtn addTarget:self action:@selector(clickPayButton) forControlEvents:UIControlEventTouchUpInside];

    orignY = VIEWFH_Y(nextBtn);
    [scrollview addSubview:nextBtn];
}

- (void)loadTopView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 19, SCREENWidth, 61)];
    [self setViewBorder:topView];
    UILabel *moneyLB = [FastFactory loadLabelWith:NSTextAlignmentLeft Frame:CGRectMake(20, 0, 200, VIEWFSH(topView)) TextColor:[UIColor blackColor] fontSize:16];
    moneyLB.text = @"投资金额";
    [topView addSubview:moneyLB];
    //全部买入按钮
    UIButton *allInBtn = [[UIButton alloc] init];
    [allInBtn setTitle:@"全部买入" forState:UIControlStateNormal];
    [allInBtn setTitleColor:COLORWithRGB(42, 138, 225, 1) forState:UIControlStateNormal];
    allInBtn.titleLabel.font = [UIFont fontWithName:SYSTEMFONTName size:12];
    [allInBtn addTarget:self action:@selector(clickAllInBtn) forControlEvents:UIControlEventTouchUpInside];
    [allInBtn sizeToFit];
    CGRect allInFrame = allInBtn.frame;
    allInFrame.origin.x = SCREENWidth - allInFrame.size.width - 20;
    allInFrame.size.height = 35;
    allInFrame.origin.y = (VIEWFSH(topView)-35)/2;
    allInBtn.frame = allInFrame;
    [topView addSubview:allInBtn];

    moneyText = [[InputMoneyText alloc] initWithFrame:CGRectMake(90, (VIEWFSH(topView)-35)/2, SCREENWidth - 90 - 10 - (SCREENWidth - allInFrame.origin.x), 35)];
    [moneyText loadTextField];
    [moneyText forbidPoint];
    [moneyText setDelegate:self];
    [topView addSubview:moneyText];
    if (_tender.isExp){
        float expMoney = [userModel.expMoney floatValue] >= 2000 ? 2000 : [userModel.expMoney floatValue];
        moneyText.text = [NSString stringWithFormat:@"%.2f",expMoney];
        [moneyText setUserInteractionEnabled:NO];
    }
    
    [scrollview addSubview:topView];
    orignY = VIEWFH_Y(topView);

    UIView *moneyView = [[UIView alloc] initWithFrame:CGRectMake(0, orignY +15, SCREENWidth, CELLHeight)];
    [self setViewBorder:moneyView];
    NSString *keys = _tender.isExp?@"体验金可用余额":@"可投金额";
    NSString *values = @"元";
    NSString *minMoney = [userModel.balance floatValue] > [_tender.balance floatValue] ? _tender.balance:userModel.balance;
    [moneyText setInputMax:[minMoney floatValue]];
    values = _tender.isExp?[NSString stringWithFormat:@"%@元" ,userModel.expMoney]:[NSString stringWithFormat:@"%@%@",minMoney,values];
    [moneyView addSubview:[self loadLabelWithTitle:keys]];
    [moneyView addSubview:[self loadLabelWithValue:values]];
    [scrollview addSubview:moneyView];
    orignY = VIEWFH_Y(moneyView) - 1;

    UIView *rateView = [[UIView alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, CELLHeight)];
    [self setViewBorder:rateView];
    keys = @"年化收益率";
    values = _tender.minEarn;
    values = [values stringByAppendingString:@"%"];
    [rateView addSubview:[self loadLabelWithTitle:keys]];
    earnRateLB = [self loadLabelWithValue:values];
    [rateView addSubview:earnRateLB];
    [scrollview addSubview:rateView];
    orignY = VIEWFH_Y(rateView)-1;

    UIView *earnView = [[UIView alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, CELLHeight)];
    [self setViewBorder:earnView];
    [earnView addSubview:[self loadLabelWithTitle:@"可获得收益"]];
    earnCountLB = [self loadLabelWithValue:@"0.00元"];
    [earnView addSubview:earnCountLB];
    [scrollview addSubview:earnView];
    orignY = VIEWFH_Y(earnView)-1;

    if (!_tender.isExp){
        UIButton *quanView = [[UIButton alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, CELLHeight)];
        [self setViewBorder:quanView];
        
        //------3.17  ---- 如果是高息标详情界面则不显示下面内容
        if (![[_dataSource objectForKey:@"borrow_type_remark"] isEqualToString:@"高息标"]) {
            [quanView addSubview:[self loadLabelWithTitle:@"优惠券"]];
            
            couponLB = [self loadLabelWithValue:@"点击选择优惠券"];
            if ([[couponInfo objectForKey:@"jiaxijuan"] count] > 0 || [[couponInfo objectForKey:@"xianjinjuan"] count] > 0){
                [couponLB setText:@"有可用的优惠券"];
                [couponLB setTextColor:[UIColor colorWithRed:0.16 green:0.55 blue:0.88 alpha:1]];
            }
            
            [quanView addSubview:couponLB];
            [scrollview addSubview:quanView];
            [quanView addTarget:self action:@selector(clickCouponBtn) forControlEvents:UIControlEventTouchUpInside];
            orignY = VIEWFH_Y(quanView);

        }
        
    }
}

- (void)clickCouponBtn{
    if (!couponInfo){
        [SVProgressHUD showErrorWithStatus:@"正在获取优惠券信息,请稍后..."];
        return;
    }
    if ([[couponInfo objectForKey:@"jiaxijuan"] count] == 0 && [[couponInfo objectForKey:@"xianjinjuan"] count] == 0){
        [couponLB setText:@"无可用的优惠券"];
        return;
    }
    [self.navigationController pushViewController:couponCtrl animated:YES];
}

- (void)loadAgreeView{
    agreeImgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    [agreeImgv setImage:IMAGENAMED(@"login_unCheck")];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"我同意投资成功后自动生成《合同范本》"];
    [attri addAttribute:NSForegroundColorAttributeName value:COLORWithRGB(41, 139, 226, 1) range:NSMakeRange(12, 6)];

    UILabel *agreeLB = [[UILabel alloc] initWithFrame:CGRectMake(VIEWFSW(agreeImgv)+4, 0, 265, 12)];
    [agreeLB setFont:[UIFont fontWithName:SYSTEMFONTName size:12]];
    agreeLB.attributedText = attri;
    [agreeLB setUserInteractionEnabled:YES];
    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBargain)];
    [agreeLB addGestureRecognizer:gest];

    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(80 , orignY +15, 265, 25)];
    [btn addSubview:agreeLB];
    [btn addSubview:agreeImgv];
    [scrollview addSubview:btn];

    UIButton *checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(VIEWFOX(btn)-15, VIEWFOY(btn)-10, 40, 40)];
    [checkBtn addTarget:self action:@selector(clickAgreeBtn) forControlEvents:UIControlEventTouchUpInside];
    [scrollview addSubview:checkBtn];
    orignY = VIEWFH_Y(checkBtn)+10;
}

- (void)clickBargain{
//    ProtocolWebCtrl *webCtrl = [[ProtocolWebCtrl alloc] init];
//    NSString *proPath = [[NSBundle mainBundle] pathForResource:@"investProtocol" ofType:@"html"];
//    [webCtrl loadWebViewWithProtocolPath:proPath baseUrl:@""];
    ContractVC *demoCon = [[ContractVC alloc] init];
    demoCon.isDemo = YES;
    [self.navigationController pushViewController:demoCon animated:YES];
}

- (void)loadCellWithImageName:(NSString *)imgName text:(NSString *)text{
    orignY += 10;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, orignY, SCREENWidth-20, 50)];
    [view setBackgroundColor:COLORWithRGB(233, 246, 255, 1)];
    [descView addSubview:view];

    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(6, 7.5, 35, 35)];
//    [imgv setImage:IMAGENAMED(imgName)];
    [ImageLoder loadImageWithUrl:imgName view:imgv];
    [view addSubview:imgv];

    NSInteger width = VIEWFSW(view);
    width -= VIEWFW_X(imgv);
    width -= 40;
    UILabel *label = [FastFactory loadLabelWith:NSTextAlignmentLeft Frame:CGRectMake(60, 7.5, width, 35) TextColor:COLORWithRGB(101, 103, 102, 1) fontSize:12];
    label.text = text;
    [label setNumberOfLines:2];
    [view addSubview:label];
    orignY = VIEWFH_Y(view);
}

- (UILabel *)loadLabelWithTitle:(NSString *)title{
    UILabel *label = [FastFactory loadLabelWith:NSTextAlignmentLeft Frame:CGRectMake(20, 0, 200, CELLHeight) TextColor:[UIColor blackColor] fontSize:16];
    label.text = title;
    return label;
}

- (UILabel *)loadLabelWithValue:(NSString *)value{
    UILabel *label = [FastFactory loadLabelWith:NSTextAlignmentRight Frame:CGRectMake(0, 0, SCREENWidth-20, CELLHeight) TextColor:[UIColor blackColor] fontSize:16];
    label.text = value;
    return label;
}

- (void)setViewBorder:(UIView *)view{
    [view setBackgroundColor:[UIColor whiteColor]];
    [view.layer setMasksToBounds:YES];
    [view.layer setBorderWidth:1.0];
    [view.layer setBorderColor:[COLORWithRGB(227, 227, 227, 1) CGColor]];
}

- (void)clickPayButton{
    if (!isAgree){
        [SVProgressHUD showErrorWithStatus:@"请先阅读并接受合同范本"];
        return;
    }
    if (!userModel.isLogin){
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        return;
    }
    if (!REGEXStr(@"^(-)?(([1-9]{1}\\d*)|([0]{1}))(\\.(\\d){1,2})?$", moneyText.text)){
        [SVProgressHUD showErrorWithStatus:@"输入的金额格式不正确"];
        return ;
    }
    if ([userModel.balance integerValue] < [moneyText.text integerValue] && !_tender.isExp){
        [SVProgressHUD showErrorWithStatus:@"可用金额不足,请重新输入"];
        return;
    }
    if ([userModel.expMoney integerValue] < [moneyText.text integerValue] && _tender.isExp){
        [SVProgressHUD showErrorWithStatus:@"体验金金额不足"];
        return;
    }

//    NSInteger exist = [_tender.balance integerValue];
//    if (STRCMP(@"万元", _tender.balanceUnit)){
//        exist *= 10000;
//    }
//    if (exist<[moneyText.text integerValue]){
//        [SVProgressHUD showErrorWithStatus:@"投标金额必须小于标的剩余可投金额"];
//        return;
//    }
    NSString *msg = [NSString stringWithFormat:@"投标金额不能少于:%@元",[_dataSource objectForKey:@"borrow_min"]];
    if ([moneyText.text integerValue]<[[_dataSource objectForKey:@"borrow_min"] integerValue]){
        [SVProgressHUD showErrorWithStatus:msg];
        return;
    }
    if ([moneyText.text integerValue]<[[_dataSource objectForKey:@"borrow_max"] integerValue]){
        msg = [NSString stringWithFormat:@"投标金额不能超过:%@元",[_dataSource objectForKey:@"borrow_max"]];
        [SVProgressHUD showErrorWithStatus:msg];
        return;
    }
    if (couponCtrl.addMoney >0.0&&[moneyText.text integerValue]<couponCtrl.mininvest){
        NSString *strMininvest;
        NSString *title;
        NSString *sureStr;
        if(couponCtrl.hongbaoID != nil && couponCtrl.hongbaoID.length > 0) {
            strMininvest = [NSString stringWithFormat:@"投资金额需超过%.2f元时新手注册红包才能使用,是否不使用新手注册红包",couponCtrl.mininvest];
            title = @"新手注册红包无法使用";
            sureStr = @"不使用新手注册红包";
        }
        else {
            strMininvest = [NSString stringWithFormat:@"投资金额需超过%.2f元时现金券才能使用,是否不使用现金券",couponCtrl.mininvest];
            title = @"现金券无法使用";
            sureStr = @"不使用现金券";
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:strMininvest preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:sureStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self startRequest];
//            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *changeBtn = [UIAlertAction actionWithTitle:@"修改投资金额" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLOG(@"我要修改投资金额");
//            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:sureBtn];
        [alert addAction:changeBtn];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
        [self startRequest];
}

- (NSString *)dictionaryToJson:(NSDictionary *)dict{
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (void)startRequest{
    NSMutableDictionary *paraDict = [NSMutableDictionary new];
    [paraDict setValue:KEY_CLIENTID forKey:@"client_id"];
    [paraDict setValue:userModel.userID forKey:@"invest_user_id"];
    [paraDict setValue:moneyText.text forKey:@"invest_money"];
    [paraDict setValue:_tender.tenderID forKey:@"borrow_id"];
    NSMutableDictionary *remark = [[NSMutableDictionary alloc] init];
    if (couponCtrl.addMoney > 0){
        if (couponCtrl.hongbaoID != nil && couponCtrl.hongbaoID.length > 0) {
            [remark setObject:couponCtrl.hongbaoID forKey:@"xianjinhongbao"];
        }
        else {
            [remark setObject:couponCtrl.xianjinID forKey:@"xianjinjuan"];
        }
    }
    if (couponCtrl.addCoupon > 0){
        [remark setObject:couponCtrl.jiaxiID forKey:@"jiaxijuan"];
    }
    if ([calculator.actID length]>0){
        [remark setObject:calculator.actID forKey:@"touzijuan"];
    }

    [paraDict setValue:[self dictionaryToJson:remark] forKey:@"remark"];

    [HttpManager hmRequestWithPara:@{@"cmdid":@"initiative_tender",@"data":paraDict} Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        [SVProgressHUD dismiss];
        if (rqCode != rqSuccess){
            [SVProgressHUD showErrorWithStatus:describle];
            return ;
        }
        webBrower = [[WebBrower alloc] initWithFrame:CGRectMake(0, 64, SCREENWidth, SCREENHeight-64)];
        NSString *urlStr = [[receiveData objectForKey:@"data"] objectForKey:@"r_url"];
        urlStr = [urlStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [webBrower loadWebBrowerWithPostStr:urlStr andBlock:^(NSInteger rtCode,NSString *newUrlStr) {
            NSLOG(@"%@",newUrlStr);

            NSString *desc;
            if (rtCode == 0){
                desc = @"支付成功";
            }
            else if (rtCode == 11){
                desc = @"支付失败";
            }
            [webBrower removeFromSuperview];
            webBrower = nil;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:desc delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alertView show];
        }];
        [self.view addSubview:webBrower];
    }];
}

- (void)clickAgreeBtn{
    isAgree = isAgree?NO:YES;
    NSString *imgName = isAgree?@"login_checked":@"login_unCheck";
    [agreeImgv setImage:IMAGENAMED(imgName)];
}//点击了同意框框

- (void)clickAllInBtn {
    if (!_tender.isExp) {
        float tenderBalance = [_tender.balance floatValue];
        float userBalance = [userModel.balance floatValue];
        NSString *moneyStr = (tenderBalance > userBalance) ? userModel.balance : _tender.balance;
        moneyText.text = moneyStr;
    }
}//点击了全部买入按钮

- (void)InputTextChange{
    calculator.investMoney = [moneyText.text floatValue];
    earnRateLB.text = [NSString stringWithFormat:@"%.2f",[calculator calculatorRate]];
    earnRateLB.text = [earnRateLB.text stringByAppendingString:@"%"];
    double earnCount = [calculator calculatorEarn];
    if ([moneyText.text floatValue]>=couponCtrl.mininvest&&couponCtrl.addMoney >0.0){
        earnCount += couponCtrl.addMoney;
    }
    earnCountLB.text = [NSString stringWithFormat:@"%.2f",earnCount];
    earnCountLB.text = [earnCountLB.text stringByAppendingString:@"元"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
