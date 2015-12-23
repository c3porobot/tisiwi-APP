//
//  ZButton.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/20.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "ZButton.h"

@interface ZButton()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ZButton

- (id)initWithFrame:( CGRect )frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //可根据自己的需要随意调整
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        self.titleLabel.font =[UIFont systemFontOfSize:14.0];
        self.titleLabel.textColor = RGB(235, 235, 235);
        self.imageView.contentMode = UIViewContentModeLeft;
    }
    return self ;
}
//重写父类UIButton的方法
//更具button的rect设定并返回文本label的rect
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleW = contentRect.size.width-34;
    CGFloat titleH = contentRect.size.height;
    CGFloat titleX = 0;
    CGFloat titleY = 0;
    contentRect = (CGRect){{titleX,titleY},{titleW,titleH}};
    return contentRect;
}
//更具button的rect设定并返回UIImageView的rect
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = 44;
    CGFloat imageH = 44;
    CGFloat imageX = contentRect.size.width-44;
    CGFloat imageY = -3;
    contentRect = ( CGRect ){{imageX,imageY},{imageW,imageH}};
    return contentRect;
}

@end
