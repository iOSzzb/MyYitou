//
//  LXHCountDownButton.h
//  Yitou
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXHCountDownButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame  time:(NSInteger)timeCount;

- (void)reloadStyle;

- (void)startTimeCount;

- (void)waitStatus;

- (void)endTimeCount;

/**
 *  第一次开始倒计时前的标题名字 默认:获取验证码
 */
@property (nonatomic,copy)NSString *normalTitle;

/**
 *  正常的背景颜色 //默认橘黄色
 */
@property (nonatomic,copy)UIColor *normalColor;

/**
 *  正常状态时标题的颜色 默认 白色
 */
@property (nonatomic,copy)UIColor *normalTitleColor;

/**
 *  倒计时时标题的颜色 默认:白色
 */
@property (nonatomic,copy)UIColor *timeDownTitleColor;

/**
 *  倒计时完成后的标题 默认:重新获取验证码
 */
@property (nonatomic,copy)NSString *afterTitle;

/**
 *  倒计时时秒数字的前缀 例如:剩余  默认:@""
 */
@property (nonatomic,copy)NSString *prefixString;

/**
 *  倒计时时数字的后缀 例如:秒 默认:秒
 */
@property (nonatomic,copy)NSString *suffixString;

/**
 *  倒计时时的背景颜色 默认灰色
 */
@property (nonatomic,copy)UIColor *waitColor;

@end
