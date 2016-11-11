//
//  HomePage.m
//  Yitou
//
//  Created by Xiaohui on 15/7/28.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "HomePage.h"

#import "AdModel.h"
#import "InvestDetailCtrl.h"
#import "LXHAdView.h"

#import "GuideCtrl.h"
#import "WebViewCtrl.h"
#import <MobClick.h>
#import "LXHTimer.h"
#import "LoginCtrl.h"
#import "CLLockVC.h"
#import "TenderView.h"


@interface HomePage ()

@property (nonatomic)Tender *tender;
@property (nonatomic,copy)TenderView *tenderView;
@property (nonatomic,copy)NSArray *adAry;//Banner的数据
@property (assign)NSInteger timeoutCount;

@end

@implementation HomePage{
    LXHAdView       *adView;     //显示Banner的View
    UIView          *gapView;    //adView与tenderView直接的缝隙
    UIButton        *investBtn;  //立即投标按钮
//    TenderView      *tenderView; //显示标信息 的View
//    NSInteger       timeoutCount;//获取首页展示标失败的次数 >=3次时停止获取
}
@synthesize tender,tenderView,timeoutCount,adAry;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    timeoutCount = 0;
    [self.navigationController.navigationBar setHidden:YES];
    [self getBorrowInfo];
}

- (void)viewDidLoad{
    [super viewDidLoad];

    timeoutCount = 0;
    [self.navigationController.navigationBar setHidden:YES];
    adAry = [NSArray new];
    [self loadadAry];
    [UserModel shareUserManager];
    [self loadAllView];
    NSString *pathStr = NSHomeDirectory();
    pathStr = [pathStr stringByAppendingPathComponent:@"Documents/firstOpen.text"];
    if (!CHECKFileExist(pathStr)){
        
        NSData *data = [pathStr dataUsingEncoding:NSUTF8StringEncoding];
        [data writeToFile:pathStr atomically:NO];
        [self performSelector:@selector(loadGuideView) withObject:nil afterDelay:0.28];
    }
    else{
        [self performSelector:@selector(autoLogin) withObject:nil afterDelay:0.3];
    }
}

//检查是否可以使用手势密码自动登陆
- (void)autoLogin{
    if (![CLLockVC hasPwd]){
        LoginCtrl *login = [[LoginCtrl alloc] init];
        [login setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }

#warning comment this before release
#ifdef DEBUG
    [HttpManager loginWithUserName:@"yuanyuan1" password:@"888888" Block:^(RequestResult rqCode, NSString *describle) {
        NSLOG(@"did login");
    }];
    return;
#endif
    __weak typeof(self) weakSelf = self;
    [CLLockVC showVerifyLockVCInVC:self forgetPwdBlock:nil successBlock:^(CLLockVC *lockVC, NSString *pwd) {
        [lockVC dismiss:0];
        if (STRCMP(@"999", pwd)){
            LoginCtrl *login = [[LoginCtrl alloc] init];
            [login setHidesBottomBarWhenPushed:YES];
            [weakSelf.navigationController pushViewController:login animated:NO];
        }
        else if ([pwd length] == 3){
            [[UserModel shareUserManager] logout];
        }
        else if (STRCMP(@"0", pwd)){
        }
    }];
}

#pragma mark 安装后第一次打开执行
- (void)loadGuideView{
    GuideCtrl *guideCtrl = [[GuideCtrl alloc] init];
    [guideCtrl.view setFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
    [guideCtrl.view setBackgroundColor:[UIColor whiteColor]];
    __weak typeof(self) weakSelf = self;
    [guideCtrl guideCompleteWithBlock:^(NSInteger result) {
        [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [guideCtrl dismissViewControllerAnimated:YES completion:nil];
            [weakSelf performSelector:@selector(autoLogin) withObject:nil afterDelay:0.3];
        } completion:nil];
    }];
    [self presentViewController:guideCtrl animated:YES completion:nil];
}

#pragma mark 加载UI

- (void)loadAllView{
    [self loadStatusView];
    [self loadAdView];
    [self loadgapView];
    [self loadtenderView];
    [self loadBuyButton];
}

//顶部状态栏的背景View
- (void)loadStatusView{
    UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 20)];
    [statusView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:statusView];
}

