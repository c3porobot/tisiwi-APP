//
//  NSString+CXExtensions.h
//
//  Created by 熊财兴 on 14/12/28.
//  Copyright (c) 2014年 熊财兴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CXExtensions)

+ (NSString *)cx_stringWithMD5OfFile:(NSString *)path;

- (NSString *)cx_MD5Hash;


- (NSString *)cx_MD5;

- (NSData *)cx_MD5CharData;

- (NSString *)URLEncodedString;
- (NSString*)URLDecodedString;

@end
