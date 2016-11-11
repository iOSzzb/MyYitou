//
//  GuideCtrl.m
//  Yitou
//
//  Created by mac on 15/11/26.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import "GuideCtrl.h"

@interface GuideCtrl ()<UIScrollViewDelegate>

@end

@implementation GuideCtrl{
    GuideBlock blocks;
    UIScrollView *scrollview;
    NSInteger lastPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:NAVIGATIONColor];
    [self loadAllView];
}

- (void)loadAllView{
    [self loadScrollView];
    [self loadImageView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger page = scrollview.contentOffset.x/SCREENWidth;
    if (lastPage == page && page == 3){
        blocks(1);
        return;
    }
    lastPage = page;
}

- (void)loadImageView{
    for (int i = 1; i < 5; i++){
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake((i-1)*SCREENWidth, 0, SCREENWidth, SCREENHeight)];
        NSString *imgName = [NSString stringWithFormat:@"guide_bg_%i",i];
        [imgv setImage:IMAGENAMED(imgName)];
        [scrollview addSubview:imgv];
    }
    [scrollview setContentSize:CGSizeMake(SCREENWidth*4, SCREENHeight)];
    [scrollview setUserInteractionEnabled:YES];
}

- (void)loadScrollView{
    scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
    [scrollview setBackgroundColor:self.view.backgroundColor];
    [scrollview setPagingEnabled:YES];
    [self.view addSubview:scrollview];
    [scrollview setDelegate:self];
    scrollview.showsHorizontalScrollIndicator = NO;
}

- (void)guideCompleteWithBlock:(GuideBlock)block{
    blocks = block;
}

- (void)autoBack{
    blocks(1);
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
