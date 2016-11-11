//
//  RecordCell.m
//  Yitou
//
//  Created by imac on 16/3/15.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "RecordCell.h"

@implementation RecordCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRecord:(Record *)record{
    _record = record;
    
    UILabel *timelab = [self showTitleLabelWithFrame:CGRectMake(0, 0, SCREENWidth/4, VIEWFSH(self)) Title:_record.timeStr];
    [self.contentView addSubview:timelab];
    
    UILabel *monthLab = [self showTitleLabelWithFrame:CGRectMake(SCREENWidth/4, 0, SCREENWidth/4, VIEWFSH(self)) Title:_record.monthStr];
    [self.contentView addSubview:monthLab];
    
    UILabel *typeLab = [self showTitleLabelWithFrame:CGRectMake(SCREENWidth/4*2, 0, SCREENWidth/4, VIEWFSH(self)) Title:_record.typeStr];
    [self.contentView addSubview:typeLab];
    
    UILabel *moneyLab = [self showTitleLabelWithFrame:CGRectMake(SCREENWidth/4*3, 0, SCREENWidth/4, VIEWFSH(self)) Title:_record.moneyStr];
    [self.contentView addSubview:moneyLab];
}

- (UILabel *)showTitleLabelWithFrame:(CGRect)frame Title:(NSString *)title{
    UILabel *lab = [[UILabel alloc] initWithFrame:frame];
    [lab setTextColor:[UIColor blackColor]];
    [lab setText:title];
    [lab setTextAlignment:NSTextAlignmentCenter];
    [lab setFont:FONT_14];
    
    return lab;
}

@end
