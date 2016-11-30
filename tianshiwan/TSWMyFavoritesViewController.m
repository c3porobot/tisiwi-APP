//
//  TSWMyFavoritesViewController.m
//  tianshiwan
//
//  Created by 刘鸿博 on 16/3/2.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "TSWMyFavoritesViewController.h"
#import "TSWArticleCell.h"
#import "TSWArticle.h"
#import "TSWLineCell.h"
#import "TSWArticleDetailsViewController.h"
#import "TSWArticleList.h"
#import "SVPullToRefresh.h"
#import "TSWBannerList.h"
#import "GVUserDefaults+TSWProperties.h"
#import "TSWTalentDetail.h"
#import "TSWTalentCell.h"
#import "TSWTalent.h"
#import "TSWTalentDetailViewController.h"
#import "RDVTabBarController.h"
#import "TSWTalentList.h"
#import "TSWOtherList.h"
#import "TSWOtherCell.h"
#import "TSWOtherDetailViewController.h"
#import "TSWFinanceCell.h"
#import "TSWFinanceList.h"
#import "TSWFinanceViewController.h"
#import "BeforeAuditFinaceViewController.h"
#import "TSWFinanceDetailViewController.h"
#import "TSWFinanceCell.h"
#define kWidth [UIScreen mainScreen].bounds.size.width //屏幕宽
#define kHeight [UIScreen mainScreen].bounds.size.height //屏幕高
@interface TSWMyFavoritesViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, TSWArticleCellDelegate, TSWTalentCellDelegate, TSWOtherCellDelegate, TSWFinanceCellDelegate>
@property (nonatomic, strong) UIView *segmentTopView; //分区选择器所在的视图
@property (nonatomic, strong) UISegmentedControl *segment; //分区选择器
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray; //数据源
@property (nonatomic, strong) TSWArticleList *articleList;
@property (nonatomic, strong) TSWBannerList *bannerList;
@property (nonatomic, strong) TSWTalentDetail *talentDetail;
@property (nonatomic, strong) TSWTalentList *talentList;
@property (nonatomic, strong) TSWOtherList *otherList;
@property (nonatomic, strong) NSMutableArray *talentDataArray; //人才数据源
@property (nonatomic, strong) NSMutableArray *otherListArray;
@property (nonatomic, strong) NSMutableArray *financingArray;
@property (nonatomic, strong) TSWFinanceList *financeList;


@end
static int talentNum = 0;
static int financeNum = 0;
@implementation TSWMyFavoritesViewController

//- (void)dealloc
//{
//    [_articleList removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
//    [_bannerList removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
//    [_talentList removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
//    
//}

