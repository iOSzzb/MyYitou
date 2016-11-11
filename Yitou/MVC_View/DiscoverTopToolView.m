//
//  DiscoverTopToolView.m
//  Yitou
//
//  Created by Xiaohui on 15/8/13.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "DiscoverTopToolView.h"

@implementation DiscoverTopToolView{
    UILabel *userCount;
    UILabel *moneyCount;
    UILabel *earnCount;
    float cellHeight;
}

- (void)loadDataInformation:(NSDictionary *)dict{
    userCount.text = [dict objectForKey:@"sum_user"];
    earnCount.text = [dict objectForKey:@"sum_borrow_money"];
    moneyCount.text = [dict objectForKey:@"sum_repay_money"];

    [userCount setTextColor:[UIColor whiteColor]];
    [earnCount setTextColor:[UIColor whiteColor]];
    [moneyCount setTextColor:[UIColor whiteColor]];
}

- (void)loadToolView{
    cellHeight = SCREENWidth*209/1242;
    [self loadLeftView];
    [self loadCenterView];
    [self loadRightView];
}

- (NSAttributedString *)formatString:(NSString *)str{
    int fontSize = SCREENWidth>321?16:14;
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:str];
    [attribut addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [str length])];
    [attribut addAttribute:NSFontAttributeName value:[UIFont fontWithName:SYSTEMFONTName size:fontSize] range:NSMakeRange(0, [str length]-1)];
    [attribut addAttribute:NSFontAttributeName value:[UIFont fontWithName:SYSTEMFONTName size:fontSize-3] range:NSMakeRange([str length]-1, 1)];
    return attribut;
}

- (void)loadRightView{
    UIView *rightCell = [[UIView alloc]initWithFrame:CGRectMake(SCREENWidth-SCREENWidth/3, 0, SCREENWidth/3, cellHeight)];
    UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, VIEWFSW(rightCell), cellHeight)];
    [imgv setImage:IMAGENAMED(@"discover_CellBg")];
    [rightCell addSubview:imgv];
    [self addSubview:rightCell];

    NSString *earnStr = @"正在获取...";
    earnCount = [[UILabel alloc] initWithFrame:CGRectMake(0, cellHeight/2-20, VIEWFSW(rightCell), 20)];
    [earnCount setTextAlignment:NSTextAlignmentCenter];
    earnCount.attributedText = [self formatString:earnStr];

    [rightCell addSubview:earnCount];

    UILabel *descLB = [[UILabel alloc] initWithFrame:CGRectMake(0, cellHeight/2+4, VIEWFSW(rightCell), 14)];
    [descLB setText:@"待收总额"];
    [descLB setTextColor:[UIColor whiteColor]];
    [descLB setTextAlignment:NSTextAlignmentCenter];
    [descLB setFont:[UIFont fontWithName:SYSTEMFONTName size:12]];
    [rightCell addSubview:descLB];
}

- (void)loadCenterView{
    UIView *centerCell = [[UIView alloc]initWithFrame:CGRectMake(SCREENWidth/3, 0, SCREENWidth/3, cellHeight)];
    UIImageView *imgv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, VIEWFSW(centerCell), cellHeight)];
    [imgv setImage:IMAGENAMED(@"discover_CellBg")];
    [centerCell addSubview:imgv];
    [self addSubview:centerCell];

    NSString *earnStr = @"正在获取...";
    moneyCount = [[UILabel alloc] initWithFrame:CGRectMake(0, cellHeight/2-20, VIEWFSW(centerCell), 20)];

    [moneyCount setTextAlignment:NSTextAlignmentCenter];
    moneyCount.attributedText = [self formatString:earnStr];

    [centerCell addSubview:moneyCount];

    UILabel *descLB = [[UILabel alloc] initWithFrame:CGRectMake(0, cellHeight/2+4, VIEWFSW(centerCell), 14)];
    [descLB setText:@"融资金额"];
    [descLB setTextColor:[UIColor whiteColor]];
    [descLB setTextAlignment:NSTextAlignmentCenter];
    [descLB setFont:[UIFont fontWithName:SYSTEMFONTName size:12]];
    [centerCell addSubview:descLB];
}

- (void)loadLeftView{
    UIView *leftCell = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth/3, cellHeight)];
    UIImageView *imgv = [[UIImageView alloc]initWithFrame:leftCell.frame];
    [imgv setImage:IMAGENAMED(@"discover_CellBg")];
    [leftCell addSubview:imgv];
    [self addSubview:leftCell];

    NSString *earnStr = @"正在获取...";
    userCount= [[UILabel alloc] initWithFrame:CGRectMake(0, cellHeight/2-20, VIEWFSW(leftCell), 20)];
    [userCount setTextAlignment:NSTextAlignmentCenter];
    userCount.attributedText = [self formatString:earnStr];
    [leftCell addSubview:userCount];

    UILabel *descLB = [[UILabel alloc] initWithFrame:CGRectMake(0, cellHeight/2+4, VIEWFSW(leftCell), 14)];
    [descLB setText:@"注册人数"];
    [descLB setTextColor:[UIColor whiteColor]];
    [descLB setTextAlignment:NSTextAlignmentCenter];
    [descLB setFont:[UIFont fontWithName:SYSTEMFONTName size:12]];
    [leftCell addSubview:descLB];
}

- (void)setDataSource:(NSDictionary *)dataSource{
    _dataSource = dataSource;
}

@end
