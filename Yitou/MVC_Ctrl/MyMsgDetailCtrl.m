//
//  MyMsgDetailCtrl.m
//  Yitou
//
//  Created by mac on 16/1/29.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "MyMsgDetailCtrl.h"

@interface MyMsgDetailCtrl ()

@end

@implementation MyMsgDetailCtrl{
    float orignY;
}

@synthesize message;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"公告详情"];
    [self loadAllView];
}

- (void)loadAllView{
    orignY = 74;
    [self loadTitleView];
    [self loadCuttingLine];
    [self loadContentView];

    [message markAsRead];
}

- (void)loadContentView{
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, orignY+6, SCREENWidth, SCREENHeight - orignY - 6)];
    [scrollview setBackgroundColor:[UIColor clearColor]];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, SCREENWidth - 40, 200)];
    [label setNumberOfLines:0];
    [label setFont:[UIFont systemFontOfSize:18]];
    [label setTextColor:[UIColor colorWithRed:0.28 green:0.28 blue:0.29 alpha:1]];
    [label setText:message.msgContent];

    CGSize size = [FastFactory calculatorSizeWithLabel:label];
    [label setFrame:CGRectMake(VIEWFOX(label), VIEWFOY(label), VIEWFSW(label), size.height)];

    [scrollview addSubview:label];
    [scrollview setContentSize:CGSizeMake(SCREENWidth, size.height+30)];
    [self.view addSubview:scrollview];
}

- (void)loadCuttingLine{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, orignY + 24, SCREENWidth, 2)];
    [line setBackgroundColor:[UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1]];
    [self.view addSubview:line];
    orignY = VIEWFH_Y(line);
}

- (void)loadTitleView{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, orignY, SCREENWidth - 40, 50)];
    [titleLabel setNumberOfLines:0];
    [titleLabel setFont:[UIFont systemFontOfSize:18]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setText:message.msgTitle];
    [self.view addSubview:titleLabel];

    CGSize size = [FastFactory calculatorSizeWithLabel:titleLabel];
    [titleLabel setFrame:CGRectMake(VIEWFOX(titleLabel), VIEWFOY(titleLabel), VIEWFSW(titleLabel), size.height+2)];

    orignY = VIEWFH_Y(titleLabel);

    UILabel *sendTime = [[UILabel alloc] initWithFrame:CGRectMake(0, orignY + 8, SCREENWidth, 16)];
    [sendTime setText:[NSString stringWithFormat:@"发布时间:%@",message.msgTime]];
    [sendTime setFont:[UIFont systemFontOfSize:15]];
    [sendTime setTextColor:[UIColor colorWithRed:0.62 green:0.62 blue:0.62 alpha:1]];
    [sendTime setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:sendTime];
    orignY = VIEWFH_Y(sendTime);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
