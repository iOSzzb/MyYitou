//
//  InvestDetailCtrl.m
//  Yitou
//
//  Created by Xiaohui on 15/8/25.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "InvestDetailCtrl.h"
#import "InvertInfoView.h"
#import "InvestPayCtrl.h"
#import "VerifyInfoCtrl.h"
#import "InvestRecordCtrl.h"
#import "LXHTimer.h"
#import "LoginCtrl.h"
#import "ImageLoder.h"

#define CELLHeight  45

@interface InvestDetailCtrl ()
@property (nonatomic, strong) InvertInfoView *infoView;
@property (nonatomic, assign) CGRect infoviewFrame;
@end

@implementation InvestDetailCtrl{
    float orignY;
//    InvertInfoView *infoView;
    UIScrollView *scrollview;
    UIButton *investBtn;
    CustomNavigation *customNav;
    NSTimer *timeRunloop;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"益押宝";
    [self.view setBackgroundColor:BG_BLUEColor];
    [self loadAllView];
}

- (void)viewWillBack{
    [timeRunloop invalidate];
    [self.infoView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshData];
}
- (void)loadAllView{
    [self loadScrollView];
    
    /**
     *  3.17    如果是高息标,不显示增长图 || 判断是否显示
     */
    
    BOOL imgBool = [[_detail objectForKey:@"initiative_img_bl"] boolValue];
    if (![[_detail objectForKey:@"borrow_type_remark"] isEqualToString:@"高息标"]||imgBool){
        [self loadImageView];
    }
    
    [self loadInvertDetail];
    [self loadLabelInfo];
    [self loadButton];
    [self loadWarningLabel];
    if ([_tender.status integerValue] == 1){
        [self checkStartTime];
        [self checkExistTime];
    }
}

- (void)checkExistTime{
    NSInteger a = [[LXHTimer shareTimerManager] companyTime:_tender.startTime];
    if (a < 3600&& a > 0){
        timeRunloop = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkStartTime) userInfo:nil repeats:YES];
    }
    else
        [timeRunloop invalidate];
}

- (void)checkStartTime{
    NSInteger a = [[LXHTimer shareTimerManager] companyTime:_tender.startTime];
    if (a>0){
        [investBtn setUserInteractionEnabled:NO];
        [investBtn setBackgroundColor:[UIColor grayColor]];
    }else{
        [investBtn setUserInteractionEnabled:YES];
        [investBtn setBackgroundImage:IMAGENAMED(@"login_btn_bg") forState:UIControlStateHighlighted];
    }
    if (a>172800){
        [investBtn setTitle:@"2天以后开始投标" forState:UIControlStateNormal];
    }
    else if (a>86400){
        [investBtn setTitle:@"1天后开始投标" forState:UIControlStateNormal];
    }
    else if (a>7200){
        NSInteger exist = a/60/60;
        [investBtn setTitle:[NSString stringWithFormat:@"大约在:%tu小时后可投",exist] forState:UIControlStateNormal];
    }
    else if (a>0){
        NSInteger exist = a/60;
        [investBtn setTitle:[NSString stringWithFormat:@"大约在:%tu分钟后可投",exist] forState:UIControlStateNormal];
    }

}

- (void)loadButton{
    investBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, orignY+30, SCREENWidth - 40, 45)];
    [investBtn setBackgroundColor:COLORWithRGB(52, 148, 245, 1)];
    [investBtn setBackgroundImage:IMAGENAMED(@"login_btn_bg") forState:UIControlStateHighlighted];
    [investBtn addTarget:self action:@selector(clickInvestButton) forControlEvents:UIControlEventTouchUpInside];
    [investBtn setTitle:@"立即投标" forState:UIControlStateNormal];
    [scrollview addSubview:investBtn];
    [scrollview setContentSize:CGSizeMake(SCREENWidth, orignY)];
    [scrollview setShowsVerticalScrollIndicator:NO];
    orignY = VIEWFH_Y(investBtn);
    if ([[_detail objectForKey:@"borrow_status"] integerValue] != 1){
        [investBtn setBackgroundColor:[UIColor grayColor]];
        [investBtn setUserInteractionEnabled:NO];
        [investBtn setTitle:_tender.statusDesc forState:UIControlStateNormal];
    }
}

