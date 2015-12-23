//
//  TSWPublishOtherController.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/16.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWPublishOtherController.h"
#import "RDVTabBarController.h"
#import "TSWSendOther.h"
#import "TSWGetRequirementType.h"
#import "TSWOtherRequirementType.h"

@interface TSWPublishOtherController ()<UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *pickerViewTextField;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *typeData;

@property (nonatomic, strong) UITextView *descView;
@property (nonatomic, strong) UIButton *typeBtn;

@property (nonatomic, strong) TSWSendOther *sendOther;
@property (nonatomic, strong) TSWGetRequirementType *getType;
@property (nonatomic, strong) NSString *selectedType;

@property (nonatomic, strong) UILabel *descVeri;
@end

@implementation TSWPublishOtherController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    self.navigationBar.title = @"其他服务";
    self.view.backgroundColor = RGB(234, 234, 234);
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight, width, height-self.navigationBarHeight)];
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 30.0f, width - 2*15.0f, 30.0f)];
    typeLabel.textAlignment = NSTextAlignmentLeft;
    typeLabel.textColor = RGB(120, 120, 120);
    typeLabel.font = [UIFont systemFontOfSize:17.0f];
    typeLabel.backgroundColor = [UIColor clearColor];
    typeLabel.text = @"需求类目";
    [_scrollView addSubview:typeLabel];
    
    self.typeBtn = [[UIButton alloc]initWithFrame:CGRectMake(80.0f+15.0f, 30.0f, width-80.0f-2*15.0f, 30.0f)];
    self.typeBtn.backgroundColor = [UIColor whiteColor];
    self.typeBtn.layer.borderColor = [RGB(127, 127, 127) CGColor];
    self.typeBtn.layer.borderWidth = 0.5f;
    [self.typeBtn setTitleColor:RGB(132, 132, 132) forState:UIControlStateNormal];
    [self.typeBtn setTitle:@"IT支持" forState:UIControlStateNormal];
    self.typeBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [self.typeBtn addTarget:self action:@selector(showPicker:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:self.typeBtn];
    
    
    
    
    // set the frame to zero
    self.pickerViewTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.pickerViewTextField];
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    // set change the inputView (default is keyboard) to UIPickerView
    self.pickerViewTextField.inputView = self.pickerView;
    
    UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 30.0f+20.0f+30.0f, width - 2*15.0f, 30.0f)];
    descLabel.textAlignment = NSTextAlignmentLeft;
    descLabel.textColor = RGB(120, 120, 120);
    descLabel.font = [UIFont systemFontOfSize:17.0f];
    descLabel.backgroundColor = [UIColor clearColor];
    descLabel.text = @"需求描述";
    [_scrollView addSubview:descLabel];
    
    _descView = [[UITextView alloc]initWithFrame:CGRectMake(80.0f+15.0f, 30.0f+20.0f+30.0f, width-80.0f-2*15.0f, 320.0f)];
    _descView.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    _descView.layer.masksToBounds=YES;
    _descView.layer.borderWidth = 0.5f;
    _descView.layer.borderColor = [RGB(127, 127, 127) CGColor];
    _descView.font = [UIFont systemFontOfSize:17.0f];
    _descView.delegate = self;
    _descView.textColor = RGB(132, 132, 132);
    _descView.autocapitalizationType = NO;
    [_scrollView addSubview:_descView];
    _descVeri = [[UILabel alloc]initWithFrame:CGRectMake(80.0f+15.0f, 30.0f+20.0f+30.0f+320.0f+5.0f, width-80.0f-2*15.0f, 20.0f)];
    _descVeri.textAlignment = NSTextAlignmentRight;
    _descVeri.textColor = [UIColor redColor];
    _descVeri.font = [UIFont systemFontOfSize:17.0f];
    _descVeri.backgroundColor = [UIColor clearColor];
    _descVeri.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _descVeri.text = @"超出有效长度";
    _descVeri.numberOfLines = 0;
    _descVeri.hidden = YES;
    [_scrollView addSubview:_descVeri];
    
    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, height - 60.0f, width, 60.0f)];
    sendBtn.backgroundColor = [UIColor whiteColor];
    [sendBtn setTitleColor:RGB(90, 90, 90) forState:UIControlStateNormal];
    [sendBtn setTitle:@"发布" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:25.0f];
    [sendBtn addTarget:self action:@selector(finishOther) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    
    
    self.typeData = [[NSMutableArray alloc]init];
    
    self.sendOther = [[TSWSendOther alloc] initWithBaseURL:TSW_API_BASE_URL path:SEND_OTHER];
    [self.sendOther addObserver:self
                      forKeyPath:kResourceLoadingStatusKeyPath
                         options:NSKeyValueObservingOptionNew
                         context:nil];
    
    self.getType = [[TSWGetRequirementType alloc] initWithBaseURL:TSW_API_BASE_URL path:GET_TYPE];
    [self.getType addObserver:self
                     forKeyPath:kResourceLoadingStatusKeyPath
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    
    [self refreshData];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePicker)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
        if(object == _sendOther){
            if (_sendOther.isLoaded) {
                [self hideLoadingView];
                [self showSuccessMessage:@"发布成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if (_sendOther.error) {
                [self showErrorMessage:[_sendOther.error localizedFailureReason]];
            }
        }else if(object == _getType){
            if (_getType.isLoaded) {
                self.typeData = _getType.types;
                if([_getType.types count]>0){
                    _selectedType = [_getType.types[0] valueForKey:@"sid"];
                }
                [self.pickerView reloadAllComponents];
            }
            else if (_getType.error) {
                [self showErrorMessage:[_sendOther.error localizedFailureReason]];
            }
        }
    }
}

