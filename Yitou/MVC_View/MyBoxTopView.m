//
//  MyBoxTopView.m
//  Yitou
//
//  Created by mac on 15/11/25.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import "MyBoxTopView.h"

@implementation MyBoxTopView{
    BoxBlock blocks;
    UIButton *unUseBtn;
    UIButton *useingBtn;
    UIButton *offUstBtn;
    UIButton *usedBtn;
    NSInteger lastIndx;
    UIView   *lineView;
}

- (void)loadTopViewWithBlock:(BoxBlock)block{
    blocks =block;
    [self loadButton];
    lastIndx = 0;
    [self loadHighlineView];
    [self setBackgroundColor:[UIColor whiteColor]];
}

- (void)loadHighlineView{
    UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(0, VIEWFSH(self)-2, SCREENWidth, 2)];
    [grayLine setBackgroundColor:[UIColor colorWithRed:0.8 green:0.81 blue:0.81 alpha:1]];
    [self addSubview:grayLine];

    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEWFOY(grayLine), SCREENWidth/4, 2)];
    [lineView setBackgroundColor:[UIColor colorWithRed:0 green:0.62 blue:0.87 alpha:1]];
    [self addSubview:lineView];
}

- (void)loadButton{
    unUseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth/4, VIEWFSH(self))];
    useingBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWidth/4, 0, SCREENWidth/4, VIEWFSH(self))];
    offUstBtn = [[UIButton alloc] initWithFrame:CGRectMake(2*SCREENWidth/4, 0, SCREENWidth/4, VIEWFSH(self))];
    usedBtn = [[UIButton alloc] initWithFrame:CGRectMake(3*SCREENWidth/4, 0, SCREENWidth/4, VIEWFSH(self))];

    [self loadBtn:unUseBtn Title:@"未使用" tag:0];
    [self loadBtn:useingBtn Title:@"使用中" tag:1];
    [self loadBtn:offUstBtn Title:@"已过期" tag:2];
    [self loadBtn:usedBtn Title:@"已使用" tag:3];

    [unUseBtn setTitleColor:[UIColor colorWithRed:0.22 green:0.55 blue:0.87 alpha:1] forState:UIControlStateNormal];
}

- (void)loadBtn:(UIButton *)btn Title:(NSString *)title tag:(NSInteger)tag {
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:0.42 green:0.42 blue:0.42 alpha:1] forState:UIControlStateNormal];
    [btn setTag:tag];
    [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

- (void)clickButton:(id)sender{
    if (lastIndx == [sender tag])
        return;
    lastIndx = [sender tag];
    blocks (lastIndx+1);
    [self unselectStatus];
    [sender setTitleColor:[UIColor colorWithRed:0.22 green:0.55 blue:0.87 alpha:1] forState:UIControlStateNormal];
    [lineView setFrame:CGRectMake(lastIndx * SCREENWidth/4, VIEWFOY(lineView), SCREENWidth/4, 2)];
}

- (void)unselectStatus{
    [unUseBtn setTitleColor:[UIColor colorWithRed:0.45 green:0.46 blue:0.46 alpha:1] forState:UIControlStateNormal];
    [useingBtn setTitleColor:[UIColor colorWithRed:0.45 green:0.46 blue:0.46 alpha:1] forState:UIControlStateNormal];
    [offUstBtn setTitleColor:[UIColor colorWithRed:0.45 green:0.46 blue:0.46 alpha:1] forState:UIControlStateNormal];
    [usedBtn setTitleColor:[UIColor colorWithRed:0.45 green:0.46 blue:0.46 alpha:1] forState:UIControlStateNormal];
}

@end
