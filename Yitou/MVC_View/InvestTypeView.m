//
//  InvestTypeView.m
//  Yitou
//
//  Created by mac on 16/1/11.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "InvestTypeView.h"

#define MAXWidth  160
#define CELLHeight 45

@implementation InvestTypeView{
    ClickBlock block;
    UITableView *tableview;
    NSArray *dataSource;
}

@synthesize typeCode;


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    typeCode = @"";
    return self;
}


- (void)loadDataSource{
    
    NSMutableDictionary *paraDict = [NSMutableDictionary new];
    [paraDict setObject:@"borrowitem" forKey:@"cmdid"];
    [paraDict setObject:@{@"client_id":KEY_CLIENTID} forKey:@"data"];
    
    __weak typeof(self) weakSelf = self;
    [HttpManager hmRequestWithPara:paraDict Block:^(RequestResult rqCode, NSString *describle, NSDictionary *receiveData) {
        if (rqCode != rqSuccess){
            [SVProgressHUD showErrorWithStatus:describle];
            return ;
        }
        
        NSLog(@"receiveData = %@",receiveData);
        NSMutableArray *array = [NSMutableArray new];
        [array addObjectsFromArray:[receiveData objectForKey:@"data"]];
        dataSource = array;
        
        typeCode = @"";
        
        [weakSelf loadTableView];
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    block(1,nil);
}

- (void)loadTypeWithBlock:(ClickBlock)blocks{
    if (block != nil)
        return;
    block = blocks;
    
    [self loadDataSource];
    [tableview setBackgroundColor:COLORWithRGB(254, 254, 254, 0.88)];
    [self setBackgroundColor:COLORWithRGB(0, 0, 0, 0.4)];
}

- (void)loadTableView{
    float width = VIEWFSW(self) > MAXWidth ?MAXWidth : VIEWFSW(self);
    float height = [dataSource count] * CELLHeight;
    height = height < VIEWFSH(self) ? height : VIEWFSH(self);
    tableview = [[UITableView alloc] initWithFrame:CGRectMake((SCREENWidth - width)/2, 64, width, height)];
    [tableview setDataSource:self];
    [tableview setDelegate:self];
    [self addSubview:tableview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"insvestCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.text = [[dataSource objectAtIndex:indexPath.row] objectForKey:@"item_name"];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELLHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    typeCode = [dataSource[indexPath.row] objectForKey:@"item_type"];
    block(indexPath.row,dataSource[indexPath.row]);

}

@end
