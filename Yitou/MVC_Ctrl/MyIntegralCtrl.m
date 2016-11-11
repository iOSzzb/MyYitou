//
//  MyIntegralCtrl.m
//  Yitou
//
//  Created by mac on 15/11/24.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import "MyIntegralCtrl.h"
#import "MyIntegralCell.h"
#import <MJRefresh.h>
#import "NullView.h"

@interface MyIntegralCtrl ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,copy)UITableView *tableview;
@property (nonatomic,copy)NSArray *dataSource;
@property (assign)NSInteger pageIndx;
@property (assign)NSInteger countSum;
@property (nonatomic,copy)NullView *nullView;

@end

@implementation MyIntegralCtrl{
    UILabel *myIntegralLB;
}

@synthesize tableview,dataSource,pageIndx,countSum,nullView;

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [tableview.mj_header setState:MJRefreshStateRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BG_BLUEColor];
    [self setTitle:@"我的积分"];
    pageIndx = 1;
    countSum = 999;
    [self loadAllView];
}

- (void)loadAllView{
    [self loadTableview];
    [self loadTopView];
    [self loadDownView];
}

- (void)loadDownView{
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHeight-40, SCREENWidth, 40)];
    [baseView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:baseView];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 40)];
    [label setText:@"仅显示近半年数据,详情可见电脑断"];
    [label setTextColor:[UIColor colorWithRed:0.44 green:0.45 blue:0.45 alpha:1]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:12]];
    [baseView addSubview:label];
}

- (void)loadIntegralAttriWithValue:(NSString *)str{
    str = [NSString stringWithFormat:@"我的积分 : %@",str];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
    [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.22 green:0.24 blue:0.24 alpha:1] range:NSMakeRange(0, 7)];
    [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.87 green:0.38 blue:0 alpha:1] range:NSMakeRange(7, [str length]-7)];
    [myIntegralLB setAttributedText:attri];
}

- (void)loadTopView{
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREENWidth, 80)];
    [baseView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:baseView];

    myIntegralLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREENWidth, 40)];
    [myIntegralLB setTextAlignment:NSTextAlignmentLeft];
    [self loadIntegralAttriWithValue:@"0"];
    [baseView addSubview:myIntegralLB];

    UIView *promptView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREENWidth, 40)];
    [promptView setBackgroundColor:[UIColor colorWithRed:0.91 green:0.91 blue:0.92 alpha:1.0]];
    [baseView addSubview:promptView];

    UILabel *lfLB= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth/3, 40)];
    [lfLB setTextAlignment:NSTextAlignmentCenter];
    [lfLB setText:@"类型"];
    [lfLB setTextColor:[UIColor colorWithRed:0.29 green:0.3 blue:0.3 alpha:1]];
    [promptView addSubview:lfLB];

    UILabel *cnLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 40)];
    [cnLB setTextAlignment:NSTextAlignmentCenter];
    [cnLB setText:@"明细"];
    [cnLB setTextColor:[UIColor colorWithRed:0.29 green:0.3 blue:0.3 alpha:1]];
    [promptView addSubview:cnLB];

    UILabel *rtLB =[[UILabel alloc] initWithFrame:CGRectMake(SCREENWidth/3*2, 0, SCREENWidth/3, 40)];
    [rtLB setTextAlignment:NSTextAlignmentCenter];
    [rtLB setText:@"时间"];
    [rtLB setTextColor:[UIColor colorWithRed:0.29 green:0.3 blue:0.3 alpha:1]];
    [promptView addSubview:rtLB];
}

- (void)loadTableview{
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 80, SCREENWidth, SCREENHeight - 80-40) style:UITableViewStyleGrouped];
    nullView = [[NullView alloc] initWithFrame:CGRectMake(0, 0, VIEWFSW(tableview), VIEWFSH(tableview))];

    [tableview setDelegate:self];
    [tableview setDataSource:self];
    __weak typeof(self) weakSelf = self;
    tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.tableview.mj_footer endRefreshing];
        weakSelf.pageIndx = 1;
        [weakSelf loadData];
    }];
    [self.view addSubview:tableview];
}

- (void)loadTableviewFooter{
    __weak typeof(self) weakSelf = self;
    tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.tableview.mj_header endRefreshing];
        if (weakSelf.dataSource.count >= weakSelf.countSum){
            [weakSelf.tableview.mj_footer endRefreshing];
            [SVProgressHUD showErrorWithStatus:@"没有更多数据了"];
            return;
        }
        weakSelf.pageIndx ++;
        [weakSelf loadData];
    }];
}

- (void)loadData{
    UserModel *usrModel = [UserModel shareUserManager];
    NSDictionary *dat = @{@"client_id":KEY_CLIENTID,@"user_name":usrModel.userName,@"password":usrModel.password,@"pageindex":[NSString stringWithFormat:@"%tu",pageIndx],@"pagesize":@"20"};
    NSDictionary *paraDict = @{@"cmdid":@"user_integral_list",@"data":dat};

    __weak typeof(self) weakSelf = self;
    [HttpManager hmRequestWithPara:paraDict Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {

        [weakSelf.tableview.mj_footer endRefreshing];
        [weakSelf.tableview.mj_header endRefreshing];
        if (rqCode != rqSuccess){
            weakSelf.countSum = 999;
            weakSelf.pageIndx --;
            [SVProgressHUD showErrorWithStatus:describle];
            return ;
        }
        weakSelf.countSum = [[receiveData objectForKey:@"rowcounts"] integerValue];
        [weakSelf loadIntegralAttriWithValue:[receiveData objectForKey:@"userintegral"]];
        if (weakSelf.pageIndx == 1){
            weakSelf.dataSource = [receiveData objectForKey:@"data"];
        }
        else{
            NSMutableArray *aryTemp = [[NSMutableArray alloc] initWithArray:dataSource];
            [aryTemp addObjectsFromArray:[receiveData objectForKey:@"data"]];
            weakSelf.dataSource = aryTemp;
        }
        [weakSelf.nullView removeFromSuperview];
        if (weakSelf.dataSource.count == 0)
            [weakSelf.tableview addSubview:weakSelf.nullView];
        if (weakSelf.countSum <= [weakSelf.dataSource count]){
            [weakSelf.tableview.mj_footer removeFromSuperview];
        }else{
            [weakSelf loadTableviewFooter];
        }
        [weakSelf.tableview reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"integer";
    MyIntegralCell *cell = (MyIntegralCell*)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        cell = [[MyIntegralCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell setCellWithDataSource:[dataSource objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
