//
//  TSWArticleList.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/11.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"
#import "TSWArticle.h"

#define ARTICLE_LIST @"v1/article"

@interface TSWArticleList : CXResource

@property (nonatomic, strong) NSMutableArray *articles;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) BOOL isInfinite;

@end
