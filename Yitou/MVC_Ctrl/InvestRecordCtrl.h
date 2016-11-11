//
//  InvestRecordCtrl.h
//  Yitou
//
//  Created by Xiaohui on 15/11/2.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import "BaseController.h"
#import "Tender.h"

@interface InvestRecordCtrl : BaseController

@property (retain)Tender *tender;

/**
 *  源数据
 */
@property (nonatomic,copy)NSDictionary *oriData;

@property (nonatomic,copy)NSString *investID;

@end
