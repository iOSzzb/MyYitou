//
//  ImageLoder.h
//  ZJYG
//
//  Created by mac on 16/1/5.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  专门用来加载图片的
 */
@interface ImageLoder : NSObject

/**
 *  通过URL加载图片
 *
 *  @param urlStr 图片的URL
 *  @param imgv   显示图片的UIImageView
 */
+ (void)loadImageWithUrl:(NSString *)urlStr view:(UIImageView *)imgv;

@end
