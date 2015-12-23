//
//  TSWOtherCell.h
//  tianshiwan
//
//  Created by zhouhai on 15/10/1.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSWOther.h"

@class TSWOther;
@protocol TSWOtherCellDelegate;

@interface TSWOtherCell : UICollectionViewCell
@property (nonatomic, weak) id<TSWOtherCellDelegate> delegate;
@property (nonatomic, strong) TSWOther *other;

@end

@protocol TSWOtherCellDelegate <NSObject>

-(void) gotoOtherDetail:(TSWOtherCell *)cell withOther:(TSWOther *)other;

@end