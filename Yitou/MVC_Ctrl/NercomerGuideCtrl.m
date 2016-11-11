//
//  NercomerGuideCtrl.m
//  Yitou
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "NercomerGuideCtrl.h"
#import "LoginCtrl.h"

@interface NercomerGuideCtrl ()

@end

@implementation NercomerGuideCtrl{
    float orignY;
    UIScrollView *scrollview;
    UIButton *nowButton;
    UIImageView *stepImageView;
    CustomNavigation *customNav;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BG_WHITEColor];
    orignY = 0;
    [self loadAllView];
    self.title = @"新手指引";
}

- (void)loadAllView{
    [self loadScrollview];
    [self loadTopImageView];
    [self loadCommonNumberViewWithTitle:@"01"];
    [self loadCommonDescribleWithTitle:@"什么是益投网贷?" text:@"益投网贷提供安全、有抵押、有托管、高收益的互联网理财服务.经过益投网贷推荐的借款信息,您可以将手中的富余资金出借给通过益投网贷严谨的风控审核,且信用良好的优质借款人,并获得利息回报" bgColor:[UIColor colorWithRed:1 green:0.53 blue:0.15 alpha:1]];
    [self loadProcessImage];
    [self loadCommonNumberViewWithTitle:@"02"];
    [self loadCommonTitle:@"我可以投资哪些理财产品?"];
    [self loadCommonDescribleWithTitle:@"楼益贷" text:@"楼益贷是由益投网贷推出的针对个人消费及经营性资金短期转需求的优质借款人，以个人房产作为抵押的融资服务。项目由汇付天下提供资金托管，益投网贷为投资人提供本息保障。" bgColor:[UIColor colorWithRed:0.16 green:0.55 blue:0.88 alpha:1]];
    [self loadCommonDescribleWithTitle:@"生益贷" text:@"生益贷是由益投网贷推出的针对有经营性资金短期周转需求的优质借款人，以个人、企业信用征信为依据的融资服务，只针对信用级别最优的企业或个人，对还款来源严格监管。项目由汇付天下提供资金托管，益投网贷为投资人提供本息保障。" bgColor:[UIColor colorWithRed:0.58 green:0.75 blue:0.27 alpha:1]];
    [self loadCommonDescribleWithTitle:@"车益贷" text:@"车益贷是由益投网贷推出的针对个人消费及经营性资金短期转需求的优质借款人，以个人汽车作为抵押的融资服务。项目由汇付天下提供资金托管，益投网贷为投资人提供本息保障" bgColor:[UIColor colorWithRed:0.98 green:0.7 blue:0.25 alpha:1]];

    [self loadCommonNumberViewWithTitle:@"03"];
    [self loadCommonTitle:@"如何投资?"];

    orignY +=10;
    [self loadCommonButtonWithTitle:@"step1:注册" tag:0];
    [self loadCommonButtonWithTitle:@"step2:实名认证" tag:1];
    orignY += 10;
    [self loadCommonButtonWithTitle:@"step3:充值" tag:2];
    [self loadCommonButtonWithTitle:@"step4:投资" tag:3];
    [self loadCommonImageView];

    [self loadEndButton];
    [self loadEndImageView];

    [scrollview setContentSize:CGSizeMake(SCREENWidth, orignY)];
}

- (void)loadEndButton{
    orignY += 10;
    [self loadCommonTitle:@"聪明的小伙伴"];
    orignY += 10;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWidth/2 - 60, orignY, 120, 40)];
    [button setBackgroundColor:[UIColor colorWithRed:0.9 green:0.3 blue:0.24 alpha:1]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"加入我们吧" forState:UIControlStateNormal];
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:4.0];
    [button addTarget:self action:@selector(clickJoinButton) forControlEvents:UIControlEventTouchUpInside];
    [scrollview addSubview:button];
    orignY = VIEWFH_Y(button);
}

- (void)loadEndImageView{
    orignY += 30;
    UIImage *image = IMAGENAMED(@"guide_end");
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, SCREENWidth*image.size.height/image.size.width)];
    [imgv setImage:image];
    [scrollview addSubview:imgv];
    orignY = VIEWFH_Y(imgv);
}

- (void)loadScrollview{
    scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
    [self.view addSubview:scrollview];
}

-(void)loadTopImageView{
    UIImage *image = IMAGENAMED(@"guide_top");
    UIImageView *topImgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, SCREENWidth*image.size.height/image.size.width)];
    [topImgv setImage:image];
    [scrollview addSubview:topImgv];
    orignY = VIEWFH_Y(topImgv);
}

- (void)loadProcessImage{
    UIImage *image = IMAGENAMED(@"guide_process");
    float imgWidth = SCREENWidth - 40;
    UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(20, orignY, imgWidth, imgWidth)];
    [imgv setImage:image];
    [scrollview addSubview:imgv];
    orignY = VIEWFH_Y(imgv);
}

