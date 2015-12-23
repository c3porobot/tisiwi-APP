//
//  NSURL+CXExtensions.h
//
//  Created by 熊财兴 on 15/3/22.
//  Copyright (c) 2015年 熊财兴. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (CXExtensions)

/**
 *  @return URL's query component as keys/values
 *  Returns nil for an empty query
 */
- (NSDictionary*) cx_queryDictionary;

/**
 *  @return URL with keys values appending to query string
 *  @param queryDictionary Query keys/values
 *  @param sortedKeys Sorted the keys alphabetically?
 *  @warning If keys overlap in receiver and query dictionary,
 *  behaviour is undefined.
 */
- (NSURL*)cx_URLByAppendingQueryDictionary:(NSDictionary*) queryDictionary
                             withSortedKeys:(BOOL) sortedKeys;

/** As above, but `sortedKeys=NO` */
- (NSURL*)cx_URLByAppendingQueryDictionary:(NSDictionary*) queryDictionary;

@end

#pragma mark -

@interface NSString (URLQuery)

/**
 *  @return If the receiver is a valid URL query component, returns
 *  components as key/value pairs. If couldn't split into *any* pairs,
 *  returns nil.
 */
- (NSDictionary*)cx_URLQueryDictionary;

@end

#pragma mark -

@interface NSDictionary (URLQuery)

/**
 *  @return URL query string component created from the keys and values in
 *  the dictionary. Returns nil for an empty dictionary.
 *  @param sortedKeys Sorted the keys alphabetically?
 *  @see cavetas from the main `NSURL` category as well.
 */
- (NSString*) cx_URLQueryStringWithSortedKeys:(BOOL) sortedKeys;

/** As above, but `sortedKeys=NO` */
- (NSString*) cx_URLQueryString;

@end
