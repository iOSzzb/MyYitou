//
//  Tender.h
//  Yitou
//
//  Created by Xiaohui on 15/8/11.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tender : NSObject

/**
 *  将标的数据写入标内
 *
 *  @param dict 单个标的数据
 */
- (void)createTenderModel:(NSDictionary *)dict;

/**
 *  检查是否是约标&&还在约标的有效期内
 */
- (BOOL)checkBelongValid;

/**
 *  是否是可以投标的状态
 */
- (BOOL)canInvestStatus;

/**
 *  获取约标人的显示名
 */
- (NSString *)showBelongName;

/**
 *   标的ID
 */
@property (nonatomic,copy,readonly)NSString *tenderID;

/**
 *  起投金额
 */
@property (nonatomic,copy,readonly)NSString *minInvest;

/**
 *  最多可投
 */
@property (nonatomic,copy,readonly)NSString *maxInvest;

/**
 *  项目有效时间
 */
//@property (nonatomic,copy,readonly)NSString *endTime;

/**
 *  是否是体验标
 */
@property (assign,readonly)BOOL isExp;

/**
 *  投标的开始时间
 */
@property (nonatomic,copy,readonly)NSString *startTime;

/**
 *  标类型  0:普通标 1:预约标
 */
@property (nonatomic,copy,readonly)NSString *type;


/**
 *  标类型名称
 */
@property (nonatomic,copy,readonly)NSString *typeName;

/**
 *  标的名字
 */
@property (nonatomic,copy,readonly)NSString *title;

/**
 *  标的状态
 */
@property (nonatomic,copy,readonly)NSString *status;

/**
 *  标状态的描述
 */
@property (nonatomic,copy,readonly)NSString *statusDesc;

/**
 *  剩余可借的钱
 */
@property (nonatomic,copy,readonly)NSString  *balance;

/**
 *  剩余可投的钱的单位
 */
@property (nonatomic,copy,readonly)NSString *balanceUnit;

/**
 *  还款时间
 */
@property (nonatomic,copy,readonly)NSString *timeCount;

/**
 *  还款时间的单位
 */
@property (nonatomic,copy,readonly)NSString *timeCountUnit;

/**
 *  投标进度
 */
@property (nonatomic,copy,readonly)NSString *schedule;

/**
 *  最大收益
 */
@property (nonatomic,copy,readonly)NSString *maxEarn;

/**
 *  最小收益
 */
@property (nonatomic,copy,readonly)NSString *minEarn;

/**
 *  需要的投资总额
 */
@property (nonatomic,copy,readonly)NSString *tenderSum;

/**
 *  借款总额的单位
 */
@property (nonatomic,copy,readonly)NSString *tenderSumUnit;

/**
 *  当前已投资
 */
@property (nonatomic,copy,readonly)NSString *tenderCount;

/**
 *  已投金额的单位
 */
@property (nonatomic,copy,readonly)NSString *tenderCountUnit;

/**
 *  还款方式
 */
@property (nonatomic,copy,readonly)NSString *payStyle;

/**
 *  发布时间
 */
@property (nonatomic,copy,readonly)NSString *createTime;

/**
 *  投标截止时间
 */
@property (nonatomic,copy,readonly)NSString *endTime;

#pragma mark 约标的属性

/**
 *  约标到期时间
 */
@property(nonatomic,copy,readonly)NSString *belongTimeout;

/**
 *  约标的用户ID
 */
@property (nonatomic,copy,readonly)NSString *belongUserID;

/**
 *  约标的用户名
 */
@property (nonatomic,copy,readonly)NSString *belongUserName;

/**
 *  约标的密码
 */
@property (nonatomic,copy,readonly)NSString *borrowPassword;

@end