#pragma mark All Events
- (void)clickStepButton:(id)sender{
    UIColor *btnColor = [UIColor colorWithRed:0.01 green:0.59 blue:0.85 alpha:1];
    [nowButton setBackgroundColor:[UIColor whiteColor]];
    [nowButton setTitleColor:btnColor forState:UIControlStateNormal];

    UIButton *button = sender;
    [button setBackgroundColor:btnColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nowButton = button;

    NSString *imageName = [NSString stringWithFormat:@"guide_step_%tu",[nowButton tag]];
    [stepImageView setImage:IMAGENAMED(imageName)];

}

- (void)clickJoinButton{
    if ([UserModel shareUserManager].isLogin){
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    LoginCtrl *loginCtrl = [[LoginCtrl alloc] init];
    [loginCtrl setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:loginCtrl animated:YES];
}

#pragma mark Common view

- (void)loadCommonImageView{
    orignY += 20;
    UIImage *image = IMAGENAMED(@"guide_step_0");
    stepImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, SCREENWidth*image.size.height/image.size.width)];
    [stepImageView setImage:image];
    [scrollview addSubview:stepImageView];
    orignY = VIEWFH_Y(stepImageView);
}

- (void)loadCommonButtonWithTitle:(NSString *)title tag:(NSInteger)tag{
    UIColor *btnColor = [UIColor colorWithRed:0.01 green:0.59 blue:0.85 alpha:1];
    float orignX = tag%2 == 0?10:(SCREENWidth)/2+10;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(orignX, orignY, (SCREENWidth)/2 - 10, 45)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:btnColor forState:UIControlStateNormal];
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:4.0];
    [button setTag:tag];
    [button.layer setBorderColor:btnColor.CGColor];
    [button.layer setBorderWidth:1.0];
    [button addTarget:self action:@selector(clickStepButton:) forControlEvents:UIControlEventTouchUpInside];

    [scrollview addSubview:button];

    orignY = tag%2 != 0 ? VIEWFH_Y(button) : orignY;
    if (tag == 0){
        nowButton = button;
        [self clickStepButton:nowButton];
    }
}

- (void)loadCommonTitle:(NSString *)title{
    orignY += 10;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, orignY, SCREENWidth, 20)];
    [titleLabel setText:title];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont systemFontOfSize:18]];
    [titleLabel setTextColor:[UIColor colorWithRed:0.28 green:0.29 blue:0.29 alpha:1]];
    [scrollview addSubview:titleLabel];
    orignY = VIEWFH_Y(titleLabel);
}

- (void)loadCommonDescribleWithTitle:(NSString *)title text:(NSString *)text bgColor:(UIColor *)bgColor{
    orignY += 5;
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(10, orignY, SCREENWidth - 20, 120)];
    [baseView setBackgroundColor:bgColor];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, VIEWFSW(baseView), 20)];
    [titleLabel setText:title];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont systemFontOfSize:18]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [baseView addSubview:titleLabel];

    UILabel *txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, VIEWFH_Y(titleLabel)+5, VIEWFSW(baseView)-20, VIEWFSH(baseView) - VIEWFSH(titleLabel)-20)];
    [txtLabel setNumberOfLines:5];
    [txtLabel setTextAlignment:NSTextAlignmentLeft];
    [txtLabel setFont:[UIFont systemFontOfSize:12]];
    [txtLabel setTextColor:[UIColor whiteColor]];
    [txtLabel setText:text];
    [baseView addSubview:txtLabel];
    [scrollview addSubview:baseView];

    [baseView.layer setMasksToBounds:YES];
    [baseView.layer setCornerRadius:4.0];
    orignY = VIEWFH_Y(baseView);

}

-(void)loadCommonNumberViewWithTitle:(NSString *)title{
    orignY += 20;
    UIImage *image = IMAGENAMED(@"guide_numberView");
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREENWidth - image.size.width)/2, orignY, image.size.width, image.size.height)];
    [imageView setImage:image];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [label setText:title];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:22]];
    [label setTextColor:[UIColor whiteColor]];
    [imageView addSubview:label];

    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(20, orignY + image.size.height/2, VIEWFOX(imageView) - 40, 1)];
    [line1 setBackgroundColor:[UIColor grayColor]];
    [scrollview addSubview:line1];

    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(VIEWFW_X(imageView)+20, orignY + image.size.height/2, VIEWFOX(imageView) - 40, 1)];
    [line2 setBackgroundColor:[UIColor grayColor]];
    [scrollview addSubview:line2];

    [scrollview addSubview:imageView];
    orignY = VIEWFH_Y(imageView);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
