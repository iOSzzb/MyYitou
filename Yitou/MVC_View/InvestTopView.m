//
//  InvestTopView.m
//  Yitou
//
//  Created by Xiaohui on 15/8/10.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#define SELECTEDColor  COLORWithRGB(63, 151, 231, 1)

#import "InvestTopView.h"

@implementation InvestTopView{
    UIView *markView;
    UIView *leftView;
    UIView *centerView;
    UIView *rightView;
    UILabel *leftLabel;
    UILabel *centerLabel;
    UILabel *rightLabel;
    NSInteger nowIndx;
}

- (void)loadTopView{
    nowIndx = 0;
    [self setBackgroundColor:[UIColor whiteColor]];
    markView = [[UIView alloc]initWithFrame:CGRectMake(20, VIEWFSH(self)-2, VIEWFSW(self)/3-40, 2)];
    [markView setBackgroundColor:SELECTEDColor];
    [self addSubview:markView];

    leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VIEWFSW(self)/3, VIEWFSH(self))];

    centerView = [[UIView alloc]initWithFrame:CGRectMake(VIEWFSW(self)/3, 0, VIEWFSW(self)/3, VIEWFSH(self))];
    rightView = [[UIView alloc]initWithFrame:CGRectMake(VIEWFSW(self)*2/3, 0, VIEWFSW(self)/3, VIEWFSH(self))];

    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, VIEWFSW(leftView), VIEWFSH(leftView))];
    UIButton *centerBtn = [[UIButton alloc] initWithFrame:leftBtn.frame];
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:leftBtn.frame];
    [leftBtn setBackgroundColor:[UIColor clearColor]];

    leftLabel = [[UILabel alloc] initWithFrame:leftBtn.frame];
    centerLabel = [[UILabel alloc] initWithFrame:leftBtn.frame];
    rightLabel = [[UILabel alloc] initWithFrame:leftBtn.frame];
    [leftLabel setTextAlignment:NSTextAlignmentCenter];
    [centerLabel setTextAlignment:NSTextAlignmentCenter];
    [rightLabel setTextAlignment:NSTextAlignmentCenter];
    [leftLabel setFont:[UIFont fontWithName:SYSTEMFONTName size:14]];
    [centerLabel setFont:leftLabel.font];
    [rightLabel setFont:leftLabel.font];

    [leftLabel setText:@"标类型"];
    [centerLabel setText:@"利率"];
    [rightLabel setText:@"期限"];

    [leftView addSubview:leftLabel];
    [centerView addSubview:centerLabel];
    [rightView addSubview:rightLabel];

    [leftView addSubview:leftBtn];
    [centerView addSubview:centerBtn];
    [rightView addSubview:rightBtn];

    [self addSubview:leftView];
    [self addSubview:centerView];
    [self addSubview:rightView];

    [leftBtn setTag:0];
    [centerBtn setTag:1];
    [rightBtn setTag:2];

    [leftBtn addTarget:self action:@selector(clickBtnAtIndx:) forControlEvents:UIControlEventTouchUpInside];
    [centerBtn addTarget:self action:@selector(clickBtnAtIndx:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addTarget:self action:@selector(clickBtnAtIndx:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)clickBtnAtIndx:(id)sender{
    nowIndx = [sender tag];
    if ([sender tag]==0){
        [leftLabel setTextColor:SELECTEDColor];
        [centerLabel setTextColor:[UIColor blackColor]];
        [rightLabel setTextColor:[UIColor blackColor]];
        [markView setFrame:CGRectMake(20, VIEWFOY(markView), VIEWFSW(markView), VIEWFSH(markView))];
        _lastIndx = 0;
    }
    if ([sender tag]==1){
        [leftLabel setTextColor:[UIColor blackColor]];
        [centerLabel setTextColor:SELECTEDColor];
        [rightLabel setTextColor:[UIColor blackColor]];
        [markView setFrame:CGRectMake(20+VIEWFSW(self)/3, VIEWFOY(markView), VIEWFSW(markView), VIEWFSH(markView))];
        if (_lastIndx != 1){
            _lastIndx = 1;
            _status = 1;
        }
        else{
            _status = _status == 2?1:2;
        }
    }
    if ([sender tag]==2){
        [leftLabel setTextColor:[UIColor blackColor]];
        [centerLabel setTextColor:[UIColor blackColor]];
        [rightLabel setTextColor:SELECTEDColor];
        [markView setFrame:CGRectMake(20+VIEWFSW(self)*2/3, VIEWFOY(markView), VIEWFSW(markView), VIEWFSH(markView))];
        if (_lastIndx != 2){
            _lastIndx = 2;
            _status = 1;
        }
        else{
            _status = _status == 2?1:2;
        }
    }
    if ([_delegate respondsToSelector:@selector(topViewDidClicked)]){
        [_delegate topViewDidClicked];
    }
}

@end