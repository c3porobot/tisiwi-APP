//
//  TSWMyRequirementsCell.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/23.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSWMyRequirement.h"

@class TSWMyRequirement;
@protocol TSWMyRequirementsCellDelegate;

@interface TSWMyRequirementsCell : UICollectionViewCell
@property (nonatomic, strong) id<TSWMyRequirementsCellDelegate> delegate;
@property (nonatomic, strong) TSWMyRequirement *myRequirement;

@end

@protocol TSWMyRequirementsCellDelegate <NSObject>

-(void) gotoList:(TSWMyRequirementsCell*)cell withRequirement:(TSWMyRequirement*)myRequirement;

@end
