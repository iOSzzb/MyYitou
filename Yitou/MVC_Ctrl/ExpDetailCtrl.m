//
//  ExpDetailCtrl.m
//  Yitou
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "ExpDetailCtrl.h"
#import <MDRadialProgressView.h>
#import <MDRadialProgressTheme.h>
#import <MDRadialProgressLabel.h>
#import "ExpDetailCell.h"
#import "NullView.h"
#import "LoginCtrl.h"
#import "InvestPayCtrl.h"
#import "LXHTimer.h"

@interface ExpDetailCtrl ()

@property (nonatomic)UITableView *tableview;
@property (nonatomic)NullView *nullView;
@property (nonatomic)NSArray *dataSource;
@property (assign)float orignY;

@end

@implementation ExpDetailCtrl{
    UIScrollView *scrollview;
    MDRadialProgressView *radioView;
    UIButton *investButton;
}

@synthesize tender,tableview,nullView,dataSource,orignY;

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"体验标";
    [self.view setBackgroundColor:BG_BLUEColor];
    [self loadAllView];
}

- (void)loadAllView{
    orignY = 0;
    [self loadScrollview];
    [self loadTopView];
    [self loadDetailView];
    [self loadTableview];
}

- (void)loadScrollview{
    scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
    [scrollview setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:scrollview];
}

#pragma mark loadAllView
- (void)loadTopView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREENWidth, 106)];
    [topView setBackgroundColor:[UIColor whiteColor]];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, SCREENWidth, 20)];
    [titleLabel setText:tender.title];
    [titleLabel setTextColor:[UIColor colorWithRed:0.22 green:0.62 blue:0.91 alpha:1]];
    [titleLabel setFont:[UIFont systemFontOfSize:18]];
    [topView addSubview:titleLabel];
    orignY = VIEWFH_Y(titleLabel) + 16;

    NSString *values = [tender.minEarn stringByAppendingString:@"%"];
    [topView addSubview:[self loadViewWithTitle:@"年化利率" value:values tag:1]];
    values = [tender.tenderSum stringByAppendingString:tender.tenderSumUnit];
    [topView addSubview:[self loadViewWithTitle:@"金额" value:values tag:2]];
    values = [tender.timeCount stringByAppendingString:tender.timeCountUnit];
    [topView addSubview:[self loadViewWithTitle:@"期限" value:values tag:3]];

    float width = VIEWFSH(topView)>130?110:VIEWFSH(topView) - 20;
    MDRadialProgressTheme *them = [MDRadialProgressTheme themeWithName:keyFont];
    [them setFont:[UIFont systemFontOfSize:0]];
    [them setCenterColor:[UIColor colorWithRed:0.97 green:0.91 blue:0.91 alpha:0.94]];

    radioView = [[MDRadialProgressView alloc] initWithFrame:CGRectMake(SCREENWidth - width - 10, 10, width, width) andTheme:them];

    NSInteger sum = [tender.tenderSum integerValue];
    sum = [tender.tenderSumUnit hasPrefix:@"万"] == YES? sum *10000:sum;
    NSInteger didTender = [tender.tenderCount integerValue];
    didTender = [tender.tenderCountUnit hasPrefix:@"万"] == YES?didTender*10000:didTender;

    radioView.progressTotal = sum;
    radioView.progressCounter = didTender;
    radioView.theme.thickness = 15;
    radioView.theme.incompletedColor = [UIColor orangeColor];
    radioView.theme.completedColor = [UIColor colorWithRed:0.16 green:0.54 blue:0.89 alpha:1];
    radioView.theme.sliceDividerHidden = YES;
    radioView.label.hidden = YES;

    UILabel *progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    [progressLabel setText:[NSString stringWithFormat:@"%tu",didTender*100/sum]];
    progressLabel.text = [progressLabel.text stringByAppendingString:@"%"];
    [progressLabel setTextAlignment:NSTextAlignmentCenter];
    [progressLabel setTextColor:[UIColor grayColor]];
    [radioView addSubview:progressLabel];
    [topView addSubview:radioView];
    [scrollview addSubview:topView];
    orignY = VIEWFH_Y(topView);
}

