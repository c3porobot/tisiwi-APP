//
//  ZHAreaPickerView.h
//  tianshiwan
//
//  Created by zhouhai on 15/10/4.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHLocation.h"

@class HZAreaPickerView;

@protocol ZHAreaPickerDelegate <NSObject>

@optional
- (void)pickerDidChaneStatus:(HZAreaPickerView *)picker;

@end

@interface ZHAreaPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>
// NSArray *provinces, *cities, *areas;
@property (assign, nonatomic) id <ZHAreaPickerDelegate> delegate;
@property (nonatomic, strong) NSArray *provinces;
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) NSArray *areas;
@property (strong, nonatomic) IBOutlet UIPickerView *locatePicker;
@property (strong, nonatomic) ZHLocation *locate;
- (id)initWithDelegate:(id<ZHAreaPickerDelegate>)delegate;
- (id)initWithDelegate:(id<ZHAreaPickerDelegate>)delegate withAll:(BOOL)all;
- (void)showInView:(UIView *)view;
- (void)cancelPicker;

@end