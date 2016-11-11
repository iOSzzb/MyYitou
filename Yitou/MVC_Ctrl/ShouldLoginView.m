//
//  ShouldLoginCtrl.m
//  Yitou
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "ShouldLoginView.h"

typedef void(^EventBlock)(BOOL isLogin);

@implementation ShouldLoginView{
    EventBlock block;
}

- (void)loadAllView{
    UIColor *btnColor = [UIColor colorWithRed:0.15 green:0.55 blue:0.89 alpha:1];
    NSMutableAttributedString *loginAttri = [[NSMutableAttributedString alloc]initWithString:@"请登录或"];
    [loginAttri addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 4)];
    [loginAttri addAttribute:NSForegroundColorAttributeName value:btnColor range:NSMakeRange(1, 2)];
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWidth/2-82, SCREENHeight/2, 74, 30)];
    [loginBtn setAttributedTitle:loginAttri forState:UIControlStateNormal];
    [loginAttri addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(1, 2)];
    [loginBtn addTarget:self action:@selector(clickLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginBtn];

    NSMutableAttributedString *regAttri = [[NSMutableAttributedString alloc]initWithString:@"注册后查看"];
    [regAttri addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(2, 3)];
    [regAttri addAttribute:NSForegroundColorAttributeName value:btnColor range:NSMakeRange(0, 2)];
    UIButton *regBtn = [[UIButton alloc] initWithFrame:CGRectMake(VIEWFW_X(loginBtn), VIEWFOY(loginBtn), 90, 30)];
    [regBtn setAttributedTitle:regAttri forState:UIControlStateNormal];
    [regAttri addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, 2)];
    [regBtn addTarget:self action:@selector(clickRegisterBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:regBtn];
}

- (void)clickLoginBtn{
    block(YES);
}

- (void)clickRegisterBtn{
    block(NO);
}

- (void)loadViewWithBlock:(void (^)(BOOL))blocks{
    block = blocks;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self loadAllView];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

@end
