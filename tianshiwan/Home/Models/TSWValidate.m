//
//  TSWValidate.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/10.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWValidate.h"

#import "CXLog.h"

@interface TSWValidate ()
@property (nonatomic, strong) NSTimer *countDownTimer;

@property (nonatomic, assign) NSUInteger surplusTime;

@property (nonatomic, assign) BOOL isStartTime;

@end

@implementation TSWValidate


- (void)setTimeout:(NSUInteger)timeout
{
    _timeout = timeout;
    
    self.surplusTime = timeout;
}

- (void)dealloc
{
    [self destroyTimer];
}

- (void)destroyTimer {
    if (self.countDownTimer) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }
}

- (void)startTime
{
    if (self.surplusTime <= 0) {
        [self destroyTimer];
        self.surplusTime = self.timeout;
        self.isStartTime = YES;
    }
    
    if (!self.countDownTimer) {
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCountDown:) userInfo:nil repeats:YES];
        [self.countDownTimer fire];
    }
}

- (void)timerCountDown:(NSTimer *)timer
{
    self.surplusTime = self.surplusTime - 1;
    
    int seconds = self.surplusTime % 60;
    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
    DDLogDebug(@"surplusTime : %@",strTime);
    
    if(self.surplusTime <= 0) { //倒计时结束，关闭
        [self destroyTimer];
    }
}

@end
