//
//  TSWMineTableViewCell.m
//  tianshiwan
//
//  Created by 刘鸿博 on 16/1/24.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "TSWMineTableViewCell.h"
#define kMarginLeft_avatar 15 //头像左边距
#define kMarginTop_avatar 15 //头像上边距
#define kWidth_avatar 60 //头像宽高
#define kInterSpace 10 //间隔
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
    }
    return self;
}
//懒加载
- (UIImageView *)avatarView {
    if (!_avatarView) {
        self.avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(kMarginLeft_avatar, kMarginTop_avatar, kWidth_avatar, kWidth_avatar)];
        self.avatarView.layer.masksToBounds = YES;
        self.avatarView.layer.cornerRadius = 30;
        self.avatarView.backgroundColor = [UIColor yellowColor];
    }
    return _avatarView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.avatarView.frame) + kInterSpace, kMarginTop_name, kWidth_label, kHight_label)];
        self.nameLabel.text = @"徐俊";
    }
    return _nameLabel;
}


- (UILabel *)positionLabel {
    if (!_positionLabel) {
        self.positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.nameLabel.frame), CGRectGetMaxY(self.nameLabel.frame) + kInterSpace, kWidth_label, kHight_label)];
        self.positionLabel.text = @"天使湾 技术总监";
    }
    return _positionLabel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
  // Configure the view for the selected state
}

@end
