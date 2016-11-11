//
//  MyInvestView.m
//  Yitou
//
//  Created by Xiaohui on 15/11/18.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import "MyInvestView.h"

#define BUTTONHeight   (SCREENHeight>570?50:35)

@implementation MyInvestView{
    InvestBlock callback;
    UIButton    *waitRec;
    UIButton    *didRec;
    UILabel     *moneyLB;
    UIView      *promptView;
}

- (void)loadMyInvestViewWithBlock:(InvestBlock)block{
    callback = block;
    [self setBackgroundColor:[UIColor whiteColor]];
    promptView = [[UIView alloc] initWithFrame:CGRectMake(30, BUTTONHeight - 2, (SCREENWidth/2)-30*2, 2)];
    [promptView setBackgroundColor:[UIColor colorWithRed:0.2 green:0.69 blue:0.89 alpha:0.88]];
    [self loadPromptView];
    [self loadButton];

    [self loadLabel];
}

- (void)loadPromptView{
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, VIEWFH_Y(promptView)-1, SCREENWidth, 1)];
    [topLine setBackgroundColor:[UIColor colorWithRed:0.83 green:0.83 blue:0.84 alpha:0.84]];
    [self addSubview:topLine];

    UIView  *downLine = [[UIView alloc] initWithFrame:CGRectMake(0, (VIEWFH_Y(promptView)-1+BUTTONHeight), SCREENWidth, 1)];
    [downLine setBackgroundColor:topLine.backgroundColor];
    [self addSubview:downLine];
    _height = VIEWFH_Y(downLine)+1;
}

- (void)loadLabel{
    UILabel *xmName = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEWFH_Y(promptView), (SCREENWidth/2)*3/5, BUTTONHeight)];
    [xmName setTextColor:[UIColor grayColor]];
    [xmName setText:@"项目名称"];
    [xmName setFont:[UIFont systemFontOfSize:14]];
    [xmName setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:xmName];

    UILabel *timeLB = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWidth*3/10, VIEWFH_Y(promptView), SCREENWidth/5, BUTTONHeight)];
    [timeLB setTextColor:[UIColor grayColor]];
    [timeLB setText:@"还款时间"];
    [timeLB setFont:[UIFont systemFontOfSize:14]];
    [timeLB setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:timeLB];

    moneyLB = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWidth/2, VIEWFH_Y(promptView), SCREENWidth/4, BUTTONHeight)];
    [moneyLB setTextColor:[UIColor grayColor]];
    [moneyLB setText:@"预计收入"];
    [moneyLB setFont:timeLB.font];
    [moneyLB setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:moneyLB];

    UILabel *detailLB = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWidth*3/4, VIEWFH_Y(promptView), SCREENWidth/4, BUTTONHeight)];
    [detailLB setTextColor:[UIColor grayColor]];
    [detailLB setText:@"明细"];
    [detailLB setFont:moneyLB.font];
    [detailLB setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:detailLB];
}

- (void)loadButton{
    waitRec = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth/2, BUTTONHeight)];
    [waitRec.titleLabel setTextColor:[UIColor grayColor]];
    [waitRec setTitle:@"回收中的投资" forState:UIControlStateNormal];
    [waitRec addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:waitRec];

    didRec = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWidth/2, 0, SCREENWidth/2, BUTTONHeight)];
    [didRec.titleLabel setTextColor:[UIColor grayColor]];
    [didRec setTitle:@"已回收的投资" forState:UIControlStateNormal];
    [didRec addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:didRec];

    [self btnChangeToUnselect:didRec];
    [self btnChangeToSelected:waitRec];
}

- (void)clickButton:(id)sender{
    if (sender == waitRec){
        [self btnChangeToUnselect:didRec];
        [self btnChangeToSelected:waitRec];
        [moneyLB setText:@"预计收入"];
        callback(0);
    }
    if (sender == didRec){
        [self btnChangeToUnselect:waitRec];
        [self btnChangeToSelected:didRec];
        [moneyLB setText:@"实际收入"];
        callback(1);
    }
}

- (void)btnChangeToUnselect:(UIButton *)btn{
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setUserInteractionEnabled:YES];
    [promptView removeFromSuperview];
}

- (void)btnChangeToSelected:(UIButton *)btn{
    [btn setTitleColor:[UIColor colorWithRed:0 green:0.5 blue:0.83 alpha:1] forState:UIControlStateNormal];
    [btn setUserInteractionEnabled:NO];
    [btn addSubview:promptView];
}

@end