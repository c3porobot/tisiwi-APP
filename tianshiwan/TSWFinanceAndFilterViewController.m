//
//  TSWFinanceAndFilterViewController.m
//  tianshiwan
//
//  Created by 刘鸿博 on 16/1/25.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "TSWFinanceAndFilterViewController.h"
#import "SVPullToRefresh.h"
#import "TSWFinanceList.h"
#import "TSWFinanceCell.h"
#import "TSWFinanceDetailViewController.h"
#import "TSWFinanceFilterViewController.h"
#import "GVUserDefaults+TSWProperties.h"
#import "BeforeAuditFinaceViewController.h"
#import "TSWPassValue.h"
#import "ZHAreaPickerView.h"
#import "TSWGetRound.h"
#import "TSWGetField.h"
#import "TSWServiceRound.h"
#import "TSWServiceField.h"
#import "GVUserDefaults+TSWProperties.h"
#import "TSWPassValue.h"

@interface TSWFinanceAndFilterViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,TSWFinanceCellDelegate,ZHAreaPickerDelegate,UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) TSWFinanceList *financeList;
@property (nonatomic, strong) UIButton *filterBtn;
@property (nonatomic, strong) UIButton *cityFilter; //城市筛选
@property (nonatomic, strong) UIButton *stepFilter; //阶段筛选
@property (nonatomic, strong) UIButton *modelFilter; //模式筛选

@property (nonatomic, strong) UITextField *pickerViewTextField;
@property (nonatomic, strong) UITextField *pickerViewTF;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIPickerView *pickeV;
@property (nonatomic, strong) NSMutableArray *roundData;
@property (nonatomic, strong) NSMutableArray *fieldData;

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
@property (nonatomic, strong) NSString *selectedField;
@property (nonatomic, strong) NSMutableArray *selectedFields;
@end
@implementation TSWFinanceAndFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    self.navigationBar.title = @"投资机构";
    self.view.backgroundColor = RGB(234, 234, 234);
   // [self addRightNavigatorButton];
    self.pickerViewTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.pickerViewTextField];
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.pickerView.tag = 101;
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerViewTextField.inputView = self.pickerView;
    
    self.pickerViewTF = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.pickerViewTF];
    self.pickeV = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.pickeV.tag = 102;
    self.pickeV.backgroundColor = [UIColor whiteColor];
    self.pickeV.showsSelectionIndicator = YES;
    self.pickeV.dataSource = self;
    self.pickeV.delegate = self;
    self.pickerViewTF.inputView = self.pickeV;
    /**
     * 筛选器
     */
    self.cityFilter = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cityFilter.frame = CGRectMake(0, self.navigationBarHeight + 5, [UIScreen mainScreen].bounds.size.width / 3, 40);
    [self.cityFilter setTitle:@"城 市" forState:UIControlStateNormal];
    self.cityFilter.backgroundColor = [UIColor whiteColor];
    self.cityFilter.tintColor =  RGB(127, 127, 127);
    [self.cityFilter addTarget:self action:@selector(cityBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cityFilter];
    
    self.stepFilter = [UIButton buttonWithType:UIButtonTypeSystem];
    self.stepFilter.frame = CGRectMake(CGRectGetMaxX(self.cityFilter.frame), self.navigationBarHeight + 5, [UIScreen mainScreen].bounds.size.width / 3, 40);
    [self.stepFilter setTitle:@"轮 次" forState:UIControlStateNormal];
    self.stepFilter.backgroundColor = [UIColor whiteColor];
    [self.stepFilter addTarget:self action:@selector(showRoundPicker) forControlEvents:UIControlEventTouchUpInside];
    self.stepFilter.tintColor =  RGB(127, 127, 127);
    [self.view addSubview:_stepFilter];
    
    self.modelFilter = [UIButton buttonWithType:UIButtonTypeSystem];
    self.modelFilter.frame = CGRectMake(CGRectGetMaxX(self.stepFilter.frame), self.navigationBarHeight + 5, [UIScreen mainScreen].bounds.size.width / 3, 40);
    [self.modelFilter setTitle:@"领 域" forState:UIControlStateNormal];
    self.modelFilter.backgroundColor = [UIColor whiteColor];
    [self.modelFilter addTarget:self action:@selector(showFieldPicker) forControlEvents:UIControlEventTouchUpInside];
    self.modelFilter.tintColor =  RGB(127, 127, 127);
    [self.view addSubview:_modelFilter];
    
    UIView *blackline1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cityFilter.frame), self.navigationBarHeight + 10, 0.5, 30)];
    blackline1.backgroundColor = RGB(234, 234, 234);
    [self.view addSubview:blackline1];
    
    UIView *blackline2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.stepFilter.frame), self.navigationBarHeight + 10, 0.5, 30)];
    blackline2.backgroundColor = RGB(234, 234, 234);
    [self.view addSubview:blackline2];
    
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight + 55, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - self.navigationBarHeight) collectionViewLayout:collectionViewFlowLayout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[TSWFinanceCell class] forCellWithReuseIdentifier:@"TSWFinanceCell"];
    
    // 处理数据
    //旧的接口
    //self.financeList = [[TSWFinanceList alloc] initWithBaseURL:TSW_API_BASE_URL path:FINANCE_LIST];
    //新的接口
    self.financeList = [[TSWFinanceList alloc] initWithBaseURL:TSW_API_BASE_URL path:[FINANCE_LIST  stringByAppendingString:@"getdata"]];
    
    [self.financeList addObserver:self
                       forKeyPath:kResourceLoadingStatusKeyPath
                          options:NSKeyValueObservingOptionNew
                          context:nil];
    
    _dataArray = [NSMutableArray array];
    NSMutableArray *first = [[NSMutableArray alloc]init];
    [_dataArray addObject:first];
    
    /**
     * 筛选接口
     */
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
    
    [GVUserDefaults standardUserDefaults].searchServiceCityCode = @"";
    [GVUserDefaults standardUserDefaults].searchServiceRound = @"";
    [GVUserDefaults standardUserDefaults].searchServiceFields = (NSMutableArray *)@[];
    
    [self setupPullToRefresh];
    [self setupInfiniteScrolling];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePicker)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [self refreshData];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addRightNavigatorButton
{
    self.filterBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 58, 20, 48, 12)];
    [self.filterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.filterBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.filterBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [self.filterBtn addTarget:self action:@selector(filter:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar setRightButton:self.filterBtn];
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
        [weakSelf requestData];
    }];
}

