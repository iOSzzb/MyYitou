//
//  AboutDesc.m
//  Yitou
//
//  Created by mac on 15/11/27.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import "AboutDesc.h"

@interface AboutDesc ()

@end

@implementation AboutDesc{
    CustomNavigation *customNav;
    UIScrollView *scrollview;
    UIImageView *baseImgv;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"平台介绍";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self loadAllView];
}

- (void)loadAllView{
    scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
    scrollview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollview];
    if (_showTeam){
        [self loadTeamDescrible];
    }
    else
        [self loadYitouDescrible];
}

- (void)loadTeamDescrible{
    self.title = @"团队介绍";
    NSInteger imgvH = 1443*SCREENWidth/414;
    baseImgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, imgvH)];
    UIImage *img = IMAGENAMED(@"about_yitouTeam");
    [baseImgv setImage:img];
    [scrollview addSubview:baseImgv];
    [scrollview setContentSize:CGSizeMake(SCREENWidth, VIEWFH_Y(baseImgv))];
}

- (void)loadYitouDescrible{
    self.title = @"平台介绍";
    NSInteger imgvH = 1415*SCREENWidth/414;
    baseImgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, imgvH)];
    UIImage *img = IMAGENAMED(@"about_yitouDesc");
    [baseImgv setImage:img];
    [scrollview addSubview:baseImgv];
    [scrollview setContentSize:CGSizeMake(SCREENWidth, VIEWFH_Y(baseImgv))];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