//顶部的Banner
- (void)loadAdView{
    float adHeight = SCREENWidth/2;
    if (SCREENHeight > 500)
        adHeight *= 1.18;
    else
        adHeight *= 0.92;
    [adView removeFromSuperview];
    adView = nil;
    adView = [[LXHAdView alloc]initWithFrame:CGRectMake(0, 20, SCREENWidth, adHeight)];
    [adView setDefaultImage:IMAGENAMED(@"image_loading")];
    [adView setShowThum:NO];
    adView.dataSource = adAry;
    [adView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.26]];
    [adView loadAdView:^(NSInteger indx) {

        [MobClick event:@"1003"];
        AdModel *adModel = [adAry objectAtIndex:indx];
        if ([adModel.adUrl length]<5)
            return ;
        WebViewCtrl *webCtrl = [[WebViewCtrl alloc] init];
        [webCtrl setHidesBottomBarWhenPushed:YES];
        webCtrl.url = adModel.adUrl;
        UserModel *user = [UserModel shareUserManager];
        if (user.isLogin&&[[adModel.adUrl componentsSeparatedByString:@"type=activ"] count]>1){
            NSString *stamp = [NSString stringWithFormat:@"%.0f",[[LXHTimer shareTimerManager].date timeIntervalSince1970]];
            NSString *md5code = [NSString stringWithFormat:@"%@%@app_url%@",user.userID,user.userName,stamp];
            NSString *loginStr = [NSString stringWithFormat:@"&username=%@&data=%@&timestamp=%@&app=ios",user.userName,[HttpManager md5:md5code],stamp];
            webCtrl.url = [NSString stringWithFormat:@"%@%@",adModel.adUrl,loginStr];
            NSLOG(@"%@",webCtrl.url);
        }
        webCtrl.name = adModel.adTitle;
        [self.navigationController pushViewController:webCtrl animated:YES];
    }];
    [self.view addSubview:adView];
}

//#pragma mark WebViewCtrlDelegate
//- (void)returnWebViewCtrlIndex:(WebViewClickBtnIndex)index Parameter:(NSString *)parameter{
//    if (index == Click_LiJiTouBiao) {
//        return;
//    }
//    if (index == Click_WoDeLiQuan) {
//        MyBoxCtrl *myBoxCtrl = [[MyBoxCtrl alloc] init];
//        [self.navigationController pushViewController:myBoxCtrl animated:YES];
//    }
//}

//Banner与标信息View直接的缝隙
- (void)loadgapView{
    gapView = [[UIView alloc]initWithFrame:CGRectMake(0, VIEWFH_Y(adView), SCREENWidth, 2)];
    [gapView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:gapView];
}

//标的信息页
- (void)loadtenderView{
    float adHeight = SCREENWidth*257/410;
    if (SCREENHeight < 500)
        tenderView = [[TenderView alloc]initWithFrame:CGRectMake(0, VIEWFH_Y(gapView), SCREENWidth, adHeight)];
    else{
        adHeight *= 1.1;
        tenderView = [[TenderView alloc] initWithFrame:CGRectMake((SCREENWidth- SCREENWidth*1.1)/2, VIEWFH_Y(gapView), SCREENWidth*1.1, adHeight)];
    }
    [tenderView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:tenderView];
}

