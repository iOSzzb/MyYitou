//
//  CalcualtorMoney.h
//  Yitou
//
//  Created by Xiaohui on 15/8/28.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  计算利息
 */
@interface CalcualtorMoney : NSObject

- (void)loadDataSource:(NSDictionary *)dataSource coupon:(double)coupon;

/**
 *  投资金额
 */
@property (assign)double investMoney;

/**
 *  分段加息的活动的ID
 */
@property (nonatomic,copy,readonly)NSString *actID;

/**
 *  将活动券的数据导入
 *
 *  @param ary 活动券的数据,由N个Dictionary组成
 */
- (void)loadTouziquanActivity:(NSArray *)ary;

/**
 *  计算出利率
 */
- (float)calculatorRate;

/**
 *  计算出预计收益
 */
- (float)calculatorEarn;

@end
