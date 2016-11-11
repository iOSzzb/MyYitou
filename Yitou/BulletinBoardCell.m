//
//  BulletinBoardCell.m
//  Yitou
//
//  Created by imac on 16/1/28.
//  Copyright © 2016年 Zhuofutong. All rights reserved.
//

#import "BulletinBoardCell.h"

#define Height_Cell 45

@implementation BulletinBoardCell{
    UIImageView *imageRed;
    UILabel *titleLab;
//    UIImageView *imageNew;
    UILabel *timeLab;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setBulletinInfo:(BulletinModel *)bulletinInfo{
    
    
    imageRed = [[UIImageView alloc] initWithFrame:CGRectMake(10, (Height_Cell-4)/2, 4, 4)];

    if ([bulletinInfo.isState isEqualToString:@"0"]) {
            [imageRed setImage:IMAGENAMED(@"bulletin_Cell1")];
    }
    [self.contentView addSubview:imageRed];
    
    NSString *str = bulletinInfo.timeStr;
    NSString *timeStr = [str substringFromIndex:5];
//    NSString *timeStr = [BulletinInfo objectForKey:@"jointime"];
    CGSize sizeTime = [timeStr sizeWithAttributes:@{NSFontAttributeName:FONT_14}];
    timeLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWidth-sizeTime.width-10, 0, sizeTime.width, Height_Cell)];
    [timeLab setText:timeStr];
    [timeLab setTextColor:[UIColor blackColor]];
    [timeLab setFont:FONT_14];
    [self.contentView addSubview:timeLab];
    
    titleLab = [[UILabel alloc] initWithFrame:CGRectMake(VIEWFW_X(imageRed)+5, 0, SCREENWidth-VIEWFW_X(imageRed)-sizeTime.width-25, Height_Cell)];
    [titleLab setText:bulletinInfo.title];
    [titleLab setTextColor:[UIColor blackColor]];
    [titleLab setTextAlignment:NSTextAlignmentLeft];
    [titleLab setFont:FONT_14];
    [titleLab setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.contentView addSubview:titleLab];
    
//    imageNew = [[UIImageView alloc] initWithFrame:CGRectMake(VIEWFW_X(titleLab)+10, (Height_Cell-11)/2, 20, 11)];
//    if ([[_BulletinInfo objectForKey:@"new"]isEqualToString:@"1"]) {
//        [imageNew setImage:IMAGENAMED(@"bulletin_Cell2")];
//    }
//    [self.contentView addSubview:imageNew];
}

//- (void)ShowImageView:(UIImageView *)imageView Frame:(CGRect)frame Image:(NSString *)image{
//    imageView = [[UIImageView alloc] initWithFrame:frame];
//    if ([[_BulletinInfo objectForKey:@"new"]isEqualToString:@"1"]) {
//        [imageView setImage:IMAGENAMED(image)];
//    }
//    [self.contentView addSubview:imageView];
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
