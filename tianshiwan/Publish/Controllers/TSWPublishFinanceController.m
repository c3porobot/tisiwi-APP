//
//  TSWPublishFinanceController.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/16.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWPublishFinanceController.h"
#import "TSWSendFinance.h"
#import "ZHDatePicker.h"

static const CGFloat labelWidth = 80.0f; //左边UILabel的宽度


@interface TSWPublishFinanceController ()<UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate, UITextFieldDelegate, ZHDatepickerDelegate>
@property (nonatomic, strong) UITextField *pickerViewTextField;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UITextField *pickerViewTextField2;
@property (nonatomic, strong) UIPickerView *pickerView2;
@property (nonatomic, strong) NSMutableArray *typeData;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *valueField;
@property (nonatomic, strong) UIButton *valueBtn;
@property (nonatomic, strong) UITextField *amountField;
@property (nonatomic, strong) UITextField *hremailField;
@property (nonatomic, strong) UIButton *amountBtn;
@property (nonatomic, strong) UIButton *numBtn;
@property (nonatomic, strong) UITextField *timeField;
//@property (nonatomic, strong) UIButton *monthBtn;
//@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) ZHDatePicker *datePicker;
@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) UITextView *otherView;

@property (nonatomic, strong) TSWSendFinance *sendFinance;
@property (nonatomic, strong) NSString *selectedCurrency;
@property (nonatomic, strong) NSString *selectedValueCurrency;

@property (nonatomic, strong) UILabel *timeVeri;
@property (nonatomic, strong) UILabel *otherVeri;
@end

@implementation TSWPublishFinanceController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    self.navigationBar.title = @"融资需求";
    self.view.backgroundColor = RGB(234, 234, 234);
    _selectedCurrency = @"rmb";
    _selectedValueCurrency = @"人民币";
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight, width, height-self.navigationBarHeight)];
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    
    UILabel *valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 30.0f, width - 2*15.0f, 30.0f)];
    valueLabel.textAlignment = NSTextAlignmentLeft;
    valueLabel.textColor = RGB(120, 120, 120);
    valueLabel.font = [UIFont systemFontOfSize:17.0f];
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.text = @"目标估值";
    [_scrollView addSubview:valueLabel];
    
    self.valueField = [[UITextField alloc]initWithFrame:CGRectMake(labelWidth+15.0f, 30.0f, (width-labelWidth-2*15.0f)/3, 30.0f)];
    self.valueField.borderStyle = UITextBorderStyleNone;
    self.valueField.layer.borderColor = [RGB(127, 127, 127) CGColor];
    self.valueField.layer.borderWidth = 0.5f;
    self.valueField.font = [UIFont systemFontOfSize:17.0f];
    [self.valueField setTextColor:RGB(132, 132, 132)];
    self.valueField.delegate = self;
    self.valueField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.valueField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.valueField.backgroundColor = [UIColor whiteColor];
    self.valueField.autocapitalizationType = NO;
    self.valueField.tag = 1;
    [_scrollView addSubview:self.valueField];
    
    UILabel *valueUnitLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth+15.0f+(width-labelWidth-2*15.0f)/3+10.0f, 30.0f, width - 2*15.0f, 30.0f)];
    valueUnitLabel.textAlignment = NSTextAlignmentLeft;
    valueUnitLabel.textColor = RGB(120, 120, 120);
    valueUnitLabel.font = [UIFont systemFontOfSize:17.0f];
    valueUnitLabel.backgroundColor = [UIColor clearColor];
    valueUnitLabel.text = @"万";
    [_scrollView addSubview:valueUnitLabel];
    
    self.valueBtn = [[UIButton alloc]initWithFrame:CGRectMake(labelWidth+15.0f+(width-labelWidth-2*15.0f)/3+10.0f+14.0f+10.0f, 30.0f, (width-labelWidth-2*15.0f)/3, 30.0f)];
    self.valueBtn.backgroundColor = [UIColor whiteColor];
    self.valueBtn.layer.borderColor = [RGB(127, 127, 127) CGColor];
    self.valueBtn.layer.borderWidth = 0.5f;
    [self.valueBtn setTitleColor:RGB(132, 132, 132) forState:UIControlStateNormal];
    [self.valueBtn setTitle:@"人民币" forState:UIControlStateNormal];
    self.valueBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [self.valueBtn addTarget:self action:@selector(showPicker2:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:self.valueBtn];
    
    UILabel *amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 30.0f+1*(30.0f+12.0f), width - 2*15.0f, 30.0f)];
    amountLabel.textAlignment = NSTextAlignmentLeft;
    amountLabel.textColor = RGB(120, 120, 120);
    amountLabel.font = [UIFont systemFontOfSize:17.0f];
    amountLabel.backgroundColor = [UIColor clearColor];
    amountLabel.text = @"融资金额";
    [_scrollView addSubview:amountLabel];
    
    self.amountField = [[UITextField alloc]initWithFrame:CGRectMake(labelWidth+15.0f, 30.0f+(30.0f+12.0f), (width-labelWidth-2*15.0f)/3, 30.0f)];
    self.amountField.borderStyle = UITextBorderStyleNone;
    self.amountField.layer.borderColor = [RGB(127, 127, 127) CGColor];
    self.amountField.layer.borderWidth = 0.5f;
    self.amountField.font = [UIFont systemFontOfSize:17.0f];
    [self.amountField setTextColor:RGB(132, 132, 132)];
    self.amountField.delegate = self;
    self.amountField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.amountField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.amountField.backgroundColor = [UIColor whiteColor];
    self.amountField.autocapitalizationType = NO;
    self.amountField.tag = 2;
    [_scrollView addSubview:self.amountField];
    
    UILabel *valueUnitLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth+15.0f+(width-labelWidth-2*15.0f)/3+10.0f, 30.0f+1*(30.0f+12.0f), width - 2*15.0f, 30.0f)];
    valueUnitLabel2.textAlignment = NSTextAlignmentLeft;
    valueUnitLabel2.textColor = RGB(120, 120, 120);
    valueUnitLabel2.font = [UIFont systemFontOfSize:17.0f];
    valueUnitLabel2.backgroundColor = [UIColor clearColor];
    valueUnitLabel2.text = @"万";
    [_scrollView addSubview:valueUnitLabel2];
    
    self.amountBtn = [[UIButton alloc]initWithFrame:CGRectMake(labelWidth+15.0f+(width-labelWidth-2*15.0f)/3+10.0f+14.0f+10.0f, 30.0f+1*(30.0f+12.0f), (width-labelWidth-2*15.0f)/3, 30.0f)];
    self.amountBtn.backgroundColor = [UIColor whiteColor];
    self.amountBtn.layer.borderColor = [RGB(127, 127, 127) CGColor];
    self.amountBtn.layer.borderWidth = 0.5f;
    [self.amountBtn setTitleColor:RGB(132, 132, 132) forState:UIControlStateNormal];
    [self.amountBtn setTitle:@"人民币" forState:UIControlStateNormal];
    self.amountBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [self.amountBtn addTarget:self action:@selector(showPicker:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:self.amountBtn];
    
    UILabel *startLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 30.0f+2*(30.0f+12.0f), width - 2*15.0f, 30.0f)];
    startLabel.textAlignment = NSTextAlignmentLeft;
    startLabel.textColor = RGB(120, 120, 120);
    startLabel.font = [UIFont systemFontOfSize:17.0f];
    startLabel.backgroundColor = [UIColor clearColor];
    startLabel.text = @"启动时间";
    [_scrollView addSubview:startLabel];
    /**
     *修改了启动时间输入框的长度
     */
