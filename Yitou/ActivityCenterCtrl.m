//
//  ActivityCenterCtrl.m
//  Yitou
//
//  Created by imac on 16/1/29.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "ActivityCenterCtrl.h"
#import "ActivityCenterCell.h"
#import <MJRefresh.h>
#import "WebViewCtrl.h"

@interface ActivityCenterCtrl ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,copy)UITableView *tableview;
@property (nonatomic,copy)NSArray *dataSource;

@end

@implementation ActivityCenterCtrl

@synthesize tableview,dataSource;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BG_BLUEColor];
    [self setTitle:@"平台活动"];

    [self showTableView];
    [self loadMJRefresh];
    [tableview.mj_header beginRefreshing];
}

- (void)showTableView{
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return RELATIVE_X(130) + RELATIVE_X(10) + 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"BulletinCell";
    ActivityCenterCell *cell = (ActivityCenterCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[ActivityCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    for (UIView *view in cell.contentView.subviews){
        [view removeFromSuperview];
    }
    cell.dicInfo = dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableview deselectRowAtIndexPath:indexPath animated:YES];
    NSString *strURL = [dataSource[indexPath.row] objectForKey:@"urllike"];
    if ([strURL length] == 0|| strURL == nil)
        return;
    NSString *strName = [dataSource[indexPath.row] objectForKey:@"title"];
    WebViewCtrl *webViewCtrl = [[WebViewCtrl alloc] init];
    webViewCtrl.url = strURL;
    webViewCtrl.name =strName;
    [self.navigationController pushViewController:webViewCtrl animated:YES];
}

- (void)loadMJRefresh{
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableview.mj_header.automaticallyChangeAlpha = YES;
    __weak typeof(self) weakSelf = self;
    tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataSource];
    }];
}

- (void)loadDataSource{
    NSDictionary *paraDic = @{@"cmdid":@"get_app_advert",@"data":@{@"client_id":KEY_CLIENTID}};

    __weak typeof(self) weakSelf = self;
    [HttpManager hmRequestWithPara:paraDic Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        if (rqCode != rqSuccess){
            [weakSelf.tableview.mj_header endRefreshing];
            [SVProgressHUD showErrorWithStatus:describle];
            return ;
        }
        weakSelf.dataSource = [receiveData objectForKey:@"data"];
        [weakSelf.tableview reloadData];
        [weakSelf.tableview.mj_header endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
