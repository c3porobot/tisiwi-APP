//
//  TSWMyRootCell.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/10.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSWMyRootCell : UICollectionViewCell

@property (nonatomic, copy) NSDictionary *contentDic;

+ (CGSize)calculateCellSizeWithCategoryChild:(NSNumber *)categoryChild containerWidth:(CGFloat)containerWidth;

@end
