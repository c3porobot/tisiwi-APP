//
//  TSWHomeRootController.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/6.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWHomeRootController.h"
#import "SVPullToRefresh.h"
#import "RDVTabBarController.h"
#import "TSWBannersCell.h"
#import "GVUserDefaults+TSWProperties.h"
#import "TSWTalentViewController.h"
#import "TSWProfileViewController.h"
#import "TSWLoginViewController.h"
#import "TSWArticleCell.h"
#import "TSWArticle.h"
#import "TSWArticleList.h"
#import "TSWBanner.h"
#import "TSWBannerList.h"
#import "TSWArticleDetailsViewController.h"
#import "TSWLineCell.h"
#import "ZButton.h"

@interface TSWHomeRootController()<UICollectionViewDelegate, UICollectionViewDataSource,TSWBannersCellDelegate, TSWArticleCellDelegate, TSWLoginViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *filterBar;
@property (nonatomic, strong) TSWBannerList *bannerList;
@property (nonatomic, strong) TSWArticleList *articleList;
@property (nonatomic, assign) BOOL isFilterBarDisplay;

@end

@implementation TSWHomeRootController
{
    TSWBannersCell     *_bannerCell;
    UILabel           *_badgeView;
    UIButton          *_leftButton;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.isFilterBarDisplay = NO;
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationBar.title = @"天使湾";
    // 判断用户是否已登录，如果没有登录，则跳登录，如果登录再进首页
//    [GVUserDefaults standardUserDefaults].token = nil;
//    if (![GVUserDefaults standardUserDefaults].token) {
//        TSWLoginViewController *loginController = [[TSWLoginViewController alloc] init];
//        loginController.delegate = self;
//        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
//        [self presentViewController:navigationController animated:YES completion:^{
//        }];
//    }
//    NSLog(@"#########################%@", [GVUserDefaults standardUserDefaults].member);
//    NSLog(@"$$$$$$$$$$$$$$$$$$$$$%@", [GVUserDefaults standardUserDefaults].token);
    [self addRightNavigatorButton];
    [self addLeftNavigatorButton];
    
    
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight-25.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - self.navigationBarHeight+25.0f) collectionViewLayout:collectionViewFlowLayout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.backgroundColor = [UIColor whiteColor];
    //    [_collectionView setBackgroundColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:213/255.0 alpha:1]];
    
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[TSWBannersCell class] forCellWithReuseIdentifier:@"TSWBannersCell"];
    [_collectionView registerClass:[TSWLineCell class] forCellWithReuseIdentifier:@"TSWLineCell"];
    [_collectionView registerClass:[TSWArticleCell class] forCellWithReuseIdentifier:@"TSWArticleCell"];
    
    
    // 处理数据
    self.bannerList = [[TSWBannerList alloc] initWithBaseURL:TSW_API_BASE_URL path:BANNER_LIST];
    [self.bannerList addObserver:self
                       forKeyPath:kResourceLoadingStatusKeyPath
                          options:NSKeyValueObservingOptionNew
                          context:nil];
    self.articleList = [[TSWArticleList alloc] initWithBaseURL:TSW_API_BASE_URL path:ARTICLE_LIST];
    [self.articleList addObserver:self
                       forKeyPath:kResourceLoadingStatusKeyPath
                          options:NSKeyValueObservingOptionNew
                          context:nil];
    
    _dataArray = [NSMutableArray array];
    
    [self addFilterBar];
    [self.view bringSubviewToFront:self.navigationBar];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentView:) name:@"PresentView" object:nil];
    
//    [self refreshData];
    [self setupPullToRefresh];
    [self setupInfiniteScrolling];
}

/**
 *  Right Button Bar item
 *
 *  @param sender
 */
//static const CGFloat kAJRecoverButtonAmountLabelHeight = 16.0f; // Icon高度

