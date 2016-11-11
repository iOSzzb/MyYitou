//
//  ActivityCtrl.m
//  Yitou
//
//  Created by mac on 16/1/29.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "ActivityCtrl.h"

#import "LoginCtrl.h"

#import "RegistFirstStepCtrl.h"

@interface ActivityCtrl ()

@end

@implementation ActivityCtrl{
    CustomNavigation *customNav;
    UIImageView *imageView;
}

@synthesize imgHeight;

- (void)viewDidLoad {
    [super viewDidLoad];
    customNav = [CustomNavigation new];
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"活动"];
    [self loadScrollView];
    [customNav customNavigation:self.navigationItem block:^(NSInteger indx) {
        [self.navigationController popViewControllerAnimated:YES];
        customNav = nil;
    }];
}

- (void)dealloc{
    NSLOG(@"dealloc:%s",object_getClassName(self));
}

- (void)loadScrollView{
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
    [self.view addSubview:_scrollview];

    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_scrollview addSubview:imageView];
}

- (void)setImage:(UIImage *)image{
    [imageView setImage:image];
}

- (void)setImgHeight:(float)imgHeights{
    [imageView setFrame:CGRectMake(0, 0, SCREENWidth, imgHeights)];
}

- (float)imgHeight{
    return imgHeight;
}

- (void)clickLoginButton{
    LoginCtrl *loginCtrl = [[LoginCtrl alloc] init];
    [loginCtrl setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:loginCtrl animated:YES];
}

- (void)clickRegisterButton{
    RegistFirstStepCtrl *regCtrl = [[RegistFirstStepCtrl alloc] init];
    [self.navigationController pushViewController:regCtrl animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
