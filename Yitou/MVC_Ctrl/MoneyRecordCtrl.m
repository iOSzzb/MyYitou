//
//  MoneyRecordCtrl.m
//  Yitou
//
//  Created by Xiaohui on 15/8/24.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "MoneyRecordCtrl.h"
#import "MoneyRecordCell.h"
#import "RecordDetailCtrl.h"
#import <MJRefresh.h>
#import "NullView.h"

#define CELLHeight  50

@interface MoneyRecordCtrl ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSArray *dataSource;
@property(nonatomic,copy)UITableView *tableview;
@property(assign)NSInteger dataCount;
@property(assign)NSInteger page;
@property(nonatomic,copy)NullView *nullView;

@end

@implementation MoneyRecordCtrl{
    UIButton *nowButton;
    float orignY;
}

@synthesize dataCount;
@synthesize tableview;
@synthesize dataSource;
@synthesize nullView;
@synthesize page;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"明细";
    page = 1;
    dataCount = 0;
    [self loadAllView];
    [tableview.mj_header setState:MJRefreshStateRefreshing];
}

- (void)loadAllView{
    [self loadButton];
    [self loadPromptColumn];
    [self loadTableview];
}

- (void)loadTableview{
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, SCREENHeight-orignY) style:UITableViewStyleGrouped];

    nullView = [[NullView alloc] initWithFrame:CGRectMake(0, 0, VIEWFSW(tableview), VIEWFSH(tableview))];
    [tableview setDataSource:self];
    [tableview setDelegate:self];
    [self.view addSubview:tableview];
    page = 1;
    __weak typeof(self) weakSelf = self;
    tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.tableview.mj_footer endRefreshing];
        weakSelf.page = 1;
        [weakSelf requestData];
    }];
}

- (void)loadTableviewFooter{
    __weak typeof(self) weakSelf = self;
    tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.tableview.mj_header endRefreshing];
        if (weakSelf.dataSource.count == weakSelf.dataCount&&weakSelf.dataCount!=0){
            [SVProgressHUD showErrorWithStatus:@"没有更多记录了"];
            [weakSelf.tableview.mj_footer endRefreshing];
            return;
        }
        weakSelf.page++;
        if (weakSelf.dataSource.count == 0){
            weakSelf.page = 1;
        }
        [weakSelf requestData];
    }];
}

- (void)requestData{
    NSString *typeStr = nowButton.tag == 2 ?@"-5":@"5";

    NSString *pageStr = [NSString stringWithFormat:@"%tu",page];
    NSMutableDictionary *paraDict = [NSMutableDictionary new];
    [paraDict setObject:KEY_CLIENTID forKey:@"client_id"];
    [paraDict setObject:USERDefineGet(KEY_LOGIN_NAME) forKey:@"user_name"];
    [paraDict setObject:USERDefineGet(KEY_LOGIN_PWD) forKey:@"password"];
    [paraDict setObject:@"20" forKey:@"pagesize"];
    if (nowButton.tag != 0)
        [paraDict setObject:typeStr forKey:@"type"];
    [paraDict setObject:pageStr forKey:@"pageindex"];

    __weak typeof(self) weakSelf = self;
    [HttpManager getMoneyRecordAtPage:paraDict Block:^(RequestResult rqCode, NSArray *array, NSInteger sumCount, NSString *describle) {
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        weakSelf.dataCount = sumCount;
        if (rqCode != rqSuccess){
            [SVProgressHUD showErrorWithStatus:describle];
            weakSelf.page = weakSelf.page==1?1:weakSelf.page-1;
            return ;
        }
        if (weakSelf.page == 1)
            weakSelf.dataSource = array;
        else{
            NSMutableArray *tempAry = [[NSMutableArray alloc]initWithArray:dataSource];
            [tempAry addObjectsFromArray:array];
            weakSelf.dataSource = [[NSArray alloc] initWithArray:tempAry];
        }
        if (weakSelf.page == 1&& weakSelf.dataSource.count == 0)
            [weakSelf.tableview addSubview:nullView];
        else
            [weakSelf.nullView removeFromSuperview];
        [weakSelf.tableview reloadData];
        if (sumCount <= [weakSelf.dataSource count]){
            [weakSelf.tableview.mj_footer removeFromSuperview];
        }else{
            [weakSelf loadTableviewFooter];
        }
    }];
}

