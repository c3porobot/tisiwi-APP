//
//  MyRequirementsCollectionViewCell.h
//  tianshiwan
//
//  Created by 刘鸿博 on 16/3/15.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSWMyRequirement.h"

@class TSWMyRequirement;
@protocol TSWMyRequirementsCellDelegate;
@interface MyRequirementsCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) id<TSWMyRequirementsCellDelegate> delegate;
@property (nonatomic, strong) TSWMyRequirement *myRequirement;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *financingLabel;
@end

@protocol TSWMyRequirementsCellDelegate <NSObject>
-(void) gotoList:(MyRequirementsCollectionViewCell *)cell withRequirement:(TSWMyRequirement*)myRequirement;
@end