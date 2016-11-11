//
//  MyInvestDetailCtrl.h
//  Yitou
//
//  Created by Xiaohui on 15/11/20.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import "BaseController.h"

@interface MyInvestDetailCtrl : BaseController

@property (nonatomic,copy)NSDictionary *dataSource;
@property (nonatomic,assign) BOOL isReceivingInvest;//是不是已回收的投资

@end