- (void)requestData
{
    if(self.financeList.finances){
        [self.financeList.finances removeAllObjects];
    }
    NSData *jsonFields = [NSJSONSerialization dataWithJSONObject:[GVUserDefaults standardUserDefaults].searchServiceFields options:NSJSONWritingPrettyPrinted error:nil];
    NSString *text =[[NSString alloc] initWithData:jsonFields encoding:NSUTF8StringEncoding];
    
    [self.financeList loadDataWithRequestMethodType:kHttpRequestMethodTypePost parameters:@{@"page":@(self.financeList.page),@"cityCode":[GVUserDefaults standardUserDefaults].searchServiceCityCode,@"round":[GVUserDefaults standardUserDefaults].searchServiceRound,@"field":text, @"member": [GVUserDefaults standardUserDefaults].member}];
    //[self refreshData];
}

- (void)dismiss:(UIButton *)sender
{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void) filter:(id)sender{
    // 筛选
    TSWFinanceFilterViewController *filterController = [[TSWFinanceFilterViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:filterController];
    [self presentViewController:navigationController animated:YES completion:^{
        
    }];
    //  [self.navigationController pushViewController:navigationController animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([TSWPassValue sharedValue].passvalue == 1) {
        [self refreshData];
    } else if([TSWPassValue sharedValue].passvalue == 0 ){
        
    }
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
}