- (void)loadWarningLabel {
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
    orignY = VIEWFH_Y(investBtn) + 80;
    [scrollview setContentSize:CGSizeMake(SCREENWidth, orignY)];
    orignY = VIEWFH_Y(lb);
}

- (void)loadScrollView{
    scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
    [self.view addSubview:scrollview];
}

- (void)loadInvertDetail{
    self.infoView = [[InvertInfoView alloc] init];
    [self.infoView loadInfoWithData:_tender andDataSource:_detail];
    if (CGRectEqualToRect(self.infoviewFrame, CGRectZero)) {
        self.infoviewFrame = CGRectMake(0, orignY, SCREENWidth, self.infoView.contentSize);

    }
    [self.infoView setFrame:self.infoviewFrame];

    [self.infoView.layer setBorderColor:[COLORWithRGB(233, 233, 233, 1) CGColor]];
    [self.infoView.layer setBorderWidth:1.0];
    [self.infoView setBackgroundColor:[UIColor whiteColor]];
    [scrollview addSubview:self.infoView];
    orignY = VIEWFH_Y(self.infoView);
}

- (void)loadImageView{
    float imgHeight = SCREENWidth*641/1242;
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, imgHeight)];
//    [imgv setImage:IMAGENAMED([self getImageName])];
//    NSString *urlStr = [_detail objectForKey:@"initiative_termimg"];
//    [ImageLoder loadImageWithUrl:urlStr view:imgv];
    NSInteger timeCount = [_tender.timeCount integerValue];
    switch (timeCount) {
        case 1:
            imgv.image = [UIImage imageNamed:@"tender_rate1"];
            break;
        case 2:
            imgv.image = [UIImage imageNamed:@"tender_rate2"];
            break;
        case 3:
            imgv.image = [UIImage imageNamed:@"tender_rate3"];
            break;
            
        default:
            break;
    }
    [scrollview addSubview:imgv];
    orignY = VIEWFH_Y(imgv);
}

//- (NSString *)getImageName{
//    NSInteger repaymentType = [[_detail objectForKey:@"repayment_type"] integerValue];
//    NSInteger borrowDurateion = [[_detail objectForKey:@"borrow_duration"] integerValue];
//    NSString *str = @"invert_return_bg1";
//    if (repaymentType == 2 || repaymentType == 3){
//        switch (borrowDurateion) {
//            case 1:str = @"invert_return_bg1";break;
//            case 2:str = @"invert_return_bg2";;break;
//            default:str = @"invert_return_bg3";;break;
//        }
//    }
//    return str;
//}

