//
//  LXHCountDownButton.m
//  Yitou
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "LXHCountDownButton.h"

@implementation LXHCountDownButton{
    BOOL isCountDonw;
    NSInteger timeCount;
    NSInteger timeBalance;//剩余的倒计时时间
    NSTimer *timer;
}

- (instancetype)initWithFrame:(CGRect)frame time:(NSInteger)timeCounts{
    self = [super initWithFrame:frame];
    if (self){
        timeCount = timeCounts;
        [self loadDefaultPara];
        [self reloadStyle];
        [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self untimeCountStatus];
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:VIEWFSH(self)/2];
    }
    return self;
}

- (void)waitStatus{
    [self setUserInteractionEnabled:NO];
}

- (void)endTimeCount{
    timer = nil;
    [timer invalidate];
    [self untimeCountStatus];
}

- (void)clickButton{
    [self startTimeCount];
}

- (void)startRunloop{
    isCountDonw = YES;
    timeBalance --;
    if (timeBalance >= 0){
        NSString *timeExist = [NSString stringWithFormat:@"%@%tu%@",self.prefixString,timeBalance,self.suffixString];
        [self setTitle:timeExist forState:UIControlStateNormal];
        [self timeCountStatus];
    }else{
        [self untimeCountStatus];
    }
}

- (void)timeCountStatus{
    [self setTitleColor:self.timeDownTitleColor forState:UIControlStateNormal];
    [self setBackgroundColor:self.waitColor];

    [self setUserInteractionEnabled:NO];
}

- (void)untimeCountStatus{
    [timer invalidate];
    NSString *btnTitle = timeBalance == 3 ? self.normalTitle : self.afterTitle;
    [self setTitle:btnTitle forState:UIControlStateNormal];
    [self setUserInteractionEnabled:YES];

    [self setTitleColor:self.normalTitleColor forState:UIControlStateNormal];
    [self setBackgroundColor:self.normalColor];
}

- (void)startTimeCount{
    [timer invalidate];
    timeBalance = timeCount;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startRunloop) userInfo:nil repeats:YES];
    [self startRunloop];
}

- (void)reloadStyle{

}

- (void)loadDefaultPara{
    timeBalance = 3;
    self.normalColor = [UIColor orangeColor];
    self.normalTitle = @"获取验证码";
    self.afterTitle = @"重新获取";
    self.prefixString = @"";
    self.suffixString = @"秒";
    self.waitColor = [UIColor grayColor];
    self.normalTitleColor = [UIColor whiteColor];
    self.timeDownTitleColor = [UIColor whiteColor];
}

@end
