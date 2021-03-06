//
//  TSWFinanceCell.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/17.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSWFinance.h"
#import "TSWResult.h"
@class TSWFinance;
@protocol TSWFinanceCellDelegate;

@interface TSWFinanceCell : UICollectionViewCell
@property (nonatomic, weak) id<TSWFinanceCellDelegate> delegate;
@property (nonatomic, strong) TSWFinance *finance;
@property (nonatomic, strong) TSWResult *result;
@end

@protocol TSWFinanceCellDelegate <NSObject>

-(void) gotoFinanceDetail:(TSWFinanceCell *)cell withFinance:(TSWFinance *)finance withResult:(TSWResult *)result;

@end
