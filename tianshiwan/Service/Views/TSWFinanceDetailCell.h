//
//  TSWFinanceDetailCell.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/17.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSWFinanceDetail.h"
@class TSWFinanceDetail;
@protocol TSWFinanceDetailCellDelegate;

@interface TSWFinanceDetailCell : UICollectionViewCell
@property (nonatomic, weak) id<TSWFinanceDetailCellDelegate> delegate;
@property (nonatomic, strong) TSWFinanceDetail *financeDetail;

@end

@protocol TSWFinanceDetailCellDelegate <NSObject>

-(void) gotoPhone:(TSWFinanceDetailCell *)cell withFinanceDetail:(TSWFinanceDetail *)financeDetail;
-(void) gotoEmail:(TSWFinanceDetailCell *)cell withFinanceDetail:(TSWFinanceDetail *)financeDetail;
-(void) gotoWeixin:(TSWFinanceDetailCell *)cell withFinanceDetail:(TSWFinanceDetail *)financeDetail;
-(void) like:(TSWFinanceDetailCell *)cell withFinanceDetail:(TSWFinanceDetail *)financeDetail;
@end
