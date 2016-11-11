//
//  MyInvestCell.m
//  Yitou
//
//  Created by Xiaohui on 15/11/19.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import "MyInvestCell.h"

@implementation MyInvestCell{
    NSDictionary *orignData;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setLabel:(UILabel *)label text:(NSString *)text{
    [label setTextColor:[UIColor grayColor]];
    [label setText:text];
    [label setFont:[UIFont systemFontOfSize:12]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:label];
}

- (NSString *)getTime{
    NSString *timeStr = [orignData objectForKey:@"income_overdue_time"];
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    return [[timeStr componentsSeparatedByString:@" "] objectAtIndex:0];
}

- (void)loadLabel{
    UILabel *nameLB =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth*0.3, CELLHeight)];
    [self setLabel:nameLB text:[orignData objectForKey:@"borrow_title"]];

    UILabel *timeLB =[[UILabel alloc] initWithFrame:CGRectMake(SCREENWidth*0.3, 0, SCREENWidth*0.2, CELLHeight)];
    [self setLabel:timeLB text:[self getTime]];

    UILabel *moneyLB = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWidth/2, 0, SCREENWidth/4, CELLHeight)];
    if (_showReal)
        [self setLabel:moneyLB text:[orignData objectForKey:@"income_real_interest"]];
    else{
        [self setLabel:moneyLB text:[orignData objectForKey:@"income_revenue"]];
    }

    UILabel *detailLB = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWidth*0.75, 0, SCREENWidth/4, CELLHeight)];
    [self setLabel:detailLB text:@"查看"];
    [detailLB setTextColor:[UIColor blueColor]];
}

- (void)setCell:(NSDictionary *)dataSource{
    orignData = dataSource;
    [self loadLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
