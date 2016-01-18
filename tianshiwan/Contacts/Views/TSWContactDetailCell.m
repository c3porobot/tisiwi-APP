//
//  TSWContactDetailCell.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/15.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWContactDetailCell.h"

@implementation TSWContactDetailCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        
        
    }
    return self;
}

- (void)layoutSubviews
{
        [super layoutSubviews];
}

- (void)setContactDetail:(TSWContactDetail *)contactDetail{
    _contactDetail = contactDetail;
}

- (void) phone{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoPhone:withContact:)]) {
        [self.delegate gotoPhone:self withContact:_contactDetail];
    }
}

- (void) email{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoEmail:withContact:)]) {
        [self.delegate gotoEmail:self withContact:_contactDetail];
    }
}

- (void) weixin{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoWeixin:withContact:)]) {
        [self.delegate gotoWeixin:self withContact:_contactDetail];
    }
}

@end


