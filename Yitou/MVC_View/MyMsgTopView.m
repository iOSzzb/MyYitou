//
//  MyMsgTopView.m
//  Yitou
//
//  Created by mac on 16/1/28.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "MyMsgTopView.h"

@implementation MyMsgTopView{
    EventBlock block;
}

- (instancetype)initWithFrame:(CGRect)frame block:(EventBlock)callBack{
    self = [super initWithFrame:frame];
    block = callBack;
    if (self){
        [self loadButton];
    }
    return self;
}

- (void)loadButton{
    [self loadButtonWithTitle:@"全部" tag:0];
    [self loadButtonWithTitle:@"未读" tag:1];
    [self loadButtonWithTitle:@"已读" tag:2];
}

- (void)loadButtonWithTitle:(NSString *)title tag:(NSInteger)tag{
    float gap = tag == 2?0:1;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWidth/3*tag, 0, SCREENWidth/3 - gap, VIEWFSH(self)-1)];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitleColor:[UIColor colorWithHue:0.58 saturation:0.02 brightness:0.33 alpha:1] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTag:tag];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];

//    if (tag == 1){
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(VIEWFSW(button)/2+22, VIEWFSH(button)/2-4, 8, 8)];
//        [view setBackgroundColor:[UIColor redColor]];
//        [button addSubview:view];
//        [view.layer setMasksToBounds:YES];
//        [view.layer setCornerRadius:VIEWFSH(view)/2];
//    }
}

- (void)clickButton:(id)sender{
    block([sender tag]);
}

@end
