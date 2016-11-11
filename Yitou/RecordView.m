//
//  RecordView.m
//  Yitou
//
//  Created by imac on 16/3/15.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "RecordView.h"
#import "RecordCell.h"
#import <MJRefresh.h>
#import "Record.h"

@implementation RecordView{
    UITableView *tableview;
    UIView *heardView;
    
    NSInteger page;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self showHeardView];
        [self showTableView];
    }
    return self;
}

- (void)showHeardView{
    heardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 45)];
    [heardView setBackgroundColor:[UIColor colorWithRed:0.45 green:0.74 blue:1 alpha:1]];
    [self addSubview:heardView];
    
    NSArray *ary = @[@"预约时间",@"标期",@"标类型",@"金额"];
    for (int i = 0; i < 4; i ++) {
       UILabel *label = [self showTitleLabelWithFrame:CGRectMake(VIEWFSW(heardView)/4*i, 0, VIEWFSW(heardView)/4, VIEWFSH(heardView)) Title:ary[i]];
        [heardView addSubview:label];
    }
    
}

- (UILabel *)showTitleLabelWithFrame:(CGRect)frame Title:(NSString *)title{
    UILabel *lab = [[UILabel alloc] initWithFrame:frame];
    [lab setTextColor:[UIColor whiteColor]];
    [lab setText:title];
    [lab setTextAlignment:NSTextAlignmentCenter];
    [lab setFont:FONT_16];
    
    return lab;
}

/**
 *  记录列表
 */
- (void)showTableView{
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, VIEWFH_Y(heardView), SCREENWidth, self.bounds.size.height - VIEWFH_Y(heardView)) style:UITableViewStylePlain];
    [tableview setBackgroundColor:BG_BLUEColor];
    [tableview setDelegate:self];
    [tableview setDataSource:self];
    [tableview setTableFooterView:[[UIView alloc] init]];
    [self addSubview:tableview];
    
     __weak typeof(self) weakSelf = self;
    tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [weakSelf loadDataSource];
    }];
    
    tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [weakSelf loadDataSource];
    }];
}

- (void)loadDataSource{
    NSString *pageStr = [NSString stringWithFormat:@"%tu",page];
    NSString *pageSize = @"20";
    UserModel *usrModel = [UserModel shareUserManager];
    NSDictionary *para = @{@"client_id":KEY_CLIENTID,@"user_name":usrModel.userName,@"password":usrModel.password,@"pageindex":pageStr,@"pagesize":pageSize};
    para = @{@"cmdid":@"get_borrowapply_list",@"data":para};
     __weak typeof(self) weakSelf = self;
    [HttpManager hmRequestWithPara:para Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        if (rqCode != rqSuccess){
            [SVProgressHUD showErrorWithStatus:describle];
            return ;
        }
        if (page > [[receiveData objectForKey:@"totalpages"] integerValue]){
            [tableview.mj_header endRefreshing];
            [tableview.mj_footer endRefreshing];
            return;
        }

        if (page != 1 && page == [[receiveData objectForKey:@"totalpages"] integerValue]){
            NSMutableArray *array = [NSMutableArray new];
            [array addObjectsFromArray:weakSelf.dataSource];
            [array addObjectsFromArray:[weakSelf createRecordModelFromData:[receiveData objectForKey:@"data"]]];
            weakSelf.dataSource = array;
        }else{
            weakSelf.dataSource = [weakSelf createRecordModelFromData:[receiveData objectForKey:@"data"]];
        }
        [tableview reloadData];
        [tableview.mj_footer endRefreshing];
        [tableview.mj_header endRefreshing];
    }];
}

- (NSArray *)createRecordModelFromData:(NSArray *)array{
    NSMutableArray *tempArray = [NSMutableArray new];
    for (NSDictionary *dict in array){
        [tempArray addObject:[Record createRecordWithData:dict]];
    }
    return tempArray;
}

- (void)beginRefreshTableView{
    [tableview.mj_header beginRefreshing];
}

//- (void)setDataSource:(NSArray *)dataSource{
//    _dataSource = dataSource;
//    [tableview reloadData];
//}

#pragma mark Tableview Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"insvestCell";
    RecordCell *cell = (RecordCell*)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        cell = [[RecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    for (UIView *view in cell.contentView.subviews){
        [view removeFromSuperview];
    }
    [cell setRecord:_dataSource[indexPath.row]];
    return cell;
}


@end