//    self.timeField = [[UITextField alloc]initWithFrame:CGRectMake(labelWidth+15.0f, 30.0f+2*(30.0f+12.0f), (width-labelWidth-2*15.0f), 30.0f)];
    //self.timeField = [[UITextField alloc]initWithFrame:CGRectMake(labelWidth+15.0f, 30.0f+2*(30.0f+12.0f), (width-labelWidth-2*15.0f) - 54, 30.0f)];
    self.timeField = [[UITextField alloc] initWithFrame:CGRectMake(labelWidth+15.0f, 30.0f+2*(30.0f+12.0f), ((width-labelWidth-2*15.0f)/3)+ ((width-labelWidth-2*15.0f)/3) + 35, 30.0f)];
    self.timeField.borderStyle = UITextBorderStyleNone;
    self.timeField.layer.borderColor = [RGB(127, 127, 127) CGColor];
    self.timeField.layer.borderWidth = 0.5f;
    self.timeField.font = [UIFont systemFontOfSize:17.0f];
    [self.timeField setTextColor:RGB(132, 132, 132)];
    self.timeField.delegate = self;
    self.timeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.timeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.timeField.backgroundColor = [UIColor whiteColor];
    self.timeField.autocapitalizationType = NO;
    self.timeField.tag = 3;
    [_scrollView addSubview:self.timeField];
    _timeVeri = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth+15.0f, 30.0f+2*(30.0f+12.0f), (width-labelWidth-2*15.0f), 30.0f)];
    _timeVeri.textAlignment = NSTextAlignmentRight;
    _timeVeri.textColor = [UIColor redColor];
    _timeVeri.font = [UIFont systemFontOfSize:17.0f];
    _timeVeri.backgroundColor = [UIColor clearColor];
    _timeVeri.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    //_timeVeri.text = @"超出有效长度";
    _timeVeri.numberOfLines = 0;
    _timeVeri.hidden = YES;
    [_scrollView addSubview:_timeVeri];
    
    // 是否愿意采用FA
    
    UILabel *FALabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 30.0f+3*(30.0f+12.0f)+3.0f, (width - 2*15.0f)/2, 30.0f)];
    FALabel.textAlignment = NSTextAlignmentLeft;
    FALabel.textColor = RGB(120, 120, 120);
    FALabel.font = [UIFont systemFontOfSize:17.0f];
    FALabel.backgroundColor = [UIColor clearColor];
    FALabel.text = @"是否愿意采用FA";
    [_scrollView addSubview:FALabel];
    _switchView = [[UISwitch alloc] initWithFrame:CGRectMake(15.0f+(width - 2*15.0f)/2, 30.0f+3*(30.0f+12.0f), (width - 2*15.0f)/2, 30.0f)];
    _switchView.on = YES;
    [_switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [_scrollView addSubview:_switchView];
    

    
    UILabel *otherLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 30.0f+4*(30.0f+12.0f)+3.0f, width - 2*15.0f, 30.0f)];
    otherLabel.textAlignment = NSTextAlignmentLeft;
    otherLabel.textColor = RGB(120, 120, 120);
    otherLabel.font = [UIFont systemFontOfSize:17.0f];
    otherLabel.backgroundColor = [UIColor clearColor];
    otherLabel.text = @"产品现状及其他";
    [_scrollView addSubview:otherLabel];
    
    _otherView = [[UITextView alloc]initWithFrame:CGRectMake(15.0f, 30.0f+5*(30.0f+12.0f)+3.0f, width-2*15.0f, 170.0f)];
    _otherView.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    _otherView.layer.masksToBounds=YES;
    _otherView.layer.borderWidth = 0.5f;
    _otherView.layer.borderColor = [RGB(127, 127, 127) CGColor];
    _otherView.font = [UIFont systemFontOfSize:17.0f];
    _otherView.delegate = self;
    _otherView.textColor = RGB(132, 132, 132);
    _otherView.autocapitalizationType = NO;
    _otherView.tag = 4;
    [_scrollView addSubview:_otherView];
    _otherVeri = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 30.0f+5*(30.0f+12.0f)+3.0f+170.0f+2.0f, width-2*15.0f, 170.0f)];
    _otherVeri.textAlignment = NSTextAlignmentRight;
    _otherVeri.textColor = [UIColor redColor];
    _otherVeri.font = [UIFont systemFontOfSize:17.0f];
    _otherVeri.backgroundColor = [UIColor clearColor];
    _otherVeri.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    //_otherVeri.text = @"超出有效长度";
    _otherVeri.numberOfLines = 0;
    _otherVeri.hidden = YES;
    [_scrollView addSubview:_otherVeri];
    
    
    
    
    // set the frame to zero
    self.pickerViewTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.pickerViewTextField];
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.tag = 1;
    
    // set change the inputView (default is keyboard) to UIPickerView
    self.pickerViewTextField.inputView = self.pickerView;
    
    self.pickerViewTextField2 = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.pickerViewTextField2];
    
    self.pickerView2 = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.pickerView2.showsSelectionIndicator = YES;
    self.pickerView2.dataSource = self;
    self.pickerView2.delegate = self;
    self.pickerView2.tag = 2;
    
    // set change the inputView (default is keyboard) to UIPickerView
    self.pickerViewTextField2.inputView = self.pickerView2;
    
    
    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, height - 60.0f, width, 60.0f)];
    sendBtn.backgroundColor = [UIColor whiteColor];
    [sendBtn setTitleColor:RGB(90, 90, 90) forState:UIControlStateNormal];
    [sendBtn setTitle:@"发布" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:25.0f];
    [sendBtn addTarget:self action:@selector(finishFinance) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    
    
    _scrollView.contentSize = CGSizeMake(width, 30.0f+5*(30.0f+12.0f)+170.0f+30.0f);
    
    
    self.typeData = [[NSMutableArray alloc]init];
    [self.typeData addObject:@{@"name":@"人民币",@"code":@"rmb"}];
    [self.typeData addObject:@{@"name":@"美元",@"code":@"dollar"}];
    self.sendFinance = [[TSWSendFinance alloc] initWithBaseURL:TSW_API_BASE_URL path:SEND_FINANCE];
    [self.sendFinance addObserver:self
                       forKeyPath:kResourceLoadingStatusKeyPath
                          options:NSKeyValueObservingOptionNew
                          context:nil];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePicker)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (IBAction)showPicker:(UIButton *)sender
{
    [self.pickerViewTextField becomeFirstResponder];
}

