//
//  MyBoxCtrl.m
//  Yitou
//
//  Created by mac on 15/11/23.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import "MyBoxCtrl.h"

#import "MyBoxCell.h"
#import "MyBoxTopView.h"

#import <MJRefresh.h>

@interface MyBoxCtrl ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,copy)UITableView *tableview;
@property (nonatomic,copy)NSArray *dataSource;
@property (nonatomic,copy)MyBoxTopView *topView;
@property (assign)NSInteger pageIndx;
@property (assign)NSInteger type;
@property (assign)NSInteger sumCount;

@end

@implementation MyBoxCtrl

@synthesize tableview,dataSource,topView,pageIndx,type,sumCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的益宝箱";
    [self.view setBackgroundColor:BG_BLUEColor];
    [self loadAllView];
}

- (void)loadDataSource{
    UserModel *usrModel = [UserModel shareUserManager];
    NSInteger rqType = type;
    NSDictionary *dat = @{@"client_id":KEY_CLIENTID,@"user_name":usrModel.userName,@"password":usrModel.password,@"prize_status":[NSString stringWithFormat:@"%tu",type],@"pageindex":[NSString stringWithFormat:@"%tu",pageIndx],@"pagesize":@"10"};
    NSDictionary *para = @{@"cmdid":@"user_prizes_list_two",@"data":dat};

    __weak typeof(self) weakSelf = self;
    [HttpManager hmRequestWithPara:para Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {

        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        if (rqType != weakSelf.type)
            return ;
        if (rqCode != rqSuccess){
            [SVProgressHUD showErrorWithStatus:describle];
            return ;
        }

        if (weakSelf.pageIndx == 1){
            weakSelf.dataSource = [receiveData objectForKey:@"data"];
        }
        else{
            NSMutableArray *aryTemp = [NSMutableArray new];
            [aryTemp addObjectsFromArray:dataSource];
            [aryTemp addObjectsFromArray:[receiveData objectForKey:@"data"]];
            weakSelf.dataSource = aryTemp;
        }
        if (weakSelf.dataSource.count == 0){
            [SVProgressHUD showInfoWithStatus:@"没有该类型的优惠券"];
            [weakSelf.tableview.mj_footer setHidden:YES];
        }
        else {
            [weakSelf.tableview.mj_footer setHidden:NO];
        }
        NSInteger totalpages = [[receiveData objectForKey:@"totalpages"] integerValue];
        if (weakSelf.pageIndx >= totalpages) {
            [weakSelf.tableview.mj_footer endRefreshingWithNoMoreData];
        }
        [weakSelf.tableview reloadData];

    }];
}

- (void)loadTableviewFooter{
    __weak typeof(self) weakSelf = self;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.dataSource.count >1){
            weakSelf.pageIndx += 1;
        }
        [weakSelf loadDataSource];
    }];
    [footer setTitle:@"仅显示半年内数据，详情可见电脑端" forState:MJRefreshStateNoMoreData];
    tableview.mj_footer = footer;
    [tableview.mj_footer setHidden:YES];
}

- (void)loadAllView{
    [self loadTopView];
    [self loadTableview];
    [self loadTableviewFooter];
}

- (void)loadTableview{
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, SCREENWidth, SCREENHeight-104)];
    [tableview setDelegate:self];
    [tableview setDataSource:self];
    [self.view addSubview:tableview];
    [tableview setBackgroundColor:[UIColor colorWithRed:0.87 green:0.95 blue:0.98 alpha:1]];
    tableview.separatorStyle = NO;

    __weak typeof(self) weakSelf = self;
    tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageIndx = 1;
        [weakSelf loadDataSource];
    }];
    [tableview.mj_header setState:MJRefreshStateRefreshing];
}

- (void)loadTopView{
    pageIndx = 1;
    type = 1;
    topView = [[MyBoxTopView alloc] initWithFrame:CGRectMake(0, 64, SCREENWidth, 40)];
    __weak typeof(self) weakSelf = self;
    [topView loadTopViewWithBlock:^(NSInteger indx) {
        weakSelf.pageIndx = 1;
        weakSelf.type = indx;
        [weakSelf loadDataSource];
    }];
    [self.view addSubview:topView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"MyBoxCellIdentifier";
    MyBoxCell *cell = (MyBoxCell*)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        cell = [[MyBoxCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle = NO;
    [cell setCellWithData:[dataSource objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return MYBoxHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
