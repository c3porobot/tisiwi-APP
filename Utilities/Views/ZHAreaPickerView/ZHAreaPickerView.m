//
//  ZHAreaPickerView.m
//  tianshiwan
//
//  Created by zhouhai on 15/10/4.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "ZHAreaPickerView.h"
#import <QuartzCore/QuartzCore.h>
#import "GVUserDefaults+TSWProperties.h"
#define kDuration 0.3

@interface ZHAreaPickerView ()
//{
//    NSArray *provinces, *cities, *areas;
//}

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
        _provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
        _cities = [[_provinces objectAtIndex:0] objectForKey:@"cities"];
        self.locate.state = [[_provinces objectAtIndex:0] objectForKey:@"ProvinceName"];
        self.locate.city = [[_cities objectAtIndex:0] objectForKey:@"CityName"];
        self.locate.cityCode = [[_cities objectAtIndex:0] objectForKey:@"code"];
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
        [tempProvinces insertObject:@{@"ID":@"",@"code":@"",@"ProvinceName":@"城市"} atIndex:0];
        _provinces = [tempProvinces copy];
        _cities = [[_provinces objectAtIndex:0] objectForKey:@"cities"];
        self.locate.state = [[_provinces objectAtIndex:0] objectForKey:@"ProvinceName"];
        self.locate.city = [[_cities objectAtIndex:0] objectForKey:@"CityName"];
        self.locate.cityCode = [[_cities objectAtIndex:0] objectForKey:@"code"];
        
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
            return [_provinces count];
            break;
        case 1:
            return [_cities count];
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
                return [[_provinces objectAtIndex:row] objectForKey:@"ProvinceName"];
                break;
            case 1:
                return [[_cities objectAtIndex:row] objectForKey:@"CityName"];
                break;
            default:
                return @"";
                break;
        }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
        switch (component) {
            case 0:{
                //第二个随第一个改变
                _cities = [[_provinces objectAtIndex:row] objectForKey:@"cities"];
                [self.locatePicker selectRow:0 inComponent:1 animated:YES];
                if (component == 0 && row == 0) {
                 
                }
                [self.locatePicker reloadComponent:1];
                
                self.locate.state = [[_provinces objectAtIndex:row] objectForKey:@"ProvinceName"];
                self.locate.city = [[_cities objectAtIndex:0] objectForKey:@"CityName"];
                self.locate.cityCode = [[_cities objectAtIndex:0] objectForKey:@"code"];
                break;
            }
            case 1:{
                self.locate.city = [[_cities objectAtIndex:row] objectForKey:@"CityName"];
                self.locate.cityCode = [[_cities objectAtIndex:row] objectForKey:@"code"];
                break;
            }
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
        self.frame = CGRectMake(0, view.frame.size.height, [UIScreen mainScreen].bounds.size.width, 230);
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height+40, self.frame.size.width, 230);
        [view addSubview:self];
    }];
    //首尾式动画
//    [UIView beginAnimations:nil context:nil];
//    //执行动画
//    [view addSubview:self];
//    //设置动画执行时间
//    [UIView setAnimationDuration:1];
//    //设置代理
//    [UIView setAnimationDelegate:self];
//    self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
//    //设置动画执行完毕调用的事件
//    [UIView commitAnimations];
    
   // self.superview.userInteractionEnabled = NO;
}

- (void)cancelPicker
{
//    [UIView animateWithDuration:0.3
//                     animations:^{
//                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
//                     }
//                     completion:^(BOOL finished){
//                         [self removeFromSuperview];
//                         
//                     }];
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

