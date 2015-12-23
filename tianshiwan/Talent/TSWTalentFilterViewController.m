//
//  TSWTalentFilterViewController.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/28.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWTalentFilterViewController.h"
#import "ZHAreaPickerView.h"
#import "TSWGetPosition.h"
#import "TSWTalentPosition.h"
#import "GVUserDefaults+TSWProperties.h"

@interface TSWTalentFilterViewController ()<UITextFieldDelegate, ZHAreaPickerDelegate,UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UITextField *pickerViewTextField;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *positionData;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *cityBtn;
@property (nonatomic, strong) UITextField *yearsField;
@property (nonatomic, strong) UITextField *salaryAField;
@property (nonatomic, strong) UITextField *salaryBField;
@property (nonatomic, strong) UIButton *positionBtn;

@property (strong, nonatomic) ZHAreaPickerView *locatePicker;
@property (strong, nonatomic) NSString *selectedCityCode;

@property (strong, nonatomic) TSWGetPosition *getPosition;
@property (strong, nonatomic) NSString *selectedPosition;
@end

@implementation TSWTalentFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    self.navigationBar.title = @"人才";
    self.view.backgroundColor = RGB(234, 234, 234);
    _selectedPosition = @"";
    _selectedCityCode = @"";
    
    if ([self.navigationController.viewControllers indexOfObject:self] == 0) {
        CGRect dismissButtonFrame = CGRectMake(00.0f, 0.0f, 21.0f, 44.0f);
        
        UIButton *dismissButton = [[UIButton alloc] initWithFrame:dismissButtonFrame];
        dismissButton.backgroundColor = [UIColor clearColor];
        [dismissButton setImage:[UIImage imageNamed:@"back_icon_normal"] forState:UIControlStateNormal];
        [dismissButton setImage:[UIImage imageNamed:@"back_icon_highlighted"] forState:UIControlStateHighlighted];
        [dismissButton setImageEdgeInsets:UIEdgeInsetsMake(0,10.0f,0,0)];
        [dismissButton setTitle:@" " forState:UIControlStateNormal];
        [dismissButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [dismissButton setTitleColor:MAIN_COLOR forState:UIControlStateHighlighted];
        [dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationBar.leftButton = dismissButton;
    }
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight, width, height-self.navigationBarHeight)];
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_scrollView];
    
    UILabel *cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 30.0f, width - 2*15.0f, 20.0f)];
    cityLabel.textAlignment = NSTextAlignmentLeft;
    cityLabel.textColor = RGB(120, 120, 120);
    cityLabel.font = [UIFont systemFontOfSize:14.0f];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.text = @"城市:";
    [_scrollView addSubview:cityLabel];
    
    
    self.cityBtn = [[UIButton alloc]initWithFrame:CGRectMake(40.0f+15.0f, 30.0f, (width-40.0f-2*15.0f), 20.0f)];
    self.cityBtn.backgroundColor = [UIColor whiteColor];
    self.cityBtn.layer.borderColor = [RGB(127, 127, 127) CGColor];
    self.cityBtn.layer.borderWidth = 0.5f;
    [self.cityBtn setTitleColor:RGB(132, 132, 132) forState:UIControlStateNormal];
    [self.cityBtn setTitle:@"全部城市" forState:UIControlStateNormal];
    self.cityBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.cityBtn addTarget:self action:@selector(cityBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:self.cityBtn];
    
    UILabel *yearsLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 30.0f+1*(20.0f+12.0f), width - 2*15.0f, 20.0f)];
    yearsLabel.textAlignment = NSTextAlignmentLeft;
    yearsLabel.textColor = RGB(120, 120, 120);
    yearsLabel.font = [UIFont systemFontOfSize:14.0f];
    yearsLabel.backgroundColor = [UIColor clearColor];
    yearsLabel.text = @"年限:";
    [_scrollView addSubview:yearsLabel];
    
    self.yearsField = [[UITextField alloc]initWithFrame:CGRectMake(40.0f+15.0f, 30.0f+1*(20.0f+12.0f), (width-40.0f-2*15.0f)/3, 20.0f)];
    self.yearsField.borderStyle = UITextBorderStyleNone;
    self.yearsField.layer.borderColor = [RGB(127, 127, 127) CGColor];
    self.yearsField.layer.borderWidth = 0.5f;
    self.yearsField.font = [UIFont systemFontOfSize:12.0f];
    [self.yearsField setTextColor:RGB(132, 132, 132)];
    self.yearsField.delegate = self;
    self.yearsField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.yearsField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.yearsField.backgroundColor = [UIColor whiteColor];
    self.yearsField.autocapitalizationType = NO;
    [_scrollView addSubview:self.yearsField];
    
    UILabel *upLabel = [[UILabel alloc]initWithFrame:CGRectMake(40.0f+15.0f+(width-40.0f-2*15.0f)/3+6.0f, 30.0f+1*(20.0f+12.0f), width - 2*15.0f, 20.0f)];
    upLabel.textAlignment = NSTextAlignmentLeft;
    upLabel.textColor = RGB(120, 120, 120);
    upLabel.font = [UIFont systemFontOfSize:14.0f];
    upLabel.backgroundColor = [UIColor clearColor];
    upLabel.text = @"年以上";
    [_scrollView addSubview:upLabel];
    
    UILabel *salaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 30.0f+2*(20.0f+12.0f), width - 2*15.0f, 20.0f)];
    salaryLabel.textAlignment = NSTextAlignmentLeft;
    salaryLabel.textColor = RGB(120, 120, 120);
    salaryLabel.font = [UIFont systemFontOfSize:14.0f];
    salaryLabel.backgroundColor = [UIColor clearColor];
    salaryLabel.text = @"薪资:";
    [_scrollView addSubview:salaryLabel];
    
    self.salaryAField = [[UITextField alloc]initWithFrame:CGRectMake(40.0f+15.0f, 30.0f+2*(20.0f+12.0f), (width-40.0f-2*15.0f)/3, 20.0f)];
    self.salaryAField.borderStyle = UITextBorderStyleNone;
    self.salaryAField.layer.borderColor = [RGB(127, 127, 127) CGColor];
    self.salaryAField.layer.borderWidth = 0.5f;
    self.salaryAField.font = [UIFont systemFontOfSize:12.0f];
    [self.salaryAField setTextColor:RGB(132, 132, 132)];
    self.salaryAField.delegate = self;
    self.salaryAField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.salaryAField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.salaryAField.backgroundColor = [UIColor whiteColor];
    self.salaryAField.autocapitalizationType = NO;
    [_scrollView addSubview:self.salaryAField];
    
    UILabel *toLabel = [[UILabel alloc]initWithFrame:CGRectMake(40.0f+15.0f+(width-40.0f-2*15.0f)/3+6.0f, 30.0f+2*(20.0f+12.0f), width - 2*15.0f, 20.0f)];
    toLabel.textAlignment = NSTextAlignmentLeft;
    toLabel.textColor = RGB(120, 120, 120);
    toLabel.font = [UIFont systemFontOfSize:14.0f];
    toLabel.backgroundColor = [UIColor clearColor];
    toLabel.text = @"K 至";
    [_scrollView addSubview:toLabel];
    
    self.salaryBField = [[UITextField alloc]initWithFrame:CGRectMake(40.0f+15.0f+(width-40.0f-2*15.0f)/3+6.0f+42.0f+6.0f, 30.0f+2*(20.0f+12.0f), (width-40.0f-2*15.0f)/3, 20.0f)];
    self.salaryBField.borderStyle = UITextBorderStyleNone;
    self.salaryBField.layer.borderColor = [RGB(127, 127, 127) CGColor];
    self.salaryBField.layer.borderWidth = 0.5f;
    self.salaryBField.font = [UIFont systemFontOfSize:12.0f];
    [self.salaryBField setTextColor:RGB(132, 132, 132)];
    self.salaryBField.delegate = self;
    self.salaryBField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.salaryBField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.salaryBField.backgroundColor = [UIColor whiteColor];
    self.salaryBField.autocapitalizationType = NO;
    [_scrollView addSubview:self.salaryBField];
    
    UILabel *kLabel = [[UILabel alloc]initWithFrame:CGRectMake(40.0f+15.0f+(width-40.0f-2*15.0f)*2/3+6.0f+42.0f+6.0f+6.0f, 30.0f+2*(20.0f+12.0f), width - 2*15.0f, 20.0f)];
    kLabel.textAlignment = NSTextAlignmentLeft;
    kLabel.textColor = RGB(120, 120, 120);
    kLabel.font = [UIFont systemFontOfSize:14.0f];
    kLabel.backgroundColor = [UIColor clearColor];
    kLabel.text = @"K";
    [_scrollView addSubview:kLabel];
    
    UILabel *positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 30.0f+3*(20.0f+12.0f), width - 2*15.0f, 20.0f)];
    positionLabel.textAlignment = NSTextAlignmentLeft;
    positionLabel.textColor = RGB(120, 120, 120);
    positionLabel.font = [UIFont systemFontOfSize:14.0f];
    positionLabel.backgroundColor = [UIColor clearColor];
    positionLabel.text = @"职位:";
    [_scrollView addSubview:positionLabel];
    
    self.positionBtn = [[UIButton alloc]initWithFrame:CGRectMake(40.0f+15.0f, 30.0f+3*(20.0f+12.0f), (width-40.0f-2*15.0f)/2, 20.0f)];
    self.positionBtn.backgroundColor = [UIColor whiteColor];
    self.positionBtn.layer.borderColor = [RGB(127, 127, 127) CGColor];
    self.positionBtn.layer.borderWidth = 0.5f;
    [self.positionBtn setTitleColor:RGB(132, 132, 132) forState:UIControlStateNormal];
    [self.positionBtn setTitle:@"全部职位" forState:UIControlStateNormal];
    self.positionBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    CGSize size6 = [self.positionBtn.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f],NSFontAttributeName, nil]];
    self.positionBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -((width-40.0f-2*15.0f)/2-size6.width)+10.0f, 0, 0);
    [self.positionBtn addTarget:self action:@selector(showPositionPicker) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:self.positionBtn];
    
    // set the frame to zero
    self.pickerViewTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.pickerViewTextField];
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    // set change the inputView (default is keyboard) to UIPickerView
    self.pickerViewTextField.inputView = self.pickerView;
    
    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, height - 60.0f, width, 60.0f)];
    sendBtn.backgroundColor = [UIColor whiteColor];
    [sendBtn setTitleColor:RGB(90, 90, 90) forState:UIControlStateNormal];
    [sendBtn setTitle:@"确定" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [sendBtn addTarget:self action:@selector(filterTalent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    
    _scrollView.contentSize = CGSizeMake(width, 30.0f+5*(20.0f+12.0f)+70.0f+12.0f+70.0f+30.0f);

    self.getPosition = [[TSWGetPosition alloc] initWithBaseURL:TSW_API_BASE_URL path:GET_POSITION];
    [self.getPosition addObserver:self
                   forKeyPath:kResourceLoadingStatusKeyPath
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePicker)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self refreshData];
}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
        if(object == _getPosition){
            if (_getPosition.isLoaded) {
                self.positionData = [[NSMutableArray alloc]init];
                TSWTalentPosition *position = [[TSWTalentPosition alloc]init];
                position.sid = @"";
                position.title = @"全部职位";
                [self.positionData addObject:position];
                for(TSWTalentPosition *p in _getPosition.positions){
                    [self.positionData addObject:p];
                }
                [self.pickerView reloadAllComponents];
            }
            else if (_getPosition.error) {
                [self showErrorMessage:[_getPosition.error localizedFailureReason]];
            }
        }
    }
}

