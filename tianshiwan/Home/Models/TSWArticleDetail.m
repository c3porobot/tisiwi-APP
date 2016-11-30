//
//  TSWArticleDetail.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/11.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWArticleDetail.h"

@implementation TSWArticleDetail
- (id)initWithSid:(NSString *)sid
            title:(NSString *)title
        imgUrl_2x:(NSString *)imgUrl_2x
        imgUrl_3x:(NSString *)imgUrl_3x
            label:(NSString *)label
           author:(NSString *)author
           rating:(NSString *)rating
             time:(NSString *)time
             type:(NSInteger)type
          content:(NSString *)content {
    self = [super init];
    if (self) {
        self.sid = sid;
        self.title = title;
        self.imgUrl_2x = imgUrl_2x;
        self.imgUrl_3x = imgUrl_3x;
        self.label = label;
        self.author = author;
        self.rating = rating;
        self.time = time;
        self.type = type;
        self.content = content;
    }
    return self;
}
@end
