//
//  TSWContactsCell.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/14.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSWContact.h"
@class TSWContact;
@protocol TSWContactsCellDelegate;

@interface TSWContactsCell : UICollectionViewCell
@property (nonatomic, weak) id <TSWContactsCellDelegate> delegate;
@property (nonatomic, strong) TSWContact *contact;
@property (nonatomic, strong) UIImageView *imageView;
@end

@protocol TSWContactsCellDelegate <NSObject>

- (void)gotoDetail:(TSWContactsCell *)cell withContact:(TSWContact *)contact;

@end
