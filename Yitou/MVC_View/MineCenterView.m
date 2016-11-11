//
//  MineCenterView.m
//  Yitou
//
//  Created by Xiaohui on 15/8/4.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "MineCenterView.h"

@implementation MineCenterView{
    TouchIndexBlock block;
}

- (void)loadAllViewWithBlock:(TouchIndexBlock)blocks{
    block = blocks;
    float width = VIEWFSW(self);
    width /= 4;
    UIButton *markBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, width, VIEWFSH(self))];
    [markBtn setBackgroundImage:IMAGENAMED(@"mark") forState:UIControlStateNormal];
    [markBtn setBackgroundImage:IMAGENAMED(@"mark_click") forState:UIControlStateHighlighted];
    [markBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [markBtn setTag:0];
    [self addSubview:markBtn];

    UIButton *topBtn = [[UIButton alloc]initWithFrame:CGRectMake(width, 0, width, VIEWFSH(self))];
    [topBtn setBackgroundImage:IMAGENAMED(@"topMoney") forState:UIControlStateNormal];
    [topBtn setBackgroundImage:IMAGENAMED(@"topMoney_click") forState:UIControlStateHighlighted];
    [topBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [topBtn setTag:1];
    [self addSubview:topBtn];

    UIButton *withdrawBtn = [[UIButton alloc]initWithFrame:CGRectMake(width*2, 0, width, VIEWFSH(self))];
    [withdrawBtn setBackgroundImage:IMAGENAMED(@"withdraw") forState:UIControlStateNormal];
    [withdrawBtn setBackgroundImage:IMAGENAMED(@"withdraw_click") forState:UIControlStateHighlighted];
    [withdrawBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [withdrawBtn setTag:2];
    [self addSubview:withdrawBtn];

    UIButton *detailsBtn = [[UIButton alloc]initWithFrame:CGRectMake(width*3, 0, width, VIEWFSH(self))];
    [detailsBtn setBackgroundImage:IMAGENAMED(@"details") forState:UIControlStateNormal];
    [detailsBtn setBackgroundImage:IMAGENAMED(@"details_click") forState:UIControlStateHighlighted];
    [detailsBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [detailsBtn setTag:3];
    [self addSubview:detailsBtn];
}

- (void)clickButton:(id)sender{
    block((int)[sender tag]);
}

@end
