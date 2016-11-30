//
//  TSWCollectionList.h
//  tianshiwan
//
//  Created by 刘鸿博 on 16/3/10.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "CXResource.h"
#define SEND_COLLECTIONLIST @"v1/storeitems/editstore"
#define COLLECTIONLIST @"v1/article/mberid/"
@interface TSWCollectionList : CXResource
@property (nonatomic, copy) NSString *status;
@end
