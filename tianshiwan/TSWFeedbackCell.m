//
//  TSWFeedbackCell.m
//  tianshiwan
//
//  Created by 刘鸿博 on 16/3/22.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "TSWFeedbackCell.h"

@implementation TSWFeedbackCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.timeLabel];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, [UIScreen mainScreen].bounds.size.width - 40, 30)];
    }
    return _titleLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * 0.5 - 30, CGRectGetMaxY(self.titleLabel.frame) + 30, 70, 30)];
        self.nameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nameLabel;
}


- (UILabel *)timeLabel {
    if (!_timeLabel) {
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame), CGRectGetMinY(self.nameLabel.frame), [UIScreen mainScreen].bounds.size.width, 30)];
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.timeLabel.font = [UIFont systemFontOfSize:14];

    }
    return _timeLabel;
}

//- (void)setFeedback:(TSWFeedback *)feedback {
//    _feedback = feedback;
//    self.titleLabel.text = _feedback.content;
//    self.nameLabel.text = _feedback.author;
//    self.timeLabel.text = _feedback.created_at;
//}
- (void)setFeedback:(TSWfeedBack *)feedback {
        _feedback = feedback;
        self.titleLabel.text = _feedback.content;
        self.nameLabel.text = _feedback.author;
        self.timeLabel.text = _feedback.created_at;
}
@end
