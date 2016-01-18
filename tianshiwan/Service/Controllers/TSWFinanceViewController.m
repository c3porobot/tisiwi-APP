//
//  TSWFinanceViewController.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/16.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWFinanceViewController.h"
#import "SVPullToRefresh.h"
#import "TSWFinanceList.h"
#import "TSWFinanceCell.h"
#import "TSWFinanceDetailViewController.h"
#import "TSWFinanceFilterViewController.h"
#import "GVUserDefaults+TSWProperties.h"
#import "BeforeAuditFinaceViewController.h"
@interface TSWFinanceViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,TSWFinanceCellDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) TSWFinanceList *financeList;
@property (nonatomic, strong) UIButton *filterBtn;
@end

@implementation TSWFinanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.title = @"投资机构";
    self.view.backgroundColor = RGB(234, 234, 234);
    [self addRightNavigatorButton];
    
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - self.navigationBarHeight) collectionViewLayout:collectionViewFlowLayout];
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
    
    [GVUserDefaults standardUserDefaults].searchServiceCityCode = @"";
    [GVUserDefaults standardUserDefaults].searchServiceRound = @"";
    [GVUserDefaults standardUserDefaults].searchServiceFields = (NSMutableArray *)@[];
    
    [self refreshData];
    [self setupPullToRefresh];
    [self setupInfiniteScrolling];
    [self refreshData];
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
    [self refreshData];
        
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
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_financeList removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

- (void) refreshData{
    self.financeList.page = 1;
    [_dataArray[0] removeAllObjects];
    [self requestData];
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

@end
