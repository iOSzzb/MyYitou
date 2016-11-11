//
//  ActivityCenterCell.m
//  Yitou
//
//  Created by imac on 16/1/29.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "ActivityCenterCell.h"
#import <UIImageView+AFNetworking.h>

@implementation ActivityCenterCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setDicInfo:(NSDictionary *)dicInfo{
    NSString *title = [dicInfo objectForKey:@"title"];
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:FONT_14}];
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(RELATIVE_X(10), 0, titleSize.width, 25)];
    [titleLab setText:title];
    [titleLab setTextColor:[UIColor blackColor]];
    [titleLab setFont:FONT_14];
    [self.contentView addSubview:titleLab];
    
    NSString *startTime = [dicInfo objectForKey:@"starttime"];
    NSString *endTime = [dicInfo objectForKey:@"endtime"];
    if ([endTime isEqualToString:@""]) {
        endTime = @"长期有效";
    }
    NSString *timeStr = [NSString stringWithFormat:@"%@-%@",startTime,endTime];
    CGSize timeSize = [timeStr sizeWithAttributes:@{NSFontAttributeName:FONT_14}];
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWidth-timeSize.width-RELATIVE_X(10), 0, timeSize.width, 25)];
    [timeLab setText:timeStr];
    [timeLab setTextColor:[UIColor blackColor]];
    [timeLab setFont:FONT_14];
    [self.contentView addSubview:timeLab];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(RELATIVE_X(10), VIEWFH_Y(timeLab), SCREENWidth-(RELATIVE_X(10)*2), RELATIVE_X(130))];
    [imageView setImageWithURL:[NSURL URLWithString:[dicInfo objectForKey:@"images"]] placeholderImage:nil];
    [self.contentView addSubview:imageView];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
