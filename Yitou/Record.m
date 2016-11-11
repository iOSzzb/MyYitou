//
//  Record.m
//  Yitou
//
//  Created by imac on 16/3/15.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "Record.h"

@implementation Record

+ (Record *)createRecordWithData:(NSDictionary *)dataSource{
    Record *record = [Record new];
    [record loadRecordProperty:dataSource];
    return record;
}

- (void)loadRecordProperty:(NSDictionary *)dataSource{
    _timeStr= [dataSource objectForKey:@"apply_resoverdue_time"];
    _monthStr = [dataSource objectForKey:@"appply_to_borrow"];
    _typeStr = [dataSource objectForKey:@"apply_borrowing_type"];
    _moneyStr = [dataSource objectForKey:@"apply_money"];
}

@end
