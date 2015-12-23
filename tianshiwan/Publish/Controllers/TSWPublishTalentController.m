//
//  TSWPublishTalentController.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/16.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWPublishTalentController.h"
#import "TSWSendTalent.h"
#import "ZHAreaPickerView.h"
#import "ZHScrollView.h"

static const CGFloat labelWidth = 80.0f; //左边UILabel的宽度

@interface TSWPublishTalentController ()<UITextFieldDelegate, UITextViewDelegate, ZHAreaPickerDelegate>
@property (nonatomic, strong) ZHScrollView *scrollView;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *hrField;
@property (nonatomic, strong) UITextField *hremailField;
@property (nonatomic, strong) UIButton *addressBtn;
@property (nonatomic, strong) UITextField *numField;
@property (nonatomic, strong) UITextField *startField;
@property (nonatomic, strong) UITextField *endField;
@property (nonatomic, strong) UITextView *hrView; //HR
@property (nonatomic, strong) UITextView *dutyView;
@property (nonatomic, strong) UITextView *askView;

@property (nonatomic, strong) TSWSendTalent *sendTalent;

@property (nonatomic, strong) NSMutableArray *regions;

@property (strong, nonatomic) ZHAreaPickerView *locatePicker;
@property (strong, nonatomic) NSString *selectedCityCode;

@property (nonatomic, strong) UILabel *nameVeri;
@property (nonatomic, strong) UILabel *numVeri;
@property (nonatomic, strong) UILabel *hrVeri;
@property (nonatomic, strong) UILabel *hremailVeri;
@property (nonatomic, strong) UILabel *dutyVeri;
@property (nonatomic, strong) UILabel *askVeri;
@end