- (UIView *)loadViewWithTitle:(NSString *)title value:(NSString *)value tag:(NSInteger)indx{
    float width = SCREENWidth/3*2;
    width /= 3;
    float orignX = (indx -1)*width;

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(orignX, orignY, width, 40)];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 20)];
    [titleLabel setTextColor:[UIColor colorWithRed:0.36 green:0.36 blue:0.37 alpha:1]];
    [titleLabel setText:title];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:titleLabel];

    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEWFH_Y(titleLabel), width, 20)];
    [valueLabel setTextColor:[UIColor colorWithRed:0.98 green:0.53 blue:0.47 alpha:1]];
    [valueLabel setText:value];
    [valueLabel setTextAlignment:NSTextAlignmentCenter];
    [valueLabel setFont:[UIFont systemFontOfSize:14]];
    [view addSubview:valueLabel];

    return view;
}

- (void)loadDetailView{
    orignY += 10;
    UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, 6)];
    [detailView setBackgroundColor:[UIColor colorWithRed:0.77 green:0.77 blue:0.77 alpha:0.66]];
    [scrollview addSubview:detailView];

    orignY = 0;
    [detailView addSubview:[self loadDetailViewWithTitle:@"发布时间" value:tender.createTime tag:0]];
    [detailView addSubview:[self loadDetailViewWithTitle:@"项目有效时间" value:tender.endTime tag:1]];
    [detailView addSubview:[self loadDetailViewWithTitle:@"还款方式" value:tender.payStyle tag:2]];
    [detailView addSubview:[self loadDetailViewWithTitle:@"可投余额" value:tender.balance tag:3]];
    [detailView addSubview:[self loadDetailViewWithTitle:@"起投金额" value:tender.minInvest tag:4]];
    [detailView addSubview:[self loadDetailViewWithTitle:@"项目类型" value:@"新手体验金专用标" tag:5]];
    [detailView setFrame:CGRectMake(0, VIEWFOY(detailView), SCREENWidth, orignY -2)];
    orignY = VIEWFH_Y(detailView);
}

- (UIView *)loadDetailViewWithTitle:(NSString *)key value:(NSString *)value tag:(NSInteger)indx{
    float viewHeight = 45;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, viewHeight)];
    [view setBackgroundColor:[UIColor whiteColor]];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 120, viewHeight)];
    [titleLabel setTextColor:[UIColor colorWithRed:0.51 green:0.51 blue:0.51 alpha:1]];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleLabel setText:key];
    [view addSubview:titleLabel];

    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth - 10, viewHeight)];
    [valueLabel setTextColor:[UIColor colorWithRed:0.51 green:0.51 blue:0.51 alpha:1]];
    [valueLabel setTextAlignment:NSTextAlignmentRight];
    [valueLabel setFont:[UIFont systemFontOfSize:14]];
    [valueLabel setText:value];
    [view addSubview:valueLabel];
    orignY = VIEWFH_Y(view) + 1;
    return view;
}

