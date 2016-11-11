//
//  DiscoverCtrl.m
//  Yitou
//
//  Created by Xiaohui on 15/8/10.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "DiscoverCtrl.h"
#import "DiscoverTopToolView.h"
#import "MyBoxCtrl.h"
#import "InvitedFriend.h"
#import "BulletinBoardCtrl.h"
#import "ActivityCenterCtrl.h"
#import "LoginCtrl.h"
#import "WebViewCtrl.h"

#if DEBUG
    #define INTEGRAL_URL @"http://apitest.haokoudai.com"
#else
    #define INTEGRAL_URL @"http://www.szytou.com"
#endif

@interface DiscoverCtrl ()

@property (nonatomic)DiscoverTopToolView *toolView;

@end

@implementation DiscoverCtrl{
    UIView *bottomView;
    float orignY;
}

@synthesize toolView;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BG_BLUEColor];
    [self loadTopImageView];
    [self loadToolView];
    [self loadData];
    [self loadBottomView];
}

- (void)loadBottomView{
    orignY += 20;
    float height = SCREENWidth/3 *134/214;
    height = height*2+1;
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, height)];
    [self.view addSubview:bottomView];
    [bottomView setBackgroundColor:[UIColor colorWithRed:0.9 green:0.91 blue:0.91 alpha:1]];
    orignY = 0;
    [self loadViewWithTitle:@"益投公告" imageName:@"discover_icon_0" tag:0];
    [self loadViewWithTitle:@"平台活动" imageName:@"discover_icon_1" tag:1];
    [self loadViewWithTitle:@"积分乐园" imageName:@"discover_icon_2" tag:2];
    [self loadViewWithTitle:@"推荐好友" imageName:@"discover_icon_3" tag:3];
    [self loadViewWithTitle:@"签到抽奖" imageName:@"qiandao_icon" tag:4];
    [self loadViewWithTitle:@"" imageName:@"" tag:5];

}

- (void)loadData{
    NSDictionary *para = @{@"cmdid":@"borrowcountinfo",@"data":@{@"client_id":KEY_CLIENTID}};

    __weak typeof(self) weakSelf = self;
    [HttpManager hmRequestWithPara:para Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        if (rqCode != rqSuccess){
            [SVProgressHUD showErrorWithStatus:describle];
            return ;
        }
        [weakSelf.toolView loadDataInformation:[receiveData objectForKey:@"data"]];
    }];
}

- (void)loadToolView{
    float toolHeight = SCREENWidth*209/1242;
    toolView = [[DiscoverTopToolView alloc]initWithFrame:CGRectMake(0, orignY, SCREENWidth, toolHeight)];
    [toolView loadToolView];
    NSDictionary *dict = @{@"key1":@"value1"};
    [toolView setDataSource:dict];
    [self.view addSubview:toolView];
    orignY = VIEWFH_Y(toolView);
}

- (void)loadTopImageView{
    orignY = SCREENWidth*537/1242;
    UIImageView *topImgv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth, orignY)];
    [topImgv setImage:IMAGENAMED(@"discover_topImage")];
    [self.view addSubview:topImgv];
    orignY = VIEWFH_Y(topImgv);
}