- (void)loadLabelInfo{
    orignY += 10;
    UIView *payWayView = [[UIView alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, CELLHeight)];
    [self setViewBorder:payWayView];
    [payWayView addSubview:[self loadLabelWithTitle:@"还款方式"]];
    [payWayView addSubview:[self loadLabelWithValue:_tender.payStyle]];
    orignY += CELLHeight - 1;
    [scrollview addSubview:payWayView];

    UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, CELLHeight)];
    [self setViewBorder:timeView];
    [timeView addSubview:[self loadLabelWithTitle:@"发布时间"]];
    [timeView addSubview:[self loadLabelWithValue:_tender.createTime]];
    orignY += CELLHeight - 1;
    [scrollview addSubview:timeView];

    if ([_tender checkBelongValid]){
        UIView *belongView = [[UIView alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, CELLHeight)];
        [self setViewBorder:belongView];
        [belongView addSubview:[self loadLabelWithTitle:@"约标有效时间"]];
        [belongView addSubview:[self loadLabelWithValue:_tender.belongTimeout]];
        orignY += CELLHeight - 1;
        [scrollview addSubview:belongView];
    }

    UIView *endTime = [[UIView alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, CELLHeight)];
    [self setViewBorder:endTime];
    [endTime addSubview:[self loadLabelWithTitle:@"项目有效时间"]];
    [endTime addSubview:[self loadLabelWithValue:_tender.endTime]];
    orignY += CELLHeight;
    [scrollview addSubview:endTime];

    UIButton *verBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, orignY+10, SCREENWidth, CELLHeight)];
    [verBtn addSubview:[self loadLabelWithTitle:@"●资质审核"]];
    [verBtn setBackgroundColor:[UIColor whiteColor]];
    [verBtn addTarget:self action:@selector(clickVerifyBtn) forControlEvents:UIControlEventTouchUpInside];
    [self setViewBorder:verBtn];
    [self addImageView:verBtn];
    [scrollview addSubview:verBtn];
    orignY = VIEWFH_Y(verBtn);

    UIButton *recBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, orignY-1, SCREENWidth, CELLHeight)];
    [recBtn addSubview:[self loadLabelWithTitle:@"●投标记录"]];
    [recBtn setBackgroundColor:[UIColor whiteColor]];
    [recBtn addTarget:self action:@selector(clickRecordBtn) forControlEvents:UIControlEventTouchUpInside];
    [self setViewBorder:recBtn];
    [self addImageView:recBtn];
    [scrollview addSubview:recBtn];
    orignY = VIEWFH_Y(recBtn);
}

- (void)addImageView:(UIView *)view{
    float imgvY = (VIEWFSH(view)-15)/2;
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWidth- 30, imgvY, 8, 15)];
    [imgv setImage:IMAGENAMED(@"towerRight")];
    [view addSubview:imgv];
}

- (void)clickVerifyBtn{
    VerifyInfoCtrl *verCtrl = [[VerifyInfoCtrl alloc] init];
    verCtrl.dataSource = _detail;
    verCtrl.tender = _tender;
    [self.navigationController pushViewController:verCtrl animated:YES];
}

- (void)clickRecordBtn{
    InvestRecordCtrl *recordCtrl = [[InvestRecordCtrl alloc] init];
    recordCtrl.tender = _tender;
    recordCtrl.oriData = _detail;
    recordCtrl.investID = _tender.tenderID;
    [self.navigationController pushViewController:recordCtrl animated:YES];
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

- (void)clickInvestButton{
    UserModel *usrModel = [UserModel shareUserManager];
    if (!usrModel.isLogin){
        LoginCtrl *loginCtrl = [[LoginCtrl alloc]initWithNibName:@"LoginCtrl" bundle:nil];
        [loginCtrl setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:loginCtrl animated:YES];
        return;
    }
    InvestPayCtrl *invest = [[InvestPayCtrl alloc] init];
    invest.tender = _tender;
    invest.dataSource = _detail;
    [self.navigationController pushViewController:invest animated:YES];

}

- (void)refreshData{
//    __weak typeof(infoView) weakInfoView;
    __weak typeof(self) weakSelf = self;
    [HttpManager getInvestDetailWithID:_tender.tenderID Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        [SVProgressHUD dismiss];
        if (rqCode == rqSuccess && !_tender.isExp){
//            InvestDetailCtrl *invest = [[InvestDetailCtrl alloc] init];
//            invest.tender = tender;
//            invest.detail = receiveData;
//            [invest setHidesBottomBarWhenPushed:YES];
//            [weakSelf.navigationController pushViewController:invest animated:YES];
            [weakSelf.infoView removeFromSuperview];
            Tender *tender = [[Tender alloc] init];
            [tender createTenderModel:receiveData];
            if (![tender.balance isEqualToString:weakSelf.tender.balance]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TenderReloadNotification" object:nil];
            }
            weakSelf.tender = tender;
            weakSelf.detail = receiveData;
            [self loadInvertDetail];
            weakSelf.infoView.frame = weakSelf.infoviewFrame;
        }
        else if (rqCode == rqSuccess){

        }
        else
            [SVProgressHUD showErrorWithStatus:describle];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
