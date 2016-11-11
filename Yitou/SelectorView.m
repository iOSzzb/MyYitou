//
//  SelectorView.m
//  Yitou
//
//  Created by imac on 16/3/14.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "SelectorView.h"



@implementation SelectorView{
    UIButton *orderBtn;   //预约按钮
    UIButton *recordBtn;  //记录按钮
    UIView *lineView;    //下划线
    UIView *contentView; //装载按钮的容器
}

- (void)LoadSelectorView{
    [self setBackgroundColor:[UIColor colorWithRed:0.2 green:0.69 blue:0.89 alpha:0.88]];
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, self.frame.size.height-1)];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:contentView];
    
    orderBtn = [self showButtonWithFrame:CGRectMake(0, 0, VIEWFSW(contentView)/2, VIEWFSH(contentView)) Title:@"预约"];
    orderBtn.tag = 101;
    recordBtn = [self showButtonWithFrame:CGRectMake(VIEWFSW(contentView)/2, 0, VIEWFSW(contentView)/2, VIEWFSH(contentView)) Title:@"预约记录"];
    recordBtn.tag = 102;
    
    [contentView addSubview:orderBtn];
    [contentView addSubview:recordBtn];
    
    lineView  = [[UIView alloc] initWithFrame:CGRectMake(10, self.frame.size.height-3, SCREENWidth/2-20, 2)];
    [lineView setBackgroundColor:[UIColor colorWithRed:0.21 green:0.56 blue:0.89 alpha:1]];
    [self addSubview:lineView];
    
    orderBtn.selected = YES;
    recordBtn.selected = NO;
    
    [orderBtn addTarget:self action:@selector(selectorButton:) forControlEvents:UIControlEventTouchUpInside];
    [recordBtn addTarget:self action:@selector(selectorButton:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)selectorButton:(UIButton *)sender{
    sender.selected = YES;
    if (sender.tag == 101) {
        if ([self.delegate performSelector:@selector(selectorButtontag:)]) {
             [self.delegate selectorButtontag:ORDER_SELECTOR];
        }
       
        [UIView animateWithDuration:0.3 animations:^{
            recordBtn.selected = NO;
            [lineView setFrame:CGRectMake(10, self.frame.size.height-3, SCREENWidth/2-20, 2)];
        }];
        
        
    }else{
        if ([self.delegate performSelector:@selector(selectorButtontag:)]) {
            [self.delegate selectorButtontag:RECORD_SELECTOR];
        }
        [UIView animateWithDuration:0.3 animations:^{
            orderBtn.selected = NO;
            [lineView setFrame:CGRectMake(SCREENWidth/2-10, self.frame.size.height-3, SCREENWidth/2-20, 2)];
        }];
        
    }
}

- (void)showSelectorRecord{
    recordBtn.selected = YES;
    
    if ([self.delegate performSelector:@selector(selectorButtontag:)]) {
        [self.delegate selectorButtontag:RECORD_SELECTOR];
    }
    [UIView animateWithDuration:0.3 animations:^{
        orderBtn.selected = NO;
        [lineView setFrame:CGRectMake(SCREENWidth/2-10, self.frame.size.height-3, SCREENWidth/2-20, 2)];
    }];
}

- (UIButton *)showButtonWithFrame:(CGRect)frame Title:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.26 green:0.6 blue:0.91 alpha:1] forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:FONT_16];
    
    return button;
}

@end
