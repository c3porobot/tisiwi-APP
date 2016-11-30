//
//  TSWTalentAndFilterViewController.m
//  tianshiwan
//
//  Created by 刘鸿博 on 16/1/26.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "TSWTalentAndFilterViewController.h"
#import "SVPullToRefresh.h"
#import "RDVTabBarController.h"
#import "TSWTalentCell.h"
#import "TSWTalent.h"
#import "TSWTalentList.h"
#import "TSWTalentDetailViewController.h"
#import "TSWTalentFilterViewController.h"
#import "GVUserDefaults+TSWProperties.h"
#import "TSWSendEmail.h"
#import "TSWPassValue.h"
#import "ZHAreaPickerView.h"
#import "TSWGetPosition.h"
#import "TSWTalentPosition.h"
#import "TSWPassValue.h"
#import "TSWTalentFilterView.h"
#import "TSWNewAddTalentViewController.h"
@interface TSWTalentAndFilterViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,TSWTalentCellDelegate, UITextFieldDelegate, ZHAreaPickerDelegate,UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) TSWTalentList *talentList;
@property (nonatomic, strong) UIButton *filterBtn; //筛选按钮(导航栏右侧的按钮)
@property (nonatomic, strong) UIButton *orderBtn; //排序按钮(导航栏右侧的按钮)
@property (nonatomic, strong) TSWSendEmail *sendEmail;

@property (nonatomic) BOOL isPullRefresh;
@property (nonatomic, strong) UIButton *cityFilter;
@property (nonatomic, strong) UIButton *positionFilter;
@property (nonatomic, strong) UIButton *filterFilter;

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
@property (strong, nonatomic) TSWTalentFilterView *filterView; //筛选视图
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *grayView; //灰色视图
@property (nonatomic, assign) NSUInteger cun;
@property (nonatomic, assign) NSUInteger pos;
@property (nonatomic, assign) NSUInteger filt;
@end

static int num = 0;

@implementation TSWTalentAndFilterViewController

- (void)viewDidLoad {
    [TSWPassValue sharedValue].passvalue = 1;
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    _cun = 0;
    _pos = 0;
    _filt = 0;
    self.navigationBar.title = @"人才";
    self.view.backgroundColor = RGB(234, 234, 234);
    [self addRightNavigatorButton];
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, [UIScreen mainScreen].bounds.size.width,  45)];
    self.topView.backgroundColor = RGB(234, 234, 234);
    [self.view addSubview:_topView];
    [self.view addSubview:self.navigationBar];
    //布局collectionView
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight + 55, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - self.navigationBarHeight) collectionViewLayout:collectionViewFlowLayout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
     [_collectionView registerClass:[TSWTalentCell class] forCellWithReuseIdentifier:@"TSWTalentCell"];
    
    self.pickerViewTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.collectionView addSubview:self.pickerViewTextField];
    
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 230);
    self.pickerViewTextField.inputView = self.pickerView;
    
    self.cityFilter = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cityFilter.frame = CGRectMake(0,  5, [UIScreen mainScreen].bounds.size.width / 3, 40);
    [self.cityFilter setTitle:@"城市" forState:UIControlStateNormal];
    self.cityFilter.backgroundColor = [UIColor whiteColor];
