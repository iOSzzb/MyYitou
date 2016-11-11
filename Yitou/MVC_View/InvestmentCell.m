//
//  TenderCell.m
//  Yitou
//
//  Created by Xiaohui on 15/8/11.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "InvestmentCell.h"

#import "LXHTimer.h"

#define GRAYColor COLORWithRGB(102, 102, 102, 1)
#define REDColor  COLORWithRGB(251,66,36,1)
#define FONTSIZEBig  15
#define FONTSIZESmall 12

@implementation InvestmentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCell{
    [self setBackgroundColor:[UIColor clearColor]];

    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, CELLHeight - 10)];
    [baseView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:baseView];

    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREENWidth/2, 40)];
    titleLabel.text = _tender.title;
    [titleLabel setTextColor:COLORWithRGB(51, 51, 51, 1)];
    [titleLabel setFont:[UIFont fontWithName:SYSTEMFONTName size:16]];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:titleLabel];

    UILabel *titleRight = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWidth/2+10, 0, SCREENWidth/2-20, 40)];
    [titleRight setText:[NSString stringWithFormat:@"投资余额:%@%@",_tender.balance,_tender.balanceUnit]];
    [titleRight setTextAlignment:NSTextAlignmentRight];
    [titleRight setTextColor:COLORWithRGB(121, 121, 121, 1)];
    [titleRight setFont:[UIFont fontWithName:SYSTEMFONTName size:14]];

    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, VIEWFSH(titleLabel), SCREENWidth, 0.4)];
    [line setBackgroundColor:[UIColor grayColor]];
    [self.contentView addSubview:titleRight];
    [self.contentView addSubview:line];
    [self loadEarnLabel:VIEWFH_Y(line)];

    [self loadIcon];
    [self loadRightButton];
    [self loadBelongUser:VIEWFH_Y(line)];
}

- (void)loadBelongUser:(float)orignY{

    UILabel *belongUser = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWidth - 125, orignY+5, 110, 20)];
    belongUser.text = @"";
    if ([_tender checkBelongValid] && [_tender.status integerValue] == 1){
        [belongUser setText:[_tender showBelongName]];
    }else if (STRCMP(@"1",_tender.status)&&[[LXHTimer shareTimerManager] companyTime:_tender.startTime] < 0){
        [belongUser setText:@"投标中"];
    }
    else{
        return;
    }
    [belongUser setTextColor:[UIColor redColor]];
    [belongUser setTextAlignment:NSTextAlignmentCenter];
    [belongUser setFont:[UIFont systemFontOfSize:14]];

    [self.contentView addSubview:belongUser];
}

- (void)loadTimelimit:(UILabel *)baseLB{
    float orignX = SCREENWidth > 320 ? VIEWFW_X(baseLB)+15 : VIEWFW_X(baseLB);
    UILabel *timeLB = [[UILabel alloc] initWithFrame:CGRectMake(orignX, VIEWFOY(baseLB), 60, VIEWFSH(baseLB))];
    NSString *timeStr = [NSString stringWithFormat:@"%@%@",_tender.timeCount,_tender.timeCountUnit];

    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:timeStr];
    int numIndx = (int)[timeStr length] - (int)[_tender.timeCountUnit length];
    [attri addAttribute:NSForegroundColorAttributeName value:REDColor range:NSMakeRange(0, numIndx)];
    [attri addAttribute:NSForegroundColorAttributeName value:GRAYColor range:NSMakeRange(numIndx, [_tender.timeCountUnit length])];
    [attri addAttribute:NSFontAttributeName value:[UIFont fontWithName:SYSTEMFONTName size:FONTSIZEBig] range:NSMakeRange(0, numIndx)];
    [attri addAttribute:NSFontAttributeName value:[UIFont fontWithName:SYSTEMFONTName size:FONTSIZESmall] range:NSMakeRange(numIndx, [_tender.timeCountUnit length])];
    [timeLB setAttributedText:attri];
    [self.contentView addSubview:timeLB];
    [self loadTotalMoneyBaseFrame:timeLB];
}

- (void)loadEarnLabel:(float)orignY{
    orignY += 4;
    UILabel *earnLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, orignY, 114, 20)];

    earnLabel.attributedText = [self loadEarnAttributed];
    [self.contentView addSubview:earnLabel];
    [self loadTimelimit:earnLabel];
}

- (void)loadTotalMoneyBaseFrame:(UILabel *)baseLB{
    float width = SCREENWidth >320 ? 70:50;
    float orignX = SCREENWidth> 320 ?VIEWFW_X(baseLB):VIEWFW_X(baseLB) - 15;
    UILabel *totalLB = [[UILabel alloc] initWithFrame:CGRectMake(orignX, VIEWFOY(baseLB), width, VIEWFSH(baseLB))];
    NSString *timeStr;
    if([_tender.tenderSum length]>=4&&[_tender.tenderSum floatValue]<10)
        timeStr = [NSString stringWithFormat:@"%@%@",[_tender.tenderSum substringToIndex:3] ,_tender.tenderSumUnit];
    else
        timeStr = [NSString stringWithFormat:@"%@%@",_tender.tenderSum,_tender.tenderSumUnit];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:timeStr];
    NSInteger numIndx = [timeStr length] - [_tender.tenderSumUnit length];
    [attri addAttribute:NSForegroundColorAttributeName value:REDColor range:NSMakeRange(0, numIndx)];
    [attri addAttribute:NSForegroundColorAttributeName value:GRAYColor range:NSMakeRange(numIndx, [_tender.tenderSumUnit length])];
    [attri addAttribute:NSFontAttributeName value:[UIFont fontWithName:SYSTEMFONTName size:FONTSIZEBig] range:NSMakeRange(0, numIndx)];
    [attri addAttribute:NSFontAttributeName value:[UIFont fontWithName:SYSTEMFONTName size:FONTSIZESmall] range:NSMakeRange(numIndx, [_tender.tenderSumUnit length])];
    [totalLB setAttributedText:attri];
    [self.contentView addSubview:totalLB];
}

