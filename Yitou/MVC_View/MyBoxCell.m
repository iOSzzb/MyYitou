//
//  MyBoxCell.m
//  Yitou
//
//  Created by mac on 15/11/25.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import "MyBoxCell.h"
#import "LXHTimer.h"

#define LINEWidth   2

@implementation MyBoxCell{
    NSDictionary *orignData;
    UIView *baseView;
    NSInteger type;
    UIImageView *topImgv;
    UIColor *commonColor;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellWithData:(NSDictionary *)dataSource{
    orignData = dataSource;
    [self setBackgroundColor:[UIColor colorWithRed:0.87 green:0.95 blue:0.98 alpha:1]];
    type = [[dataSource objectForKey:@"prize_status"] integerValue];
    [self loadQuan];
    [self loadLabel];
    [self loadMarkAndTimeLabel];
}

- (void)loadUsedQuan{
    commonColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.71 alpha:1];
    [topImgv setImage:IMAGENAMED(@"quan_bg_type3")];
}

- (void)loadOvertimeQuan{
    commonColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.71 alpha:1];
    [topImgv setImage:IMAGENAMED(@"quan_bg_type3")];
}

- (void)loadUsingQuan{
    commonColor = [UIColor colorWithRed:0.94 green:0.48 blue:0.52 alpha:1];
    [topImgv setImage:IMAGENAMED(@"quan_bg_type2")];
}

- (void)loadUnuseQuan{
    commonColor = [UIColor colorWithRed:0.17 green:0.71 blue:0.92 alpha:1];
    [topImgv setImage:IMAGENAMED(@"quan_bg_type1")];
}

- (void)loadQuan{
    [baseView removeFromSuperview];
    baseView = nil;
    baseView = [[UIView alloc] initWithFrame:CGRectMake(20, 5, SCREENWidth-40, MYBoxHeight-10)];
    [baseView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:baseView];

    topImgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, VIEWFSW(baseView), 12)];
    [baseView addSubview:topImgv];

//    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LINEWidth, VIEWFSH(baseView))];
//    [leftLine setBackgroundColor:[UIColor grayColor]];
//    [baseView addSubview:leftLine];
//
//    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(VIEWFSW(baseView)-LINEWidth, 0, LINEWidth, VIEWFSH(baseView))];
//    [rightLine setBackgroundColor:leftLine.backgroundColor];
//    [baseView addSubview:rightLine];
//
//    UIView *underLine = [[UIView alloc] initWithFrame:CGRectMake(0, (VIEWFSH(baseView)-LINEWidth), VIEWFSW(baseView), LINEWidth)];
//    [underLine setBackgroundColor:leftLine.backgroundColor];
//    [baseView addSubview:underLine];

    switch ([[orignData objectForKey:@"prize_status"] integerValue]) {
        case 1:[self loadUnuseQuan];break;
        case 2:[self loadUsingQuan];break;
        case 3:[self loadOvertimeQuan];break;
        case 4:[self loadUsedQuan];break;
        default:NSLOG(@"券类型错误-->10001");break;
    }
}

- (void)loadLabel{
    NSString *str = [orignData objectForKey:@"details"];
//    NSInteger tp = [[orignData objectForKey:@"prize_type"] integerValue];
    NSString *quanStr = [orignData objectForKey:@"prize_type"];
//    if (tp == 33||tp==43||tp == 45){
//        str = [str stringByAppendingString:@"元"];
//        quanStr = @"新手红包";
//    }else if (tp == 27||tp==28||tp==30||tp == 40||tp == 46||tp == 44){
//        str = [str stringByAppendingString:@"%"];
//        quanStr =@"加息券";
//    }else if (tp == 34){
//        str = [str stringByAppendingString:@"元"];
//        quanStr = @"新手体验金";
//    }
//    else{
//        str = [str stringByAppendingString:@"元"];
//        quanStr = @"新手红包";
//    }

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, VIEWFSW(baseView)-30, VIEWFSH(baseView))];
    [label setTextColor:commonColor];
    [label setFont:[UIFont systemFontOfSize:30]];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setText:str];
    [baseView addSubview:label];

    UILabel *quanName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,VIEWFSW(baseView)-20, VIEWFSH(baseView))];
    [quanName setTextColor:commonColor];
    [quanName setFont:[UIFont systemFontOfSize:24]];
    [quanName setTextAlignment:NSTextAlignmentRight];
    [quanName setText:quanStr];
    [baseView addSubview:quanName];
}

- (void)loadMarkAndTimeLabel{
    NSInteger size = SCREENWidth>321?13:11;

    UILabel *markLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, VIEWFSH(baseView)-35, VIEWFSW(baseView)-10, 15)];
    [markLabel setFont:[UIFont systemFontOfSize:size]];
    [markLabel setText:[orignData objectForKey:@"conent"]];
    [markLabel setTextColor:[UIColor colorWithRed:0.75 green:0.76 blue:0.76 alpha:1]];
    [baseView addSubview:markLabel];

    UILabel *timeLable = [[UILabel alloc] initWithFrame:CGRectMake(10, VIEWFH_Y(markLabel)+2, VIEWFSW(markLabel), 15)];

    [timeLable setFont:[UIFont systemFontOfSize:size]];
    [timeLable setText:[NSString stringWithFormat:@"使用时间:%@-%@",[LXHTimer changeTime:[orignData objectForKey:@"create_time"] byFormat:@"yyyy.MM.dd"],[LXHTimer changeTime:[orignData objectForKey:@"overdue_time"] byFormat:@"yyyy.MM.dd"]]];
    [timeLable setTextColor:[UIColor colorWithRed:0.75 green:0.76 blue:0.76 alpha:1]];
    [baseView addSubview:timeLable];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
