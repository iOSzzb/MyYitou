//
//  TenderCell.h
//  Yitou
//
//  Created by Xiaohui on 15/8/11.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tender.h"

#define CELLHeight  110

@interface InvestmentCell : UITableViewCell

@property (retain)Tender *tender;

- (void)setCell;

@end
