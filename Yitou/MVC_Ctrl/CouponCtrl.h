//
//  CouponCtrl.h
//  Yitou
//
//  Created by Xiaohui on 15/11/4.
//  Copyright © 2015年 Xiaohui Li. All rights reserved.
//

#import "BaseController.h"

@interface CouponCtrl : BaseController

/**
 *  选中的加息券
 */
@property (nonatomic,copy,readonly)NSString *jiaxiID;

/**
 *  选中的新手红包
 */
@property (nonatomic,copy,readonly)NSString *xianjinID;
/**
 *  选中的红包
 */
@property (nonatomic,copy,readonly)NSString *hongbaoID;

/**
 *  加的利息汇总
 */
@property (assign,readonly)double addCoupon;

/**
 加息类型
 */
@property (nonatomic,copy) NSString *jiaxiTypeId;

/**
 *  新手红包的金额
 */
@property (assign,readonly)double addMoney;

/**
 *  最低投资金额可用现金卷
 */
@property (assign,readonly)double mininvest;

/**
 是否黄金加息券
 */
//@property (nonatomic,assign)BOOL didChoseHuangjin;

/**
 *  导入优惠券信息
 *
 *  @param jiaxi   加息券
 *  @param xianjin 现金券
 *  @param hongbao 现金红包
 */
- (void)loadCouponWithJiaxiData:(NSArray *)jiaxi xianjin:(NSArray *)xianjin hongbao:(NSArray *)hongbao;
@end