//    self.cityFilter.titleLabel.font = [UIFont systemFontOfSize:12];
    self.cityFilter.tintColor =  RGB(127, 127, 127);
    [self.cityFilter addTarget:self action:@selector(cityBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:_cityFilter];
    
    self.positionFilter = [UIButton buttonWithType:UIButtonTypeSystem];
    self.positionFilter.frame = CGRectMake(CGRectGetMaxX(self.cityFilter.frame), 5, [UIScreen mainScreen].bounds.size.width / 3, 40);
    [self.positionFilter setTitle:@"职位" forState:UIControlStateNormal];
    self.positionFilter.backgroundColor = [UIColor whiteColor];
    [self.positionFilter addTarget:self action:@selector(showPositionPicker) forControlEvents:UIControlEventTouchUpInside];
    self.positionFilter.tintColor =  RGB(127, 127, 127);
    [self.topView addSubview:_positionFilter];
    
    self.filterFilter = [[UIButton alloc] init];
    self.filterFilter.frame = CGRectMake(CGRectGetMaxX(self.positionFilter.frame), 5, [UIScreen mainScreen].bounds.size.width / 3, 40);
    [self.filterFilter setTitleColor:RGB(127, 127, 127) forState:UIControlStateNormal];
    [self.filterFilter setTitle:@"筛选" forState:UIControlStateNormal];
    self.filterFilter.backgroundColor = [UIColor whiteColor];
    self.filterFilter.titleLabel.font = [UIFont systemFontOfSize:15.5f];
    [self.filterFilter addTarget:self action:@selector(showFieldPicker) forControlEvents:UIControlEventTouchUpInside];
    //self.filterFilter.tintColor =  RGB(127, 127, 127);
    [self.topView addSubview:_filterFilter];
    
    UIView *blackline1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cityFilter.frame), self.navigationBarHeight + 10, 0.5, 30)];
    blackline1.backgroundColor = RGB(234, 234, 234);
    [self.view addSubview:blackline1];
    
    UIView *blackline2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.positionFilter.frame), self.navigationBarHeight + 10, 0.5, 30)];
    blackline2.backgroundColor = RGB(234, 234, 234);
    [self.view addSubview:blackline2];
    
    
    // 处理数据
    
    
    
    
    _dataArray = [NSMutableArray array];
    NSMutableArray *first = [[NSMutableArray alloc]init];
    [_dataArray addObject:first];
    
    [GVUserDefaults standardUserDefaults].searchTalentCityCode = @"";
    [GVUserDefaults standardUserDefaults].searchTalentSeniority = @"";
    [GVUserDefaults standardUserDefaults].searchTalentSalaryMin = @"";
    [GVUserDefaults standardUserDefaults].searchTalentSalaryMax = @"";
    [GVUserDefaults standardUserDefaults].searchTalentTitle = @"";
    
    
    
   
    /**
     * 添加筛选视图
     */
    self.filterView = [[TSWTalentFilterView alloc]initWithFrame:CGRectMake(0, self.navigationBarHeight + 45, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height / 3.5)];
    
    UIButton *resettingBtn = (UIButton *)[self.filterView viewWithTag:101];
    dispatch_async(dispatch_get_main_queue(), ^{
        [resettingBtn addTarget:self action:@selector(handleResetting:) forControlEvents:UIControlEventTouchUpInside];
    });
    
    UIButton *completeBtn = (UIButton *)[self.filterView viewWithTag:102];
    dispatch_async(dispatch_get_main_queue(), ^{
        [completeBtn addTarget:self action:@selector(handleComplete:) forControlEvents:UIControlEventTouchUpInside];
    });
    //[self.view addSubview:self.filterView];
    /**
     *
     */
    //[self.view bringSubviewToFront:self.topView];
    [self setupPullToRefresh];
    [self setupInfiniteScrolling];
    [self refreshData]; //刷新数据
    
    self.grayView = [[UIView alloc] initWithFrame:self.view.frame];
    _grayView.backgroundColor = [UIColor grayColor];
    _grayView.alpha = 0.3;
    _grayView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePicker)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    if (!resettingBtn) {
        tapGestureRecognizer.cancelsTouchesInView = NO;
    }
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    
}
#pragma mark -- 筛选按钮响应事件
- (void)handleResetting:(UIButton *)sender {
        self.filterView.expTextField.text = @"";
        self.filterView.salaryTextField.text = @"";
        num = 0;
}

