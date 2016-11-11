//
//  ShouldLoginCtrl.h
//  Yitou
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShouldLoginView : UIView

- (void)loadViewWithBlock:(void(^)(BOOL isLogin))block;

@end
