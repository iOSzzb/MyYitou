//
//  NullView.m
//  Yitou
//
//  Created by mac on 16/1/12.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "NullView.h"

@implementation NullView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self loadAllView];
    }
    return self;
}

- (void)loadAllView{
    [self setBackgroundColor:[UIColor colorWithRed:0.86 green:0.95 blue:0.97 alpha:1]];
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEWFSH(self)/2 - 10, SCREENWidth, 20)];
    [msgLabel setText:@"没有数据"];
    [msgLabel setTextColor:[UIColor grayColor]];
    [msgLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:msgLabel];
}

@end
