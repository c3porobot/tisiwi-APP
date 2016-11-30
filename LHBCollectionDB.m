//
//  LHBCollectionDB.m
//  tianshiwan
//
//  Created by 刘鸿博 on 16/3/3.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "LHBCollectionDB.h"

@implementation LHBCollectionDB
- (instancetype)init {
    self = [super init];
    if (self) {
        [self createDataBase];
        [self createTableInDataBase];
    }
    return self;
}
//创建数据库 -- 数据库中存放表
- (void)createDataBase {
    //db -- 数据库操作类对象 -- 指向本地的数据库
    self.db = [FMDatabase databaseWithPath:[self getDataBasePath]];
}
//创建表 -- 表用来存储数据 -- 一条数据就是一个完整的联系人信息
- (void)createTableInDataBase {
    //1.打开数据库
    BOOL isOpen = [self.db open];
    if (!isOpen) {
        return;
    }
    //2.通过SQL语句操作数据库 -- 创建表
    BOOL isSuccess = [self.db executeUpdate:@"create table if not exists Collection(c_id integer primary key autoincrement, c_title text, c_content text)"];
    NSLog(@"%@", isSuccess ? @"创建表成功" : @"创建表失败");
    //3.关闭数据库
    [self.db close];
}
//查询数据方法 -- 从数据库中读取数据
- (NSMutableArray *)selectDataFromDataBase {
    //1.打开数据库
    BOOL isOpen = [self.db open];
    if (!isOpen) {
        return nil;
    }
    //2.通过SQL语句操作数据库 -- 查询所有数据
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    FMResultSet *result = [self.db executeQuery:@"select * from Collection"];
    while ([result next]) {
        //读取一条数据每个字段的值
        NSString *sid = [result stringForColumn:@"c_sid"];
        NSString *title = [result stringForColumn:@"c_title"];
        NSString *imgUrl_2x = [result stringForColumn:@"c_imgUrl_2x"];
        NSString *imgUrl_3x = [result stringForColumn:@"c_imgUrl_3x"];
        NSString *label = [result stringForColumn:@"c_label"];
        NSString *author = [result stringForColumn:@"c_author"];
        NSString *rating = [result stringForColumn:@"c_rating"];
        NSString *time = [result stringForColumn:@"c_time"];
        NSInteger type = [result intForColumn:@"c_type"];
        NSString *content = [result stringForColumn:@"c_content"];
        
        TSWArticleDetail *model = [[TSWArticleDetail alloc] initWithSid:sid title:title imgUrl_2x:imgUrl_2x imgUrl_3x:imgUrl_3x label:label author:author rating:rating time:time type:type content:content];
        [array addObject:model];
    }
    //3.关闭数据库
    [self.db close];
    return array;
}
//往数据库中插入一条新的数据
- (void)insertDataInDataBase:(TSWArticleDetail *)model {
    //1.打开数据库
    BOOL isOpen = [self.db open];
    if (!isOpen) {
        return;
    }
    //2.通过SQL语句操作数据库 -- 往数据库中插入一条数据
    BOOL isSuccess = [self.db executeUpdate:@"insert into Collection(c_title, c_imgUrl_2x, c_imgUrl_3x, c_label, c_author, c_rating, c_time, c_type, c_content) values(? ,?)", model.title, model.content];
    NSLog(@"%@", isSuccess ? @"插入成功" : @"插入失败");
    //需要做一步数据的同步处理,同步唯一标识
    model.sid = [NSString stringWithFormat:@"%lld", self.db.lastInsertRowId];
    
    //3.关闭数据库
    [self.db close];
}
//从数据库中删除一条数据
//从数据库中删除一条数据
- (void)deleteDataFromDataBase:(NSInteger)ID {
    //1.打开数据库
    BOOL isOpen = [self.db open];
    if (!isOpen) {
        return;
    }
    //2.通过SQL语句操作数据库 -- 从数据库中删除一条数据
    BOOL isSuccess = [self.db executeUpdate:@"delete from Collection where c_id = ?", @(ID)];
    NSLog(@"%@", isSuccess ? @"删除成功" : @"删除失败");
    //3.关闭数据库
    [self.db close];
}

//获取数据库文件路径的方法
- (NSString *)getDataBasePath {
    //1.获取Documents文件夹路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //2.拼接上数据库文件路径
    return [documentsPath stringByAppendingPathComponent:@"Collection.sqlite"];
}



@end
