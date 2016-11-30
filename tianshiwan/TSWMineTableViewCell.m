//
//  TSWMineTableViewCell.m
//  tianshiwan
//
//  Created by 刘鸿博 on 16/1/24.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "TSWMineTableViewCell.h"
#define kMarginLeft_avatar 20 //头像左边距
#define kMarginTop_avatar 15 //头像上边距
#define kWidth_avatar 60 //头像宽高
#define kInterSpace 30 //间隔
#define kWidth_label ([UIScreen mainScreen].bounds.size.width)
#define kHight_label 20
#define kMarginTop_name 20
@implementation TSWMineTableViewCell
//重写初始化方法
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.avatarView];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.positionLabel];
        [self.contentView addSubview:self.enterView];
    }
    return self;
}
//懒加载
- (UIImageView *)avatarView {
    if (!_avatarView) {
        self.avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(kMarginLeft_avatar, kMarginTop_avatar, kWidth_avatar, kWidth_avatar)];
        self.avatarView.layer.masksToBounds = YES;
        self.avatarView.layer.cornerRadius = 30;
        [self.avatarView setImage:[UIImage imageNamed:@"default_face"]];
    }
    return _avatarView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.avatarView.frame) + kInterSpace, kMarginTop_name, kWidth_label, kHight_label)];
        self.nameLabel.text = @"";
    }
    return _nameLabel;
}


- (UILabel *)positionLabel {
    if (!_positionLabel) {
        self.positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame) + 10, kWidth_label - CGRectGetWidth(self.avatarView.frame) - CGRectGetWidth(self.enterView.frame) - 70, kHight_label)];
        self.positionLabel.font = [UIFont systemFontOfSize:15];
        self.positionLabel.text = @"";
    }
    return _positionLabel;
}

- (UIImageView *)enterView {
    if (!_enterView ) {
        self.enterView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth_label - 0.12* kWidth_label, CGRectGetHeight(self.contentView.frame) - 15, 30, 30)];
        self.enterView.image = [UIImage imageNamed:@"right_arrow_n"];
    }
    return _enterView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
  // Configure the view for the selected state
}

@end