- (void)addFilterBar{
    CGFloat width = CGRectGetWidth(self.view.bounds);
    self.filterBar = [[UIView alloc ]initWithFrame:CGRectMake(0.0f, 24.0f, width, 40.0f)];
    self.filterBar.backgroundColor = [UIColor whiteColor];
    
    UIButton *all = [[UIButton alloc]initWithFrame:CGRectMake(15.0f, 10.0f, (width-102)/4, 20.0f)];
    all.backgroundColor = RGB(82, 173, 233);
    [all setTitle:@"全部" forState:UIControlStateNormal];
    [all.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [all addTarget:self action:@selector(gotoAll) forControlEvents:UIControlEventTouchUpInside];
    [self.filterBar addSubview:all];
    
    UIButton *toutiao = [[UIButton alloc]initWithFrame:CGRectMake(15.0f+(width-102)/4+24.0f, 10.0f, (width-102)/4, 20.0f)];
    toutiao.backgroundColor = RGB(82, 173, 233);
    [toutiao setTitle:@"头条" forState:UIControlStateNormal];
    [toutiao.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [toutiao addTarget:self action:@selector(gotoToutiao) forControlEvents:UIControlEventTouchUpInside];
    [self.filterBar addSubview:toutiao];
    
    UIButton *baike = [[UIButton alloc]initWithFrame:CGRectMake(15.0f+2*(width-102)/4+2*24.0f, 10.0f, (width-102)/4, 20.0f)];
    baike.backgroundColor = RGB(82, 173, 233);
    [baike setTitle:@"百科" forState:UIControlStateNormal];
    [baike.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [baike addTarget:self action:@selector(gotoBaike) forControlEvents:UIControlEventTouchUpInside];
    [self.filterBar addSubview:baike];
    
    UIButton *huodong = [[UIButton alloc]initWithFrame:CGRectMake(15.0f+3*(width-102)/4+3*24.0f, 10.0f, (width-102)/4, 20.0f)];
    huodong.backgroundColor = RGB(82, 173, 233);
    [huodong setTitle:@"活动" forState:UIControlStateNormal];
    [huodong.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [huodong addTarget:self action:@selector(gotoHuodong) forControlEvents:UIControlEventTouchUpInside];
    [self.filterBar addSubview:huodong];
    
    [self.view addSubview:self.filterBar];
}

-(void) gotoAll{
    [self pushFilterBar];
    self.articleList.page = 1;
    if([_dataArray count]>=2){
        [_dataArray[1] removeAllObjects];
    }
    [self.articleList loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:@{@"type":@""}];
}

- (void)gotoToutiao{
    // 头条
    [self pushFilterBar];
    self.articleList.page = 1;
    if([_dataArray count]>=2){
        [_dataArray[1] removeAllObjects];
    }
    [self.articleList loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:@{@"type":@"article"}];
}

-(void) gotoBaike{
    // 搜索新的列表
    [self pushFilterBar];
    self.articleList.page = 1;
    if([_dataArray count]>=2){
        [_dataArray[1] removeAllObjects];
    }
    [self.articleList loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:@{@"type":@"wiki"}];
}

-(void)gotoHuodong{
    // 搜索新的列表
    [self pushFilterBar];
    self.articleList.page = 1;
    if([_dataArray count]>=2){
        [_dataArray[1] removeAllObjects];
    }
    [self.articleList loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:@{@"type":@"activity"}];
}

- (void)setupPullToRefresh
{
    __weak __typeof(&*self)weakSelf = self;
    [self.collectionView addPullToRefreshWithActionHandler:^{
        // hack：解决因为[self.view bringSubviewToFront:self.navigationBar];引起的collectionView偏移25px的问题。（不知为何产生）
        weakSelf.collectionView.frame = CGRectMake(0.0f, weakSelf.navigationBarHeight, CGRectGetWidth(weakSelf.view.bounds), CGRectGetHeight(weakSelf.view.bounds) - weakSelf.navigationBarHeight);
        
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

- (void)refreshData
{
//    if(self.articleList.articles){
//        [self.articleList.articles removeAllObjects];
//    }
//    self.articleList.page = 1;
    [self showLoadingView];
    [self.bannerList loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
}

- (void)requestData
{
    if(self.articleList.articles){
        [self.articleList.articles removeAllObjects];
    }
    self.articleList.isInfinite = YES;
    
    [self.articleList loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:@{@"page":@(self.articleList.page)}];
}

- (void)addRightNavigatorButton
{
    //使用UIButton的子类
    ZButton *rightButton=[[ ZButton alloc ] initWithFrame : CGRectMake (0, 31, 100, 44)];
    [rightButton setTitle : @"筛选" forState : UIControlStateNormal];
    [rightButton setImage :[ UIImage imageNamed:@"arrow"] forState : UIControlStateNormal];
    [rightButton setTitleColor :[ UIColor whiteColor ] forState : UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navigationBar addSubview :rightButton];
    [self.navigationBar setRightButton:rightButton];
}

- (void)addLeftNavigatorButton
{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 31, 44, 44)];
    [leftButton setImage:[UIImage imageNamed:@"top"]  forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"top"]  forState:UIControlStateHighlighted];
//    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(2, 14, 5, 9)];
    [leftButton addTarget:self action:@selector(leftButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar setLeftButton:leftButton];
}

- (void) rightButtonTapped:(id)sender{
    if(self.isFilterBarDisplay){
        [self pushFilterBar];
    }else{
        [self pullFilterBar];
    }
    
}

- (void) pullFilterBar{
    CGFloat width = CGRectGetWidth(self.view.bounds);
    //打印动画块的位置
    NSLog(@"动画执行之前的位置：%@",NSStringFromCGPoint(self.filterBar.center));
    //首尾式动画
    [UIView beginAnimations:nil context:nil];
    //执行动画
    //设置动画执行时间
    [UIView setAnimationDuration:0.5];
    //设置代理
    [UIView setAnimationDelegate:self];
    //设置动画执行完毕调用的事件
    [UIView setAnimationDidStopSelector:@selector(stopAnimating)];
    self.filterBar.center=CGPointMake(width/2, 84);
    [UIView commitAnimations];
    
    self.isFilterBarDisplay =YES;
}

- (void) pushFilterBar{
    CGFloat width = CGRectGetWidth(self.view.bounds);
    //打印动画块的位置
    NSLog(@"动画执行之前的位置：%@",NSStringFromCGPoint(self.filterBar.center));
    //首尾式动画
    [UIView beginAnimations:nil context:nil];
    //执行动画
    //设置动画执行时间
    [UIView setAnimationDuration:1.0];
    //设置代理
    [UIView setAnimationDelegate:self];
    //设置动画执行完毕调用的事件
    [UIView setAnimationDidStopSelector:@selector(stopAnimating)];
    self.filterBar.center=CGPointMake(width/2, 40);
    [UIView commitAnimations];
    
    self.isFilterBarDisplay = NO;
}

- (void)leftButtonTapped:(id)sender
{
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    TSWProfileViewController *pushController = [[TSWProfileViewController alloc] init];
    [self.navigationController pushViewController:pushController animated:YES];
}

#pragma mark Key-value observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
        if(object == _bannerList){
            if (_bannerList.isLoaded) {
                [self hideLoadingView];
                [self.collectionView.pullToRefreshView stopAnimating];
                [self.collectionView.infiniteScrollingView stopAnimating];
                if(self.dataArray.count>1){
                    // 如果是非首次下拉刷新
                    [self.dataArray[0] removeAllObjects];
                    [_dataArray[0] addObject:_bannerList];
                }else{
                    // 如果是首次下拉刷新
                    NSMutableArray *array = [[NSMutableArray alloc]init];
                    [array addObject:_bannerList];
                    [_dataArray addObject:array];
                }
                self.articleList.page = 1;
                [self.articleList loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
            }
            else if (_bannerList.error) {
                [self hideLoadingView];
                [self.collectionView.pullToRefreshView stopAnimating];
                [self.collectionView.infiniteScrollingView stopAnimating];
                [self showErrorMessage:[_bannerList.error localizedFailureReason]];
            }
        }else if(object == _articleList){
            if(_articleList.isLoaded){
                if(_articleList.articles){
                    [self.collectionView.infiniteScrollingView stopAnimating];
                    [self.collectionView.pullToRefreshView stopAnimating];
                    if(_articleList.isInfinite){
                        for (TSWArticle *article in _articleList.articles) {
                            [_dataArray[1] addObject:article];
                        }
                        _articleList.isInfinite = NO;
                    }else{
                        if([_dataArray count]<2){
                            // 如果是首次下拉刷新
                            NSMutableArray *tempArr = [[NSMutableArray alloc]init];
                            [_dataArray addObject:tempArr];
                        }else{
                            // 如果是非首次下拉刷新
                            [self.dataArray[1] removeAllObjects];
                        }
                        for (TSWArticle *article in _articleList.articles) {
                            [_dataArray[1] addObject:article];
                        }
                    }
                }
                [self.collectionView reloadData];

            }else if(_articleList.error){
                [self.collectionView.infiniteScrollingView stopAnimating];
                [self.collectionView.pullToRefreshView stopAnimating];
                [self showErrorMessage:[_articleList.error localizedFailureReason]];
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
        id obj = array[indexPath.row];
        if([obj isKindOfClass:[TSWBannerList class]])
        {
            
            if(!_bannerCell)
            {
                _bannerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TSWBannersCell" forIndexPath:indexPath];
            }
            _bannerCell.delegate = self;
            [_bannerCell.cycleScrollView setPlaceHolderImage:@"banner_default"];
            
            _bannerCell.banners = ((TSWBannerList *)obj).banners;
            return _bannerCell;
        }else if([obj isKindOfClass:[TSWArticle class]]){
            TSWArticleCell *articleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TSWArticleCell" forIndexPath:indexPath];
            TSWArticle *temp = (TSWArticle *)obj;
            articleCell.article = temp;
            articleCell.delegate = self;
            return articleCell;
        }else{
            TSWLineCell *lineCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TSWLineCell" forIndexPath:indexPath];
            return lineCell;
        }
}

#pragma mark UICollectionViewDelegateFlowLayout
// 定义cell的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = CGRectGetWidth(self.collectionView.bounds);
    if (indexPath.section==0) {
        // 计算宽度
        NSLog(@"banner高度:%f", width*710/1250);
        return CGSizeMake(width, width*710/1250);
    }else{
        return CGSizeMake(width, 120.5);
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.0F, 0.0F, 0.0F, 0.0F);
}

// 定义上下cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0F;
}

// 定义左右cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0F;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

-(void) gotoArticleDetail:(TSWArticleCell *)cell withArticle:(TSWArticle *)article{
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    TSWArticleDetailsViewController *articleDetailsController = [[TSWArticleDetailsViewController alloc]initWithArticleId:article.sid];
    [self.navigationController pushViewController:articleDetailsController animated:YES];
}

- (void) gotoDetail:(TSWBannersCell *)cell withBanner:(TSWBanner *)banner{
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    TSWArticleDetailsViewController *articleDetailsController = [[TSWArticleDetailsViewController alloc]initWithArticleId:banner.article];
    [self.navigationController pushViewController:articleDetailsController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
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
    [_bannerList removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [_articleList removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

-(void)presentView:(NSNotification*)notification{
    NSString *sid = [notification object];
    NSLog(@"===== receive notification1");
    //跳转到文章详情界面
    TSWArticleDetailsViewController *articleDetailsController = [[TSWArticleDetailsViewController alloc]initWithArticleId:sid withPresent:YES];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:articleDetailsController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end

