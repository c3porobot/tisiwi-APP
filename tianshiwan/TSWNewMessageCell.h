//
//  TSWNewMessageCell.h
//  tianshiwan
//
//  Created by 刘鸿博 on 16/3/21.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSWMessage.h"
@interface TSWNewMessageCell : UICollectionViewCell

@property (nonatomic, strong) TSWMessage *message;
@property (nonatomic, strong) UILabel *titleLabel; //标题
@property (nonatomic, strong) UILabel *systemLabel; //系统
@property (nonatomic, strong) UILabel *timeLabel; //时间列表
@end