- (void)loadTableview{
    orignY += 10;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 40)];
    [headView addSubview:[self loadTableviewHeadWithKey:@"投标用户" indx:0]];
    [headView addSubview:[self loadTableviewHeadWithKey:@"投标金额" indx:1]];
    [headView addSubview:[self loadTableviewHeadWithKey:@"投标收益" indx:2]];
    [headView addSubview:[self loadTableviewHeadWithKey:@"投标时间" indx:3]];
    [headView setBackgroundColor:[UIColor colorWithRed:0.16 green:0.54 blue:0.89 alpha:1]];

    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, 40 + CELLHeight) style:UITableViewStyleGrouped];
    [tableview setTableHeaderView:headView];
    [tableview setDelegate:self];
    [tableview setDataSource:self];
    [tableview setScrollEnabled:NO];
    [tableview setUserInteractionEnabled:NO];
    [scrollview addSubview:tableview];

    nullView = [[NullView alloc] initWithFrame:CGRectMake(0, 40, VIEWFSW(tableview), VIEWFSH(tableview) - 40)];
    [nullView setBackgroundColor:[UIColor whiteColor]];
    [tableview addSubview:nullView];
    orignY = VIEWFH_Y(tableview);

    __weak typeof(self) weakSelf = self;

    [HttpManager getInvestRecordListInPage:1 investID:tender.tenderID Block:^(RequestResult rqCode, NSArray *array, NSInteger sumCount, NSString *describle) {
        if (rqCode != rqSuccess || [array count] == 0)
            return ;
        [weakSelf.nullView removeFromSuperview];
        weakSelf.dataSource = array;
        [weakSelf.tableview reloadData];
        weakSelf.orignY = VIEWFH_Y(tableview);
        [weakSelf loadButton];
    }];
    [self loadButton];
}

- (void)loadButton{
    [investButton removeFromSuperview];

    orignY += 10;

    investButton = [[UIButton alloc] initWithFrame:CGRectMake(10, orignY, SCREENWidth - 20, 40)];
    [investButton setBackgroundColor:[UIColor colorWithRed:0.16 green:0.54 blue:0.89 alpha:1]];
    [scrollview addSubview:investButton];
    NSString *str = @"           立即使用          ";//cw 原为 立即使用 2000元体验金
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22] range:NSMakeRange(11, 4)];
    [attri addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(11, 4)];
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(15, [str length] - 15)];
    [attri addAttribute:NSForegroundColorAttributeName value:COLORWithRGB(255, 255, 255, 0.70) range:NSMakeRange(15, [str length] - 15)];
    [investButton setAttributedTitle:attri forState:UIControlStateNormal];
    [investButton addTarget:self action:@selector(clickInvestButton) forControlEvents:UIControlEventTouchUpInside];
    [scrollview setContentSize:CGSizeMake(SCREENWidth, VIEWFH_Y(investButton)+30)];

}

- (UILabel *)loadTableviewHeadWithKey:(NSString *)title indx:(NSInteger)indx{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(indx*SCREENWidth/4, 0, SCREENWidth/4, 40)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:title];
    [label setFont:[UIFont systemFontOfSize:16]];
    [label setTextColor:[UIColor whiteColor]];
    return label;
}

#pragma mark Event

- (void)clickInvestButton{
    UserModel *usrModel = [UserModel shareUserManager];
    if (!usrModel.isLogin){
        LoginCtrl *loginCtrl = [[LoginCtrl alloc]initWithNibName:@"LoginCtrl" bundle:nil];
        [loginCtrl setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:loginCtrl animated:YES];
        return;
    }
    if (![tender canInvestStatus]){
        if (![LXHTimer shareTimerManager].isValid){
            [SVProgressHUD showErrorWithStatus:@"获取服务器时间失败,请在一分钟后重试"];
        }else{
            [SVProgressHUD showErrorWithStatus:@"不可投标的状态,请选择其它可投的标"];
        }
        return;
    }
    InvestPayCtrl *invest = [[InvestPayCtrl alloc] init];
    invest.tender = tender;
    invest.dataSource = _detail;
    [self.navigationController pushViewController:invest animated:YES];
}


#pragma mark TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([dataSource count] > 0)
        [tableview setFrame:CGRectMake(0, VIEWFOY(tableview), SCREENWidth, CELLHeight*dataSource.count + 40)];
    return CELLHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"insvestRecordCell";
    ExpDetailCell *cell = (ExpDetailCell*)[tableview dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        cell = [[ExpDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [cell setCell:[dataSource objectAtIndex:indexPath.row]];
    }
    [cell setCell:dataSource[indexPath.row]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return nil;
}

@end
