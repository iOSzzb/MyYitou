//
//  InvitedFriend.m
//  Yitou
//
//  Created by mac on 16/1/21.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "InvitedFriend.h"
#import <MJRefresh.h>
#import "ActivityInvitedCtrl.h"
#import "LoginCtrl.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>

#define CELLHeight 45

@interface InvitedFriend ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,copy)UITableView *tableview;
@property (nonatomic,copy)UILabel *moneyLabel;
@property (nonatomic,copy)NSString *shareStr;
@property (nonatomic,copy)NSArray *dataSource;
@property (nonatomic,copy)NSDictionary *shareData;
@property (assign)NSInteger page;
@property (assign)BOOL showUM;

@end

@implementation InvitedFriend{
    UIView *headView;
    float orignY;
}

@synthesize tableview,moneyLabel,shareStr,dataSource,shareData,page,showUM;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"推荐好友"];
    [self loadAllView];
    page = 1;
    showUM = NO;
    [self loadUserData];
    [self loadShareRewardList];
}

#pragma mark 获取数据

- (void)loadUserData{
    UserModel *usrModel = [UserModel shareUserManager];
    if (!usrModel.isLogin)
        return;
    NSDictionary *para = @{@"client_id":KEY_CLIENTID,@"user_name":usrModel.userName,@"password":usrModel.password};
    para = @{@"cmdid":@"userrecommenditem",@"data":para};
    [SVProgressHUD showWithStatus:@"正在加载数据" maskType:SVProgressHUDMaskTypeBlack];
    __weak typeof(self) weakSelf = self;
    [HttpManager hmRequestWithPara:para Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        [SVProgressHUD dismiss];
        if (rqCode != rqSuccess)
            return ;
        receiveData = [receiveData objectForKey:@"data"];
        weakSelf.moneyLabel.text = [receiveData objectForKey:@"amount_total"];
        weakSelf.shareData = receiveData;
        weakSelf.shareStr = [receiveData objectForKey:@"fromUrl"];
        [[UserModel shareUserManager] setShareUrl:weakSelf.shareStr];
        weakSelf.shareStr = [[receiveData objectForKey:@"shareContent"] stringByAppendingString:weakSelf.shareStr];
        if (weakSelf.showUM){
            [weakSelf showUMengShareView];
        }
    }];
}

- (void)loadShareRewardList{
    UserModel *usr = [UserModel shareUserManager];
    if (!usr.isLogin){
        [tableview.mj_header endRefreshing];
        return;
    }
    NSString *pageStr = [NSString stringWithFormat:@"%tu",page];
    NSDictionary *para = @{@"client_id":KEY_CLIENTID,@"user_name":usr.userName,@"password":usr.password,@"pageindex":pageStr};
    para = @{@"cmdid":@"userrecommendprofit",@"data":para};
    __weak typeof(self) weakSelf = self;
    [HttpManager hmRequestWithPara:para Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        if (rqCode != rqSuccess){
            [SVProgressHUD showErrorWithStatus:describle];
            return ;
        }

        if (weakSelf.page == 1){
            weakSelf.dataSource = [receiveData objectForKey:@"data"];
        }else{
            NSMutableArray *array = [NSMutableArray new];
            [array addObjectsFromArray:dataSource];
            [array addObjectsFromArray:[receiveData objectForKey:@"data"]];
            weakSelf.dataSource = array;
        }

        if (weakSelf.page >= [[receiveData objectForKey:@"totalpages"] integerValue]){
            [weakSelf.tableview.mj_footer removeFromSuperview];
        }
        else{
            [weakSelf loadTableviewFooter];
        }
        [weakSelf.tableview reloadData];
    }];
}

#pragma mark 加载UI

- (void)loadAllView{
    orignY = 0;
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 80)];
    [self loadTopImageView];
    [self loadDescribleView];
    orignY += 15;
    [self loadHeadViewLine];
    orignY +=10;
    [self loadToolViewWithTitle:@"好友用户名" tag:0];
    [self loadToolViewWithTitle:@"所获得金额" tag:1];
    [self loadToolViewWithTitle:@"好友投资收益" tag:2];
    [headView setFrame:CGRectMake(0, 0, SCREENWidth, orignY)];
    [self loadHeadViewLine];
    [self loadTableview];
}

- (void)loadHeadViewLine{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, orignY-1, SCREENWidth, 1)];
    [view setBackgroundColor:[UIColor grayColor]];
    [view setAlpha:0.45];
    [headView addSubview:view];
}

- (void)loadTableview{
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
    [tableview setTableHeaderView:headView];
    [tableview setDelegate:self];
    [tableview setDataSource:self];
    [tableview setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:tableview];
    __weak typeof(self) weakSelf = self;
    tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf loadShareRewardList];
    }];
}

- (void)loadToolViewWithTitle:(NSString *)title tag:(NSInteger)tag{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWidth/3*tag, orignY, SCREENWidth/3, 20)];
    [label setText:title];
    [label setTextColor:[UIColor colorWithRed:0.24 green:0.24 blue:0.24 alpha:1]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [headView addSubview:label];
    if (tag == 2){
        orignY = VIEWFH_Y(label)+10;
    }
}

