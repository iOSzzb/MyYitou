//
//  ExpDetailCell.m
//  Yitou
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "ExpDetailCell.h"

@implementation ExpDetailCell

@synthesize cell;

- (void)setCell:(NSDictionary *)cells{
    cell = cells;
    if (cells == nil)
        return;
    [self loadLabelWithText:[cell objectForKey:@"invest_user_name"] index:0];
    [self loadLabelWithText:[cell objectForKey:@"invest_money"] index:1];
    [self loadLabelWithText:[cell objectForKey:@"user_interest"] index:2];
    NSString *str = [cell objectForKey:@"invest_time"];
    str = [str substringToIndex:[str length]-3];
    [self loadLabelWithText:str index:3];
}

- (void)loadLabelWithText:(NSString *)value index:(NSInteger)indx{
    float orignX = SCREENWidth/4*indx;
    float width = SCREENWidth/4;
    if (indx == 3){
        orignX -= 20;
        width += 20;
    }
    if (indx ==2)
        width -= 20;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(orignX, 0, width, CELLHeight)];
    [label setText:value];
    [label setTextColor:[UIColor colorWithRed:0.55 green:0.56 blue:0.56 alpha:1]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:14]];
    [self.contentView addSubview:label];
}



@end
