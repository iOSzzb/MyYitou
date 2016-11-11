//
//  FastFactory.h
//  Yitou
//
//  Created by Xiaohui on 15/8/24.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FastFactory : UIView

/**
 *  直接用一行代码设置好一个UILabel 参数不要使用Nil
 *
 *  @param alignment 对齐方式
 *  @param frame     坐标
 *  @param textcolor 字体颜色
 *  @param textSize  字体大小
 */
+ (UILabel *)loadLabelWith:(NSTextAlignment)alignment Frame:(CGRect)frame TextColor:(UIColor *)textcolor fontSize:(NSInteger)textSize;

+ (UIImage*)convertViewToImage:(UIView*)v color:(UIColor *)color;

+ (CGSize)calculatorSizeWithLabel:(UILabel *)label;

+ (UIButton *)customButton:(UIButton *)button bgColorR:(NSInteger)r g:(NSInteger)g b:(NSInteger)b;

+ (void)customViewRadius:(UIView *)view;

@end
