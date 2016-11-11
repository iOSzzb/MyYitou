//
//  Record.h
//  Yitou
//
//  Created by imac on 16/3/15.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Record : NSObject

/**
 *  预约时间
 */
@property (nonatomic,copy) NSString *timeStr;

/**
 *  标期
 */
@property (nonatomic,copy) NSString *monthStr;

/**
 *  标类型
 */
@property (nonatomic,copy) NSString *typeStr;

/**
 *  金额
 */
@property (nonatomic,copy) NSString *moneyStr;


+ (Record *)createRecordWithData:(NSDictionary *)dataSource;

@end
