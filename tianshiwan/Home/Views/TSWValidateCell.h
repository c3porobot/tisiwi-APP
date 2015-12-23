//
//  TSWValidateCell.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/10.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TSWValidate;

@protocol TSWValidateCellDelegate;

@interface TSWValidateCell : UICollectionViewCell

@property (nonatomic, weak) id <TSWValidateCellDelegate> delegate;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) TSWValidate *validate;

+ (CGSize)calculateCellSizeWithValidateCode:(TSWValidate *)validateCode containerWidth:(CGFloat)containerWidth;

@end

@protocol TSWValidateCellDelegate <NSObject>

- (void)validateCell:(TSWValidateCell *)cell validate:(TSWValidate *)validate;

- (void)validateCell:(TSWValidateCell *)cell validate:(TSWValidate *)validate textField:(UITextField *)textField;

- (void)sendValidateCell:(TSWValidateCell *)cell;

@end