- (IBAction)showPicker2:(UIButton *)sender
{
    [self.pickerViewTextField2 becomeFirstResponder];
}

- (void) showDatePicker{
    self.datePicker.hidden = NO;
}

-(void)hidePicker{
    [self.pickerViewTextField resignFirstResponder];
    [self.pickerViewTextField2 resignFirstResponder];
    self.datePicker.hidden = YES;
    [self.view endEditing:YES];
}

-(void)switchAction:(id)sender{

}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
        if(object == _sendFinance){
            if (_sendFinance.isLoaded) {
                [self hideLoadingView];
                [self showSuccessMessage:@"发布成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if (_sendFinance.error) {
                [self showErrorMessage:[_sendFinance.error localizedFailureReason]];
            }
        }
    }
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
    NSString *item = [[self.typeData objectAtIndex:row] objectForKey:@"name"];
    return item;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // perform some action
    if(pickerView.tag == 1){
        [self.amountBtn setTitle:[[self.typeData objectAtIndex:row] objectForKey:@"name"] forState:UIControlStateNormal];
        _selectedCurrency = [[self.typeData objectAtIndex:row] objectForKey:@"code"];
    }else{
        [self.valueBtn setTitle:[[self.typeData objectAtIndex:row] objectForKey:@"name"] forState:UIControlStateNormal];
        _selectedValueCurrency = [[self.typeData objectAtIndex:row] objectForKey:@"name"];
    }
    
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
/**
 *修改了>=
 */
