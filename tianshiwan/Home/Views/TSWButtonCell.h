//
//  TSWButtonCell.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/8.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSWButtonInfo;

@protocol TSWButtonCellDelegate;

@interface TSWButtonCell : UICollectionViewCell

@property (nonatomic, weak) id <TSWButtonCellDelegate> delegate;

@property (nonatomic, strong) TSWButtonInfo *buttonInfo;

+ (CGSize)calculateCellSizeWithCategoryChild:(NSNumber *)categoryChild containerWidth:(CGFloat)containerWidth;

@end


@protocol TSWButtonCellDelegate <NSObject>

- (void)buttonCell:(TSWButtonCell *)cell buttonInfo:(TSWButtonInfo *)buttonInfo;

@end
