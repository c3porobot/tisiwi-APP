//
//  TSWMineTableViewCell.h
//  tianshiwan
//
//  Created by 刘鸿博 on 16/1/24.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSWMineTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *avatarView; //头像
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *positionLabel;
@property (nonatomic, strong) UIImageView *enterView; //进入下一界面的小箭头
@end
