//
//  TSWFinanceFilterViewController.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/28.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWFinanceFilterViewController.h"
#import "ZHAreaPickerView.h"
#import "TSWGetRound.h"
#import "TSWGetField.h"
#import "TSWServiceRound.h"
#import "TSWServiceField.h"
#import "GVUserDefaults+TSWProperties.h"

@interface TSWFinanceFilterViewController ()<ZHAreaPickerDelegate,UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UITextField *pickerViewTextField;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *roundData;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *provinceBtn;
@property (nonatomic, strong) UIButton *cityBtn;
@property (nonatomic, strong) UIButton *stepBtn;
@property (nonatomic, strong) UIButton *fieldBtn;

@property (nonatomic, strong) UIView *fieldBtns;

@property (strong, nonatomic) ZHAreaPickerView *locatePicker;
@property (strong, nonatomic) NSString *selectedCityCode;

@property (nonatomic, strong) TSWGetRound *getRound;
@property (nonatomic, strong) TSWGetField *getField;

@property (nonatomic, strong) NSString *selectedRound;

@property (nonatomic, strong) NSMutableArray *selectedFields;

@end

@implementation TSWFinanceFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectedFields = [[NSMutableArray alloc]init];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    self.navigationBar.title = @"融资";
    self.view.backgroundColor = RGB(234, 234, 234);
    _selectedCityCode = @"";
    _selectedRound = @"";
    
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
    cityLabel.text = @"投资地区";
    [_scrollView addSubview:cityLabel];
    
    
    self.cityBtn = [[UIButton alloc]initWithFrame:CGRectMake(70.0f+15.0f, 30.0f, (width-70.0f-2*15.0f), 20.0f)];
    self.cityBtn.backgroundColor = [UIColor whiteColor];
    self.cityBtn.layer.borderColor = [RGB(127, 127, 127) CGColor];
    self.cityBtn.layer.borderWidth = 0.5f;
    [self.cityBtn setTitleColor:RGB(132, 132, 132) forState:UIControlStateNormal];
    [self.cityBtn setTitle:@"全部城市" forState:UIControlStateNormal];
    self.cityBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    CGSize size3 = [self.cityBtn.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f],NSFontAttributeName, nil]];
    self.cityBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -((width-70.0f-2*15.0f)/4-size3.width)+10.0f, 0, 0);
    [self.cityBtn addTarget:self action:@selector(cityBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:self.cityBtn];
    
    UILabel *stepLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 30.0f+1*(20.0f+12.0f), width - 2*15.0f, 20.0f)];
    stepLabel.textAlignment = NSTextAlignmentLeft;
    stepLabel.textColor = RGB(120, 120, 120);
    stepLabel.font = [UIFont systemFontOfSize:14.0f];
    stepLabel.backgroundColor = [UIColor clearColor];
    stepLabel.text = @"投资阶段:";
    [_scrollView addSubview:stepLabel];
    
    self.stepBtn = [[UIButton alloc]initWithFrame:CGRectMake(70.0f+15.0f, 30.0f+1*(20.0f+12.0f), (width-70.0f-2*15.0f)/4, 20.0f)];
    self.stepBtn.backgroundColor = [UIColor whiteColor];
    self.stepBtn.layer.borderColor = [RGB(127, 127, 127) CGColor];
    self.stepBtn.layer.borderWidth = 0.5f;
    [self.stepBtn setTitleColor:RGB(132, 132, 132) forState:UIControlStateNormal];
    [self.stepBtn setTitle:@"全部阶段" forState:UIControlStateNormal];
    self.stepBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    CGSize size4 = [self.stepBtn.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f],NSFontAttributeName, nil]];
    self.stepBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -((width-70.0f-2*15.0f)/4-size4.width)+10.0f, 0, 0);
    [self.stepBtn addTarget:self action:@selector(showRoundPicker) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:self.stepBtn];
    
    // set the frame to zero
    self.pickerViewTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.pickerViewTextField];
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    // set change the inputView (default is keyboard) to UIPickerView
    self.pickerViewTextField.inputView = self.pickerView;
    
    UILabel *fieldLabel = [[UILabel alloc]initWithFrame:CGRectMake(15.0f, 30.0f+2*(20.0f+12.0f), width - 2*15.0f, 20.0f)];
    fieldLabel.textAlignment = NSTextAlignmentLeft;
    fieldLabel.textColor = RGB(120, 120, 120);
    fieldLabel.font = [UIFont systemFontOfSize:14.0f];
    fieldLabel.backgroundColor = [UIColor clearColor];
    fieldLabel.text = @"投资领域";
    [_scrollView addSubview:fieldLabel];
    
    _fieldBtns = [[UIView alloc]initWithFrame:CGRectMake(5.0f, 30.0f+3*(20.0f+12.0f), width-2*5.0f, 20.0f)];
    [_scrollView addSubview:_fieldBtns];
    
    UIButton *sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, height - 60.0f, width, 60.0f)];
    sendBtn.backgroundColor = [UIColor whiteColor];
    [sendBtn setTitleColor:RGB(90, 90, 90) forState:UIControlStateNormal];
    [sendBtn setTitle:@"确定" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [sendBtn addTarget:self action:@selector(filterFinance) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    
    _scrollView.contentSize = CGSizeMake(width, 30.0f+5*(20.0f+12.0f)+70.0f+12.0f+70.0f+30.0f);
    
    self.getRound = [[TSWGetRound alloc] initWithBaseURL:TSW_API_BASE_URL path:GET_ROUND];
    [self.getRound addObserver:self
                       forKeyPath:kResourceLoadingStatusKeyPath
                          options:NSKeyValueObservingOptionNew
                          context:nil];
    
    self.getField = [[TSWGetField alloc] initWithBaseURL:TSW_API_BASE_URL path:GET_FIELD];
    [self.getField addObserver:self
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
        if(object == _getRound){
            if (_getRound.isLoaded) {
                self.roundData = [[NSMutableArray alloc]init];
                TSWServiceRound *round = [[TSWServiceRound alloc]init];
                round.sid = @"";
                round.title = @"全部阶段";
                [self.roundData addObject:round];
                for(TSWServiceRound *r in _getRound.rounds){
                    [self.roundData addObject:r];
                }
                [self.pickerView reloadAllComponents];
            }
            else if (_getRound.error) {
                [self showErrorMessage:[_getRound.error localizedFailureReason]];
            }
        }else if(object == _getField){
            if (_getField.isLoaded) {
                [self initField:_getField.fields];
            }
            else if (_getField.error) {
                [self showErrorMessage:[_getField.error localizedFailureReason]];
            }
        }
    }
}

- (void)refreshData
{
    [_getRound loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
    [_getField loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
}

-(void)initField:(NSMutableArray *)fields{
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat bound = width - 2*15;
    int i = 0;
    CGFloat w = 0;
    CGFloat h = 0;
    for (TSWServiceField *field in fields) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectZero];
        button.tag = [field.sid integerValue];
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(selectField:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:RGB(132, 132, 132) forState:UIControlStateNormal];
        [button setTitleColor:RGB(255, 255, 255) forState:UIControlStateSelected];
        //根据计算文字的大小
        
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]};
        CGFloat length = [field.title boundingRectWithSize:CGSizeMake(bound, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        //为button赋值
        [button setTitle:field.title forState:UIControlStateNormal];
        //设置button的frame
        button.frame = CGRectMake(10+w, h, length + 15 , 24);
        button.layer.borderColor = [RGB(127, 127, 127) CGColor];
        button.layer.borderWidth = 0.5f;
        button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        button.selected = NO;
        //当button的位置超出屏幕边缘时换行 width 只是button所在父视图的宽度
        if(10 + w + length + 15 > bound){
            w = 0; //换行时将w置为0
            h = h + button.frame.size.height + 10;//距离父视图也变化
            button.frame = CGRectMake(10+w, h, length + 15, 24);//重设button的frame
        }
        w = button.frame.size.width + button.frame.origin.x;
        [self.fieldBtns addSubview:button];
        i++;
    }
    _fieldBtns.frame = CGRectMake(5.0f, 30.0f+3*(20.0f+12.0f), width-2*5.0f, h + 24.0f + 10.0f);
    _scrollView.contentSize = CGSizeMake(width, 30.0f+3*(20.0f+12.0f)+CGRectGetHeight(_fieldBtns.frame)+60.0f);
    
}

-(void) selectField:(UIButton *)sender{
    if(sender.selected){
        sender.selected = NO;
        sender.backgroundColor = [UIColor clearColor];
        [_selectedFields removeObject:[NSString stringWithFormat:@"%li", (long)sender.tag]];
    }else{
        sender.selected = YES;
        sender.backgroundColor = RGB(32, 158, 217);
        [_selectedFields addObject:[NSString stringWithFormat:@"%li", (long)sender.tag]];
    }
}

- (void)dismiss{
    //    [[self getAppdelegate] removeTrackingArrayLastObject];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
   // [self.navigationController popToRootViewControllerAnimated:YES];
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
    NSString *name = @"";
    if(picker.locate.city){
        name = picker.locate.city;
    }else{
        name = picker.locate.state;
    }
    [self.cityBtn setTitle:[NSString stringWithFormat:@"%@", name] forState:UIControlStateNormal];
    self.selectedCityCode = picker.locate.cityCode;
}

-(void)hidePicker{
    [self.pickerViewTextField resignFirstResponder];
    [self.locatePicker cancelPicker];
    [self.view endEditing:YES];
}

- (IBAction)showRoundPicker
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
    return [self.roundData count];
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    TSWServiceRound *temp = (TSWServiceRound *)[self.roundData objectAtIndex:row];
    NSString *item = temp.title;
    return item;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // perform some action
    TSWServiceRound *temp = (TSWServiceRound *)[self.roundData objectAtIndex:row];
    [self.stepBtn setTitle:temp.title forState:UIControlStateNormal];
    _selectedRound = temp.sid;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self refreshData];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
}

-(void)filterFinance {
    // 把搜索条件存到公共区域，然后在人才列表页面willAppear的时候重新搜索
    [GVUserDefaults standardUserDefaults].searchServiceCityCode = _selectedCityCode;
    [GVUserDefaults standardUserDefaults].searchServiceRound = _selectedRound;
    [GVUserDefaults standardUserDefaults].searchServiceFields = _selectedFields;
    [self dismiss];
}

- (void)dealloc
{
    [_getRound removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [_getField removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

@end
