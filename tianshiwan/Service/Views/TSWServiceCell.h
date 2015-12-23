//
//  TSWServiceCell.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/16.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSWService.h"
@class tswService;
@protocol TSWServiceCellDelegate;

@interface TSWServiceCell : UICollectionViewCell
@property (nonatomic, weak) id<TSWServiceCellDelegate> delegate;
@property (nonatomic, strong) TSWService *service;
-(void) relayout;
@end

@protocol TSWServiceCellDelegate <NSObject>

- (void) gotoServiceList:(TSWServiceCell *)cell withService:(TSWService *)service;

@end
