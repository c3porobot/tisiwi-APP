//
//  TSWFeedbackCell.h
//  tianshiwan
//
//  Created by 刘鸿博 on 16/3/22.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSWfeedBack.h"
@interface TSWFeedbackCell : UICollectionViewCell

@property (nonatomic, strong) TSWfeedBack *feedback;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end
