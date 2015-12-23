//
//  TSWContactsCell.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/14.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWContactsCell.h"
#import "CXImageLoader.h"
#import "UIImageView+WebCache.h"
@interface TSWContactsCell()
@property (nonatomic, strong) UIButton *contactView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UIView *bottomLineView;
@end

@implementation TSWContactsCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = CGRectGetWidth(self.bounds);
        CGFloat height = CGRectGetHeight(self.bounds);
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.contactView = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, width, height)];
        self.contactView.backgroundColor = [UIColor whiteColor];
        [self.contactView addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15.0f, 5.0f, 40.0f, 40.0f)];
//        self.imageView.image = [UIImage imageNamed:@"foto"];
        self.imageView.backgroundColor = [UIColor whiteColor];
        //self.imageView.backgroundColor = [UIColor yellowColor];
        self.imageView.layer.masksToBounds = YES; //是否裁剪
        self.imageView.layer.cornerRadius = 20; //裁剪半径
        [self.contactView addSubview:self.imageView];
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f+40.0f+5.0f, 10.0f, width-2*15.0f-40.0f, 15.0f)];
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        self.textLabel.textColor = RGB(127, 127, 127);
        self.textLabel.font = [UIFont systemFontOfSize:15.0f];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.text = @"";
        [self.contactView addSubview:self.textLabel];
        
        self.positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0f+40.0f+5.0f, 10.0f+15.0f+5.0f, width-2*15.0f-40.0f, 10.0f)];
        self.positionLabel.textAlignment = NSTextAlignmentLeft;
        self.positionLabel.textColor = RGB(151, 151, 151);
        self.positionLabel.font = [UIFont systemFontOfSize:10.0f];
        self.positionLabel.backgroundColor = [UIColor clearColor];
        self.positionLabel.text = @"";
        [self.contactView addSubview:self.positionLabel];
        
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0.0F, 50-0.5f, width, 0.5f)];
        _bottomLineView.backgroundColor = [UIColor colorWithRed:227/255.0f green:227/255.0f blue:227/255.0f alpha:1.0f];
        [self.contactView addSubview:_bottomLineView];
        [self.contentView addSubview:self.contactView];
    }
    return self;
}

- (void)layoutSubviews
{
}

- (void)setContact:(TSWContact *)contact
{
    _contact = contact;
    if (contact.imgUrl_3x) {
        [[CXImageLoader sharedImageLoader] loadImageForURL:[NSURL URLWithString:contact.imgUrl_3x] image:^(UIImage *image, NSError *error) {
            _imageView.image = image;
        }];
    }
    [_imageView sd_setImageWithURL:[NSURL URLWithString:contact.imgUrl_3x] placeholderImage:[UIImage imageNamed:@"foto"]];
    _textLabel.text = _contact.name;
    _positionLabel.text = [NSString stringWithFormat:@"%@ %@",_contact.title,_contact.company];
    
}

- (void) clickAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoDetail:withContact:)]) {
        [self.delegate gotoDetail:self withContact:_contact];
    }
}

@end

