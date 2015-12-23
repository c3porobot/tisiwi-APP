//
//  TSWTextInput.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/8.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWTextInput.h"

@implementation TSWTextInput

@synthesize autocapitalizationType = _autocapitalizationType;
@synthesize autocorrectionType = _autocorrectionType;
@synthesize spellCheckingType = _spellCheckingType;
@synthesize keyboardType = _keyboardType;
@synthesize keyboardAppearance = _keyboardAppearance;
@synthesize returnKeyType = _returnKeyType;
@synthesize secureTextEntry = _secureTextEntry;

- (BOOL)isSecureTextEntry;
{
    return _secureTextEntry;
}


@end