- (void)dealloc
{
    [_financeList removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [_getRound removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [_getField removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

- (void) refreshData{
    self.financeList.page = 1;
    [_dataArray[0] removeAllObjects];
    [self requestData];
    [_getRound loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
    [_getField loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
}

#pragma mark Key-value observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
        if (object == _financeList) {
            if (_financeList.isLoaded) {
                [self.collectionView.infiniteScrollingView stopAnimating];
                [self.collectionView.pullToRefreshView stopAnimating];
                //                [self.dataArray removeAllObjects];
                if(_financeList.finances){
                    [_dataArray[0] addObjectsFromArray:_financeList.finances];
                }
                [self.collectionView reloadData];
                
                [GVUserDefaults standardUserDefaults].searchServiceCityCode = @"";
                [GVUserDefaults standardUserDefaults].searchServiceRound = @"";
                [GVUserDefaults standardUserDefaults].searchServiceFields =(NSMutableArray *)@[];
            }
            else if (_financeList.error) {
                [self.collectionView.infiniteScrollingView stopAnimating];
                [self.collectionView.pullToRefreshView stopAnimating];
                [self showErrorMessage:[_financeList.error localizedFailureReason]];
            }
        }
    }
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
                self.fieldData = [[NSMutableArray alloc] init];
                TSWServiceField *field = [[TSWServiceField alloc] init];
                field.sid = @"";
                field.title = @"领域";
                [self.fieldData addObject:field];
                for (TSWServiceField *f in _getField.fields) {
                    [self.fieldData addObject:f];
                }
                [self.pickeV reloadAllComponents];
            }
            else if (_getField.error) {
                [self showErrorMessage:[_getField.error localizedFailureReason]];
            }
        }
    }
}

- (void) cityBtnTouched{
    self.locatePicker = [[ZHAreaPickerView alloc] initWithDelegate:self withAll:YES];
    [self.locatePicker showInView:self.view];
}
-(void)pickerDidChaneStatus:(ZHAreaPickerView *)picker
{
    NSString *name = @"";
    if(picker.locate.city){
        name = picker.locate.city;
    }else{
        name = picker.locate.state;
    }
    [self.cityFilter setTitle:[NSString stringWithFormat:@"%@", name] forState:UIControlStateNormal];
    self.selectedCityCode = picker.locate.cityCode;
}

-(void)hidePicker{
    [self.pickerViewTextField resignFirstResponder];
    [self.locatePicker cancelPicker];
    [self.view endEditing:YES];
}
//轮次
- (IBAction)showRoundPicker
{
    [self.pickerViewTextField becomeFirstResponder];
}
//领域
- (void)showFieldPicker {
    [self.pickerViewTF becomeFirstResponder];
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
    if (pickerView.tag == 101) {
        return [self.roundData count];
    } else {
        return [self.fieldData count];
    }
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 101) {
        TSWServiceRound *temp = (TSWServiceRound *)[self.roundData objectAtIndex:row];
        NSString *item = temp.title;
        return item;
    } else {
        TSWServiceField *temp = (TSWServiceField *)[self.fieldData objectAtIndex:row];
        NSString *item = temp.title;
        return item;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // perform some action
    if (pickerView.tag == 101) {
        TSWServiceRound *temp1 = (TSWServiceRound *)[self.roundData objectAtIndex:row];
        [self.stepFilter setTitle:temp1.title forState:UIControlStateNormal];
        _selectedRound = temp1.sid;
    } else {
        TSWServiceField *temp = (TSWServiceField *)[self.fieldData objectAtIndex:row];
        [self.modelFilter setTitle:temp.title forState:UIControlStateNormal];
        _selectedField = temp.sid;
    }
    
}


-(void)filterFinance {
    // 把搜索条件存到公共区域，然后在人才列表页面willAppear的时候重新搜索
    [GVUserDefaults standardUserDefaults].searchServiceCityCode = _selectedCityCode;
    [GVUserDefaults standardUserDefaults].searchServiceRound = _selectedRound;
    [GVUserDefaults standardUserDefaults].searchServiceFields = _selectedFields;
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
    
    if ([object isKindOfClass:[TSWFinance class]]) {
        TSWFinanceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TSWFinanceCell" forIndexPath:indexPath];
        TSWFinance *temp =(TSWFinance *)object;
        cell.finance = temp;
        cell.delegate = self;
        return cell;
        
    }else{
        TSWFinanceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TSWFinanceCell" forIndexPath:indexPath];
        TSWFinance *temp =(TSWFinance *)object;
        cell.finance = temp;
        cell.delegate = self;
        return cell;
    }
}

#pragma mark UICollectionViewDelegateFlowLayout
// 定义cell的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = CGRectGetWidth(self.collectionView.bounds);
    return CGSizeMake(width, 110);
    
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

-(void) gotoFinanceDetail:(TSWFinanceCell *)cell withFinance:(TSWFinance *)finance withResult:(TSWResult *)result{
    if ([finance.currentstatus isEqualToString:@"-2"] || [finance.currentstatus isEqualToString:@"-1"] || [finance.currentstatus isEqualToString:@"0"]) {
        BeforeAuditFinaceViewController *BAVC = [[BeforeAuditFinaceViewController alloc] initWithFinanceId:finance.sid];
        BAVC.investorName = finance.name;
        BAVC.sidValue = finance.sid;
        BAVC.currentStatus = finance.currentstatus;
        [self.navigationController pushViewController:BAVC animated:YES];
    } else if ([finance.currentstatus isEqualToString:@"1"]) {
        TSWFinanceDetailViewController *financeDetailController = [[TSWFinanceDetailViewController alloc] initWithFinanceId:finance.sid];
        financeDetailController.investorName = finance.name;
        [self.navigationController pushViewController:financeDetailController animated:YES];
        
    }
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
