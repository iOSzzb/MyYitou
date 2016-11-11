//
//  InvestDetailCtrl.h
//  Yitou
//
//  Created by Xiaohui on 15/8/25.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "BaseController.h"
#import "Tender.h"

@interface InvestDetailCtrl :BaseController

/**
 *  标的源数据
 */
@property (nonatomic,copy)NSDictionary *detail;

@property (retain)Tender *tender;

@end
