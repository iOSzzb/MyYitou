//
//  SetAndHelpCell.m
//  Yitou
//
//  Created by mac on 16/1/14.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "SetAndHelpCell.h"

@implementation SetAndHelpCell{
    UIView *cellView;
}

- (void)setDataSource:(NSDictionary *)dataSource{
    [cellView removeFromSuperview];
    cellView = nil;
    _dataSource = dataSource;

    cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, CELLHeight)];
    [cellView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:cellView];

    [self loadImageView];
    [self loadTitle];
    [self loadValue];
}

- (void)loadImageView{
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(15, (CELLHeight -30)/2, 30, 30)];
    [imgv setImage:IMAGENAMED([_dataSource objectForKey:CELL_KEY_ICON])];
    [cellView addSubview:imgv];
}

- (void)loadTitle{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 200, CELLHeight)];
    label.text = [_dataSource objectForKey:CELL_KEY_NAME];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setTextColor:[UIColor blackColor]];
    [cellView addSubview:label];
}

- (void)loadValue{
    NSString *title = [_dataSource objectForKey:CELL_KEY_NAME];
    float width = 50 + [title length]*17;
    if ([title hasSuffix:@")"]){
        width -= 20;
    }
    width += 2;
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(width + 5, 0, (SCREENWidth - width) - 10, VIEWFSH(cellView))];
    [contentLabel setFont:[UIFont systemFontOfSize:14]];
    [contentLabel setText:[_dataSource objectForKey:CELL_KEY_VALUE]];
    [contentLabel setTextColor:[UIColor grayColor]];
    [contentLabel setNumberOfLines:2];
    [cellView addSubview:contentLabel];
}

@end