- (void)refreshData
{
    [_getPosition loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
}

-(void)dismiss{
    //    [[self getAppdelegate] removeTrackingArrayLastObject];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) cityBtnTouched{
    self.locatePicker = [[ZHAreaPickerView alloc] initWithDelegate:self withAll:YES];
    [self.locatePicker showInView:self.view];
}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(ZHAreaPickerView *)picker
{
    [self.cityBtn setTitle:[NSString stringWithFormat:@"%@", picker.locate.city] forState:UIControlStateNormal];
    self.selectedCityCode = picker.locate.cityCode;
}

-(void)hidePicker{
    [self.locatePicker cancelPicker];
    [self.pickerViewTextField resignFirstResponder];
    [self.view endEditing:YES];
}

- (IBAction)showPositionPicker
{
    [self.pickerViewTextField becomeFirstResponder];
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
    return [self.positionData count];
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    TSWTalentPosition *temp = (TSWTalentPosition *)[self.positionData objectAtIndex:row];
    NSString *item = temp.title;
    return item;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // perform some action
    TSWTalentPosition *temp = (TSWTalentPosition *)[self.positionData objectAtIndex:row];
    [self.positionBtn setTitle:temp.title forState:UIControlStateNormal];
    _selectedPosition = temp.sid;
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

-(void)filterTalent {
    // 把搜索条件存到公共区域，然后在人才列表页面willAppear的时候重新搜索
    [GVUserDefaults standardUserDefaults].searchTalentCityCode = _selectedCityCode;
    [GVUserDefaults standardUserDefaults].searchTalentSeniority = _yearsField.text;
    NSString *min = @"";
    if(_salaryAField.text!=nil && ![_salaryAField.text isEqualToString:@""]){
        min = [_salaryAField.text stringByAppendingString:@"000"];
    }
    NSString *max = @"";
    if(_salaryBField.text!=nil && ![_salaryBField.text isEqualToString:@""]){
        max = [_salaryBField.text stringByAppendingString:@"000"];
    }
    [GVUserDefaults standardUserDefaults].searchTalentSalaryMin = min;
    [GVUserDefaults standardUserDefaults].searchTalentSalaryMax = max;
    [GVUserDefaults standardUserDefaults].searchTalentTitle = _selectedPosition;
    [self dismiss];
}

- (void)dealloc
{
    [_getPosition removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

@end
