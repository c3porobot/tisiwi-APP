//
//  ZHDatePicker.h
//  tianshiwan
//
//  Created by zhouhai on 15/10/5.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <UIKit/UIKit.h>

//设置委托

@protocol ZHDatepickerDelegate <NSObject>

@optional

-(void)valuechange:(NSDate *)mydate;

@end


@interface ZHDatePicker :UIControl //UIViewController

<UIPickerViewDelegate,UIPickerViewDataSource>

{
    
    UIPickerView *kengdiepicker;
    
    // UIDatePicker *kengdiepicker;
    
    NSDate *minimumDate,*maximumDate;
    
    NSDate *date;
    
    NSArray *month;
    
    NSMutableArray *year;
    
    int thismonth,thisyear;
    
//    id<ZHDatepickerDelegate> _thedate;//设置委托变量
    
    // UIDatePicker *picker;
    
}

@property(nonatomic, retain) UIPickerView *kengdiepicker;

//@property(nonatomic, retain) UIDatePicker *kengdiepicker;

@property(nonatomic, retain) NSDate *minimumDate;

@property(nonatomic, retain) NSDate *maximumDate;

@property(nonatomic, retain) NSDate *date;

@property(nonatomic, retain) NSArray *month;

@property(nonatomic, retain) NSMutableArray *year;

@property(nonatomic, assign)id<ZHDatepickerDelegate> _thedate;

-(id)MyInit;

-(void)setdate:(NSDate *)mydate;

@end
