//
//  ZHAreaPickerView.m
//  tianshiwan
//
//  Created by zhouhai on 15/10/4.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "ZHAreaPickerView.h"
#import <QuartzCore/QuartzCore.h>

#define kDuration 0.3

@interface ZHAreaPickerView ()
{
    NSArray *provinces, *cities, *areas;
}

@end

@implementation ZHAreaPickerView

@synthesize delegate=_delegate;
@synthesize locate=_locate;
@synthesize locatePicker = _locatePicker;

- (void)dealloc
{
//    [_locate release];
//    [_locatePicker release];
//    [provinces release];
//    [super dealloc];
}

-(ZHLocation *)locate
{
    if (_locate == nil) {
        _locate = [[ZHLocation alloc] init];
    }
    
    return _locate;
}

- (id)initWithDelegate:(id<ZHAreaPickerDelegate>)delegate
{
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"ZHAreaPickerView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.delegate = delegate;
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
        
        //加载数据
        provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
        cities = [[provinces objectAtIndex:0] objectForKey:@"cities"];
        self.locate.state = [[provinces objectAtIndex:0] objectForKey:@"ProvinceName"];
        self.locate.city = [[cities objectAtIndex:0] objectForKey:@"CityName"];
        self.locate.cityCode = [[cities objectAtIndex:0] objectForKey:@"code"];
    }
    
    return self;
    
}

- (id)initWithDelegate:(id<ZHAreaPickerDelegate>)delegate withAll:(BOOL)all
{
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"ZHAreaPickerView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.delegate = delegate;
        self.locatePicker.dataSource = self;
        self.locatePicker.delegate = self;
        
        //加载数据
        NSMutableArray *tempProvinces = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
        [tempProvinces insertObject:@{@"ID":@"",@"code":@"",@"ProvinceName":@"全部城市"} atIndex:0];
        provinces = [tempProvinces copy];
        cities = [[provinces objectAtIndex:0] objectForKey:@"cities"];
        self.locate.state = [[provinces objectAtIndex:0] objectForKey:@"ProvinceName"];
        self.locate.city = [[cities objectAtIndex:0] objectForKey:@"CityName"];
        self.locate.cityCode = [[cities objectAtIndex:0] objectForKey:@"code"];
    }
    
    return self;
    
}



#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [provinces count];
            break;
        case 1:
            return [cities count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
        switch (component) {
            case 0:
                return [[provinces objectAtIndex:row] objectForKey:@"ProvinceName"];
                break;
            case 1:
                return [[cities objectAtIndex:row] objectForKey:@"CityName"];
                break;
            default:
                return @"";
                break;
        }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
        switch (component) {
            case 0:
                cities = [[provinces objectAtIndex:row] objectForKey:@"cities"];
                [self.locatePicker selectRow:0 inComponent:1 animated:YES];
                [self.locatePicker reloadComponent:1];
                
                self.locate.state = [[provinces objectAtIndex:row] objectForKey:@"ProvinceName"];
                self.locate.city = [[cities objectAtIndex:0] objectForKey:@"CityName"];
                self.locate.cityCode = [[cities objectAtIndex:0] objectForKey:@"code"];
                break;
            case 1:
                self.locate.city = [[cities objectAtIndex:row] objectForKey:@"CityName"];
                self.locate.cityCode = [[cities objectAtIndex:0] objectForKey:@"code"];
                break;
            default:
                break;
        }
    
    if([self.delegate respondsToSelector:@selector(pickerDidChaneStatus:)]) {
        [self.delegate pickerDidChaneStatus:self];
    }
    
}


#pragma mark - animation

- (void)showInView:(UIView *) view
{
    self.frame = CGRectMake(0, view.frame.size.height, [UIScreen mainScreen].bounds.size.width, self.frame.size.height);
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
    
   // self.superview.userInteractionEnabled = NO;
}

- (void)cancelPicker
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         
                     }];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.minimumFontSize = 8.0f;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:UITextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

@end