-(void)finishFinance {
    NSString *NUM = @"^[0-9]*$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", NUM];
    if(_valueField.text.length > 0){
        if([regextestmobile evaluateWithObject:_valueField.text] == YES){
            if(_amountField.text.length > 0){
                if([regextestmobile evaluateWithObject:_amountField.text] == YES){
                    if(_timeField.text.length>0){
                        if(_timeField.text.length<=256){
                            _timeVeri.hidden = YES;
                            if(_otherView.text.length > 0 && _otherView.text.length<=1024){
                                    _otherVeri.hidden = YES;
                                    [self showLoadingViewWithText:@"提交中..."];
                                    int fa = 0;
                                    if(_switchView.on){
                                        fa = 1;
                                    }else{
                                        fa = 0;
                                    }
                                    NSString *value = [[_valueField.text stringByAppendingString:@"万"] stringByAppendingString:_selectedValueCurrency];
                                    [self.sendFinance loadDataWithRequestMethodType:kHttpRequestMethodTypePost parameters:@{@"valuation":value,@"amount":_amountField.text,@"amountType":_selectedCurrency,@"start":_timeField.text,@"fa":[NSString stringWithFormat:@"%d",fa],@"projectStatus":_otherView.text}];
                            }else if(_otherView.text.length>1024){
                                _otherVeri.hidden = NO;
                            }
                        }else{
                            _timeVeri.hidden = NO;
                        }
                    }else{
                        _timeVeri.text = @"请填写融资时间";
                        _timeVeri.hidden = NO;
                    }
                }else{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"融资金额请填写数字" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];
                }
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"请填写融资金额" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"目前估值请填写数字" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"请填写目前估值" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
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
    [_sendFinance removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSString *NUM = @"^[0-9]*$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", NUM];
    switch (textField.tag) {
        case 1:
            if(_valueField.text.length <= 0){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"请填写目前估值" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }else if([regextestmobile evaluateWithObject:_valueField.text] == NO){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"目前估值请填写数字" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }
            break;
        case 2:
            if(_amountField.text.length <= 0){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"请填写融资金额" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }else if([regextestmobile evaluateWithObject:_amountField.text] == NO){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"融资金额请填写数字" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }
            break;
        case 3:
            if(_timeField.text.length>0){
                if(_timeField.text.length<=256){
                    _timeVeri.hidden = YES;
                }else{
                    _timeVeri.hidden = NO;
                }
            }else{
                //_timeVeri.text = @"请填写融资时间";
                _timeVeri.hidden = NO;
            }

            break;
        default:
            break;
    }
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    switch (textView.tag) {
        case 4:
            if(_otherView.text.length>0){
                if(_otherView.text.length<=1024){
                    _otherVeri.hidden = YES;
                }else{
                    _otherVeri.hidden = NO;
                }
            }
            break;
        default:
            break;
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGFloat offset = self.view.frame.size.height - (textField.frame.origin.y+textField.frame.size.height+216+50);
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