- (void)handleComplete:(UIButton *)sender {
        [self refreshData];
        [self.filterView removeFromSuperview];
        [_grayView removeFromSuperview]; //灰色视图消失
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)addRightNavigatorButton
{
    self.filterBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 40, 20, 32, 30)];
    [self.filterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.filterBtn.titleLabel.font = [UIFont systemFontOfSize:34.0f];
    //[self.filterBtn setTitle:@"新增" forState:UIControlStateNormal];
    //[self.filterBtn setImage:[UIImage imageNamed:@"write_n"] forState:UIControlStateNormal];
    [self.filterBtn setTitle:@"+" forState:UIControlStateNormal];
    [self.filterBtn addTarget:self action:@selector(rightButtonTapped1:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar setRightButton:self.filterBtn];
    
    self.orderBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 106, 20, 48, 12)];
    [self.orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.orderBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.orderBtn setTitle:@"排序" forState:UIControlStateNormal];
    [self.orderBtn addTarget:self action:@selector(rightButtonTapped2:) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationBar setRightButton:self.orderBtn];
}

- (void)setupPullToRefresh
{
    __weak __typeof(&*self)weakSelf = self;
    [self.collectionView addPullToRefreshWithActionHandler:^{
            
            [weakSelf refreshData];
    }];
    
    [self.collectionView.pullToRefreshView setTitle:@"下拉即可刷新..." forState:SVPullToRefreshStateStopped];
    [self.collectionView.pullToRefreshView setTitle:@"刷新中..." forState:SVPullToRefreshStateLoading];
    [self.collectionView.pullToRefreshView setTitle:@"松开即可刷新..." forState:SVPullToRefreshStateTriggered];
}

- (void)setupInfiniteScrolling
{
    self.collectionView.showsInfiniteScrolling = NO;
    
    __weak __typeof(&*self)weakSelf = self;
    
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        if (num == 0) {
            [weakSelf requestData];
        } else if (num == 1){
            NSLog(@"################%d", num);
        }
    }];
}
//请求数据
- (void)requestData
{
    if(self.talentList.talents){
        [self.talentList.talents removeAllObjects];
    }
    [self.talentList loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:@{@"page":@(self.talentList.page),@"cityCode1":[GVUserDefaults standardUserDefaults].searchTalentCityCode,@"seniority":[GVUserDefaults standardUserDefaults].searchTalentSeniority,@"salaryMin":[GVUserDefaults standardUserDefaults].searchTalentSalaryMin,@"salaryMax":[GVUserDefaults standardUserDefaults].searchTalentSalaryMax,@"title":[GVUserDefaults standardUserDefaults].searchTalentTitle}];
}

