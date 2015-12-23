//
//  TSWTalentDetailCell.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/16.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSWTalentDetailCell.h"

@class TSWTalentDetail;
@protocol TSWTalentDetailCellDelegate;

@interface TSWTalentDetailCell : UICollectionViewCell

@property (nonatomic, strong) id <TSWTalentDetailCellDelegate> delegate;
@property (nonatomic, strong) TSWTalentDetail *talentDetail;

@end

@protocol TSWTalentDetailCellDelegate <NSObject>

- (void) gotoPhone:(TSWTalentDetailCell *) cell withTalentDetail:(TSWTalentDetail *)talentDetaill;

- (void) gotoEmail:(TSWTalentDetailCell *) cell withTalentDetail:(TSWTalentDetail *)talentDetaill;

@end
