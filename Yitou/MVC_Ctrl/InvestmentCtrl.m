//
//  InvestmentCtrl.m
//  Yitou
//
//  Created by Xiaohui on 15/8/10.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "InvestmentCtrl.h"
#import "InvestTopView.h"
#import "InvestmentCell.h"
#import "InvestDetailCtrl.h"
#import <MJRefresh.h>
#import "InvestTypeView.h"
#import "NullView.h"
#import "ExpDetailCtrl.h"
#import <MobClick.h>

@interface InvestmentCtrl ()<UITableViewDelegate,UITableViewDataSource,InvestTopViewDelegate>

@property (nonatomic)UITableView *tableview;
@property (nonatomic)NSMutableArray *dataSource;
@property (nonatomic)CustomNavigation *customNav;

@property (nonatomic)InvestTypeView *typeView;
@property (nonatomic)InvestTopView *topView;
@property (nonatomic)NullView *nullView;
@property (assign)NSInteger page;
@property (assign)NSInteger countSum;

@end

@implementation InvestmentCtrl

@synthesize tableview,dataSource,customNav,nullView,page,countSum,typeView,topView;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    countSum = 1;
    self.navigationController.navigationBar.barTintColor = NAVIGATIONColor;
    self.title = @"所有项目";
    self.navigationController.title=@"投资";
    typeView = [[InvestTypeView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];

    [self loadTopView];
    [self loadTableview];
    dataSource = [NSMutableArray new];
    [tableview.mj_header setState:MJRefreshStateRefreshing];

    customNav = [[CustomNavigation alloc] init];
    [customNav customNavigationTitle:self.navigationController];
    __weak typeof(self) weakSelf = self;
    [customNav customNavigationView:self.navigationItem title:@"所有项目" block:^(NSInteger indx) {
        [MobClick event:@"2101"];
        [weakSelf loadInvestTypeView];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAllData) name:@"TenderReloadNotification" object:nil];

}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 加载UI

- (void)loadInvestTypeView{
    [typeView setAlpha:1.0];
    __weak typeof(self) weakSelf = self;
    [typeView loadTypeWithBlock:^(NSInteger indx, NSDictionary *dataSources) {
        [UIView animateWithDuration:0.6 animations:^{
            [weakSelf.typeView setAlpha:0.0];
        }];
        if (dataSources){
            [weakSelf.customNav customNavigationView:weakSelf.navigationItem title:[dataSources objectForKey:@"item_name"] block:nil];
            weakSelf.page = 1;
            [weakSelf.tableview.mj_header setState:MJRefreshStateRefreshing];
            [MobClick event:@"2102"];
        }
        else{
            [MobClick event:@"2104"];
        }
    }];
    [self.view.window addSubview:typeView];
    return;
}

- (void)loadTableview{
    int h =SCREENHeight;
    h -= VIEWFH_Y(topView);
    h -= self.tabBarController.tabBar.frame.size.height;
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, VIEWFH_Y(topView)+2, SCREENWidth, h-2) style:UITableViewStyleGrouped];
    nullView = [[NullView alloc] initWithFrame:CGRectMake(0, 0, VIEWFSW(tableview), VIEWFSH(tableview))];
    [tableview setBackgroundColor:[UIColor blueColor]];
    [self.view setBackgroundColor:BG_BLUEColor];
    [tableview setDelegate:self];
    [tableview setDataSource:self];
    [tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableview setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:tableview];
    page = 1;

    __weak typeof(self) weakSelf = self;
    tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.tableview.mj_footer endRefreshing];
        weakSelf.page = 1;
        [weakSelf loadNewPage];
    }];
}

- (void)loadTableviewFooter{
    [tableview.mj_footer removeFromSuperview];
    __weak typeof(self) weakSelf = self;
    tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.tableview.mj_header endRefreshing];
        weakSelf.page ++;
        if (weakSelf.dataSource.count >= weakSelf.countSum){
            [weakSelf.tableview.mj_footer endRefreshing];
            [SVProgressHUD showErrorWithStatus:@"没有更多数据了"];
            return;
        }
        [weakSelf loadNewPage];
    }];
}

