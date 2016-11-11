//
//  InvestRecordCell.m
//  Yitou
//
//  Created by Xiaohui on 15/11/2.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import "InvestRecordCell.h"
#import "LXHTimer.h"

#define TEXTSize  SCREENWidth>321?14:12

@implementation InvestRecordCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCell:(NSDictionary *)dataSource{
    [self loadData:dataSource];
}

- (void)loadData:(NSDictionary *)dict{
    float imgH = CELLHeight - 16;
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, imgH, imgH)];
    [self.contentView addSubview:imgv];

    UILabel *lbUsrNmae = [FastFactory loadLabelWith:NSTextAlignmentCenter Frame:CGRectMake(VIEWFW_X(imgv)+4, 0, SCREENWidth/5-10, CELLHeight) TextColor:[UIColor grayColor] fontSize:TEXTSize];
    [self.contentView addSubview:lbUsrNmae];

    UILabel *lbTime = [FastFactory loadLabelWith:NSTextAlignmentCenter Frame:CGRectMake(SCREENWidth/5+30, 0, SCREENWidth/5-20, CELLHeight) TextColor:[UIColor grayColor] fontSize:TEXTSize];
    [self.contentView addSubview:lbTime];

    UILabel *lbLilv = [FastFactory loadLabelWith:NSTextAlignmentCenter Frame:CGRectMake(SCREENWidth/5*2+10, 0, SCREENWidth/5- 10, CELLHeight) TextColor:[UIColor grayColor] fontSize:TEXTSize];
    [self.contentView addSubview:lbLilv];

    UILabel *lbMoney = [FastFactory loadLabelWith:NSTextAlignmentCenter Frame:CGRectMake(SCREENWidth/5*3, 0, SCREENWidth/5+20, CELLHeight) TextColor:[UIColor grayColor] fontSize:TEXTSize];
    [self.contentView addSubview:lbMoney];

    UILabel *lbEarn = [FastFactory loadLabelWith:NSTextAlignmentCenter Frame:CGRectMake(SCREENWidth/5*4, 0, SCREENWidth/5, CELLHeight) TextColor:[UIColor grayColor] fontSize:TEXTSize];
    [self.contentView addSubview:lbEarn];

    lbTime.text = [LXHTimer changeTime:[dict objectForKey:@"invest_time"] byFormat:@"M/d"];
    lbUsrNmae.text = [dict objectForKey:@"invest_user_name"];
    lbEarn.text = [dict objectForKey:@"user_interest"];
    lbMoney.text = [dict objectForKey:@"invest_money"];
    lbLilv.text = [[dict objectForKey:@"borrow_lilv"] stringByAppendingString:@"%"];
    NSArray *ary = [dict objectForKey:@"prize_img"];
    if ([ary count]>0&&[[ary objectAtIndex:0] length]>1){
        NSString *imgName = [ary objectAtIndex:0];
        if ([imgName isEqualToString:@"tou"]||[imgName isEqualToString:@"chui"]) {
            [imgv setImage:[UIImage imageNamed:imgName]];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
