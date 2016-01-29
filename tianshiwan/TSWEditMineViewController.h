//
//  TSWEditMineViewController.h
//  tianshiwan
//
//  Created by 刘鸿博 on 16/1/22.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "CXNavigationBarController.h"


@protocol passImageValueDelegate

- (void)passImageValue:(UIImage *)value;

@end

@interface TSWEditMineViewController : CXNavigationBarController
@property (nonatomic, assign) id<passImageValueDelegate>delegate;
@end
