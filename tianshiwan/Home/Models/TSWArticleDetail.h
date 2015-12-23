//
//  TSWArticleDetail.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/11.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXResource.h"
#define ARTICLE_DETAIL @"v1/article"
#define RATING  @"v1/article/"
@interface TSWArticleDetail : CXResource

@property (nonatomic,strong) NSString *sid;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *imgUrl_2x;
@property (nonatomic,strong) NSString *imgUrl_3x;
@property (nonatomic,strong) NSString *label;
@property (nonatomic,strong) NSString *author;
@property (nonatomic,strong) NSString *rating;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,assign) NSInteger *type;
@property (nonatomic,strong) NSString *content;

@end