- (void)refreshData
{
    [self.getType loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
}

- (IBAction)showPicker:(UIButton *)sender
{
    [self.pickerViewTextField becomeFirstResponder];
}

-(void)hidePicker{
    [self.pickerViewTextField resignFirstResponder];
    [self.view endEditing:YES];
}

-(void)submitContent:(UIButton *)sender{
    
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.typeData count];
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    TSWOtherRequirementType *temp = (TSWOtherRequirementType *)[self.typeData objectAtIndex:row];
    NSString *item = temp.name;
    if(row==0){
        _selectedType = temp.sid;
    }
    return item;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // perform some action
    TSWOtherRequirementType *temp = (TSWOtherRequirementType *)[self.typeData objectAtIndex:row];
    [self.typeBtn setTitle:temp.name forState:UIControlStateNormal];
//    self.navigationBar.title = temp.name;
    _selectedType = temp.sid;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [self refreshData];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)finishOther {
    
    if(_descView.text.length > 0)
    {
        if(_descView.text.length<=512){
            _descVeri.hidden = YES;
            [self showLoadingViewWithText:@"提交中..."];
            [self.sendOther loadDataWithRequestMethodType:kHttpRequestMethodTypePost parameters:@{@"type":_selectedType,@"description":_descView.text}];
        }else{
            _descVeri.hidden = NO;
        }
    }else{
        _descVeri.text = @"请填写需求描述";
        _descVeri.hidden = NO;
    }
}

#pragma mark - UIButton
- (void)dismiss:(UIButton *)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)dealloc
{
    [_sendOther removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [_getType removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if(_descView.text.length>0){
        if(_descView.text.length<=512){
            _descVeri.hidden = YES;
        }else{
            _descVeri.hidden = NO;
        }
    }else{
        _descVeri.text = @"请填写需求描述";
        _descVeri.hidden = NO;
    }
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    CGFloat offset = self.view.frame.size.height - (textView.frame.origin.y+textView.frame.size.height+216+50);
    if(offset <= 0){
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
    return YES;
}
@end
