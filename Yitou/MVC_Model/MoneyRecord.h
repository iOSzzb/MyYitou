//
//  MoneyRecord.h
//  Yitou
//
//  Created by Xiaohui on 15/8/24.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyRecord : NSObject

/**
 *  记录产生的时间
 */
@property (nonatomic,copy)NSString *date;

/**
 *  金额
 */
@property (nonatomic,copy)NSString *money;

/**
 *  记录类型  PS:收入or支出
 */
@property (nonatomic,copy)NSString *types;

/**
 *  金额的单位
 */
@property (nonatomic,copy)NSString *unit;

/**
 *  描述
 */
@property (nonatomic,copy)NSString *desc;

/**
 *  余额
 */
@property (nonatomic,copy)NSString *balance;

/**
 *  数据来源
 */
@property (nonatomic,copy)NSDictionary *orignData;

@end