- (void)loadTopView{
    topView = [[InvestTopView alloc]initWithFrame:CGRectMake(0, 64, SCREENWidth, 40)];
    topView.delegate = self;
    [topView loadTopView];
    [self.view addSubview:topView];
}

#pragma mark 加载数据

- (void)loadNewPage{
    NSString *key = @"0";
    NSString *values;
    NSMutableDictionary *para = [NSMutableDictionary new];
    if (topView.lastIndx == 1){
        key = @"lilvby";
        values = [NSString stringWithFormat:@"%tu",topView.status];
        [para setObject:values forKey:key];
    }
    if (topView.lastIndx == 2){
        key = @"durationby";
        values = [NSString stringWithFormat:@"%tu",topView.status];
        [para setObject:values forKey:key];
    }
    if (![typeView.typeCode isEqualToString:@""]){
        [para setObject:typeView.typeCode forKey:@"borrow_type"];
    }
    [para setObject:[NSString stringWithFormat:@"%tu",page] forKey:@"pageindex"];
    __weak typeof(self) weakSelf = self;
    [HttpManager getBorrowMoneyListWithPara:para Block:^(RequestResult rqCode, NSArray *array, NSInteger sumCount, NSString *describle) {
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        if (rqCode != rqSuccess){
            [MobClick event:@"2001"];
            [SVProgressHUD showErrorWithStatus:describle];
            weakSelf.page = weakSelf.page > 1?weakSelf.page--:1;
            return ;
        }

        if (weakSelf.page == 1){
            weakSelf.dataSource = [[NSMutableArray alloc] initWithArray:array];
            [weakSelf.tableview reloadData];
        }
        else if([weakSelf.dataSource count]<sumCount){
            [weakSelf.dataSource addObjectsFromArray:array];
            [weakSelf.tableview reloadData];
        }
        [weakSelf.nullView removeFromSuperview];
        if (weakSelf.dataSource.count == 0)
            [weakSelf.tableview addSubview:weakSelf.nullView];
        weakSelf.countSum = sumCount;
        if (weakSelf.countSum == [weakSelf.dataSource count]) {
            [weakSelf.tableview.mj_footer removeFromSuperview];
        }else{
            [weakSelf loadTableviewFooter];
        }
    }];
}

#pragma mark 点击顶部类型事件

- (void)topViewDidClicked{
    [MobClick event:@"2103"];
    [tableview.mj_header setState:MJRefreshStateRefreshing];
}

#pragma mark TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"insvestCell";
    InvestmentCell *cell = (InvestmentCell*)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        cell = [[InvestmentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    for (UIView *view in cell.contentView.subviews){
        [view removeFromSuperview];
    }
    Tender *tend = [dataSource objectAtIndex:indexPath.row];
    cell.tender = tend;
    [cell setCell];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELLHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Tender *tender = [dataSource objectAtIndex:indexPath.row];
    [SVProgressHUD showWithStatus:@"正在获取数据" maskType:SVProgressHUDMaskTypeBlack];
    __weak typeof(self) weakSelf = self;
    [HttpManager getInvestDetailWithID:tender.tenderID Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        [SVProgressHUD dismiss];
        if (rqCode == rqSuccess && !tender.isExp){
            InvestDetailCtrl *invest = [[InvestDetailCtrl alloc] init];
            invest.tender = tender;
            invest.detail = receiveData;
            [invest setHidesBottomBarWhenPushed:YES];
            [weakSelf.navigationController pushViewController:invest animated:YES];
        }
        else if (rqCode == rqSuccess){
            ExpDetailCtrl *expCtrl = [[ExpDetailCtrl alloc] init];
            expCtrl.tender = tender;
            expCtrl.detail = receiveData;
            [expCtrl setHidesBottomBarWhenPushed:YES];
            [weakSelf.navigationController pushViewController:expCtrl animated:YES];
        }
        else
            [SVProgressHUD showErrorWithStatus:describle];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)reloadAllData {
    [tableview.mj_header beginRefreshing];
}

@end
