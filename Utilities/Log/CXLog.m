//
//  CXLog.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/7.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXLog.h"

#ifdef DEBUG
DDLogLevel const ddLogLevel = DDLogLevelAll;
#else
DDLogLevel const ddLogLevel = DDLogLevelWarning;
#endif

@implementation CXLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage
{
    return [NSString stringWithFormat:@"////////////////////////////////////////////////// \nFileName:%@ \nFunction:%@ \nLine:%@ \n%@ \n//////////////////////////////////////////////////",
            logMessage.fileName, logMessage.function, @(logMessage.line), logMessage.message];
}

@end
