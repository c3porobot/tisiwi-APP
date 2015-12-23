//
//  TSWOtherViewController.m
//  tianshiwan
//
//  Created by zhouhai on 15/10/1.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWOtherViewController.h"
#import "SVPullToRefresh.h"
#import "TSWOtherList.h"
#import "TSWOtherCell.h"
#import "TSWOtherDetailViewController.h"

@interface TSWOtherViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,TSWOtherCellDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) TSWOtherList *otherList;
@property (nonatomic, strong) UIButton *filterBtn;

@property (nonatomic, strong) NSString *titlex;
@end

@implementation TSWOtherViewController
- (void)dealloc
{
    [_otherList removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

- (instancetype)initWithType:(NSString *)type withTitle:(NSString *)title{
    self = [super init];
    if (self) {
        _titlex = title;
        self.otherList = [[TSWOtherList alloc] initWithBaseURL:TSW_API_BASE_URL path:[[OTHER_LIST stringByAppendingString:type]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [self.otherList addObserver:self
                             forKeyPath:kResourceLoadingStatusKeyPath
                                options:NSKeyValueObservingOptionNew
                                context:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.title = _titlex;
    self.view.backgroundColor = RGB(234, 234, 234);
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - self.navigationBarHeight) collectionViewLayout:collectionViewFlowLayout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[TSWOtherCell class] forCellWithReuseIdentifier:@"TSWOtherCell"];
    
    _dataArray = [NSMutableArray array];
    NSMutableArray *first = [[NSMutableArray alloc]init];
    [_dataArray addObject:first];
    [self refreshData];
    
    [self setupPullToRefresh];
    [self setupInfiniteScrolling];
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
    if(self.otherList.others){
        [self.otherList.others removeAllObjects];
    }
    self.otherList.isInfinite = YES;
    [self.otherList loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:@{@"page":@(self.otherList.page)}];
}

- (void)dismiss:(UIButton *)sender
{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
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

- (void) refreshData{
    self.otherList.page = 1;
    [_dataArray[0] removeAllObjects];
    [self.otherList loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
}

#pragma mark Key-value observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
        if (object == _otherList) {
            if (_otherList.isLoaded) {
                [self.collectionView.infiniteScrollingView stopAnimating];
                [self.collectionView.pullToRefreshView stopAnimating];
                if(_otherList.isInfinite){
                    for (TSWOther *other in _otherList.others) {
                        [_dataArray[1] addObject:other];
                    }
                    _otherList.isInfinite = NO;
                }else{
                    if([_dataArray count]<2){
                        // 如果是首次下拉刷新
                        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
                        [_dataArray addObject:tempArr];
                    }else{
                        // 如果是非首次下拉刷新
                        [self.dataArray[1] removeAllObjects];
                    }
                    for (TSWOther *other in _otherList.others) {
                        [_dataArray[1] addObject:other];
                    }
                }
//                if(_otherList.others){
//                    [_dataArray[0] addObjectsFromArray:_otherList.others];
//                }
                
                [self.collectionView reloadData];
            }
            else if (_otherList.error) {
                [self.collectionView.infiniteScrollingView stopAnimating];
                [self.collectionView.pullToRefreshView stopAnimating];
                [self showErrorMessage:[_otherList.error localizedFailureReason]];
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
    id object = array[indexPath.row];
    
    if ([object isKindOfClass:[TSWOther class]]) {
        TSWOtherCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TSWOtherCell" forIndexPath:indexPath];
        TSWOther *temp =(TSWOther *)object;
        cell.other = temp;
        cell.delegate = self;
        return cell;
        
    }else{
        TSWOtherCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TSWOtherCell" forIndexPath:indexPath];
        TSWOther *temp =(TSWOther *)object;
        cell.other = temp;
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

-(void) gotoOtherDetail:(TSWOtherCell *)cell withOther:(TSWOther *)other{
    TSWOtherDetailViewController *otherDetailController = [[TSWOtherDetailViewController alloc] initWithType:other.type OtherId:other.sid withName:other.name];
    [self.navigationController pushViewController:otherDetailController animated:YES];
}

@end
