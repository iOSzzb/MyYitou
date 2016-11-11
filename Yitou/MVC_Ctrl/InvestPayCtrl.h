//
//  InvestPayCtrl.h
//  Yitou
//
//  Created by Xiaohui on 15/8/27.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "BaseController.h"
#import "Tender.h"

@interface InvestPayCtrl : BaseController

@property (retain)Tender *tender;

@property (nonatomic,copy)NSDictionary *dataSource;

@end