/********************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:NO];
    self.talentList = [[TSWTalentList alloc] initWithBaseURL:TSW_API_BASE_URL path:TALENT_LIST];
    [self.talentList addObserver:self
                      forKeyPath:kResourceLoadingStatusKeyPath
                         options:NSKeyValueObservingOptionNew
                         context:nil];
    
    self.getPosition = [[TSWGetPosition alloc] initWithBaseURL:TSW_API_BASE_URL path:GET_POSITION];
    [self.getPosition addObserver:self
                       forKeyPath:kResourceLoadingStatusKeyPath
                          options:NSKeyValueObservingOptionNew
                          context:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([TSWPassValue sharedValue].passvalue == 1) {
            self.selectedCityCode = @"";
            self.selectedPosition = @"";
            self.filterView.expTextField.text = @"";
            self.filterView.salaryTextField.text = @"";
            _cun = 1;
            if (_cun == 1) {
                [self.cityFilter setTitle:@"城市" forState:UIControlStateNormal];
                [self.locatePicker.locatePicker selectRow:0 inComponent:0 animated:YES];
                //布局地区采集器,让他从视图最下边出现
                self.locatePicker = [[ZHAreaPickerView alloc] initWithDelegate:self withAll:YES];
                self.locatePicker.frame = CGRectMake(0, self.view.frame.size.height, [UIScreen mainScreen].bounds.size.width, 200);
                [self.view addSubview:self.locatePicker];
            }
            _pos = 1;
            if (_pos == 1) {
                [self.positionFilter setTitle:@"职位" forState:UIControlStateNormal];
                [self.pickerView selectRow:0 inComponent:0 animated:YES];
            }
            if (_filt == 1) {
                self.filterView.expTextField.text = @"";
                self.filterView.salaryTextField.text = @"";
            }
            [self refreshData];
        } else {
            
        }
    });
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.locatePicker removeFromSuperview];
    [self.pickerView removeFromSuperview];
    [self.filterView removeFromSuperview];
    [self.grayView removeFromSuperview];
    dispatch_async(dispatch_get_main_queue(), ^{
        [TSWPassValue sharedValue].passvalue = 1;
    });
    
    [_talentList removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [_getPosition removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];

}

- (void)viewDidDisappear:(BOOL)animated {
    _cun = 1;
    _pos = 1;
    _filt = 1;
}
- (void)dealloc
{
    //    [_sendEmail removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
//    [_positionFilter removeObserver:self forKeyPath:@"text"];

}

//刷新数据
- (void) refreshData{
    self.talentList.page = 1;
    [_dataArray[0] removeAllObjects];
    [self filterTalent];
    [self requestData];
    [_getPosition loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
}

#pragma mark Key-value observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
        if (object == _talentList) {
            if (_talentList.isLoaded) {
                [self.collectionView.pullToRefreshView stopAnimating];
                [self.collectionView.infiniteScrollingView stopAnimating];
                
                if(_talentList.talents){
                    [_dataArray[0] addObjectsFromArray:_talentList.talents];
                }
                [self.collectionView reloadData];
                
                [GVUserDefaults standardUserDefaults].searchTalentCityCode = @"";
                [GVUserDefaults standardUserDefaults].searchTalentSeniority = @"";
                [GVUserDefaults standardUserDefaults].searchTalentSalaryMin = @"";
                [GVUserDefaults standardUserDefaults].searchTalentSalaryMax = @"";
                [GVUserDefaults standardUserDefaults].searchTalentTitle = @"";
            }
            else if (_talentList.error) {
                [self.collectionView.pullToRefreshView stopAnimating];
                [self.collectionView.infiniteScrollingView stopAnimating];
                [self showErrorMessage:[_talentList.error localizedFailureReason]];
                
            }
        }else if(object == _sendEmail){
            if(_sendEmail.isLoaded){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，附件已发送到您的邮箱，请查收" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }else if(_sendEmail.error){
                [self showErrorMessage:[_sendEmail.error localizedFailureReason]];
            }
        }
    }
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
        if(object == _getPosition){
            if (_getPosition.isLoaded) {
                self.positionData = [[NSMutableArray alloc]init];
                TSWTalentPosition *position = [[TSWTalentPosition alloc]init];
                position.sid = @"";
                position.title = @"职位";
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
- (void) cityBtnTouched{
    _cun = 0;
    _grayView.userInteractionEnabled = YES;
    [self.view addSubview:_grayView];
    [self.locatePicker showInView:self.view];
    [self.locatePicker becomeFirstResponder];
    self.filterBtn.selected = !self.filterBtn.selected;
    [self.filterFilter setTitle:@"筛选" forState:UIControlStateNormal];
    [self.filterView removeFromSuperview];

}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(ZHAreaPickerView *)picker
{
    picker.tag = 201;
    NSString *name = @"";
    if(picker.locate.city){
        name = picker.locate.city;
       // self.cityFilter.titleLabel.font = [UIFont systemFontOfSize:15 weight:15];
        num = 1;
    }else{
        name = picker.locate.state;
        //self.cityFilter.titleLabel.font = [UIFont systemFontOfSize:15 weight:0];
        num = 0;
    }
    if (_cun == 0) {
        [self.cityFilter setTitle:[NSString stringWithFormat:@"%@", name] forState:UIControlStateNormal];
        self.selectedCityCode = picker.locate.cityCode;
        [self refreshData];
        
    }
    
    
}

-(void)hidePicker{
    //点击导航栏会回收采集器
    [self.pickerView removeFromSuperview];
    //[self.locatePicker cancelPicker];
    [self.locatePicker removeFromSuperview];
    [self.filterView removeFromSuperview];
    self.filterView.expTextField.text = @"";
    self.filterView.salaryTextField.text = @"";
    [self.view endEditing:YES];
    //灰色视图
    _grayView.userInteractionEnabled = NO;
    [_grayView removeFromSuperview];
   
}

- (IBAction)showPositionPicker
{
    //[self.pickerViewTextField becomeFirstResponder];
    _pos = 0;
    [self.filterView removeFromSuperview];
    [self.locatePicker removeFromSuperview];
    _grayView.userInteractionEnabled = YES;
    [self.view addSubview:_grayView];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    //打印动画块的位置
    //NSLog(@"动画执行之前的位置：%@",NSStringFromCGPoint(self.details.center));
    //首尾式动画
    [UIView beginAnimations:nil context:nil];
    //执行动画
    //设置动画执行时间
    [UIView setAnimationDuration:1];
    //设置代理
    [UIView setAnimationDelegate:self];
    //设置动画执行完毕调用的事件
    self.pickerView.center = CGPointMake(width / 2, height - 100);
    self.pickerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_pickerView];
    [self.view bringSubviewToFront:self.topView];
    [UIView setAnimationDidStopSelector:@selector(didStopAnimation)];
    [UIView commitAnimations];
   
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
    if (_pos == 0) {
        TSWTalentPosition *temp = (TSWTalentPosition *)[self.positionData objectAtIndex:row];
        [self.positionFilter setTitle:temp.title forState:UIControlStateNormal];
        if (![temp.title isEqualToString:@"职位"]) {
            //self.positionFilter.titleLabel.font = [UIFont systemFontOfSize:15 weight:15];
        } else {
            //self.positionFilter.titleLabel.font = [UIFont systemFontOfSize:15 weight:0];
        }
        _selectedPosition = temp.sid;
    }
    if (row == 0) {
        num = 0;
    } else {
        num = 1;
    }
    [self refreshData]; //选择器选择完毕之后自动刷新
}

-(void)filterTalent {
    _filt = 0;
    //num = 1;
    // 把搜索条件存到公共区域，然后在人才列表页面willAppear的时候重新搜索
    [GVUserDefaults standardUserDefaults].searchTalentCityCode = _selectedCityCode;
    [GVUserDefaults standardUserDefaults].searchTalentSeniority = self.filterView.expTextField.text;
    if ([GVUserDefaults standardUserDefaults].searchTalentSeniority != nil && ![[GVUserDefaults standardUserDefaults].searchTalentSeniority isEqualToString:@""]) {
        self.filterFilter.titleLabel.font = [UIFont systemFontOfSize:15 weight:15];
    } else {
        self.filterFilter.titleLabel.font = [UIFont systemFontOfSize:15 weight:0];
    }
    if (_filt == 0) {
        
        NSString *min = @"";
        if(self.filterView.salaryTextField.text!=nil && ![self.filterView.salaryTextField.text isEqualToString:@""]){
            min = [self.filterView.salaryTextField.text stringByAppendingString:@""];
            self.filterFilter.titleLabel.font = [UIFont systemFontOfSize:15 weight:15];
        } else {
            self.filterFilter.titleLabel.font = [UIFont systemFontOfSize:15 weight:0];
        }
        NSString *max = @"";
        if(self.filterView.salaryTextField.text!=nil && ![self.filterView.salaryTextField.text isEqualToString:@""]){
            max = [self.filterView.salaryTextField.text stringByAppendingString:@""];
            //self.filterFilter.titleLabel.font = [UIFont systemFontOfSize:15 weight:15];
        } else {
            //self.filterFilter.titleLabel.font = [UIFont systemFontOfSize:15 weight:0];
        }
        [GVUserDefaults standardUserDefaults].searchTalentSalaryMin = min;
        [GVUserDefaults standardUserDefaults].searchTalentSalaryMax = max;
    }
    [GVUserDefaults standardUserDefaults].searchTalentTitle = _selectedPosition;
}


#pragma mark  UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.dataArray count];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *array = self.dataArray[section];
    return [array count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = self.dataArray[indexPath.section];
    id object;
    if([array count]>0){
        object = array[indexPath.row];
    }
    
    
    if ([object isKindOfClass:[TSWTalent class]]) {
        TSWTalentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TSWTalentCell" forIndexPath:indexPath];
        TSWTalent *temp =(TSWTalent *)object;
        cell.talent = temp;
        cell.delegate = self;
        return cell;
        
    }else{
        TSWTalentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TSWTalentCell" forIndexPath:indexPath];
        TSWTalent *temp =(TSWTalent *)object;
        cell.talent = temp;
        cell.delegate = self;
        return cell;
    }
}

#pragma mark UICollectionViewDelegateFlowLayout
// 定义cell的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = CGRectGetWidth(self.collectionView.bounds);
    return CGSizeMake(width, 90);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if(section == 0){
        return UIEdgeInsetsMake(0.0F, 0.0F, 0.0F, 0.0F);
    }else{
        return UIEdgeInsetsMake(0.0F, 0.0F, 0.0F, 0.0F);
    }
}

// 定义上下cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0F;
}

// 定义左右cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0F;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark -- 导航栏右侧按钮
//筛选详细
- (void)rightButtonTapped1: (UIButton *)sender{
    TSWNewAddTalentViewController *newAddTalentVC = [[TSWNewAddTalentViewController alloc]init];
    [self.navigationController pushViewController:newAddTalentVC animated:YES];
    
}

- (void)rightButtonTapped2:(UIButton *)sender {

}
- (void) gotoTalentDetail:(TSWTalentCell *)cell withTalent:(TSWTalent *)talent{
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    TSWTalentDetailViewController *talentDetailController = [[TSWTalentDetailViewController alloc] initWithTalentId:talent.sid];
    talentDetailController.talentName = talent.name;
    [self.navigationController pushViewController:talentDetailController animated:YES];
}

-(void) email:(TSWTalent *)talent{
    if(_sendEmail){
        [_sendEmail removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    }
    
    self.sendEmail = [[TSWSendEmail alloc] initWithBaseURL:TSW_API_BASE_URL path:[[[[EMAIL stringByAppendingString:@"personnel"] stringByAppendingString:@"/"] stringByAppendingString:talent.sid] stringByAppendingString:@"/mail_attachment"]];
    
    [self.sendEmail addObserver:self
                     forKeyPath:kResourceLoadingStatusKeyPath
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    [self.sendEmail loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:@{@"serviceType":@"personnel",@"sid":talent.sid}];
}
- (void)showFieldPicker {
    //self.filterFilter.selected = !self.filterFilter.selected;
    CGFloat width = CGRectGetWidth(self.view.bounds);
    //CGFloat height = CGRectGetHeight(self.view.bounds);
    [self.filterView becomeFirstResponder];
    [self.view addSubview:_grayView];
    //移除地点控件
    [self.locatePicker removeFromSuperview];
    [self.pickerView removeFromSuperview];
    [self.filterFilter setTitle:@"筛选" forState:UIControlStateNormal];
    self.filterFilter.backgroundColor = [UIColor whiteColor];
    //打印动画块的位置
    //NSLog(@"动画执行之前的位置：%@",NSStringFromCGPoint(self.details.center));
    //首尾式动画
    [UIView beginAnimations:nil context:nil];
    //执行动画
    //设置动画执行时间
    [UIView setAnimationDuration:1];
    //设置代理
    [UIView setAnimationDelegate:self];
    //设置动画执行完毕调用的事件
    self.filterView.center = CGPointMake(width / 2, 64 + 0.5 * CGRectGetHeight(self.filterView.frame) + 45);
    self.filterView.backgroundColor = [UIColor whiteColor];
    
    _grayView.userInteractionEnabled = YES;
        [self.view addSubview:_filterView];
        [self.view bringSubviewToFront:self.topView];
        [UIView setAnimationDidStopSelector:@selector(didStopAnimation)];
        [UIView commitAnimations];
}

- (void)didStopAnimation {
    
}

- (void)didStopAnimation2 {
   
}

#pragma mark -- filterViewBtnAction
- (void)completeFilter:(UIButton *)sender {

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
