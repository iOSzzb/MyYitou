//
//  BankCell.h
//  Yitou
//
//  Created by Xiaohui on 15/9/16.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankCell : UIButton 

- (void)loadBankCell;

@property(nonatomic,copy)NSDictionary *dataSource;

@end