- (void)loadViewWithTitle:(NSString *)title imageName:(NSString *)imgName tag:(NSInteger)tag{
    float width = SCREENWidth/3;
    float height = width *134/214;
    if (tag == 3)
        orignY += height +1;

    UIButton *baseView = [[UIButton alloc] initWithFrame:CGRectMake(tag%3*width, orignY, width - 1, height)];
    [baseView setBackgroundColor:[UIColor whiteColor]];
    [bottomView addSubview:baseView];

    if (tag == 5){
        [baseView setFrame:CGRectMake(VIEWFOX(baseView), orignY, width*2, height)];
    }

    UIImage *image = IMAGENAMED(imgName);
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake((width - image.size.width)/2, (height - image.size.height)/2 - 10, image.size.width, image.size.height)];
    if (tag == 4) {
        imgv.frame = CGRectMake((width - image.size.width*1.5)/2, (height - image.size.height*1.5)/2 - 10, image.size.width*1.5, image.size.height*1.5);
    }
    [imgv setImage:image];
    [imgv setBackgroundColor:[UIColor clearColor]];
    [baseView addSubview:imgv];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEWFH_Y(imgv), width, 16)];
    if (tag == 4) {
        label.frame = CGRectMake(0, VIEWFH_Y(imgv)+5, width, 16);
    }
    [label setText:title];
    [label setTextColor:[UIColor colorWithRed:0.05 green:0.07 blue:0.08 alpha:1]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:15]];

    [baseView addSubview:label];
    [baseView setTag:tag];
    [baseView addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark 点击事件

- (void)popToLogin{
    LoginCtrl *login = [[LoginCtrl alloc] init];
    [login setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:login animated:YES];
}

- (void)clickButton:(id)sender{
    switch ([sender tag]) {
        case 0:[self showBulletinBoardCtrl]; break;
        case 2:[self showIntegralCtrl];break;
        case 1:[self showActivityCenterCtrl]; break;
        case 3:[self showInvitedFriend]; break;
        case 4:[self showCheckIn]; break;
        default:break;
    }
}

- (void)showIntegralCtrl{
    UserModel *usr = [UserModel shareUserManager];
    if (!usr.isLogin){
        [self popToLogin];
        return;
    }

    NSInteger timeStamp = [[NSDate date] timeIntervalSince1970];
    NSString *md5Code = [NSString stringWithFormat:@"%@%@app_url%tu",usr.userID,usr.userName,timeStamp];
    md5Code = [HttpManager md5:md5Code];
    NSString *urlStr = [NSString stringWithFormat:@"%@/wap/topic/integralapp/default?username=%@&data=%@&timestamp=%tu&app=ios",INTEGRAL_URL,usr.userName,md5Code,timeStamp];

    NSLOG(@"%@",urlStr);
    WebViewCtrl *webCtrl = [[WebViewCtrl alloc] init];
    webCtrl.name =@"积分乐园";
    webCtrl.url = urlStr;
    [webCtrl setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:webCtrl animated:YES];
}

- (void)showBulletinBoardCtrl{
    if (![UserModel shareUserManager].isLogin){
        [self popToLogin];
        return;
    }
    [self.navigationController.navigationBar setHidden:NO];
    BulletinBoardCtrl *bulletinBoardCtrl = [[BulletinBoardCtrl alloc] init];
    [bulletinBoardCtrl setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:bulletinBoardCtrl animated:YES];
}

- (void)showActivityCenterCtrl{
    [self.navigationController.navigationBar setHidden:NO];
    ActivityCenterCtrl *activityCenterCtrl = [[ActivityCenterCtrl alloc] init];
    [activityCenterCtrl setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:activityCenterCtrl animated:YES];
}

- (void)showInvitedFriend{
    [self.navigationController.navigationBar setHidden:NO];
    InvitedFriend *invFri = [[InvitedFriend alloc] init];
    [invFri setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:invFri animated:YES];
}

- (void)showCheckIn {
    WebViewCtrl *web = [[WebViewCtrl alloc] init];
    web.name = @"签到抽奖";
    /** 正式签到抽奖 */
    //public final static String URL_QIANDAO ="http://www.szytou.com/wap/topic/signin/default.aspx";
    /** 测试签到抽奖 */
    //	public final static String URL_QIANDAO ="http://apitest.haokoudai.com:9092/wap/topic/signin/default.aspx";
#if DEBUG
    web.url = @"http://apitest.haokoudai.com:9092/wap/topic/signin/default.aspx";
#else
    web.url = @"http://www.szytou.com/wap/topic/signin/default.aspx";
#endif
    [self.navigationController.navigationBar setHidden:NO];
    [web setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:web animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
