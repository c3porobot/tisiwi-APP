//
//  TSWNewMessageCell.m
//  tianshiwan
//
//  Created by 刘鸿博 on 16/3/21.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "TSWNewMessageCell.h"

@implementation TSWNewMessageCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.systemLabel];
        [self.contentView addSubview:self.timeLabel];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, [UIScreen mainScreen].bounds.size.width - 30, 30)];
    }
    return _titleLabel;
}

- (UILabel *)systemLabel {
    if (!_systemLabel) {
        self.systemLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 250, CGRectGetMaxY(self.titleLabel.frame) + 5, 50, 30)];
        self.systemLabel.text = @"系统";
    }
    return _systemLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.systemLabel.frame), CGRectGetMinY(self.systemLabel.frame), 200, 30)];
    }
    return _timeLabel;
}

//- (void)setMessage:(TSWMessage *)message
//{
//    _message = message;
//    _titleLabel.text = _message.title;
//    _timeLabel.text = _message.create_at;
//    
//}

- (void)setMessage:(TSWMessage *)message {
    _message = message;
        _titleLabel.text = _message.title;
        _timeLabel.text = _message.created_at;

}
@end