- (void)viewWillDisappear:(BOOL)animated {
    [_articleList removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [_bannerList removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [_talentList removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [_otherList removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [_financeList removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.bannerList = [[TSWBannerList alloc] initWithBaseURL:TSW_API_BASE_URL path:BANNER_LIST];
    [self.bannerList addObserver:self
                      forKeyPath:kResourceLoadingStatusKeyPath
                         options:NSKeyValueObservingOptionNew
                         context:nil];
    
    self.articleList = [[TSWArticleList alloc] initWithBaseURL:TSW_API_BASE_URL path:[ARTICLE_LIST stringByAppendingString:[GVUserDefaults standardUserDefaults].member]];
    [self.articleList addObserver:self
                       forKeyPath:kResourceLoadingStatusKeyPath
                          options:NSKeyValueObservingOptionNew
                          context:nil];
    
    
    self.talentList = [[TSWTalentList alloc] initWithBaseURL:TSW_API_BASE_URL path:[TALENT_DETAIL stringByAppendingString:[GVUserDefaults standardUserDefaults].member]];
    [self.talentList addObserver:self
                      forKeyPath:kResourceLoadingStatusKeyPath
                         options:NSKeyValueObservingOptionNew
                         context:nil];
    
    self.otherList = [[TSWOtherList alloc] initWithBaseURL:TSW_API_BASE_URL path:[[OTHER_LISTCollection stringByAppendingString:[GVUserDefaults standardUserDefaults].member] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [self.otherList addObserver:self
                     forKeyPath:kResourceLoadingStatusKeyPath
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    
    self.financeList = [[TSWFinanceList alloc] initWithBaseURL:TSW_API_BASE_URL path:[[FINANCE_LISTCollection  stringByAppendingString:[GVUserDefaults standardUserDefaults].member] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [self.financeList addObserver:self
                       forKeyPath:kResourceLoadingStatusKeyPath
                          options:NSKeyValueObservingOptionNew
                          context:nil];
    
    [self setupPullToRefresh];
    [self setupInfiniteScrolling];
    
    [self refreshData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.title = @"我的收藏";
    self.view.backgroundColor = RGB(234, 234, 234);
    self.dataArray = [NSMutableArray array];
    self.talentDataArray = [NSMutableArray array];
    
    self.otherListArray = [NSMutableArray array];
    NSMutableArray *first = [[NSMutableArray alloc]init];
    [_otherListArray addObject:first];
    
    _financingArray = [NSMutableArray array];
    NSMutableArray *first1 = [[NSMutableArray alloc]init];
    [_financingArray addObject:first1];
    
    [self configureWithSegment];
    // Do any additional setup after loading the view.
    [self configutreWithCollection];
    
    

}
//布局分区选择器
- (void)configureWithSegment {
    self.segmentTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, kWidth, 50)];
    self.segmentTopView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.segmentTopView];
     self.segment = [[UISegmentedControl alloc] initWithItems:@[@"文章", @"投资人", @"服务", @"人才"]];
    _segment.frame = CGRectMake(kWidth / 2 - kWidth / (1.5 * 2), 10, kWidth / 1.5, 30);
    _segment.selectedSegmentIndex = 0;
    _segment.tintColor = [UIColor colorWithRed:33.0f/255.0f green:159.0f/255.0f blue:218.0f/255.0f alpha:1.0f];
    [_segment addTarget:self action:@selector(handleChange:) forControlEvents:UIControlEventValueChanged];
    [self.segmentTopView addSubview:_segment];
    
}
- (void)configutreWithCollection {
    //布局collectionView
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight + 63, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - self.navigationBarHeight) collectionViewLayout:collectionViewFlowLayout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[TSWArticleCell class] forCellWithReuseIdentifier:@"TSWArticleCell"];
    [_collectionView registerClass:[TSWLineCell class] forCellWithReuseIdentifier:@"TSWLineCell"];
     [_collectionView registerClass:[TSWTalentCell class] forCellWithReuseIdentifier:@"TSWTalentCell"];
    [_collectionView registerClass:[TSWOtherCell class] forCellWithReuseIdentifier:@"TSWOtherCell"];
     [_collectionView registerClass:[TSWFinanceCell class] forCellWithReuseIdentifier:@"TSWFinanceCell"];
    [self.view addSubview:_collectionView];
}
- (void)setupPullToRefresh
{
    __weak __typeof(&*self)weakSelf = self;
    [self.collectionView addPullToRefreshWithActionHandler:^{
        // hack：解决因为[self.view bringSubviewToFront:self.navigationBar];引起的collectionView偏移25px的问题。（不知为何产生）
        weakSelf.collectionView.frame = CGRectMake(0.0f, weakSelf.navigationBarHeight + 63, CGRectGetWidth(weakSelf.view.bounds), CGRectGetHeight(weakSelf.view.bounds) - weakSelf.navigationBarHeight);
        
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
       // [weakSelf requestData];
        [weakSelf refreshData];
    }];
}
- (void)refreshData
{
//    [self showLoadingView];
    if (_segment.selectedSegmentIndex == 0) {
        [self.bannerList loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
    } else if(_segment.selectedSegmentIndex == 3) {
        [self.talentList loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:@{@"memberid":[GVUserDefaults standardUserDefaults].member}];
    } else if (_segment.selectedSegmentIndex == 2) {
        [self.otherList loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:@{@"memberid":[GVUserDefaults standardUserDefaults].member}];
    } else if (_segment.selectedSegmentIndex == 1) {
        [self.financeList loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:@{@"memberid":[GVUserDefaults standardUserDefaults].member}];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- UISegmentController Action 
- (void)handleChange:(UISegmentedControl *)segment {
    switch (segment.selectedSegmentIndex) {
        case 0: {
            //[self.dataArray removeAllObjects];
            [self.collectionView reloadData];
            
        break;
        }
        case 1: {
            [self refreshData];
            [self.collectionView reloadData];
            break;
        }
        case 2: {
            [self refreshData];
            [self.collectionView reloadData];
        }
            break;
        case 3: {
            //[self.talentDataArray removeAllObjects];
            [self refreshData];
            [self.collectionView reloadData];
        }
            break;
        default:
            break;
    }

}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
            if(object == _bannerList){
                if (_bannerList.isLoaded) {
                    [self hideLoadingView];
                    [self.collectionView.pullToRefreshView stopAnimating];
                    [self.collectionView.infiniteScrollingView stopAnimating];
                    if(self.dataArray.count > 0){
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
                    } else {
                        //没有数据,移除数组中所有元素
                        [_dataArray removeAllObjects];
                    }
                    [self.collectionView reloadData];
                    
                }else if(_articleList.error){
                    [self.collectionView.infiniteScrollingView stopAnimating];
                    [self.collectionView.pullToRefreshView stopAnimating];
                    [self showErrorMessage:[_articleList.error localizedFailureReason]];
                }
            }
        }
        //人才
        if (object == _talentList) {
            if (_talentList.isLoaded) {
                [self.collectionView.pullToRefreshView stopAnimating];
                [self.collectionView.infiniteScrollingView stopAnimating];
                if(_talentList.talents){
                    if (self.talentDataArray.count > 0) {
                        [self.talentDataArray removeAllObjects];
                        [_talentDataArray addObjectsFromArray:_talentList.talents];
                        talentNum = 1;
                    } else {
                        if (talentNum == 0) {
                            [_talentDataArray addObjectsFromArray:_talentList.talents];
                        }
                    }
                } else {
                    talentNum = 0;
                    [_talentDataArray removeAllObjects];
                }
                [self.collectionView reloadData];
            }
            else if (_talentList.error) {
                [self.collectionView.pullToRefreshView stopAnimating];
                [self.collectionView.infiniteScrollingView stopAnimating];
                [self showErrorMessage:[_talentList.error localizedFailureReason]];
                
            }
        }
    
    if (object == _otherList) {
        if (_otherList.isLoaded) {
            [self.collectionView.infiniteScrollingView stopAnimating];
            [self.collectionView.pullToRefreshView stopAnimating];
            if(_otherList.isInfinite){
                for (TSWOther *other in _otherList.others) {
                    [_otherListArray[1] addObject:other];
                    NSLog(@"**************%@",_otherListArray[1]);
                }
                _otherList.isInfinite = NO;
            }else{
                if([_otherListArray count] < 2){
                    // 如果是首次下拉刷新
                    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
                    [_otherListArray addObject:tempArr];
                    NSLog(@"##################%@", _otherListArray);
                }else{
                    // 如果是非首次下拉刷新
                    [self.otherListArray[1] removeAllObjects];
                }
                
                for (TSWOther *other in _otherList.others) {
                    [_otherListArray[1] addObject:other];
                    NSLog(@"**************%@",_otherListArray[1]);
                }
            }
            //   if(_otherList.others){
            //   [_dataArray[0] addObjectsFromArray:_otherList.others];
            //   }
            
            [self.collectionView reloadData];
        }
        else if (_otherList.error) {
            [self.collectionView.infiniteScrollingView stopAnimating];
            [self.collectionView.pullToRefreshView stopAnimating];
            [self showErrorMessage:[_otherList.error localizedFailureReason]];
        }
    }
    
    if (object == _financeList) {
        if (_financeList.isLoaded) {
            [self.collectionView.infiniteScrollingView stopAnimating];
            [self.collectionView.pullToRefreshView stopAnimating];
            if(_financeList.finances){
                if (_financingArray.count > 0) {
                    [_financingArray[0] removeAllObjects];
                    [_financingArray[0] addObjectsFromArray:_financeList.finances];
                    financeNum = 1;
                } else {
                    if (financeNum == 0) {
                        [_financingArray[0] addObjectsFromArray:_financeList.finances];
                    }
                }
            }else {
                financeNum = 0;
                [_financingArray[0] removeAllObjects];
            }
            [self.collectionView reloadData];
        }
        else if (_financeList.error) {
            [self.collectionView.infiniteScrollingView stopAnimating];
            [self.collectionView.pullToRefreshView stopAnimating];
            [self showErrorMessage:[_financeList.error localizedFailureReason]];
        }
    }
}




#pragma mark  UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (_segment.selectedSegmentIndex == 0) {
    return [self.dataArray count] - 1;
    } else if (_segment.selectedSegmentIndex == 3){
    double val = sqrt([self.talentDataArray count]);
    return val;
    } else  if (_segment.selectedSegmentIndex == 2){
    return [self.otherListArray count] - 1;
    } else {
        return [self.financingArray count];
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_segment.selectedSegmentIndex == 0) {
        NSArray *array = self.dataArray[1];
        return [array count];
    } else if (_segment.selectedSegmentIndex == 3){
        NSArray *array = self.talentDataArray;
        return [array count];
    }else if (_segment.selectedSegmentIndex == 2){
        NSArray *array = self.otherListArray[1];
        return [array count];
    } else {
        NSArray *array = self.financingArray[0];
        return [array count];
    }
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_segment.selectedSegmentIndex == 0) {
        NSArray *array = self.dataArray[1];
        id obj = array[indexPath.row];
        
        if([obj isKindOfClass:[TSWArticle class]]){
            TSWArticleCell *articleCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TSWArticleCell" forIndexPath:indexPath];
            articleCell.backgroundColor = [UIColor whiteColor];
            TSWArticle *temp = (TSWArticle *)obj;
            articleCell.article = temp;
            articleCell.delegate = self;
            return articleCell;
        } else {
            TSWLineCell *lineCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TSWLineCell" forIndexPath:indexPath];
            return lineCell;
        }
    } else if (_segment.selectedSegmentIndex == 3){
        NSArray *array = self.talentDataArray;
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

    } else if (_segment.selectedSegmentIndex == 2){
        NSArray *array = self.otherListArray[1];
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

    } else {
        NSArray *array = self.financingArray[0];
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
}


    


#pragma mark UICollectionViewDelegateFlowLayout
// 定义cell的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = CGRectGetWidth(self.collectionView.bounds);
    if (_segment.selectedSegmentIndex == 0) {
        return CGSizeMake(width, 130);
    } else if(_segment.selectedSegmentIndex == 3){
        return CGSizeMake(width, 90);
    } else {
        return CGSizeMake(width, 110);
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
    TSWArticleDetailsViewController *articleDetailsController = [[TSWArticleDetailsViewController alloc]initWithArticleId:article.sid];
    [self.navigationController pushViewController:articleDetailsController animated:YES];
}

- (void) gotoTalentDetail:(TSWTalentCell *)cell withTalent:(TSWTalent *)talent{
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    TSWTalentDetailViewController *talentDetailController = [[TSWTalentDetailViewController alloc] initWithTalentId:talent.sid];
    talentDetailController.talentName = talent.name;
    [self.navigationController pushViewController:talentDetailController animated:YES];
}

-(void) gotoOtherDetail:(TSWOtherCell *)cell withOther:(TSWOther *)other{
    TSWOtherDetailViewController *otherDetailController = [[TSWOtherDetailViewController alloc] initWithType:other.type OtherId:other.sid withName:other.name];
    [self.navigationController pushViewController:otherDetailController animated:YES];
}

-(void) gotoFinanceDetail:(TSWFinanceCell *)cell withFinance:(TSWFinance *)finance withResult:(TSWResult *)result{
    if (![finance.currentstatus isEqualToString:@"2"]) {
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
    } else {
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
