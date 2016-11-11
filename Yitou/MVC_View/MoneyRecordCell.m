//
//  MoneyRecordCell.m
//  Yitou
//
//  Created by Xiaohui on 15/8/24.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "MoneyRecordCell.h"

@implementation MoneyRecordCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCell{
    UILabel *dateLB = [FastFactory loadLabelWith:NSTextAlignmentCenter Frame:CGRectMake(0, 0, SCREENWidth/4, VIEWFSH(self)) TextColor:COLORWithRGB(85, 85, 85, 1) fontSize:12];
    dateLB.text = [[_moneyRecord.date componentsSeparatedByString:@" "] objectAtIndex:0];
    [self.contentView addSubview:dateLB];

    float orignX = STRCMP(@"+", _moneyRecord.unit)?SCREENWidth/4:SCREENWidth/2;
    CGRect frame = CGRectMake(orignX, 0, SCREENWidth/4, VIEWFSH(dateLB));

    UILabel *changeMoney = [FastFactory loadLabelWith:NSTextAlignmentCenter Frame:frame TextColor:dateLB.textColor fontSize:12];
    changeMoney.text = [NSString stringWithFormat:@"%@%@",_moneyRecord.unit,_moneyRecord.money];
    [self.contentView addSubview:changeMoney];

    UILabel *typeLB = [FastFactory loadLabelWith:NSTextAlignmentCenter Frame:CGRectMake(SCREENWidth*3/4, 0, SCREENWidth/4, VIEWFSH(dateLB)) TextColor:[UIColor colorWithRed:0.16 green:0.55 blue:0.88 alpha:1] fontSize:12];
    typeLB.text = @"查看";
    [self.contentView addSubview:typeLB];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
