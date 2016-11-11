//
//  BaseController.m
//  Yitou
//
//  Created by mac on 16/1/30.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "BaseController.h"

@interface BaseController ()

@end

@implementation BaseController{
    CustomNavigation *customNav;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.barTintColor = NAVIGATIONColor;

    customNav = [[CustomNavigation alloc] init];
    [customNav customNavigationTitle:self.navigationController];
    __weak typeof(self) weakSelf = self;
    [customNav customNavigation:self.navigationItem block:^(NSInteger indx) {
        [weakSelf viewWillBack];
        [self.navigationController popViewControllerAnimated:YES];
        customNav = nil;
    }];
}

- (void)viewWillBack{

}

- (void)dealloc{
    NSLOG(@"dealloc:%s self.title=%@",object_getClassName(self),self.title);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (customNav != nil)
        return;
    customNav = [[CustomNavigation alloc] init];
    [customNav customNavigationTitle:self.navigationController];
    __weak typeof(self) weakSelf = self;
    [customNav customNavigation:self.navigationItem block:^(NSInteger indx) {
        [weakSelf viewWillBack];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        customNav = nil;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
