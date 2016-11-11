//
//  MyInvestRecordCtrl.m
//  Yitou
//
//  Created by Xiaohui on 15/11/13.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import "MyInvestRecordCtrl.h"
#import "MyInvestDetailCtrl.h"
#import <MJRefresh.h>
#import "MyInvestView.h"
#import "MyInvestCell.h"
#import "NullView.h"

#define SMALLViewH   (SCREENHeight>570?73:53)

@interface MyInvestRecordCtrl ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,copy)UIScrollView *scrollview;
@property (nonatomic,copy)UITableView *tableview;
@property (nonatomic,copy)NSString *showType;
@property (nonatomic,copy)NSArray *dataSource;
@property (nonatomic,copy)NullView *nullView;
@property (nonatomic,copy)NSString *rqType;
@property (assign)NSInteger pageIndx;

@end

@implementation MyInvestRecordCtrl{
    float           orignY;
}

@synthesize scrollview,tableview,showType,dataSource,nullView,rqType,pageIndx;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的投资";
    dataSource = [NSArray new];
    [self loadAllView];
}

- (void)loadAllView{
    [self loadScrollview];
    [self loadTopView];
    showType = @"0";
    MyInvestView *myView = [[MyInvestView alloc] initWithFrame:CGRectMake(0, (SMALLViewH*2+50), SCREENWidth, 160)];
    __weak typeof(self) weakSelf = self;
    [myView loadMyInvestViewWithBlock:^(NSInteger indx) {
        if (indx ==0||indx==1){
            weakSelf.showType = [NSString stringWithFormat:@"%li",(long)indx];
            weakSelf.dataSource = [NSArray new];
            [weakSelf.tableview.mj_header setState:MJRefreshStateRefreshing];
        }
    }];
    pageIndx = 1;
    [myView setFrame:CGRectMake(0, VIEWFOY(myView), SCREENWidth, myView.height)];
    orignY = VIEWFH_Y(myView);
    [scrollview addSubview:myView];
    [self loadTableview];
}

- (void)loadTableview{
    float existH = SCREENHeight - orignY-64;

    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, existH) style:UITableViewStyleGrouped];

    nullView = [[NullView alloc] initWithFrame:CGRectMake(0, 0, VIEWFSW(tableview), VIEWFSH(tableview))];

    [tableview setDataSource:self];
    [tableview setDelegate:self];
    [scrollview addSubview:tableview];
    [tableview setScrollEnabled:YES];
    __weak typeof(self) weakSelf = self;
    tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.rqType = weakSelf.showType;
        weakSelf.pageIndx = 1;
        [weakSelf loadDataSource];
    }];

    [tableview.mj_header setState:MJRefreshStateRefreshing];
}

- (void)loadTableviewFooter{
    __weak typeof(self) weakSelf = self;
    tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.rqType = weakSelf.showType;
        if (weakSelf.dataSource.count >1){
            weakSelf.pageIndx += 1;
        }
        [weakSelf loadDataSource];
    }];
}

- (void)loadDataSource{
    UserModel *usrModel = [UserModel shareUserManager];
    NSDictionary *dict1 = @{@"client_id":KEY_CLIENTID,@"user_name":usrModel.userName,@"password":usrModel.password,@"invest_type":showType,@"pageindex":[NSString stringWithFormat:@"%tu",pageIndx],@"pagesize":@"10"};
    NSDictionary *para = @{@"cmdid":@"user_income_list",@"data":dict1};

    __weak typeof(self) weakSelf = self;
    [HttpManager hmRequestWithPara:para Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {

        [weakSelf.tableview.mj_footer endRefreshing];
        [weakSelf.tableview.mj_header endRefreshing];

        if (!STRCMP(weakSelf.rqType , weakSelf.showType)){
//            [SVProgressHUD showErrorWithStatus:@""];
            NSLOG(@"操作频繁  过滤数据");
            return ;
        }
        if (rqCode != rqSuccess){
            [SVProgressHUD showErrorWithStatus:describle];
            weakSelf.pageIndx = weakSelf.pageIndx>1?weakSelf.pageIndx--:1;
            return ;
        }
        NSInteger sumCount = [[receiveData objectForKey:@"rowcounts"] integerValue];
        if (weakSelf.dataSource.count == sumCount){
            if (weakSelf.dataSource.count == 0)
                [weakSelf.tableview addSubview:weakSelf.nullView];
            [weakSelf.tableview.mj_footer removeFromSuperview];
            [SVProgressHUD showErrorWithStatus:@"加载完毕,没有更多数据了..."];
            [weakSelf.tableview reloadData];
            return;
        }

        [weakSelf loadTableviewFooter];
        if (weakSelf.pageIndx == 1){
            weakSelf.dataSource = [NSArray arrayWithArray:[receiveData objectForKey:@"data"]];
        }
        else{
            NSMutableArray *temp = [NSMutableArray new];
            [temp addObjectsFromArray:weakSelf.dataSource];
            [temp addObjectsFromArray:[receiveData objectForKey:@"data"]];
            weakSelf.dataSource = [NSArray arrayWithArray:temp];
        }
        if (weakSelf.dataSource.count > sumCount){
            weakSelf.dataSource = [NSArray new];
            [weakSelf.tableview reloadData];
            return;
        }//数据问题,从新获取

        if (weakSelf.dataSource.count == 0)
            [weakSelf.tableview addSubview:weakSelf.nullView];
        else
            [weakSelf.nullView removeFromSuperview];
        [weakSelf.tableview reloadData];

    }];
}

