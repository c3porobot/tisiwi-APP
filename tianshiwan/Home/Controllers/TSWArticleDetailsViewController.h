//
//  TSWArticleDetailsViewController.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/21.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXNavigationBarController.h"

@interface TSWArticleDetailsViewController : CXNavigationBarController
-(instancetype)initWithArticleId:(NSString *)articleId;
-(instancetype)initWithArticleId:(NSString *)articleId withPresent:(BOOL)isPresent;
@end
