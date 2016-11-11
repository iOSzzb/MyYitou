//
//  RecordDetailCtrl.m
//  Yitou
//
//  Created by Xiaohui on 15/8/24.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "RecordDetailCtrl.h"

#define CELLHeight  45

@interface RecordDetailCtrl ()

@end

@implementation RecordDetailCtrl{
    CustomNavigation *customNav;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"明细";
    [self loadAllView];
}

- (void)loadAllView{
    UIView *dateView = [[UIView alloc] initWithFrame:CGRectMake(-1, 75, SCREENWidth+2, CELLHeight)];
    dateView = [self setViewBorder:dateView];
    [dateView addSubview:[self loadLabelWithTitle:@"记录日期"]];
    [dateView addSubview:[self loadLabelWithValue:_records.date]];
    [self.view addSubview:dateView];

    UIView *proName = [[UIView alloc] initWithFrame:CGRectMake(-1, VIEWFH_Y(dateView)-1, SCREENWidth+2, CELLHeight)];
    proName = [self setViewBorder:proName];
    [proName addSubview:[self loadLabelWithTitle:@"项目名称"]];
    [proName addSubview:[self loadLabelWithValue:_records.desc]];
    [self.view addSubview:proName];
    
    UIView *XMType = [[UIView alloc] initWithFrame:CGRectMake(-1, VIEWFH_Y(proName)-1, SCREENWidth+2, CELLHeight)];
    XMType = [self setViewBorder:XMType];
    [XMType addSubview:[self loadLabelWithTitle:@"类型"]];
    [XMType addSubview:[self loadLabelWithValue:_records.types]];
    [self.view addSubview:XMType];

    UIView *moneyType = [[UIView alloc] initWithFrame:CGRectMake(-1, VIEWFH_Y(XMType)-1, SCREENWidth+2, CELLHeight)];
    moneyType = [self setViewBorder:moneyType];
    [moneyType addSubview:[self loadLabelWithTitle:@"支出"]];
    [moneyType addSubview:[self loadLabelWithValue:[NSString stringWithFormat:@"%@%@",_records.unit,_records.money]]];
    [self.view addSubview:moneyType];

    UIView *existMoney = [[UIView alloc] initWithFrame:CGRectMake(-1, VIEWFH_Y(moneyType)-1, SCREENWidth+2, CELLHeight)];
    existMoney = [self setViewBorder:existMoney];
    [existMoney addSubview:[self loadLabelWithTitle:@"可用余额"]];
    [existMoney addSubview:[self loadLabelWithValue:_records.balance]];
    [self.view addSubview:existMoney];

}

- (UILabel *)loadLabelWithTitle:(NSString *)title{
    UILabel *label = [FastFactory loadLabelWith:NSTextAlignmentLeft Frame:CGRectMake(20, 0, 200, CELLHeight) TextColor:[UIColor blackColor] fontSize:16];
    label.text = title;
    return label;
}

- (UILabel *)loadLabelWithValue:(NSString *)value{
    UILabel *label = [FastFactory loadLabelWith:NSTextAlignmentRight Frame:CGRectMake(100, 0, SCREENWidth - 100, CELLHeight) TextColor:[UIColor blackColor] fontSize:16];
    label.text = value;
    return label;
}

- (UIView *)setViewBorder:(UIView *)view{
    [view setBackgroundColor:[UIColor whiteColor]];
    [view.layer setMasksToBounds:YES];
    [view.layer setBorderWidth:1.0];
    [view.layer setBorderColor:[COLORWithRGB(227, 227, 227, 1) CGColor]];
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
