//
//  UIImage+CXExtensions.m
//
//  Created by 熊财兴 on 15/1/15.
//  Copyright (c) 2015年 熊财兴. All rights reserved.
//

#import "UIImage+CXExtensions.h"

@implementation UIImage (CXExtensions)

+ (UIImage *)cx_imageWithSize:(CGSize)size color:(UIColor *)color
{
    CGFloat scale = [UIScreen mainScreen].scale;
    CGRect rect = CGRectMake(0.0f, 0.0f, scale * size.width, scale * size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)cx_imageWithSize:(CGSize)size color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius
{
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize scaledSize = CGSizeMake(scale * size.width, scale * size.height);
    CGRect rect = CGRectMake(0.0f, 0.0f, scaledSize.width, scaledSize.height);
    UIGraphicsBeginImageContext(scaledSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    UIBezierPath *roundCornerRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius * scale];
    
    CGContextAddPath(context, roundCornerRect.CGPath);
    CGContextFillPath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+(UIImage *)scaleImage:(UIImage *)image toWidth:(int)toWidth toHeight:(int)toHeight{
    int width=0;
    int height=0;
    int x=0;
    int y=0;
    if (image.size.width<toWidth){
        width = toWidth;
        height = image.size.height*(toWidth/image.size.width);
        y = (height - toHeight)/2;
    }else if (image.size.height<toHeight){
        height = toHeight;
        width = image.size.width*(toHeight/image.size.height);
        x = (width - toWidth)/2;
    }else if (image.size.width>toWidth){
        width = toWidth;
        height = image.size.height*(toWidth/image.size.width);
        y = (height - toHeight)/2;
    }else if (image.size.height>toHeight){
        height = toHeight;
        width = image.size.width*(toHeight/image.size.height);
        x = (width - toWidth)/2;
    }else{
        height = toHeight;
        width = toWidth;
    }
    
    CGSize size = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGSize subImageSize = CGSizeMake(toWidth, toHeight);
    CGRect subImageRect = CGRectMake(x, y, toWidth, toHeight);
    CGImageRef imageRef = image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
    UIGraphicsBeginImageContext(subImageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, subImageRect, subImageRef);
    UIImage* subImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();
    return subImage;
}

/**
 *  set a proper position
 *
 *  @param img  be setted
 *  @param size current rect can be used
 *
 *  @return Proper Rect
 */
+ (CGRect)AJ_ArrangeImage:(UIImage *)img FromCurrentSuperViewSize:(CGSize)size
{
    CGFloat imgW = img.size.width;
    CGFloat imgH = img.size.height;

    NSInteger diffW = size.width- imgW;
    NSInteger diffH = size.height - imgH;

    if(diffH > 0 && diffW > 0)
    {
    if(diffH < diffW)
    {
        if(imgH + 5 > size.height)
        {
            NSInteger tmpH = size.height - 10;
            CGFloat originScale = imgW/imgH;
            NSInteger tmpW = tmpH*originScale;
            NSInteger tmpX = (size.width - tmpW)/2;
            return CGRectMake(tmpX, 5, tmpW, tmpH);
        }
        else
        {
            NSInteger tmpX = (size.width - imgW)/2;
            NSInteger tmpY = size.height- 5 - imgH;
            return CGRectMake(tmpX, tmpY, imgW, imgH);
        }
    }
    else
    {
        if(imgW + 10 > size.width)
        {
            NSInteger tmpW = size.width - 10;
            CGFloat originScale = imgW/imgH;
            NSInteger tmpH = tmpW/originScale;
            NSInteger tmpY = size.height - imgH - 5;
            return CGRectMake(5, tmpY, tmpW, tmpH);
        }
        else
        {
             NSInteger tmpX = (size.width - imgW)/2;
             NSInteger tmpY = size.height- 5 - imgH;
            return CGRectMake(tmpX, tmpY, imgW, imgH);
        }
    }
    }
    else
    {
         CGFloat scaleW = size.width/imgW;
        CGFloat scaleH = size.height/imgH;
        CGFloat scaleImg = imgW/imgH;
        
        if(scaleW < scaleH)
        {
            NSInteger tmpW = size.width-10;
            NSInteger tmpH = tmpW/scaleImg;
            NSInteger tmpY = size.height - tmpH - 5;
            return CGRectMake(5, tmpY, tmpW, tmpH);
        }
        else
        {
            NSInteger tmpH = size.height - 10;
            NSInteger tmpW = tmpH*scaleImg;
            NSInteger tmpX = (size.width-tmpW)/2;
            return CGRectMake(tmpX, 5, tmpW, tmpH);
        }
    }
}

@end
