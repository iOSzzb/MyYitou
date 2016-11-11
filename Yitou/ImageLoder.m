//
//  ImageLoder.m
//  ZJYG
//
//  Created by mac on 16/1/5.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#define IMAGEFOLDER  [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Image"]

/**
 *  检查路径为pathStr的文件是否存在
 *
 *  @param pathStr 文件路径
 */
#define CHECKFile(pathStr) [[NSFileManager defaultManager] fileExistsAtPath:pathStr]

#import "ImageLoder.h"
#import <UIImageView+AFNetworking.h>

@implementation ImageLoder

+ (void)loadImageWithUrl:(NSString *)urlStr view:(UIImageView *)imgv{
    if (![urlStr hasSuffix:@"jpg"]&&![urlStr hasSuffix:@"png"]){
        [imgv setImage:IMAGENAMED(@"iconDefultHead")];
        NSLOG(@"load image fail with error url:%@",urlStr);
        return;
    }
    NSString *imgLocalPath = [IMAGEFOLDER stringByAppendingPathComponent:[urlStr lastPathComponent]];
    if (CHECKFile(imgLocalPath)){
        [imgv setImage:[UIImage imageWithContentsOfFile:imgLocalPath]];
        return;
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    UIImageView *temp = imgv;
    [imgv setImageWithURLRequest:[NSURLRequest requestWithURL:url] placeholderImage:IMAGENAMED(@"iconDefultHead") success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {

        [temp setImage:image];
        [UIImagePNGRepresentation(image) writeToFile:imgLocalPath atomically:YES];
        NSLOG(@"图片下载并保存成功");
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        NSLOG(@"download image fail \n\n  url:%@ \n\n error:%@",urlStr,error);
    }];
}

@end