@implementation TSWPublishTalentController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    self.navigationBar.title = @"人才需求";
    self.view.backgroundColor = RGB(234, 234, 234);
    _selectedCityCode = @"110000";
    
    _scrollView = [[ZHScrollView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight, width, height-self.navigationBarHeight)];
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 30.0f, width - 2*15.0f, 30.0f)];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = RGB(120, 120, 120);
    nameLabel.font = [UIFont systemFontOfSize:17.0f];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.text = @"岗位名称";
    [_scrollView addSubview:nameLabel];
    
    self.nameField = [[UITextField alloc]initWithFrame:CGRectMake(labelWidth+15.0f, 30.0f, width-labelWidth-2*15.0f, 30.0f)];
    self.nameField.borderStyle = UITextBorderStyleNone;
    self.nameField.layer.borderColor = [RGB(127, 127, 127) CGColor];
    self.nameField.layer.borderWidth = 0.5f;
    self.nameField.font = [UIFont systemFontOfSize:17.0f];
    [self.nameField setTextColor:RGB(132, 132, 132)];
    self.nameField.delegate = self;
    self.nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameField.backgroundColor = [UIColor whiteColor];
    self.nameField.autocapitalizationType = NO;
    self.nameField.tag = 1;
    [_scrollView addSubview:self.nameField];
    _nameVeri = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth+15.0f, 30.0f, (width-labelWidth-2*15.0f), 30.0f)];
    _nameVeri.textAlignment = NSTextAlignmentRight;
    _nameVeri.textColor = [UIColor redColor];
    _nameVeri.font = [UIFont systemFontOfSize:17.0f];
    _nameVeri.backgroundColor = [UIColor clearColor];
    _nameVeri.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    //_nameVeri.text = @"超出有效长度";
    _nameVeri.numberOfLines = 0;
    _nameVeri.hidden = YES;
    [_scrollView addSubview:_nameVeri];
    
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 30.0f+1*(30.0f+12.0f), width - 2*15.0f, 30.0f)];
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.textColor = RGB(120, 120, 120);
    addressLabel.font = [UIFont systemFontOfSize:17.0f];
    addressLabel.backgroundColor = [UIColor clearColor];
    addressLabel.text = @"工作地点";
    [_scrollView addSubview:addressLabel];
    
    self.addressBtn = [[UIButton alloc]initWithFrame:CGRectMake(labelWidth+15.0f, 30.0f+1*(30.0f+12.0f), (width-labelWidth-2*15.0f), 30.0f)];
    self.addressBtn.backgroundColor = [UIColor whiteColor];
    self.addressBtn.layer.borderColor = [RGB(127, 127, 127) CGColor];
    self.addressBtn.layer.borderWidth = 0.5f;
    [self.addressBtn setTitleColor:RGB(132, 132, 132) forState:UIControlStateNormal];
    [self.addressBtn setTitle:@"北京市" forState:UIControlStateNormal];
    self.addressBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [self.addressBtn addTarget:self action:@selector(someButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:self.addressBtn];
    
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 30.0f+2*(30.0f+12.0f), width - 2*15.0f, 30.0f)];
    numLabel.textAlignment = NSTextAlignmentLeft;
    numLabel.textColor = RGB(120, 120, 120);
    numLabel.font = [UIFont systemFontOfSize:17.0f];
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.text = @"需求人数";
    [_scrollView addSubview:numLabel];
    
    self.numField = [[UITextField alloc]initWithFrame:CGRectMake(labelWidth+15.0f, 30.0f+2*(30.0f+12.0f), (width-labelWidth-2*15.0f), 30.0f)];
    self.numField.borderStyle = UITextBorderStyleNone;
    self.numField.layer.borderColor = [RGB(127, 127, 127) CGColor];
    self.numField.layer.borderWidth = 0.5f;
    self.numField.font = [UIFont systemFontOfSize:17.0f];
    [self.numField setTextColor:RGB(132, 132, 132)];
    self.numField.delegate = self;
    self.numField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.numField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.numField.backgroundColor = [UIColor whiteColor];
    self.numField.autocapitalizationType = NO;
    self.numField.tag = 2;
    [_scrollView addSubview:self.numField];
    _numVeri = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth+15.0f, 30.0f+2*(30.0f+12.0f), (width-labelWidth-2*15.0f), 30.0f)];
    _numVeri.textAlignment = NSTextAlignmentRight;
    _numVeri.textColor = [UIColor redColor];
    _numVeri.font = [UIFont systemFontOfSize:17.0f];
    _numVeri.backgroundColor = [UIColor clearColor];
    _numVeri.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    //_numVeri.text = @"超出有效长度";
    _numVeri.numberOfLines = 0;
    _numVeri.hidden = YES;
    [_scrollView addSubview:_numVeri];
    
    UILabel *salaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 30.0f+3*(30.0f+12.0f), width - 2*15.0f, 30.0f)];
    salaryLabel.textAlignment = NSTextAlignmentLeft;
    salaryLabel.textColor = RGB(120, 120, 120);
    salaryLabel.font = [UIFont systemFontOfSize:17.0f];
    salaryLabel.backgroundColor = [UIColor clearColor];
    salaryLabel.text = @"月薪范围";
    [_scrollView addSubview:salaryLabel];
    
    self.startField = [[UITextField alloc]initWithFrame:CGRectMake(labelWidth+15.0f, 30.0f+3*(30.0f+12.0f), (width-labelWidth-2*15.0f)/3, 30.0f)];
    self.startField.borderStyle = UITextBorderStyleNone;
    self.startField.layer.borderColor = [RGB(127, 127, 127) CGColor];
    self.startField.layer.borderWidth = 0.5f;
    self.startField.font = [UIFont systemFontOfSize:17.0f];
    [self.startField setTextColor:RGB(132, 132, 132)];
    self.startField.delegate = self;
    self.startField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.startField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.startField.backgroundColor = [UIColor whiteColor];
    self.startField.autocapitalizationType = NO;
    self.startField.tag = 3;
    [_scrollView addSubview:self.startField];
    
    UILabel *toLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth+15.0f+(width-labelWidth-2*15.0f)/3+6.0f, 30.0f+3*(30.0f+12.0f), width - 2*15.0f, 30.0f)];
    toLabel.textAlignment = NSTextAlignmentLeft;
    toLabel.textColor = RGB(120, 120, 120);
    toLabel.font = [UIFont systemFontOfSize:17.0f];
    toLabel.backgroundColor = [UIColor clearColor];
    toLabel.text = @"K 至";
    [_scrollView addSubview:toLabel];
    
    self.endField = [[UITextField alloc]initWithFrame:CGRectMake(labelWidth+15.0f+(width-labelWidth-2*15.0f)/3+6.0f+42.0f+6.0f, 30.0f+3*(30.0f+12.0f), (width-labelWidth-2*15.0f)/3, 30.0f)];
    self.endField.borderStyle = UITextBorderStyleNone;
    self.endField.layer.borderColor = [RGB(127, 127, 127) CGColor];
    self.endField.layer.borderWidth = 0.5f;
    self.endField.font = [UIFont systemFontOfSize:17.0f];
    [self.endField setTextColor:RGB(132, 132, 132)];
    self.endField.delegate = self;
    self.endField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.endField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.endField.backgroundColor = [UIColor whiteColor];
    self.endField.autocapitalizationType = NO;
    self.endField.tag = 4;
    [_scrollView addSubview:self.endField];
    
    UILabel *kLabel = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth+15.0f+(width-labelWidth-2*15.0f)*2/3+6.0f+42.0f+6.0f+6.0f, 30.0f+3*(30.0f+12.0f), width - 2*15.0f, 30.0f)];
    kLabel.textAlignment = NSTextAlignmentLeft;
    kLabel.textColor = RGB(120, 120, 120);
    kLabel.font = [UIFont systemFontOfSize:17.0f];
    kLabel.backgroundColor = [UIColor clearColor];
    kLabel.text = @"K";
    [_scrollView addSubview:kLabel];
    
    UILabel *hrLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 30.0f+4*(30.0f+12.0f), width - 2*15.0f, 30.0f)];
    hrLabel.textAlignment = NSTextAlignmentLeft;
    hrLabel.textColor = RGB(120, 120, 120);
    hrLabel.font = [UIFont systemFontOfSize:17.0f];
    hrLabel.backgroundColor = [UIColor clearColor];
    hrLabel.text = @"HR联系人";
    [_scrollView addSubview:hrLabel];
    
    self.hrField = [[UITextField alloc]initWithFrame:CGRectMake(labelWidth+15.0f, 30.0f+4*(30.0f+12.0f), width-labelWidth-2*15.0f, 30.0f)];
    self.hrField.borderStyle = UITextBorderStyleNone;
    self.hrField.layer.borderColor = [RGB(127, 127, 127) CGColor];
    self.hrField.layer.borderWidth = 0.5f;
    self.hrField.font = [UIFont systemFontOfSize:17.0f];
    [self.hrField setTextColor:RGB(132, 132, 132)];
    self.hrField.delegate = self;
    self.hrField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.hrField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.hrField.backgroundColor = [UIColor whiteColor];
    self.hrField.autocapitalizationType = NO;
    self.hrField.tag = 5;
    [_scrollView addSubview:self.hrField];
    _hrVeri = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth+15.0f, 30.0f+4*(30.0f+12.0f), (width-labelWidth-2*15.0f), 30.0f)];
    _hrVeri.textAlignment = NSTextAlignmentRight;
    _hrVeri.textColor = [UIColor redColor];
    _hrVeri.font = [UIFont systemFontOfSize:17.0f];
    _hrVeri.backgroundColor = [UIColor clearColor];
    _hrVeri.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    //_hrVeri.text = @"超出有效长度";
    _hrVeri.numberOfLines = 0;
    _hrVeri.hidden = YES;
    [_scrollView addSubview:_hrVeri];
    
    UILabel *hremailLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 30.0f+5*(30.0f+12.0f), width - 2*15.0f, 30.0f)];
    hremailLabel.textAlignment = NSTextAlignmentLeft;
    hremailLabel.textColor = RGB(120, 120, 120);
    hremailLabel.font = [UIFont systemFontOfSize:17.0f];
    hremailLabel.backgroundColor = [UIColor clearColor];
    hremailLabel.text = @"HR邮箱";
    [_scrollView addSubview:hremailLabel];
    
    self.hremailField = [[UITextField alloc]initWithFrame:CGRectMake(labelWidth+15.0f, 30.0f+5*(30.0f+12.0f), width-labelWidth-2*15.0f, 30.0f)];
    self.hremailField.borderStyle = UITextBorderStyleNone;
    self.hremailField.layer.borderColor = [RGB(127, 127, 127) CGColor];
    self.hremailField.layer.borderWidth = 0.5f;
    self.hremailField.font = [UIFont systemFontOfSize:17.0f];
    [self.hremailField setTextColor:RGB(132, 132, 132)];
    self.hremailField.delegate = self;
    self.hremailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.hremailField.clearButtonMode = UITextFieldViewModeWhileEditing; //清除之前内容
    self.hremailField.backgroundColor = [UIColor whiteColor];
    self.hremailField.autocapitalizationType = NO;
    self.hremailField.tag = 6;
    [_scrollView addSubview:self.hremailField];
    _hremailVeri = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth+15.0f, 30.0f+5*(30.0f+12.0f), (width-labelWidth-2*15.0f), 30.0f)];
    _hremailVeri.textAlignment = NSTextAlignmentRight;
    _hremailVeri.textColor = [UIColor redColor];
    
    _hremailVeri.font = [UIFont systemFontOfSize:17.0f];
    _hremailVeri.backgroundColor = [UIColor clearColor];
    _hremailVeri.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    //_hremailVeri.text = @"超出有效长度";
    _hremailVeri.numberOfLines = 0;
    _hremailVeri.hidden = YES;
    [_scrollView addSubview:_hremailVeri];
    
    UILabel *dutyLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 30.0f+6*(30.0f+12.0f), width - 2*15.0f, 30.0f)];
    dutyLabel.textAlignment = NSTextAlignmentLeft;
    dutyLabel.textColor = RGB(120, 120, 120);
    dutyLabel.font = [UIFont systemFontOfSize:17.0f];
    dutyLabel.backgroundColor = [UIColor clearColor];
    dutyLabel.text = @"岗位职责";
    [_scrollView addSubview:dutyLabel];
    
    _dutyView = [[UITextView alloc]initWithFrame:CGRectMake(labelWidth+15.0f, 30.0f+6*(30.0f+12.0f), width-labelWidth-2*15.0f, 70.0f)];
    _dutyView.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    _dutyView.layer.masksToBounds=YES;
    _dutyView.layer.borderWidth = 0.5f;
    _dutyView.layer.borderColor = [RGB(127, 127, 127) CGColor];
    _dutyView.font = [UIFont systemFontOfSize:17.0f];
    _dutyView.delegate = self;
    _dutyView.textColor = RGB(132, 132, 132);
    _dutyView.autocapitalizationType = NO;
    _dutyView.tag = 7;
    [_scrollView addSubview:_dutyView];
    _dutyVeri = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth+15.0f, 30.0f+6*(30.0f+12.0f), (width-labelWidth-2*15.0f), 30.0f)];
    _dutyVeri.textAlignment = NSTextAlignmentRight;
    _dutyVeri.textColor = [UIColor redColor];
    _dutyVeri.font = [UIFont systemFontOfSize:17.0f];
    _dutyVeri.backgroundColor = [UIColor clearColor];
    _dutyVeri.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    //_dutyVeri.text = @"超出有效长度";
    _dutyVeri.numberOfLines = 0;
    _dutyVeri.hidden = YES;
    [_scrollView addSubview:_dutyVeri];
    
    UILabel *askLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 30.0f+6*(30.0f+12.0f)+70.0f+12.0f, width - 2*15.0f, 30.0f)];
    askLabel.textAlignment = NSTextAlignmentLeft;
    askLabel.textColor = RGB(120, 120, 120);
    askLabel.font = [UIFont systemFontOfSize:17.0f];
    askLabel.backgroundColor = [UIColor clearColor];
    askLabel.text = @"任职要求";
    [_scrollView addSubview:askLabel];
    
    _askView = [[UITextView alloc]initWithFrame:CGRectMake(labelWidth+15.0f, 30.0f+6*(30.0f+12.0f)+70.0f+12.0f, width-labelWidth-2*15.0f, 70.0f)];
    _askView.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    _askView.layer.masksToBounds=YES;
    _askView.layer.borderWidth = 0.5f;
    _askView.layer.borderColor = [RGB(127, 127, 127) CGColor];
    _askView.font = [UIFont systemFontOfSize:17.0f];
    _askView.delegate = self;
    _askView.textColor = RGB(132, 132, 132);
    _askView.autocapitalizationType = NO;
    _askView.tag = 8;
    [_scrollView addSubview:_askView];
    _askVeri = [[UILabel alloc]initWithFrame:CGRectMake(labelWidth+15.0f, 30.0f+6*(30.0f+12.0f)+70.0f+12.0f, (width-labelWidth-2*15.0f), 30.0f)];
    _askVeri.textAlignment = NSTextAlignmentRight;
    _askVeri.textColor = [UIColor redColor];
    _askVeri.font = [UIFont systemFontOfSize:17.0f];
    _askVeri.backgroundColor = [UIColor clearColor];
    _askVeri.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    //_askVeri.text = @"超出有效长度";
    _askVeri.numberOfLines = 0;
    _askVeri.hidden = YES;
    [_scrollView addSubview:_askVeri];
    
    
    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, height - 60.0f, width, 60.0f)];
    sendBtn.backgroundColor = [UIColor whiteColor];
    [sendBtn setTitleColor:RGB(90, 90, 90) forState:UIControlStateNormal];
    [sendBtn setTitle:@"发布" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:25.0f];
    [sendBtn addTarget:self action:@selector(finishTalent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    
    _scrollView.contentSize = CGSizeMake(width, 30.0f+6*(30.0f+12.0f)+70.0f+12.0f+70.0f+30.0f);
    
    self.sendTalent = [[TSWSendTalent alloc] initWithBaseURL:TSW_API_BASE_URL path:SEND_TALENT];
    [self.sendTalent addObserver:self
                       forKeyPath:kResourceLoadingStatusKeyPath
                          options:NSKeyValueObservingOptionNew
                          context:nil];
    
    [self loadRegionData];
    
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
        if(object == _sendTalent){
            if (_sendTalent.isLoaded) {
                [self hideLoadingView];
                [self showSuccessMessage:@"发布成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if (_sendTalent.error) {
                [self showErrorMessage:[_sendTalent.error localizedFailureReason]];
            }
        }
    }
}

- (IBAction)someButtonTouched:(UIButton *)sender
{
    self.locatePicker = [[ZHAreaPickerView alloc] initWithDelegate:self];
    [self.locatePicker showInView:self.view];
}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(ZHAreaPickerView *)picker
{
    [self.addressBtn setTitle:[NSString stringWithFormat:@"%@", picker.locate.city] forState:UIControlStateNormal];
    self.selectedCityCode = picker.locate.cityCode;
}

-(void)hidePicker{
    [self.locatePicker cancelPicker];
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

- (void) loadRegionData{
    
}
-(void)finishTalent {
    // 提交前校验
    NSString *NUM = @"^[0-9]*$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", NUM];
    NSString * EMAIL = @"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$";
    NSPredicate *regextestemail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", EMAIL];
    if(_nameField.text.length > 0){
        if(_nameField.text.length<=128){
            _nameVeri.hidden = YES;
            if(_numField.text.length>0){
                if(_numField.text.length<=8){
                    if([regextestmobile evaluateWithObject:_numField.text] == YES){
                    _numVeri.hidden = YES;
                    if(_startField.text.length > 0){
                        if([regextestmobile evaluateWithObject:_startField.text] == YES){
                            if(_endField.text.length > 0){
                                if([regextestmobile evaluateWithObject:_endField.text] == YES){
                                    if(_hrField.text.length>0){
                                        if(_hrField.text.length<32){
                                            _hrVeri.hidden = YES;
                                            if(_hremailField.text.length>0){
                                                if(_hremailField.text.length<128){
                                                    if([regextestemail evaluateWithObject:_hremailField.text] == YES){
                                                        _hremailVeri.hidden = YES;
                                                        if(_dutyView.text.length>0){
                                                            if(_dutyView.text.length<=1024){
                                                                _dutyVeri.hidden = YES;
                                                                if(_askView.text.length>=0 && _askView.text.length<=1024){
                                                                        _askVeri.hidden = YES;
                                                                        [self showLoadingViewWithText:@"提交中..."];
                                                                        NSString *askText = @"";
                                                                    if(_askView.text){
                                                                        askText = _askView.text;
                                                                    }
                                                                    [self.sendTalent loadDataWithRequestMethodType:kHttpRequestMethodTypePost parameters:@{@"name":_nameField.text,@"cityCode":_selectedCityCode,@"amount":_numField.text,@"salaryMin":[_startField.text stringByAppendingString:@"000"] ,@"salaryMax":[_endField.text stringByAppendingString:@"000"],@"hr":_hrField.text,@"hrEmail":_hremailField.text,@"responsibility":_dutyView.text,@"requirements":askText}];
                                                                }else if(_askView.text.length>1024){
                                                                    _askVeri.hidden = NO;
                                                                }
                                                            }else{
                                                                _dutyVeri.hidden = NO;
                                                            }
                                                        }else{
                                                            //_dutyVeri.text = @"请填写岗位职责";
                                                            _dutyVeri.hidden = NO;
                                                        }
                                                    }else{
                                                        //_hremailVeri.text = @"请填写正确的邮箱";
                                                        _hremailVeri.hidden = NO;
                                                    }
                                                }else{
                                                    _hremailVeri.hidden = NO;
                                                }
                                            }else{
                                                //_hremailVeri.text = @"请填写HR邮箱";
                                                _hremailVeri.hidden = NO;
                                            }
                                        }else{
                                            _hrVeri.hidden = NO;
                                        }
                                    }else{
                                        //_hrVeri.text = @"请填写HR联系人";
                                        _hrVeri.hidden = NO;
                                    }
                                }else{
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"薪资范围请填写数字" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                    [alertView show];
                                }
                            }else{
                                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"请填写薪资范围" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                [alertView show];
                            }
                        }else{
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"薪资范围请填写数字" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                            [alertView show];
                        }
                    }else{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"请填写薪资范围" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alertView show];
                    }
                    }else{
                        //_numVeri.text = @"请填写数字";
                        _numVeri.hidden = NO;
                    }
                }else{
                    _numVeri.hidden = NO;
                }
            }else{
                //_numVeri.text = @"请填写人数需求";
                _numVeri.hidden = NO;
            }
        }else{
            _nameVeri.hidden = NO;
        }
        
    }else{
        //_nameVeri.text = @"请填写岗位名称";
        _nameVeri.hidden = NO;
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
    [_sendTalent removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSString *NUM = @"^[0-9]*$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", NUM];
    NSString * EMAIL = @"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$";
    NSPredicate *regextestemail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", EMAIL];
    switch (textField.tag) {
        case 1:
            if(_nameField.text.length>0){
                if(_nameField.text.length<=128){
                    _nameVeri.hidden = YES;
                }else{
                    _nameVeri.hidden = NO;
                }
            }else{
                //_nameVeri.text = @"请填写岗位名称";
                _nameVeri.hidden = NO;
            }
            break;
        case 2:
            if(_numField.text.length>0){
                if(_numField.text.length<=8){
                    if([regextestmobile evaluateWithObject:_numField.text] == YES){
                        _numVeri.hidden = YES;
                    }else{
                       // _numVeri.text = @"请填写数字";
                        _numVeri.hidden = NO;
                    }
                    
                }else{
                    _numVeri.hidden = NO;
                }
            }else{
               // _numVeri.text = @"请填写人数需求";
                _numVeri.hidden = NO;
            }
            break;
        case 3:
            if(_startField.text.length <= 0){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"请填写薪资范围" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }else if([regextestmobile evaluateWithObject:_startField.text] == NO){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"薪资范围请填写数字" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }
            break;
        case 4:
            if(_endField.text.length <= 0){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"请填写薪资范围" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }else if([regextestmobile evaluateWithObject:_startField.text] == NO){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"薪资范围请填写数字" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }
            break;
        case 5:
            if(_hrField.text.length>0){
                if(_hrField.text.length<=32){
                    _hrVeri.hidden = YES;
                }else{
                    _hrVeri.hidden = NO;
                }
            }else{
                //_hrVeri.text = @"请填写HR联系人";
                _hrVeri.hidden = NO;
            }
            break;
        case 6:
            if(_hremailField.text.length>0){
                if(_hremailField.text.length<=128){
                    if([regextestemail evaluateWithObject:_hremailField.text] == YES){
                        _hremailVeri.hidden = YES;
                    }else{
                        //_hremailVeri.text = @"请填写正确的邮箱";
                        _hremailVeri.hidden = NO;
                    }
                    
                }else{
                    _hremailVeri.hidden = NO;
                }
            }else{
                //_hremailVeri.text = @"请填写HR邮箱";
                _hremailVeri.hidden = NO;
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
        case 7:
            if(_dutyView.text.length>0){
                if(_dutyView.text.length<=1024){
                    _dutyVeri.hidden = YES;
                }else{
                    _dutyVeri.hidden = NO;
                }
            }else{
                //_dutyVeri.text = @"请填写岗位职责";
                _dutyVeri.hidden = NO;
            }
            break;
        case 8:
            if(_askView.text.length>0 && _askView.text.length<=1024){
                _askVeri.hidden = YES;
            }else{
                _askVeri.hidden = NO;
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
    CGFloat offset = self.view.frame.size.height - (textView.frame.origin.y+textView.frame.size.height+210+120);
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
    CGFloat offset = self.view.frame.size.height - (textField.frame.origin.y+textField.frame.size.height+320+50);
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