- (NSAttributedString *)loadEarnAttributed{
    NSString *earnStr = _tender.minEarn;
    earnStr = [earnStr stringByAppendingString:@"%"];
    if ([_tender.maxEarn length] >0){
        earnStr = [NSString stringWithFormat:@"%@~%@",earnStr,_tender.maxEarn];
        earnStr = [earnStr stringByAppendingString:@"%"];
    }
    for (int i = 0;i<13;i++){
        if ([earnStr length]<13){
            earnStr = [earnStr stringByAppendingString:@" "];
        }
    }
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc]initWithString:earnStr];
    [attributed addAttribute:NSForegroundColorAttributeName value:REDColor range:NSMakeRange(0, [_tender.minEarn length])];
    [attributed addAttribute:NSFontAttributeName value:[UIFont fontWithName:SYSTEMFONTName size:FONTSIZEBig] range:NSMakeRange(0, [_tender.minEarn length])];
    [attributed addAttribute:NSForegroundColorAttributeName value:GRAYColor range:NSMakeRange([_tender.minEarn length], 1)];
    [attributed addAttribute:NSFontAttributeName value:[UIFont fontWithName:SYSTEMFONTName size:FONTSIZESmall] range:NSMakeRange([_tender.minEarn length], 1)];
    [attributed addAttribute:NSForegroundColorAttributeName value:GRAYColor range:NSMakeRange([_tender.minEarn length], 2)];

    [attributed addAttribute:NSForegroundColorAttributeName value:REDColor range:NSMakeRange([_tender.minEarn length]+2, [_tender.maxEarn length])];
    [attributed addAttribute:NSFontAttributeName value:[UIFont fontWithName:SYSTEMFONTName size:FONTSIZEBig] range:NSMakeRange([_tender.minEarn length]+2, [_tender.maxEarn length])];
    [attributed addAttribute:NSForegroundColorAttributeName value:GRAYColor range:NSMakeRange([_tender.maxEarn length]+2+[_tender.minEarn length], 1)];
    [attributed addAttribute:NSFontAttributeName value:[UIFont fontWithName:SYSTEMFONTName size:FONTSIZESmall] range:NSMakeRange([_tender.maxEarn length]+2+[_tender.minEarn length], 1)];
    [attributed addAttribute:NSForegroundColorAttributeName value:GRAYColor range:NSMakeRange([earnStr length]-1, 1)];
    return attributed;
}

- (void)loadIcon{
    float orignX = 10;
    
    if ([_tender.typeName isEqualToString:@"高息标"]) {
        UIImageView *imgCash = [[UIImageView alloc]initWithFrame:CGRectMake(orignX, CELLHeight - 10 - 24, 13, 13)];
        [imgCash setImage:IMAGENAMED(@"smallicon_Height")];
        [self.contentView addSubview:imgCash];
    }else{
        if (!_tender.isExp){//新手体验去掉“现”字
            UIImageView *imgCash = [[UIImageView alloc]initWithFrame:CGRectMake(orignX, CELLHeight - 10 - 24, 13, 13)];
            [imgCash setImage:IMAGENAMED(@"smallicon_Cash")];
            [self.contentView addSubview:imgCash];
            orignX += 16;
        }
        if (!_tender.isExp){
            if (!([_tender.timeCount isEqualToString:@"1"] && [_tender.timeCountUnit isEqualToString:@" 个月"])) {
                UIImageView *imgCash = [[UIImageView alloc]initWithFrame:CGRectMake(orignX, CELLHeight - 10 - 24, 13, 13)];
                [imgCash setImage:IMAGENAMED(@"smallicon_add")];
                [self.contentView addSubview:imgCash];
                orignX += 16;
            }
        }
        
        if ([_tender checkBelongValid]){
            UIImageView *imgCash = [[UIImageView alloc]initWithFrame:CGRectMake(orignX, CELLHeight - 10 - 24, 13, 13)];
            [imgCash setImage:IMAGENAMED(@"smallicon_belong")];
            [self.contentView addSubview:imgCash];
        }
    
    }
}

- (void)loadRightButton{
    UIView *scheduleView = [[UIView alloc] initWithFrame:CGRectMake(SCREENWidth - 125, CELLHeight - 10-26, 110, 22)];
    [scheduleView setBackgroundColor:COLORWithRGB(42, 138, 225, 1)];
    [scheduleView.layer setMasksToBounds:YES];
    [scheduleView.layer setCornerRadius:VIEWFSH(scheduleView)/2];

    NSString *str = _tender.schedule;
    float sche = [str floatValue];
    str = [NSString stringWithFormat:@"已完成%.2f",sche];
    str = [str stringByAppendingString:@"%"];

    if ([_tender.status integerValue] != 1){
        str = _tender.statusDesc;
        [scheduleView setBackgroundColor:COLORWithRGB(190, 190, 190, 1)];
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, VIEWFSW(scheduleView), VIEWFSH(scheduleView))];
    [label setText:str];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont fontWithName:SYSTEMFONTName size:FONTSIZEBig-3]];
    [scheduleView addSubview:label];

    [self.contentView addSubview:scheduleView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
