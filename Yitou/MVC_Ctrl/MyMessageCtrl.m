//
//  MyMessageCtrl.m
//  Yitou
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "MyMessageCtrl.h"
#import "MyMsgTopView.h"
#import "MyMessageCell.h"
#import "MyMsgDetailCtrl.h"
#import "Message.h"
#import <MJRefresh.h>

@interface MyMessageCtrl ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,copy)UITableView *tableview;
@property (nonatomic,copy)NSArray *dataSource;
@property (assign)NSInteger showType;
@property (assign)NSInteger page;

@end

@implementation MyMessageCtrl{
    MyMsgTopView *topView;
}

@synthesize tableview,dataSource,showType,page;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"站内信息"];
    [self.view setBackgroundColor:BG_BLUEColor];
    [self loadTopView];
}

- (void)loadTopView{
    showType = 0;
    page = 1;
    __weak typeof(self) weakSelf = self;
    topView = [[MyMsgTopView alloc] initWithFrame:CGRectMake(0, 64, SCREENWidth, 45) block:^(NSInteger indx) {
        weakSelf.showType = indx;
        [weakSelf loadDataSource];
    }];
    [self.view addSubview:topView];
    [self loadTableview];
    [self loadDataSource];
}

- (void)loadTableview{
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, VIEWFH_Y(topView), SCREENWidth, SCREENHeight - VIEWFH_Y(topView)) style:UITableViewStyleGrouped];
    [tableview setDelegate:self];
    [tableview setDataSource:self];
    [tableview setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:tableview];
    __weak typeof(self) weakSelf = self;
    tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf loadDataSource];
    }];
}

- (void)loadTableviewFooter{
    [tableview.mj_footer removeFromSuperview];
    __weak typeof(self) weakSelf = self;
    tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.tableview.mj_header endRefreshing];
        weakSelf.page ++;
        [weakSelf loadDataSource];
    }];
}

- (void)loadDataSource{
    NSString *pageStr = [NSString stringWithFormat:@"%tu",page];
    NSString *typeStr = [NSString stringWithFormat:@"%tu",showType];
    UserModel *usrModel = [UserModel shareUserManager];
    NSDictionary *para = @{@"client_id":KEY_CLIENTID,@"user_name":usrModel.userName,@"password":usrModel.password,@"type":typeStr,@"pageindex":pageStr};
    para = @{@"cmdid":@"get_letter_list",@"data":para};
    [SVProgressHUD showWithStatus:@"正在获取数据" maskType:SVProgressHUDMaskTypeBlack];
    __weak typeof(self) weakSelf = self;
    [HttpManager hmRequestWithPara:para Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        [SVProgressHUD dismiss];
        [weakSelf.tableview.mj_footer endRefreshing];
        [weakSelf.tableview.mj_header endRefreshing];
        if (rqCode != rqSuccess){
            [SVProgressHUD showErrorWithStatus:describle];
            return ;
        }
        if (weakSelf.page >= [[receiveData objectForKey:@"totalpages"] integerValue]){
            [weakSelf.tableview.mj_footer removeFromSuperview];
        }else{
            [weakSelf loadTableviewFooter];
        }
        if (weakSelf.page != 1){
            NSMutableArray *array = [NSMutableArray new];
            [array addObjectsFromArray:weakSelf.dataSource];
            [array addObjectsFromArray:[weakSelf createModelFromData:[receiveData objectForKey:@"data"]]];
            weakSelf.dataSource = array;
        }else{
            weakSelf.dataSource = [weakSelf createModelFromData:[receiveData objectForKey:@"data"]];
        }
        [weakSelf.tableview reloadData];
    }];
}

- (NSArray *)createModelFromData:(NSArray *)array{
    NSMutableArray *tempArray = [NSMutableArray new];
    for (NSDictionary *dict in array){
        [tempArray addObject:[Message createMessageWithData:dict]];
    }
    return tempArray;
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
    MyMessageCell *cell = (MyMessageCell*)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        cell = [[MyMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    for (UIView *view in cell.contentView.subviews){
        [view removeFromSuperview];
    }
    [cell setMessage:dataSource[indexPath.section]];
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
    MyMsgDetailCtrl *msgDetail = [[MyMsgDetailCtrl alloc] init];
    msgDetail.message = dataSource[indexPath.section];
    [self.navigationController pushViewController:msgDetail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
