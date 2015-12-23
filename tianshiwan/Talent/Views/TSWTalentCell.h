//
//  TSWTalentCell.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/16.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSWTalent.h"

@class TSWTalent;
@protocol TSWTalentCellDelegate;

@interface TSWTalentCell : UICollectionViewCell

@property (nonatomic, weak) id <TSWTalentCellDelegate> delegate;
@property (nonatomic, strong) TSWTalent *talent;

@end

@protocol TSWTalentCellDelegate <NSObject>
- (void) gotoTalentDetail:(TSWTalentCell *)cell withTalent:(TSWTalent *)talent;
- (void) email:(TSWTalent *)talent;
@end