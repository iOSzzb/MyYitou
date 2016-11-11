//
//  AboutUs.m
//  Yitou
//
//  Created by mac on 15/11/27.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import "AboutUs.h"

#import "AboutDesc.h"

#define CELLHeight  45

@interface AboutUs ()

@end

@implementation AboutUs{
    NSInteger orignY;
    NSInteger btnIndx;
    CustomNavigation *customNav;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    [self.view setBackgroundColor:BG_BLUEColor];
    [self loadAllView];
}

- (void)loadAllView{
    orignY = 74;
    btnIndx = 0;
    [self loadCellWithIconName:@"icon_about_yitou" title:@"平台介绍"];
    [self loadCellWithIconName:@"icon_about_team" title:@"团队介绍"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadCellWithIconName:(NSString *)imgName title:(NSString *)title{
    UIButton *cellView = [[UIButton alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, CELLHeight)];
    [cellView setBackgroundColor:[UIColor whiteColor]];

    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(15, (CELLHeight -30)/2, 30, 30)];
    [imgv setImage:IMAGENAMED(imgName)];
    [cellView addSubview:imgv];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(VIEWFW_X(imgv)+5, 0, 200, CELLHeight)];
    label.text = title;
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setTextColor:[UIColor blackColor]];
    [cellView addSubview:label];

    UIImageView *iconRt = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWidth-25, (CELLHeight-15)/2, 8, 15)];
    [iconRt setImage:IMAGENAMED(@"towerRight")];
    [cellView addSubview:iconRt];
    [self.view addSubview:cellView];

    orignY = VIEWFH_Y(cellView)+10;
    [cellView setTag:btnIndx];
    btnIndx ++;

    UIImage *img = [FastFactory convertViewToImage:cellView color:[UIColor colorWithRed:1 green:0.99 blue:0.92 alpha:1]];
    [cellView setBackgroundImage:img forState:UIControlStateHighlighted];
    [cellView addTarget:self action:@selector(clickCell:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickCell:(id)sender{
    AboutDesc *about = [[AboutDesc alloc] init];
    if ([sender tag] == 0)
        about.showTeam = NO;
    else
        about.showTeam = YES;
    [self.navigationController pushViewController:about animated:YES];
}

@end
