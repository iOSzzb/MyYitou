//
//  MyBoxTopView.h
//  Yitou
//
//  Created by mac on 15/11/25.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BoxBlock)(NSInteger indx);

@interface MyBoxTopView : UIView

- (void)loadTopViewWithBlock:(BoxBlock)block;

@end
