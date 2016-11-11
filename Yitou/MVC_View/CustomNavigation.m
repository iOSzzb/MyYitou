//
//  CustomNavigation.m
//  Yitou
//
//  Created by Xiaohui on 15/11/6.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import "CustomNavigation.h"

@implementation CustomNavigation{
    CustomBlock customBlock;
    UINavigationItem *itme;
}

- (void)customNavigationTitle:(UINavigationController *)navi{
    [navi.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont fontWithName:SYSTEMFONTName size:NAV_FONTSize],NSFontAttributeName,nil]];
}

- (void)customNavigation:(UINavigationItem *)navi block:(CustomBlock)block{
    customBlock = block;
    itme = navi;
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 20, 20)];
    [imgv setImage:IMAGENAMED(@"nav_back")];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 80, 40)];
    [btn addSubview:imgv];
    [btn addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchUpInside];

    itme.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn setUserInteractionEnabled:YES];
}

- (void)customNavigationView:(UINavigationItem *)navi title:(NSString *)title block:(CustomBlock)block{
    if (customBlock == nil&&block != nil)
        customBlock = block;
    UIButton *view = [[UIButton alloc] initWithFrame:CGRectMake(100, 0, SCREENWidth - 200, 35)];
    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake((VIEWFSW(view) - [title length]*20)/2, 0, [title length]*20, 35)];
    [label setText:title];
    [view addSubview:label];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [view setBackgroundColor:[UIColor clearColor]];
    [navi setTitleView:view];
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(VIEWFW_X(label), VIEWFOY(label)+6, 20, 20)];
    [imgv setImage:IMAGENAMED(@"towerDown")];
    [view addSubview:imgv];
    [view addTarget:self action:@selector(clickNavigataionTitle) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickNavigataionTitle{
    if (customBlock != nil)
        customBlock(3);
}

- (void)clickBack{
    customBlock(1);
}

@end
