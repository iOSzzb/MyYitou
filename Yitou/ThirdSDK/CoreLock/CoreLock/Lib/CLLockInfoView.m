//
//  CLLockInfoView.m
//  CoreLock
//
//  Created by 成林 on 15/4/27.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "CLLockInfoView.h"
#import "CoreLockConst.h"

@implementation CLLockInfoView{
    UIView *baseView;
}

- (void)setShowPwd:(NSString *)showPwd{
    _showPwd = showPwd;
    [self setNeedsDisplay];

}

- (void)loadBaseView:(CGRect)rect{
    if (_showPwd == nil)
        _showPwd = @"";
    [baseView removeFromSuperview];
    baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:baseView];
    for (NSUInteger i=0; i<9; i++) {

        CGFloat marginV = 5.f;
        CGFloat padding = 1.0f;
        CGFloat rectWH = (rect.size.width - marginV * 2 - padding*2) / 3;


        NSUInteger row = i % 3;
        NSUInteger col = i / 3;

        CGFloat rectX = (rectWH + marginV) * row + padding;

        CGFloat rectY = (rectWH + marginV) * col + padding;

        CGRect rects = CGRectMake(rectX, rectY, rectWH, rectWH);

        UIView *view = [[UIView alloc] initWithFrame:rects];

        NSArray *ary = [_showPwd componentsSeparatedByString:[NSString stringWithFormat:@"%tu",i]];
        if ([ary count] == 2)
            [view setBackgroundColor:[UIColor whiteColor]];
        [view.layer setMasksToBounds:YES];
        [view.layer setBorderColor:[UIColor whiteColor].CGColor];
        [view.layer setBorderWidth:1.0];

        [view.layer setCornerRadius:VIEWFSH(view)/2];

        [baseView addSubview:view];

    }
}

-(void)drawRect:(CGRect)rect{
    [self loadBaseView:rect];
    //获取上下文
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    
//    //设置属性
//    CGContextSetLineWidth(ctx, CoreLockArcLineW);
//    
//    //设置线条颜色
//    [CoreLockCircleLineNormalColor set];
//    
//    //新建路径
//    CGMutablePathRef pathM =CGPathCreateMutable();
//    
//    CGFloat marginV = 3.f;
//    CGFloat padding = 1.0f;
//    CGFloat rectWH = (rect.size.width - marginV * 2 - padding*2) / 3;
//    
//    //添加圆形路径
//    for (NSUInteger i=0; i<9; i++) {
//        
//        NSUInteger row = i % 3;
//        NSUInteger col = i / 3;
//        
//        CGFloat rectX = (rectWH + marginV) * row + padding;
//        
//        CGFloat rectY = (rectWH + marginV) * col + padding;
//        
//        CGRect rect = CGRectMake(rectX, rectY, rectWH, rectWH);
//        
//        CGPathAddEllipseInRect(pathM, NULL, rect);
//    }
//    
//    //添加路径
//    CGContextAddPath(ctx, pathM);
//    
//    //绘制路径
//    CGContextStrokePath(ctx);
//    
//    //释放路径
//    CGPathRelease(pathM);
}




















@end
