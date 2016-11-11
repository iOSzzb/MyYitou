//
//  AdModel.m
//  Yitou
//
//  Created by Xiaohui on 15/8/3.
//  Copyright (c) 2015年 Xiaohui Li. All rights reserved.
//

#import "AdModel.h"

@implementation AdModel

@synthesize adUrl;
@synthesize adTitle;
@synthesize adImgPath;
@synthesize imgStatus;
@synthesize adImgUrl;

- (void)setModel:(NSDictionary *)adDict{
    NSString *imgPath = IMAGE_FOLDER;
    adUrl = [adDict objectForKey:@"paths"];
    adTitle = [adDict objectForKey:@"title"];
    adImgUrl = [adDict objectForKey:@"images"];

    imgPath = [imgPath stringByAppendingPathComponent:[adImgUrl lastPathComponent]];
    adImgPath = imgPath;
    imgStatus = 1;
    if (CHECKFileExist(imgPath))
        imgStatus = 3;
}

@end
