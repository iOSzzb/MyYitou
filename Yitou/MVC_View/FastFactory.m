//
//  FastFactory.m
//  Yitou
//
//  Created by Xiaohui on 15/8/24.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "FastFactory.h"

@implementation FastFactory

+ (UILabel *)loadLabelWith:(NSTextAlignment)alignment Frame:(CGRect)frame TextColor:(UIColor *)textcolor fontSize:(NSInteger)textSize{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    [label setTextAlignment:alignment];
    [label setTextColor:textcolor];
    [label setFont:[UIFont fontWithName:SYSTEMFONTName size:textSize]];
    return label;
}

+ (UIImage*)convertViewToImage:(UIView*)view color:(UIColor *)color{
    UIButton *btn = [[UIButton alloc] initWithFrame:view.frame];
    [btn setTitle:btn.currentTitle forState:UIControlStateNormal];
    [btn setBackgroundColor:color];
    UIGraphicsBeginImageContext(btn.bounds.size);
    [btn.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

+ (CGSize)calculatorSizeWithLabel:(UILabel *)label{
    NSDictionary * attri = [NSDictionary dictionaryWithObjectsAndKeys:label.font,NSFontAttributeName,nil];
    CGSize  size =[label.text boundingRectWithSize:CGSizeMake(VIEWFSW(label), 0) options:NSStringDrawingUsesLineFragmentOrigin  attributes:attri context:nil].size;
    return size;
}

+ (UIButton *)customButton:(UIButton *)button bgColorR:(NSInteger)r g:(NSInteger)g b:(NSInteger)b{
    NSInteger gap = 20;
    [button setBackgroundColor:COLORWithRGB(r - gap, g - gap, b - gap, 0.42)];
    [button setBackgroundImage:[FastFactory convertViewToImage:button color:button.backgroundColor] forState:UIControlStateHighlighted];
    [button setBackgroundColor:COLORWithRGB(r, g, b, 1.0)];
    return button;
}

+ (void)customViewRadius:(UIView *)view{
    [view.layer setMasksToBounds:YES];
    [view.layer setCornerRadius:VIEWFSH(view)/2];
}

@end
