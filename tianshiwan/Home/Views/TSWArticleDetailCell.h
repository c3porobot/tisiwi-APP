//
//  TSWArticleDetailCell.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/18.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSWArticleDetail.h"

@interface TSWArticleDetailCell : UICollectionViewCell
@property (nonatomic, strong) TSWArticleDetail *articleDetail;
+ (CGSize)calculateCellSizeWithArticleDetail:(TSWArticleDetail *)articleDetail containerWidth:(CGFloat)containerWidth;
@end
