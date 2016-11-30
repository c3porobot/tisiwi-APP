//
//  LHBCollectionDB.h
//  tianshiwan
//
//  Created by 刘鸿博 on 16/3/3.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "CXResource.h"
#import "FMDatabase.h"
#import "TSWArticleDetail.h"
@interface LHBCollectionDB : CXResource
@property (nonatomic, strong) FMDatabase *db; //数据库
- (void)deleteDataFromDataBase:(NSInteger)ID;
- (void)insertDataInDataBase:(TSWArticleDetail *)model;
- (NSMutableArray *)selectDataFromDataBase;
@end
