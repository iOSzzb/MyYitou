//
//  MyInvestCell.h
//  Yitou
//
//  Created by Xiaohui on 15/11/19.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CELLHeight   45

@interface MyInvestCell : UITableViewCell

@property(assign)BOOL showReal;

- (void)setCell:(NSDictionary *)dataSource;

@end
