//
//  ZHScrollView.m
//  tianshiwan
//
//  Created by zhouhai on 15/10/4.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "ZHScrollView.h"

@implementation ZHScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    //做你想要的操作
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    //做你想要的操作
}


@end
