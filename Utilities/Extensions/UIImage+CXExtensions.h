//
//  UIImage+CXExtensions.h
//
//  Created by 熊财兴 on 15/1/15.
//  Copyright (c) 2015年 熊财兴. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CXExtensions)

#pragma mark Create Image
+ (UIImage *)cx_imageWithSize:(CGSize)size color:(UIColor *)color;

+ (UIImage *)cx_imageWithSize:(CGSize)size color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

+ (CGRect)AJ_ArrangeImage:(UIImage *)img FromCurrentSuperViewSize:(CGSize)size;

+(UIImage *)scaleImage:(UIImage *)image toWidth:(int)toWidth toHeight:(int)toHeight;

@end
