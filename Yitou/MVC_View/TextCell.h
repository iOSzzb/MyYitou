//
//  TextCell.h
//  Yitou
//
//  Created by Xiaohui on 15/8/21.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextCell : UIView

@property (nonatomic,copy)NSString *text;

- (void)loadCellWithContent:(NSString *)content_;

@end