- (void)loadDescribleView{
    orignY += 10;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, orignY, SCREENWidth - 30, 70)];
    [label setNumberOfLines:3];
    NSString *desc = @"好友投资拿返利90天收益!被邀请的好友自注册之日起90天内每完成一笔投资,邀请人可获得好友投资金额0.1%的返利";
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:desc];
    [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.21 green:0.21 blue:0.22 alpha:1] range:NSMakeRange(0, [desc length])];
    [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.88 green:0 blue:0 alpha:1] range:NSMakeRange(7, 5)];
    [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.88 green:0 blue:0 alpha:1] range:NSMakeRange(49, 4)];
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, [desc length])];
    [label setAttributedText:attri];
    [headView addSubview:label];
    UIButton *descBtn = [[UIButton alloc] initWithFrame:CGRectMake(VIEWFOX(label), VIEWFH_Y(label)+10, 100, 30)];
    [descBtn setBackgroundColor:[UIColor colorWithRed:0.16 green:0.54 blue:0.89 alpha:1]];
    [descBtn setTitle:@"查看详情" forState:UIControlStateNormal];
    [descBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [descBtn.layer setMasksToBounds:YES];
    [descBtn.layer setCornerRadius:6.0];
    [descBtn addTarget:self action:@selector(clickDescribleButton) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:descBtn];
    orignY = VIEWFH_Y(descBtn);
}

- (void)clickDescribleButton{
    ActivityInvitedCtrl *invitedAct = [[ActivityInvitedCtrl alloc] init];
    [self.navigationController pushViewController:invitedAct animated:YES];
}

- (void)loadTopImageView{
    UIImage *image = IMAGENAMED(@"invited_bg");
    float height = SCREENWidth*image.size.height/image.size.width;
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, height)];
    [imgv setImage:image];
    [headView addSubview:imgv];
    orignY = VIEWFH_Y(imgv);

    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREENWidth, 16)];
    [descLabel setText:@"我的推荐累积收益"];
    [descLabel setTextAlignment:NSTextAlignmentCenter];
    [descLabel setTextColor:[UIColor colorWithHue:0.67 saturation:0.01 brightness:0.95 alpha:1]];
    [descLabel setFont:[UIFont systemFontOfSize:14]];
    [headView addSubview:descLabel];

    moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, VIEWFSH(imgv) - 20)];
    [moneyLabel setTextColor:[UIColor whiteColor]];
    [moneyLabel setText:@"0.00"];
    [moneyLabel setFont:[UIFont systemFontOfSize:40]];
    [moneyLabel setTextAlignment:NSTextAlignmentCenter];
    [headView addSubview:moneyLabel];

    UIButton *invitedBtn = [[UIButton alloc] initWithFrame:CGRectMake((SCREENWidth - 150)/2, VIEWFSH(imgv) - 48, 150, 35)];
    [invitedBtn setBackgroundColor:[UIColor colorWithHue:0.5 saturation:0 brightness:1 alpha:1]];
    [invitedBtn setTitle:@"邀请好友" forState:UIControlStateNormal];
    [invitedBtn setTitleColor:[UIColor colorWithHue:0.52 saturation:1 brightness:0.82 alpha:1] forState:UIControlStateNormal];
    [headView addSubview:invitedBtn];
    [invitedBtn addTarget:self action:@selector(showUMengShareView) forControlEvents:UIControlEventTouchUpInside];
    [invitedBtn.layer setMasksToBounds:YES];
    [invitedBtn.layer setCornerRadius:6.0];
}

- (void)loadTableviewFooter{
    [tableview.mj_footer removeFromSuperview];
    __weak typeof(self) weakSelf = self;
    tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.tableview.mj_header endRefreshing];
        weakSelf.page ++;
        [weakSelf loadShareRewardList];
    }];
}

- (UILabel *)loadCellLabelWithIndx:(NSInteger)indx{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(indx*SCREENWidth/3, 0, SCREENWidth/3, CELLHeight)];
    [label setTextColor:[UIColor colorWithRed:0.23 green:0.24 blue:0.24 alpha:1]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:14]];
    return label;
}

#pragma mark UMeng分享的Delegate

- (void)showUMengShareView{
    if (![UserModel shareUserManager].isLogin){
        LoginCtrl *login = [[LoginCtrl alloc] init];
        [login setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:login animated:YES];
        return;
    }
    if ([shareStr length] < 10||shareStr == nil){
        [self loadUserData];
        return;
    }

    NSArray* imageArray = @[[shareData objectForKey:@"shareImg"]];

    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:[shareData objectForKey:@"shareContent"]
                                     images:imageArray
                                        url:[NSURL URLWithString:[shareData objectForKey:@"fromUrl"]]
                                      title:[shareData objectForKey:@"shareTitle"]
                                       type:SSDKContentTypeAuto];

    [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {

        switch (state) {
            case SSDKResponseStateSuccess:{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                break;
            }
            case SSDKResponseStateFail:{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
            default:break;
        }
    }];
}

#pragma mark Tableview Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"insvestCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    for (UIView *view in cell.contentView.subviews){
        [view removeFromSuperview];
    }

    NSDictionary *dict = dataSource[indexPath.section];
    UILabel *lfLabel = [self loadCellLabelWithIndx:0];
    lfLabel.text = [dict objectForKey:@"username"];
    [cell .contentView addSubview:lfLabel];

    UILabel *ctLabel = [self loadCellLabelWithIndx:1];
    ctLabel.text = [dict objectForKey:@"amount"];
    [cell .contentView addSubview:ctLabel];

    UILabel *rtLabel = [self loadCellLabelWithIndx:2];
    rtLabel.text = [dict objectForKey:@"suminterest"];
    [cell .contentView addSubview:rtLabel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
