//
//  TSWContactDetailCell.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/15.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSWContactDetail.h"
@class TSWContactDetail;
@protocol TSWContactDetailCellDelegate;

@interface TSWContactDetailCell : UICollectionViewCell
@property (nonatomic, weak) id <TSWContactDetailCellDelegate> delegate;
@property (nonatomic, strong) TSWContactDetail *contactDetail;

@end

@protocol TSWContactDetailCellDelegate <NSObject>

- (void)gotoPhone:(TSWContactDetailCell *)cell withContact:(TSWContactDetail *)contactDetail;
- (void)gotoEmail:(TSWContactDetailCell *)cell withContact:(TSWContactDetail *)contactDetail;
- (void)gotoWeixin:(TSWContactDetailCell *)cell withContact:(TSWContactDetail *)contactDetail;

@end
