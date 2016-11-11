//
//  MoneyRecordCell.h
//  Yitou
//
//  Created by Xiaohui on 15/8/24.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoneyRecord.h"

@interface MoneyRecordCell : UITableViewCell

@property(retain)MoneyRecord *moneyRecord;

- (void)setCell;

@end