- (void)loadScrollview{
    scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
    [self.view addSubview:scrollview];
}

- (void)loadTopView{
    UserModel *usrModel = [UserModel shareUserManager];

    UIView *moneySum = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREENWidth/2, SMALLViewH)];
    [self loadView:moneySum icon:@"icon_myMoney" title:@"资产总额" detail:usrModel.sumMoney];
    [scrollview addSubview:moneySum];

    UIView *waitOwnMoney =[[UIView alloc] initWithFrame:CGRectMake(SCREENWidth/2, 20, SCREENWidth/2, SMALLViewH)];
    [self loadView:waitOwnMoney icon:@"icon_myWait" title:@"待收本金" detail:usrModel.waitPrin];
    [scrollview addSubview:waitOwnMoney];

    UIView *waitEarn = [[UIView alloc] initWithFrame:CGRectMake(0, VIEWFH_Y(moneySum)+20, SCREENWidth/2, SMALLViewH)];
    [self loadView:waitEarn icon:@"icon_myWaitEarn" title:@"待收利息" detail:usrModel.waitInterest];
    [scrollview addSubview:waitEarn];

    UIView *allEarn = [[UIView alloc] initWithFrame:CGRectMake(SCREENWidth/2, VIEWFH_Y(moneySum)+20, SCREENWidth/2, SMALLViewH)];
    [self loadView:allEarn icon:@"icon_mySumEarn" title:@"累计总收益" detail:usrModel.didEarn];
    [scrollview addSubview:allEarn];
}

- (void)loadView:(UIView *)baseView icon:(NSString *)imgName title:(NSString *)title detail:(NSString *)value{
    float orignX = VIEWFOX(baseView)>100?0:20;
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(orignX, 0, SMALLViewH, SMALLViewH)];
    [imgv setImage:IMAGENAMED(imgName)];
    [baseView addSubview:imgv];

    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(VIEWFW_X(imgv), SMALLViewH/2-20, VIEWFSW(baseView)-VIEWFW_X(imgv), 20)];
    [titleLb setText:title];
    [titleLb setFont:[UIFont systemFontOfSize:16]];
    [titleLb setTextAlignment:NSTextAlignmentCenter];
    [baseView addSubview:titleLb];

    UILabel *detailLB = [[UILabel alloc] initWithFrame:CGRectMake(VIEWFOX(titleLb), VIEWFH_Y(titleLb)+10, VIEWFSW(titleLb), 16)];
    [detailLB setTextAlignment:NSTextAlignmentCenter];
    [detailLB setText:[self changeMoney:value]];
    [detailLB setFont:[UIFont systemFontOfSize:14]];
    [detailLB setTextColor:[UIColor colorWithRed:0.92 green:0.46 blue:0.15 alpha:1]];
    [baseView addSubview:detailLB];
}

- (NSString *)changeMoney:(NSString *)orignMoney{
    float temp = [orignMoney floatValue];
    NSString *result;
    if (temp >=100000){
        result = [NSString stringWithFormat:@"¥%.0f",[orignMoney floatValue]];
    }
    else {
        result = [NSString stringWithFormat:@"¥%@",orignMoney];
    }
    if (temp >=1000000){
        temp = [orignMoney intValue]/10000;
        result = [NSString stringWithFormat:@"¥%.2f万",temp];
    }
    return result;
}

#pragma mark TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLOG(@"index count:%tu",dataSource.count);
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"MyInsvestCell";
    MyInvestCell *cell = (MyInvestCell*)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        cell = [[MyInvestCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    for (UIView *view in cell.contentView.subviews)
        [view removeFromSuperview];
    cell.showReal = STRCMP(@"1", showType);
    [cell setCell:[dataSource objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELLHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MyInvestDetailCtrl *detailCtrl = [[MyInvestDetailCtrl alloc] init];
    detailCtrl.dataSource = [dataSource objectAtIndex:indexPath.row];
    detailCtrl.isReceivingInvest = STRCMP(@"0", showType);
    [self.navigationController pushViewController:detailCtrl animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
