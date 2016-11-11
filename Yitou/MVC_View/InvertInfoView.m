//
//  InvertInfoView.m
//  Yitou
//
//  Created by Xiaohui on 15/8/25.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "InvertInfoView.h"
#import "InvestRecordCell.h"

#import "LXHTimer.h"

#define TEXTOrignX    20

#define BIGTextSize   16
#define SMALLTextSize   12

#define VIEWHeight    60


@implementation InvertInfoView{
    NSInteger  orignY;
    Tender *tender;
    NSDictionary *dataSource;
    NSTimer *timer;
    UILabel *timeLabel;
}

- (void)removeFromSuperview{
    [super removeFromSuperview];
    [timer invalidate];
}

- (void)loadInfoWithData:(Tender *)tend andDataSource:(NSDictionary *)dict{
    tender = tend;
    dataSource = dict;
    [self setBackgroundColor:[UIColor whiteColor]];
    [self loadTitle:tender.title];
    [self loadTopLineView];
}

- (void)loadTopLineView{
    UIView *topLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth/3, VIEWHeight)];
    NSString *values = tender.minEarn;
    if ([tender.maxEarn length]>0){
        values = [values stringByAppendingString:@"-"];
        values = [values stringByAppendingString:tender.maxEarn];
    }
    [self loadViewWithKey:@"年化收益(%)" andValue:values forView:topLeftView];
    [self addSubview:topLeftView];

    UIView *topNoonView = [[UIView alloc] initWithFrame:CGRectMake(VIEWFW_X(topLeftView)-1, orignY, SCREENWidth/3+1, VIEWHeight)];
    values = tender.tenderSum;
    NSString *keys = [NSString stringWithFormat:@"金额(%@)",tender.tenderSumUnit];
    [self loadViewWithKey:keys andValue:values forView:topNoonView];
    [self addSubview:topNoonView];

    UIView *topRightView = [[UIView alloc] initWithFrame:CGRectMake(VIEWFW_X(topNoonView)-1, orignY, SCREENWidth/3, VIEWHeight)];
    values = tender.timeCount;
    keys = [NSString stringWithFormat:@"时间(%@)",tender.timeCountUnit];
    [self loadViewWithKey:keys andValue:values forView:topRightView];
    [self addSubview:topRightView];
    orignY += VIEWHeight-1;

    UIView *downLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth/3, VIEWHeight)];
    values = tender.balance;
    keys = [NSString stringWithFormat:@"可投金额(%@)",tender.balanceUnit];
    [self loadViewWithKey:keys andValue:values forView:downLeftView];
    [self addSubview:downLeftView];

    UIView *downNoonView = [[UIView alloc] initWithFrame:CGRectMake(VIEWFW_X(downLeftView)-1, orignY, SCREENWidth/3+1, VIEWHeight)];
    values = @"50";
    keys = [NSString stringWithFormat:@"起投金额(元)"];
    [self loadViewWithKey:keys andValue:values forView:downNoonView];
    [self addSubview:downNoonView];

    UIView *downRightView = [[UIView alloc] initWithFrame:CGRectMake(VIEWFW_X(downNoonView)-1, orignY, SCREENWidth/3, VIEWHeight)];
    values = tender.statusDesc;
    keys = [NSString stringWithFormat:@"项目状态"];
    [self loadViewWithKey:keys andValue:values forView:downRightView];
    [self addSubview:downRightView];
    orignY += VIEWHeight+1;
    _contentSize = orignY;
}

- (void)loadCountDownTime:(id)sender{
    if (timeLabel == nil){
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth - 20, 60)];
        [timeLabel setTextColor:[UIColor redColor]];
        [timeLabel setTextAlignment:NSTextAlignmentRight];
        [self addSubview:timeLabel];
    }
    NSInteger second = [[LXHTimer shareTimerManager] companyTime:tender.startTime];
    [timeLabel setText:[[LXHTimer shareTimerManager] calculatorWaitTimeFromSecond:second]];
    if (second <= 0){
        [timeLabel removeFromSuperview];
        [timer invalidate];
    }
}

- (void)loadTitle:(NSString *)title{
    float showCount = 1;
    if ([tender checkBelongValid])
        showCount = 2;

    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 60)];
    UILabel *titleLB = [FastFactory loadLabelWith:NSTextAlignmentLeft Frame:CGRectMake(TEXTOrignX, 0, SCREENWidth-TEXTOrignX, 60/showCount)  TextColor:COLORWithRGB(40, 138, 225, 1) fontSize:BIGTextSize];
    titleLB.text = title;
    [titleView addSubview:titleLB];
    [self addSubview:titleView];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    orignY = VIEWFH_Y(titleView);

    if ([[LXHTimer shareTimerManager] companyTime:tender.startTime] > 0)
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(loadCountDownTime:) userInfo:nil repeats:YES];
    if (showCount==1)
        return;
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(VIEWFOX(titleLB), VIEWFH_Y(titleLB)- 4, VIEWFSW(titleLB), VIEWFSH(titleLB))];
    [titleView addSubview:nameLabel];
    [nameLabel setTextColor:[UIColor redColor]];
    if ([tender checkBelongValid])
        nameLabel.text = [tender showBelongName];
}

- (void)loadViewWithKey:(NSString *)key_ andValue:(NSString *)value_ forView:(UIView *)view{
    [view setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:[self loadTopLabel:key_]];
    [view addSubview:[self loadValueLabel:value_]];
    [view.layer setMasksToBounds:YES];
    [view.layer setBorderWidth:1.0];
    [view.layer setBorderColor:[COLORWithRGB(233, 233, 233, 1) CGColor]];
}

- (UILabel *)loadTopLabel:(NSString *)str{
    UILabel *label = [FastFactory loadLabelWith:NSTextAlignmentLeft Frame:CGRectMake(TEXTOrignX, 0, SCREENWidth/3-TEXTOrignX, VIEWHeight/2) TextColor:COLORWithRGB(153, 153, 153, 1) fontSize:SMALLTextSize];
    label.text = str;
    return label;
}

- (UILabel *)loadValueLabel:(NSString *)str{
    UILabel *label = [FastFactory loadLabelWith:NSTextAlignmentLeft Frame:CGRectMake(TEXTOrignX, VIEWHeight/2, SCREENWidth/3-TEXTOrignX, VIEWHeight/2) TextColor:COLORWithRGB(117, 117, 117, 1) fontSize:BIGTextSize];
    label.text = str;
    if (STRCMP(@"投标中", str)){
        [label setTextColor:[UIColor redColor]];
    }
    return label;
}

@end
