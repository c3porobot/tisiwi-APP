/*
 *  pinyin.h
 *  Chinese Pinyin First Letter
 *
 *  Created by zhouhai on 4/21/10.
 *  Copyright 2010 RED/SAFI. All rights reserved.
 *
 */

/*
 * // Example
 *
 * #import "pinyin.h"
 *
 * NSString *hanyu = @"CXXXXX";
 * for (int i = 0; i < [hanyu length]; i++)
 * {
 *     printf("%c", pinyinFirstLetter([hanyu characterAtIndex:i]));
 * }
 *
 */

char pinyinFirstLetter(unsigned short hanzi);