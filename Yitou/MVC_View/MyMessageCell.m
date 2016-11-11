//
//  MyMessageCell.m
//  Yitou
//
//  Created by mac on 16/1/28.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "MyMessageCell.h"

@implementation MyMessageCell

@synthesize message;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setMessage:(Message *)messages{
    message = messages;
    [self loadMarkView];
    [self loadContentLabel];
}

- (void)loadContentLabel{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(24, 14, SCREENWidth - 20-24, 20)];
    [label setText:message.msgTitle];
    [label setNumberOfLines:1];
    [label setTextColor:[UIColor colorWithRed:0.32 green:0.32 blue:0.33 alpha:1]];
    [label setFont:[UIFont systemFontOfSize:16]];
    [self.contentView addSubview:label];
    CGSize size= [FastFactory calculatorSizeWithLabel:label];
    if (size.height>20){
        [label setFrame:CGRectMake(VIEWFOX(label), VIEWFOY(label), VIEWFSW(label), 40)];
        [label setNumberOfLines:2];
    }

    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEWFOY(label)+50, SCREENWidth - 20, 20)];
    [timeLabel setText:message.msgTime];
    [timeLabel setFont:[UIFont systemFontOfSize:14]];
    [timeLabel setTextAlignment:NSTextAlignmentRight];
    [timeLabel setTextColor:[UIColor colorWithRed:0.64 green:0.65 blue:0.65 alpha:1]];
    [self.contentView addSubview:timeLabel];

    if ([label.text length]<14){
        [label setFrame:CGRectMake(VIEWFOX(label), VIEWFOY(label), VIEWFSW(label), VIEWFSH(label)/2)];
    }
}

- (void)loadMarkView{
    if (message.isRead)
        return;
    UIView *mark = [[UIView alloc] initWithFrame:CGRectMake(11, 17, 8, 8)];
    [mark setBackgroundColor:[UIColor redColor]];
    [mark.layer setMasksToBounds:YES];
    [mark.layer setCornerRadius:VIEWFSH(mark)/2];
    [self.contentView addSubview:mark];
}

@end
