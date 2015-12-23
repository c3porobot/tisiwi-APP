//
//  CXLog.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/7.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CocoaLumberjack.h"

extern DDLogLevel const ddLogLevel;

@interface CXLogFormatter : NSObject <DDLogFormatter>

@end