- (void)loadPromptColumn{
    UIView *promptView = [[UIView alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, 50)];
    [promptView setBackgroundColor:COLORWithRGB(115, 188, 255, 1)];
    [self.view addSubview:promptView];

    UILabel *dateLB = [FastFactory loadLabelWith:NSTextAlignmentCenter Frame:CGRectMake(0, 0, SCREENWidth/4, VIEWFSH(promptView)) TextColor:COLORWithRGB(255, 255, 255, 1) fontSize:16];
    dateLB.text = @"记录日期";
    [promptView addSubview:dateLB];

    UILabel *projectLB = [FastFactory loadLabelWith:NSTextAlignmentCenter Frame:CGRectMake(VIEWFW_X(dateLB), 0, SCREENWidth/4, VIEWFSH(promptView)) TextColor:COLORWithRGB(255, 255, 255, 1) fontSize:16];
    projectLB.text = @"存入";
    [promptView addSubview:projectLB];

    UILabel *addMoneyLB = [FastFactory loadLabelWith:NSTextAlignmentCenter Frame:CGRectMake(VIEWFW_X(projectLB), 0, SCREENWidth/4, VIEWFSH(promptView)) TextColor:COLORWithRGB(255, 255, 255, 1) fontSize:16];
    addMoneyLB.text = @"支出";
    [promptView addSubview:addMoneyLB];

    UILabel *withdrawLB = [FastFactory loadLabelWith:NSTextAlignmentCenter Frame:CGRectMake(VIEWFW_X(addMoneyLB), 0, SCREENWidth/4, VIEWFSH(promptView)) TextColor:COLORWithRGB(255, 255, 255, 1) fontSize:16];
    withdrawLB.text = @"操作";
    [promptView addSubview:withdrawLB];

    orignY = VIEWFH_Y(promptView);
}

- (void)loadButton{

    UIButton *allStatusBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 65, SCREENWidth/3, 50)];
    [allStatusBtn setTitle:@"所有记录" forState:UIControlStateNormal];
    [allStatusBtn setTitleColor:COLORWithRGB(42, 138, 225, 1) forState:UIControlStateNormal];
    [allStatusBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    allStatusBtn.tag = 0;
    [self.view addSubview:allStatusBtn];
    nowButton = allStatusBtn;

    UIButton *rechargeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWidth/3, 65, SCREENWidth/3, 50)];
    [rechargeBtn setTitle:@"充值记录" forState:UIControlStateNormal];
    [rechargeBtn setTitleColor:COLORWithRGB(116, 116, 116, 1) forState:UIControlStateNormal];
    [rechargeBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    rechargeBtn.tag = 1;
    [self.view addSubview:rechargeBtn];

    UIButton *withdrawBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWidth*2/3, VIEWFOY(rechargeBtn), SCREENWidth/3, VIEWFSH(rechargeBtn))];
    [withdrawBtn setTag:2];
    [withdrawBtn setTitle:@"提现记录" forState:UIControlStateNormal];
    [withdrawBtn setTitleColor:COLORWithRGB(116, 116, 116, 1) forState:UIControlStateNormal];
    [withdrawBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:withdrawBtn];
    orignY = VIEWFH_Y(withdrawBtn);
}

- (void)clickButton:(id)sender{
    if (nowButton == nil ||[sender tag] == nowButton.tag)
        return;
    UIButton *button = sender;
    [button setTitleColor:COLORWithRGB(42, 138, 225, 1) forState:UIControlStateNormal];
    [nowButton setTitleColor:COLORWithRGB(116, 116, 116, 1) forState:UIControlStateNormal];
    [tableview.mj_header setState:MJRefreshStateRefreshing];
    nowButton = button;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"insvestCell";
    MoneyRecordCell *cell = (MoneyRecordCell*)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        cell = [[MoneyRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    for (UIView *view in cell.contentView.subviews)
        [view removeFromSuperview];
    MoneyRecord *tend = [dataSource objectAtIndex:indexPath.row];
    cell.moneyRecord = tend;
    [cell setCell];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELLHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    RecordDetailCtrl *recordCtrl = [[RecordDetailCtrl alloc] init];
    recordCtrl.records = [dataSource objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:recordCtrl animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