//底部的 立即投标 按钮
- (void)loadBuyButton{
    float width = SCREENWidth*9/16;
    float surplusH = SCREENHeight - VIEWFH_Y (tenderView) - self.tabBarController.tabBar.frame.size.height;
    surplusH = (surplusH - 40)/2;
    investBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREENWidth-width)/2, VIEWFSH(tenderView)+VIEWFOY(tenderView)+surplusH, width, 35)];
    [investBtn setTitle:@"立即抢标" forState:UIControlStateNormal];
    [FastFactory customButton:investBtn bgColorR:251 g:66 b:36];
    [investBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [FastFactory customViewRadius:investBtn];
    [investBtn.titleLabel setFont:[UIFont fontWithName:SYSTEMFONTName size:22]];
    [investBtn addTarget:self action:@selector(clickBuyButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:investBtn];
    [self loadAutoTimeRemove:nil];
}

//立即投标Button倒计时的统计
- (void)loadAutoTimeRemove:(id)sender{
    LXHTimer *timer = [LXHTimer shareTimerManager];
    NSTimer *tm = sender;
    [tm invalidate];
    if (!timer.isValid){
        [self performSelector:@selector(loadAutoTimeRemove:) withObject:tm afterDelay:1.0];
        [investBtn setTitle:@"立即抢标" forState:UIControlStateNormal];
        return;
    }//无效的时间 1S后再重试
    if ([timer companyTime:tender.startTime] < 0 && ![tender checkBelongValid]){
        [investBtn setTitle:@"立即抢标" forState:UIControlStateNormal];
        [investBtn setUserInteractionEnabled:YES];
        [tm invalidate];
        return;
    }
    if ([tender checkBelongValid]){
        [investBtn setTitle:[tender showBelongName] forState:UIControlStateNormal];
        [investBtn setUserInteractionEnabled:YES];
        [tm invalidate];
        return;
    }
    [investBtn setTitle:[timer calculatorWaitTimeFromSecond:[timer companyTime:tender.startTime]] forState:UIControlStateNormal];
    [self performSelector:@selector(loadAutoTimeRemove:) withObject:tm afterDelay:1.0];
}

#pragma mark Event

- (void)clickBuyButton:(id)sender{
    if (tender == nil){
        [SVProgressHUD showErrorWithStatus:@"正在获取数据,请稍后..."];
        return;
    }
    [SVProgressHUD showWithStatus:@"正在获取数据..." maskType:SVProgressHUDMaskTypeBlack];
    __weak typeof(self) weakSelf = self;
    [HttpManager getInvestDetailWithID:tender.tenderID Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        [SVProgressHUD dismiss];
        if (rqCode == rqSuccess){
            [MobClick event:@"1004"];
            InvestDetailCtrl *invest = [[InvestDetailCtrl alloc] init];
            invest.tender = tender;
            invest.detail = receiveData;
            [invest setHidesBottomBarWhenPushed:YES];
            [weakSelf.navigationController pushViewController:invest animated:YES];
        }
        else{
            [MobClick event:@"1002"];
            [SVProgressHUD showErrorWithStatus:describle];
        }
    }];
}

#pragma mark load data

//加载Banner的数据
- (void)loadadAry{

    [self loadOffLineadAry];
    NSDictionary *dict = @{@"client_id":KEY_CLIENTID,@"type":@"wap"};
    NSDictionary *para = @{@"cmdid":@"get_banner",@"data":dict};
    __weak typeof(self) weakSelf = self;
    [HttpManager hmRequestWithPara:para Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {

        if (rqCode != rqSuccess){
            [MobClick event:@"1001"];
            [SVProgressHUD showErrorWithStatus:describle];
            return ;
        }
        NSArray *ary = [receiveData objectForKey:@"data"];
        NSMutableArray *tempAry = [NSMutableArray new];
        for (NSDictionary *adDict in ary){
            AdModel *adv = [AdModel new];
            [adv setModel:adDict];
            [tempAry addObject:adv];
        }
        weakSelf.adAry = [[NSArray alloc] initWithArray:tempAry];
        [weakSelf loadAdView];
    }];
}

//加载Banner数据失败时调用
- (void)loadOffLineadAry{
    AdModel *ad = [AdModel new];
    ad.adUrl = @"";
    ad.adImgPath =  RESOURCE(@"defaultBanner", @"png");
    ad.adTitle = @"";
    ad.imgStatus = 3;
    adAry = [NSArray arrayWithObjects:ad, nil];
    [self loadAdView];
}

//获取首页标的数据
- (void)getBorrowInfo{
    NSDictionary *para = @{@"pageindex":@"1",@"pagesize":@"1"};
    __weak typeof(self) weakSelf = self;
    [HttpManager getBorrowMoneyListWithPara:para Block:^(RequestResult rqCode, NSArray *array, NSInteger sumCount, NSString *describle) {
        if (rqCode == rqSuccess && [array count] > 0){
            weakSelf.tender = [array objectAtIndex:0];
            [weakSelf.tenderView setTender:weakSelf.tender];
        }
        else if (weakSelf.timeoutCount<3){
            weakSelf.timeoutCount++;
            [weakSelf getBorrowInfo];
        }
        else{
            [SVProgressHUD showErrorWithStatus:describle];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
