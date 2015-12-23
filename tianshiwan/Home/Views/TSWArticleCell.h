//
//  TSWArticleCell.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/11.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSWArticle;
@protocol TSWArticleCellDelegate;

@interface TSWArticleCell : UICollectionViewCell
@property (nonatomic, strong) id<TSWArticleCellDelegate> delegate;
@property (nonatomic, strong) TSWArticle *article;

+ (CGSize)calculateCellSizeWithSummary:(TSWArticle *)article containerWidth:(CGFloat)containerWidth;

@end

@protocol TSWArticleCellDelegate <NSObject>

-(void) gotoArticleDetail:(TSWArticleCell *)cell withArticle:(TSWArticle *)article;

@end
