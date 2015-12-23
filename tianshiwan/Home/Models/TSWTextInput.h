//
//  TSWTextInput.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/8.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSWTextInput : NSObject <UITextInputTraits>

@property (nonatomic, copy) NSString *text;
@property(nonatomic, copy) NSString *placeholder;

@property (nonatomic, assign) UIEdgeInsets capInsets;

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *highlightedImageName;

@end
