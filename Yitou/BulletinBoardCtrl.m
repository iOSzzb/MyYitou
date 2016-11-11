//
//  BulletinBoardCtrl.m
//  Yitou
//
//  Created by imac on 16/1/28.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "BulletinBoardCtrl.h"
#import "BulletinBoardCell.h"
#import <MJRefresh.h>
#import "BulletinContentCtrl.h"
#import "BulletinModel.h"

@interface BulletinBoardCtrl ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,copy)UITableView *boardTableView;
@property (nonatomic)NSMutableArray *dataAry;
@property (assign)NSInteger page;
@property (assign)NSInteger rowCounts;


@end

@implementation BulletinBoardCtrl

@synthesize boardTableView,dataAry,page,rowCounts;

- (void)viewDidLoad {
    [super viewDidLoad];
  
    dataAry = [NSMutableArray new];
    [self.view setBackgroundColor:BG_BLUEColor];
    [self setTitle:@"网站公告"];

    [self showTableView];
    [self loadMJRefresh];
    
    [boardTableView.mj_header beginRefreshing];
}

- (void)showTableView{
    boardTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight) style:UITableViewStylePlain];
    boardTableView.delegate = self;
    boardTableView.dataSource = self;
    boardTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:boardTableView];
}

- (void)loadMJRefresh{
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    boardTableView.mj_header.automaticallyChangeAlpha = YES;
    __weak typeof(self) weakSelf = self;
    boardTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf loadDataSourceWithPageSize:@"20" PageIndex:[NSString stringWithFormat:@"%tu",weakSelf.page] NewsTyep:@"2"];
    }];

    boardTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf loadDataSourceWithPageSize:@"20" PageIndex:[NSString stringWithFormat:@"%tu",weakSelf.page] NewsTyep:@"2"];
    }];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"BulletinCell";
    BulletinBoardCell *cell = (BulletinBoardCell*)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        cell = [[BulletinBoardCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    for (UIView *view in cell.contentView.subviews){
        [view removeFromSuperview];
    }
    cell.bulletinInfo = dataAry[indexPath.row];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [boardTableView deselectRowAtIndexPath:indexPath animated:YES];
    BulletinModel *bulletinModel = dataAry[indexPath.row];
    
    bulletinModel.isState = @"1";
    NSLOG(@"dataAry = %@",dataAry);
    [boardTableView reloadData];
    [self markAsReadWithBulletinModel:bulletinModel Index:indexPath.row];
   
    BulletinContentCtrl *bulletinContentCtrl = [[BulletinContentCtrl alloc] init];
    bulletinContentCtrl.titleStr = bulletinModel.title;
    bulletinContentCtrl.timeStr = bulletinModel.timeStr;
    bulletinContentCtrl.htmlContent = bulletinModel.content;
    [self.navigationController pushViewController:bulletinContentCtrl animated:YES];
}

- (void)markAsReadWithBulletinModel:(BulletinModel *)bulletinModel Index:(NSInteger)index{
    NSMutableDictionary *para = [NSMutableDictionary new];
    NSMutableDictionary *data = [NSMutableDictionary new];
    NSString *userName = [UserModel shareUserManager].userName;
    NSString *passWord = [UserModel shareUserManager].password;
    [para setObject:@"set_notice_state" forKey:@"cmdid"];
    [data setObject:KEY_CLIENTID forKey:@"client_id"];
    [data setObject:bulletinModel.idStr forKey:@"id"];
    [data setObject:userName forKey:@"user_name"];
    [data setObject:passWord forKey:@"password"];
    [para setObject:data forKey:@"data"];
    [HttpManager hmRequestWithPara:para Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        if (rqCode != rqSuccess){
            [SVProgressHUD showErrorWithStatus:describle];
            return ;
        }
    }];
}

- (void)loadDataSourceWithPageSize:(NSString *)pageSize PageIndex:(NSString *)pageIndex NewsTyep:(NSString *)newsTypes{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:@"get_notice_list" forKey:@"cmdid"];
    NSMutableDictionary *data = [NSMutableDictionary new];
    [data setObject:KEY_CLIENTID forKey:@"client_id"];
    
    NSString *userName = [UserModel shareUserManager].userName;
    NSString *userPassWord = [UserModel shareUserManager].password;
    [data setObject:userName forKey:@"user_name"];
    [data setObject:userPassWord forKey:@"password"];
    
    if (pageSize.length > 0)
        [data setObject:pageSize forKey:@"pagesize"];
    if (pageIndex.length > 0)
        [data setObject:pageIndex forKey:@"pageindex"];
    if (newsTypes.length > 0)
        [data setObject:newsTypes forKey:@"newsType"];
    [para setObject:data forKey:@"data"];

    __weak typeof(self) weakSelf = self;
    [HttpManager hmRequestWithPara:para Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        [weakSelf.boardTableView.mj_header endRefreshing];
        [weakSelf.boardTableView.mj_footer endRefreshing];
        if (rqCode != rqSuccess){
            [SVProgressHUD showErrorWithStatus:describle];
            return ;
        }
        if ([pageIndex isEqualToString:@"1"]) {
            weakSelf.dataAry = [NSMutableArray new];
        }
        
        NSArray *array = [receiveData objectForKey:@"data"];
        for (int i = 0; i < array.count; i ++) {
            BulletinModel *bulletinModel = [[BulletinModel alloc] init];
            bulletinModel.isState = [array[i] objectForKey:@"new_state"];
            bulletinModel.title = [array[i] objectForKey:@"title"];
            bulletinModel.timeStr = [array[i] objectForKey:@"jointime"];
            bulletinModel.content = [array[i] objectForKey:@"content"];
            bulletinModel.idStr = [array[i] objectForKey:@"id"];

            [weakSelf.dataAry addObject:bulletinModel];
        }

        weakSelf.rowCounts = [[receiveData objectForKey:@"rowcounts"] integerValue];
        [weakSelf.boardTableView reloadData];

        if (weakSelf.dataAry.count >= weakSelf.rowCounts) {
            [SVProgressHUD showErrorWithStatus:@"没有更多数据了"];
            [weakSelf.boardTableView.mj_footer removeFromSuperview];
            [weakSelf.boardTableView.mj_header removeFromSuperview];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
