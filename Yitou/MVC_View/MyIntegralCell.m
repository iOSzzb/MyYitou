//
//  MyIntegralCell.m
//  Yitou
//
//  Created by mac on 15/11/24.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import "MyIntegralCell.h"

@implementation MyIntegralCell{
    UILabel *typeLB;
    UILabel *detailLB;
    UILabel *timeLB;
}

- (void)setCellWithDataSource:(NSDictionary *)dataSource{
    [typeLB removeFromSuperview];
    [detailLB removeFromSuperview];
    [timeLB removeFromSuperview];

    typeLB = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREENWidth/2-60, VIEWFSH(self))];
    [typeLB setTextAlignment:NSTextAlignmentLeft];
    NSLog(@"%@",[dataSource objectForKey:@"credit_type"]);
    [self loadLabel:typeLB withText:[dataSource objectForKey:@"credit_type"]];

    detailLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, VIEWFSH(self))];
    [detailLB setTextAlignment:NSTextAlignmentCenter];
    [self loadLabel:detailLB withText:[dataSource objectForKey:@"credit_change_point"]];

    timeLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth-20, VIEWFSH(self))];
    [timeLB setTextAlignment:NSTextAlignmentRight];
    [self loadLabel:timeLB withText:[dataSource objectForKey:@"credit_time"]];
}

- (void)loadLabel:(UILabel *)lb withText:(NSString *)value{
    [lb setText:value];
    [lb setTextColor:[UIColor grayColor]];
    [lb setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:lb];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)awakeFromNib {

}

@end
