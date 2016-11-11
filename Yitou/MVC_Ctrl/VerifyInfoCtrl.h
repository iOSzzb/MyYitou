//
//  VerifyInfoCtrl.h
//  Yitou
//
//  Created by Xiaohui on 15/9/2.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "BaseController.h"
#import "Tender.h"

@interface VerifyInfoCtrl : BaseController

@property (nonatomic,copy)NSDictionary *dataSource;

@property (retain)Tender *tender;

@end
