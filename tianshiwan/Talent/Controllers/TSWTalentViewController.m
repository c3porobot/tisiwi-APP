//
//  TSWTalentViewController.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/6.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWTalentViewController.h"
#import "SVPullToRefresh.h"
#import "RDVTabBarController.h"
#import "TSWTalentCell.h"
#import "TSWTalent.h"
#import "TSWTalentList.h"
#import "TSWTalentDetailViewController.h"
#import "TSWTalentFilterViewController.h"
#import "GVUserDefaults+TSWProperties.h"
#import "TSWSendEmail.h"

@interface TSWTalentViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,TSWTalentCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) TSWTalentList *talentList;
@property (nonatomic, strong) UIButton *filterBtn;

@property (nonatomic, strong) TSWSendEmail *sendEmail;

@property (nonatomic) BOOL isPullRefresh;

@end

@implementation TSWTalentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.title = @"人才";
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
    
    [_collectionView registerClass:[TSWTalentCell class] forCellWithReuseIdentifier:@"TSWTalentCell"];
    
    // 处理数据
    self.talentList = [[TSWTalentList alloc] initWithBaseURL:TSW_API_BASE_URL path:TALENT_LIST];
    [self.talentList addObserver:self
                       forKeyPath:kResourceLoadingStatusKeyPath
                          options:NSKeyValueObservingOptionNew
                          context:nil];
    
    _dataArray = [NSMutableArray array];
    NSMutableArray *first = [[NSMutableArray alloc]init];
    [_dataArray addObject:first];
    
    [GVUserDefaults standardUserDefaults].searchTalentCityCode = @"";
    [GVUserDefaults standardUserDefaults].searchTalentSeniority = @"";
    [GVUserDefaults standardUserDefaults].searchTalentSalaryMin = @"";
    [GVUserDefaults standardUserDefaults].searchTalentSalaryMax = @"";
    [GVUserDefaults standardUserDefaults].searchTalentTitle = @"";
    
//    [self refreshData];
    
    [self setupPullToRefresh];
    [self setupInfiniteScrolling];
    [self refreshData]; //刷新数据
    
}

- (void)addRightNavigatorButton
{
    self.filterBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 58, 20, 48, 12)];
    [self.filterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.filterBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.filterBtn setTitle:@"筛选" forState:UIControlStateNormal];
    [self.filterBtn addTarget:self action:@selector(rightButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
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
//请求数据
- (void)requestData
{
    if(self.talentList.talents){
        [self.talentList.talents removeAllObjects];
    }
    [self.talentList loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:@{@"page":@(self.talentList.page),@"cityCode":[GVUserDefaults standardUserDefaults].searchTalentCityCode,@"seniority":[GVUserDefaults standardUserDefaults].searchTalentSeniority,@"salaryMin":[GVUserDefaults standardUserDefaults].searchTalentSalaryMin,@"salaryMax":[GVUserDefaults standardUserDefaults].searchTalentSalaryMax,@"title":[GVUserDefaults standardUserDefaults].searchTalentTitle}];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:NO];
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
    [_talentList removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [_sendEmail removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

//刷新数据
- (void) refreshData{
    self.talentList.page = 1;
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


- (void)rightButtonTapped: (UIButton *)sender{
    // 筛选
    TSWTalentFilterViewController *filterController = [[TSWTalentFilterViewController alloc]init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:filterController];
    [self presentViewController:navigationController animated:YES completion:^{
    }];
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

@end
