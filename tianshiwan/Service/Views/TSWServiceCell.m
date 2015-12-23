//
//  TSWServiceCell.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/16.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWServiceCell.h"
#import "CXImageLoader.h"

static const CGFloat iconWidth = 50.0f; // icon宽高

@interface TSWServiceCell()
@property (nonatomic, strong) UIView *serviceView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation TSWServiceCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = CGRectGetWidth(self.bounds);
        CGFloat height = CGRectGetHeight(self.bounds);
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        _serviceView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
        UIImage *image1 = [UIImage imageNamed:@"service_default"];
        _imageView = [[UIImageView alloc]initWithImage:image1];
        _imageView.frame = CGRectMake((width - iconWidth)/2, 0.0f, iconWidth, iconWidth);
        //_imageView.backgroundColor = [UIColor redColor];
        [_serviceView addSubview:_imageView];
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 3.0f+iconWidth, width, 13.0f)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = RGB(136, 136, 136);
        _titleLabel.font = [UIFont systemFontOfSize:13.0f];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter; //中心对其
        _titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _titleLabel.text = @"融资";
        _titleLabel.numberOfLines = 0;
        [_serviceView addSubview:_titleLabel];
        /**
         * 添加手势
         */
        UITapGestureRecognizer *myProjectsTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoServiceList)];
        
        [_serviceView addGestureRecognizer:myProjectsTapGesture];
        
        [self.contentView addSubview:_serviceView];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setService:(TSWService *)service
{
    _service = service;
    if (service.imgUrl_3x) {
        [[CXImageLoader sharedImageLoader] loadImageForURL:[NSURL URLWithString:service.imgUrl_3x] image:^(UIImage *image, NSError *error) {
            _imageView.image = image;
        }];
    }
    _titleLabel.text = _service.title;
    
}

-(void) relayout{
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    if([_service.sort integerValue]%4 == 0){
        _serviceView.frame = CGRectMake(15.0f, 0, width-15.0f, height);
        _imageView.frame = CGRectMake((width-15 - iconWidth)/2, 0.0f, iconWidth, iconWidth);
        _titleLabel.frame = CGRectMake(0.0f, 3.0f+iconWidth, width-15.0f, 10.0f);
    }else if([_service.sort integerValue]%4 == 3){
        _serviceView.frame = CGRectMake(0.0f, 0, width-15.0f, height);
        _imageView.frame = CGRectMake((width-15 - iconWidth)/2, 0.0f, iconWidth, iconWidth);
        _titleLabel.frame = CGRectMake(0.0f, 3.0f+iconWidth, width-15.0f, 10.0f);
    
    } else if ([_service.sort integerValue]%4 == 1){
    _serviceView.frame = CGRectMake(10, 0, width-15.0f, height);
    _imageView.frame = CGRectMake((width-15 - iconWidth)/2, 0.0f, iconWidth, iconWidth);
    _titleLabel.frame = CGRectMake(0.0f, 3.0f+iconWidth, width-15.0f, 10.0f);
    } else if ([_service.sort integerValue] % 4 == 2) {
        _serviceView.frame = CGRectMake(5.0f, 0, width-15.0f, height);
        _imageView.frame = CGRectMake((width-15 - iconWidth)/2, 0.0f, iconWidth, iconWidth);
        _titleLabel.frame = CGRectMake(0.0f, 3.0f+iconWidth, width-15.0f, 10.0f);
    }
}

/**
 *  点击每个collectionView的事件
 */

- (void) gotoServiceList{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoServiceList:withService:)]) {
        [self.delegate gotoServiceList:self withService:_service];
    }
}

@end
