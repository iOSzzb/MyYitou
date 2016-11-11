//
//  LXHAdView.m
//  Yitou
//
//  Created by mac on 15/11/23.
//  Copyright © 2015年 Zhuofutong. All rights reserved.
//

#import "LXHAdView.h"
#import "AdModel.h"

#import <UIImageView+WebCache.h>
#import <AFNetworking.h>

@implementation LXHAdView{
    UIScrollView *scrollview;
    NSInteger pageIndx;
    AdClickBlock blocks;
    UIPageControl *pageCtrl;
    UIImageView *bgImageView;
}

- (void)loadAdView:(AdClickBlock)block{
    pageIndx = 0;
    [self loadScrollView];
    [self loadImageView];
    blocks = block;
    [self loadPageController];
}

- (void)loadPageController{
    pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20)];
    [pageCtrl setNumberOfPages:[_dataSource count]];
    [pageCtrl setCurrentPage:0];
    [self addSubview:pageCtrl];
}

- (void)loadImageView{
    if (_dataSource.count == 0 || _dataSource == nil){
        return;
    }
    int indx = 0;
    for (AdModel *adModel in _dataSource){
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(indx*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        dispatch_async(dispatch_get_main_queue(), ^{
            _defaultImage = _defaultImage == nil ?[UIImage imageNamed:@"image_loading"]:_defaultImage;
            [imgv setImage:_defaultImage];
        });
        if (adModel.imgStatus != 3||CHECKFileExist(adModel.adImgPath)){
            [self downloadImageFrom:adModel forImgv:imgv];
        }
        else{
            [self loadImageFor:imgv model:adModel];
        }
        indx ++;
        dispatch_async(dispatch_get_main_queue(), ^{
            [scrollview addSubview:imgv];
        });
    }
}

- (void)loadScrollView{
    [scrollview removeFromSuperview];
    scrollview = nil;
    scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, VIEWFSW(self), VIEWFSH(self))];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addSubview:scrollview];
    });
    [scrollview setContentSize:CGSizeMake(_dataSource.count*self.frame.size.width, self.frame.size.height)];
    [scrollview setPagingEnabled:YES];
    [scrollview setDelegate:self];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickWebView)];
    [scrollview addGestureRecognizer:tapGesture];
    scrollview.showsHorizontalScrollIndicator = NO;
}

- (void)clickWebView{
    blocks(pageIndx);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    pageIndx = scrollView.contentOffset.x/VIEWFSW(self);
    [pageCtrl setCurrentPage:pageIndx];
}

- (void)loadImageFor:(UIImageView *)imgv model:(AdModel *)adModel{
    UIImage *image;
    image = [[UIImage alloc] initWithContentsOfFile:adModel.adImgPath];
    if (image == nil)
        return;
    if (self.showThum)
        image = [[UIImage alloc] initWithData:UIImageJPEGRepresentation(image, 0.3)];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (CHECKFileExist(adModel.adImgPath))
            [imgv setImage:image];
        [pageCtrl removeFromSuperview];
        [self addSubview:pageCtrl];
    });
}

- (void)downloadImageFrom:(AdModel *)adModel forImgv:(UIImageView *)imgv{
    if (adModel.imgStatus == 2||adModel.imgStatus == 3){
        NSLOG(@"图片正在下载或已下载");
        [self loadImageFor:imgv model:adModel];
        return;
    }
    NSLOG(@"开始下载");
    adModel.imgStatus = 2;
    [HttpManager hmDownloadImageWithUrl:adModel.adImgUrl block:^(RequestResult rqCode, NSString *describle) {
        if (rqCode == rqSuccess){
            adModel.imgStatus = 3;
        }else{
            adModel.imgStatus = 0;
        }
        [self downloadImageFrom:adModel forImgv:imgv];
    }];
}

@end
