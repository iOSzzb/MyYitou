//
//  TextCell.m
//  Yitou
//
//  Created by Xiaohui on 15/8/21.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "TextCell.h"

@implementation TextCell{
    UILabel *cellLabel;
}

- (void)loadCellWithContent:(NSString *)content_{
    [cellLabel removeFromSuperview];
    cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, VIEWFSW(self)-25, VIEWFSH(self))];

    [cellLabel setTextColor:COLORWithRGB(85, 85, 85, 1)];
    [cellLabel setFont:[UIFont fontWithName:SYSTEMFONTName size:12]];
    [cellLabel setTextAlignment:NSTextAlignmentLeft];
    [cellLabel setText:content_];
    [self addSubview:cellLabel];

    [self setBackgroundColor:[UIColor whiteColor]];

    [self.layer setBorderWidth:1.0];
    [self.layer setBorderColor:[[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1] CGColor]];


}

- (void)setText:(NSString *)text{
    cellLabel.text = text;
    _text = text;
}

@end
