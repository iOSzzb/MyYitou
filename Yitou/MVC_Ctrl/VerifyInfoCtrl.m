//
//  VerifyInfoCtrl.m
//  Yitou
//
//  Created by Xiaohui on 15/9/2.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "VerifyInfoCtrl.h"
#import "InvestPayCtrl.h"
#import "LXHAdView.h"
#import "AdModel.h"
#import "LXHTimer.h"
#import "NullView.h"
#import <MWPhoto.h>
#import <MWPhotoBrowser.h>
#import "ShouldLoginView.h"
#import "LoginCtrl.h"
#import "RegistFirstStepCtrl.h"
#import <UIImageView+AFNetworking.h>


#define LABELWidth      (SCREENWidth - 20)
#define TEXTSize_Small  14.0

@interface VerifyInfoCtrl ()

@property (nonatomic)MWPhotoBrowser *brower;
@property (nonatomic)ShouldLoginView *unloginView;

@end

@implementation VerifyInfoCtrl{
    float orignY;
    UIScrollView *scrollview;
    CustomNavigation *customNav;
    LXHAdView *adView;
    UIButton *investBtn;
    NSTimer *timeRunloop;
    NullView *nullView;
}

@synthesize brower,unloginView;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([UserModel shareUserManager].isLogin){
        [unloginView removeFromSuperview];
    }
    else
        [self.view addSubview:unloginView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资质审核";
    [self loadAllView];

    [self checkExistTime];
    unloginView = [[ShouldLoginView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
    __weak typeof(self) weakSelf = self;
    [unloginView loadViewWithBlock:^(BOOL isLogin) {
        if (isLogin){
            LoginCtrl *loginCtrl = [[LoginCtrl alloc] init];
            [loginCtrl setHidesBottomBarWhenPushed:YES];
            [weakSelf.navigationController pushViewController:loginCtrl animated:YES];
        }else{
            RegistFirstStepCtrl *regCtrl = [[RegistFirstStepCtrl alloc] init];
            [weakSelf.navigationController pushViewController:regCtrl animated:YES];
        }
    }];
}

- (void)viewWillBack{
    brower = nil;
    [adView removeFromSuperview];
    adView = nil;
}

- (void)loadAllView{
    scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
    [self.view addSubview:scrollview];
    [self loadTopText];
    [self loadCenterText];
    [self loadImageView];
    [self loadButton];
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
    }else if (a == 0&&[_tender.status integerValue] == 1){
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
    orignY = VIEWFH_Y(investBtn) + 10;
    [scrollview setContentSize:CGSizeMake(SCREENWidth, orignY)];
    [scrollview setShowsVerticalScrollIndicator:NO];

    if ([_tender.status integerValue] != 1){
        [investBtn setBackgroundColor:[UIColor grayColor]];
        [investBtn setUserInteractionEnabled:NO];
        [investBtn setTitle:_tender.statusDesc forState:UIControlStateNormal];
    }
}

- (void)clickInvestButton{
    UserModel *usrModel = [UserModel shareUserManager];
    if (!usrModel.isLogin){
        [SVProgressHUD showErrorWithStatus:@"请先登录!"];
        return;
    }
    InvestPayCtrl *invest = [[InvestPayCtrl alloc] init];
    invest.tender = _tender;
    invest.dataSource = _dataSource;
    [self.navigationController pushViewController:invest animated:YES];
}

- (void)loadTopText{
    orignY = 20;
    UIView *topview = [self loadLabelWith:@"verify_one" andText:@"项目简介"];
    [scrollview addSubview:topview];

    orignY += VIEWFSH(topview)+10;
    NSString *dataStr = [_dataSource objectForKey:@"borrow_context"];

    float h = [self calculatorTextHeightWithText:dataStr];
    UILabel *topLB = [[UILabel alloc] initWithFrame:CGRectMake(10, orignY, LABELWidth, h)];
    topLB.text = [_dataSource objectForKey:@"borrow_context"];
    [topLB setTextColor:COLORWithRGB(85, 85, 85, 1)];
    [topLB setFont:[UIFont systemFontOfSize:TEXTSize_Small]];
    [topLB setNumberOfLines:h/TEXTSize_Small];
    [topLB setText:dataStr];
    [scrollview addSubview:topLB];
    orignY = VIEWFH_Y(topLB);
}

- (void)loadCenterText{
    orignY += 20;
    UIView *midView = [self loadLabelWith:@"verify_two" andText:@"风控式意见"];
    [scrollview addSubview:midView];

    orignY += VIEWFSH(midView)+10;
    NSString *dataStr = [_dataSource objectForKey:@"borrow_opinion"];

    float h = [self calculatorTextHeightWithText:dataStr];
    UILabel *topLB = [[UILabel alloc] initWithFrame:CGRectMake(10, orignY, LABELWidth, h)];
    [topLB setTextColor:COLORWithRGB(85, 85, 85, 1)];
    [topLB setFont:[UIFont systemFontOfSize:TEXTSize_Small]];
    [topLB setNumberOfLines:h/TEXTSize_Small];

    [topLB setText:dataStr];
    [scrollview addSubview:topLB];
    orignY = VIEWFH_Y(topLB);
}

-(void)loadImageView{
    orignY += 20;
    UIView *midView = [self loadLabelWith:@"verify_three" andText:@"资质审核"];
    [scrollview addSubview:midView];
    orignY = VIEWFH_Y(midView)+20;

    NSArray *imgArray = [_dataSource objectForKey:@"data_ids_img"];
    NSMutableArray *temp = [NSMutableArray new];
    for (NSString *imgUrl in imgArray){
        AdModel *ad = [AdModel new];
        ad.adUrl = @"";
        ad.adImgUrl = imgUrl;
        NSString *imgPath = IMAGE_FOLDER;
        imgPath = [imgPath stringByAppendingPathComponent:[ad.adImgUrl lastPathComponent]];
        ad.adImgPath = imgPath;
        ad.imgStatus = 1;
        if (CHECKFileExist(imgPath))
            ad.imgStatus = 3;
        [temp addObject:ad];
    }
    adView = [[LXHAdView alloc] initWithFrame:CGRectMake(10, orignY, SCREENWidth - 20, SCREENWidth*0.75)];
    [adView setShowThum:YES];
    adView.dataSource = temp;

    __weak typeof(self) weakSelf = self;
    [adView loadAdView:^(NSInteger indx) {
        weakSelf.brower = [[MWPhotoBrowser alloc] initWithPhotos:[self loadImageList]];
        [weakSelf.brower setCurrentPhotoIndex:indx];
        [weakSelf.navigationController pushViewController:brower animated:YES];
    }];

    if ([imgArray count] == 0){
        [nullView removeFromSuperview];
        nullView = [[NullView alloc] initWithFrame:CGRectMake(0, 0, VIEWFSW(adView), VIEWFSH(adView))];
        [adView setBackgroundColor:[UIColor colorWithRed:0.87 green:0.95 blue:0.97 alpha:1]];
        [adView addSubview:nullView];
    }
    [scrollview addSubview:adView];
    orignY = VIEWFH_Y(adView);
}

- (NSArray *)loadImageList{
    NSMutableArray *photoArray = [NSMutableArray new];
    for (AdModel *ad in adView.dataSource){
        if (CHECKFileExist(ad.adImgPath)){
            [photoArray addObject:[MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:ad.adImgPath]]];
        }else{
            [photoArray addObject:[MWPhoto photoWithURL:[NSURL URLWithString:ad.adImgUrl]]];
        }
    }
    return photoArray;
}

- (float)calculatorTextHeightWithText:(NSString *)text{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];

    NSRange allRange = [text rangeOfString:text];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:TEXTSize_Small]
                    range:allRange];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor blackColor]
                    range:allRange];

    NSInteger textLen = [text length] > 5?5:[text length];
    NSRange destRange = [text rangeOfString:[text substringToIndex:textLen]];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:destRange];
    CGFloat titleHeight;

    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(LABELWidth, CGFLOAT_MAX)
                                        options:options
                                        context:nil];
    titleHeight = ceilf(rect.size.height);
    return titleHeight+2;
}

- (UIView *)loadLabelWith:(NSString *)imgName andText:(NSString *)text{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, 30)];

    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 30, 30)];
    [imgv setImage:IMAGENAMED(imgName)];
    [view addSubview:imgv];

    UILabel *titleLB = [FastFactory loadLabelWith:NSTextAlignmentLeft Frame:CGRectMake(50, 0, 200, 30) TextColor:COLORWithRGB(101, 101, 101, 1) fontSize:20];
    titleLB.text = text;
    [view addSubview:titleLB];
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
