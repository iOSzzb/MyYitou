//
//  CustomNavigation.h
//  Yitou
//
//  Created by Xiaohui on 15/11/6.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNavigation : UIView

typedef void(^CustomBlock)(NSInteger indx);

/**
 *  设置Navigation的返回按钮为通用的白色返回按钮
 *
 *  @param navi  传递self.navigationitem
 *  @param block 点击了返回按钮时需要使用到的
 */
- (void)customNavigation:(UINavigationItem *)navi block:(CustomBlock)block;

/**
 *  设置Navigation的title颜色
 *
 *  @param navi 传递self.navigationcontroller过来即可
 */
- (void)customNavigationTitle:(UINavigationController *)navi;

- (void)customNavigationView:(UINavigationItem *)navi title:(NSString *)title block:(CustomBlock)block;

@end
