//
//  TSWTextFieldCellCollectionViewCell.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/8.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSWTextField.h"

@class TSWTextInput;

@protocol TSWTextFieldCellDelegate;

@interface TSWTextFieldCell : UICollectionViewCell

@property (nonatomic, weak) id <TSWTextFieldCellDelegate> delegate;

@property (nonatomic, strong) TSWTextInput *textInput;
@property (nonatomic, strong) TSWTextField *textField;

+ (CGSize)calculateCellSizeWithCategoryChild:(NSNumber *)categoryChild containerWidth:(CGFloat)containerWidth;

@end


@protocol TSWTextFieldCellDelegate <NSObject>

- (void)textFieldCell:(TSWTextFieldCell *)cell textInput:(TSWTextInput *)textInput;

- (void)textFieldCell:(TSWTextFieldCell *)cell textInput:(TSWTextInput *)textInput textField:(UITextField *)textField;

@end
