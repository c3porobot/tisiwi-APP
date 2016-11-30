//
//  TSWNewTalentRequirementsViewController.m
//  tianshiwan
//
//  Created by 刘鸿博 on 16/3/18.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "TSWNewTalentRequirementsViewController.h"
#import "TSWFinancingCollectionReusableView.h"
#import "TSWPersonelRequirement.h"
#import "TSWFeedbackList.h"
#import "TSWFeedbackCell.h"
#import "SVPullToRefresh.h"
#define kCell @"feedback"
@interface TSWNewTalentRequirementsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) TSWPersonelRequirement *personnelDetail;
@property (nonatomic, strong) TSWFeedbackList *feedbackList;
@property (nonatomic, strong) NSString *sid;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *talentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *HRLabel;
@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) UIView *midView;
@property (nonatomic, strong) UILabel *jobStatus;


@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation TSWNewTalentRequirementsViewController

- (void)dealloc {
    [_personnelDetail removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [_feedbackList removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

- (instancetype)initWithPersonnelId:(NSString *)personnelId {
    self = [super init];
    if (self) {
        self.sid = personnelId;
        
        self.personnelDetail = [[TSWPersonelRequirement alloc] initWithBaseURL:TSW_API_BASE_URL path:[[PERSONNEL_DETAIL stringByAppendingString:self.sid]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [self.personnelDetail addObserver:self
                             forKeyPath:kResourceLoadingStatusKeyPath
                                options:NSKeyValueObservingOptionNew
                                context:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat width = CGRectGetWidth(self.view.bounds);
    //CGFloat height = CGRectGetHeight(self.view.bounds);
    self.view.backgroundColor = RGB(234, 234, 234);
    self.navigationBar.title = @"人才需求";
    self.navigationBar.bottomLineView.hidden = YES;
    
    self.dataArray = [NSMutableArray array];
    NSMutableArray *first = [[NSMutableArray alloc]init];
    [_dataArray addObject:first];
    
    self.feedbackList = [[TSWFeedbackList alloc] initWithBaseURL:TSW_API_BASE_URL path:[[[FEEDBACK_LIST stringByAppendingString:self.sid] stringByAppendingString:@"/personnel"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self.feedbackList addObserver:self forKeyPath:kResourceLoadingStatusKeyPath options:NSKeyValueObservingOptionNew context:nil];
    
//    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight, width, height - self.navigationBarHeight)];
//    _scrollView.backgroundColor = RGB(234, 234, 234);
//    [self.view addSubview:_scrollView];
    
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    collectionViewFlowLayout.headerReferenceSize = CGSizeMake(width, self.navigationBarHeight + self.topView.frame.size.height + self.midView.frame.size.height + 135);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - self.navigationBarHeight) collectionViewLayout:collectionViewFlowLayout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.backgroundColor = RGB(234, 234, 234);
    [_collectionView registerClass:[TSWFeedbackCell class] forCellWithReuseIdentifier:kCell];
    [self.view addSubview:_collectionView];
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationBarHeight, width, 120)];
    _topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_topView];
    
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 40, 40)];
    _logoImageView.image = [UIImage imageNamed:@"man"];
    [_topView addSubview:_logoImageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.logoImageView.frame) + 10, 20, width - CGRectGetMaxX(self.logoImageView.frame) - 100, 30)];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    self.titleLabel.numberOfLines = 0;
    [_topView addSubview:_titleLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), CGRectGetMinY(self.titleLabel.frame), CGRectGetWidth(self.titleLabel.frame), CGRectGetHeight(self.titleLabel.frame))];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.font = [UIFont systemFontOfSize:14.0f];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.timeLabel.numberOfLines = 0;
    [_topView addSubview:_timeLabel];
    
    self.statusLabel = [[UILabel alloc] init];
    [_topView addSubview:_statusLabel];
    
    self.talentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame), width - 30, CGRectGetHeight(self.titleLabel.frame))];
    self.talentLabel.textAlignment = NSTextAlignmentLeft;
    self.talentLabel.font = [UIFont systemFontOfSize:14.0f];
    self.talentLabel.numberOfLines = 0;
    [_topView addSubview:_talentLabel];
    
    self.HRLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.talentLabel.frame), width - 30, CGRectGetHeight(self.talentLabel.frame))];
    self.HRLabel.textAlignment = NSTextAlignmentLeft;
    self.HRLabel.font = [UIFont systemFontOfSize:14.0f];
    self.HRLabel.numberOfLines = 0;
    [_topView addSubview:_HRLabel];
    
    self.midView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topView.frame), width, 60)];
    _midView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_midView];
    
    self.jobStatus = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.logoImageView.frame) + 10, 20, width - CGRectGetMaxX(self.logoImageView.frame) - 100, 30)];
    self.jobStatus.textAlignment = NSTextAlignmentLeft;
    self.jobStatus.font = [UIFont systemFontOfSize:14.0f];
    self.jobStatus.numberOfLines = 0;
    [_midView addSubview:_jobStatus];
    
   
    //[self setupPullToRefresh];
    //[self setupInfiniteScrolling];
    
    [self refreshData];
}

- (void)configutreWithCollection {
    //布局collectionView
   
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
        
    }];
}


- (void) refreshData{
    [self.personnelDetail loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
    
    [self.feedbackList loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:@{@"sid":self.sid, @"type": @"personnel"}];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

#pragma mark Key-value observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
        if (object == _personnelDetail) {
            if (_personnelDetail.isLoaded) {
                [self setDetail:_personnelDetail];
            }
            else if (_personnelDetail.error) {
                [self showErrorMessage:[_personnelDetail.error localizedFailureReason]];
            }
        }
        if (object == _feedbackList) {
            if (_feedbackList.isLoaded) {
                [self.collectionView.pullToRefreshView stopAnimating];
                [self.collectionView.infiniteScrollingView stopAnimating];
               if (_feedbackList.feedbacks) {
                    [self.dataArray[0] addObjectsFromArray:_feedbackList.feedbacks];
                }
                [self.collectionView reloadData];
            } else if (_feedbackList.error) {
                [self.collectionView.pullToRefreshView stopAnimating];
                [self.collectionView.infiniteScrollingView stopAnimating];
                [self showErrorMessage:[_feedbackList.error localizedFailureReason]];
            }
            
        }
    }
}

- (void)setDetail:(TSWPersonelRequirement *)personnelDetail{
    CGFloat width = CGRectGetWidth(self.view.bounds);
    _personnelDetail = personnelDetail;
    if(_personnelDetail.status == 0){
        _statusLabel.text = @"已提交";
    }else if(_personnelDetail.status == 1){
        _statusLabel.text = @"处理中";
    }else if(_personnelDetail.status == 2){
        _statusLabel.text = @"已完成";
    }else if(_personnelDetail.status == 3){
        _statusLabel.text = @"关闭";
    }
    NSString *str = @"人才需求";
    _titleLabel.text = [[[[str stringByAppendingString:@" / "] stringByAppendingString:_statusLabel.text] stringByAppendingString:@" / "] stringByAppendingString:@"胖胖"];
    _talentLabel.text = [[[[[[personnelDetail.name stringByAppendingString:@" / 经验"] stringByAppendingString:personnelDetail.amount] stringByAppendingString:@"+年 / "] stringByAppendingString:@"月薪"] stringByAppendingString: personnelDetail.salary] stringByAppendingString:@"元"];
    _HRLabel.text = [[personnelDetail.hr stringByAppendingString:@" / "] stringByAppendingString:personnelDetail.hrEmail];
    
    _jobStatus.text = [@"岗位描述:" stringByAppendingString:personnelDetail.requirements];
    _jobStatus.numberOfLines = 0;
    CGSize titleSize = [_jobStatus.text boundingRectWithSize:CGSizeMake(width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _jobStatus.frame = CGRectMake(CGRectGetMaxX(self.logoImageView.frame) + 10, 5, width - 60, titleSize.height);
    [_midView addSubview:_jobStatus];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateStyle:NSDateFormatterMediumStyle];
    [formatter1 setTimeStyle:NSDateFormatterShortStyle];
    //[formatter1 setDateFormat:@"yyyy-MM-dd HH:MM:ss"];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    NSDate *datea1 = [NSDate dateWithTimeIntervalSince1970:[_personnelDetail.time doubleValue]];
    NSString *dateString1 = [formatter1 stringFromDate:datea1];
    _timeLabel.text = [[NSString alloc]initWithFormat:@"%@",dateString1];
    
    //
    //    self.top.frame = CGRectMake(12.0f, 18.0f, width-2*12.0f, 10.0f+12.0f+15.0f+12.0f+15.0f+12.0f+15.0f+12.0f+15.0f+titleSize.height+40.0f);
    //    self.bottom.frame = CGRectMake(15.0f, CGRectGetHeight(_top.frame)+12.0f+12.0f, width-2*15, 12.0f);
    //    self.scrollView.contentSize = CGSizeMake(width,CGRectGetHeight(self.top.frame)+12.0f+12.0f+12.0f);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *array = self.dataArray[indexPath.section];
    id object;
    if([array count]>0){
        object = array[indexPath.row];
    }
    if ([object isKindOfClass:[TSWFeedbackCell class]]) {
        TSWFeedbackCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCell forIndexPath:indexPath];
        TSWfeedBack *temp =(TSWfeedBack *)object;
        cell.feedback = temp;
        return cell;
    }else{
        TSWFeedbackCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCell forIndexPath:indexPath];
        TSWfeedBack *temp =(TSWfeedBack *)object;
        cell.feedback = temp;
        return cell;
    }
    
}





#pragma mark UICollectionViewDelegateFlowLayout
// 定义cell的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = CGRectGetWidth(self.collectionView.bounds);
    return CGSizeMake(width, 110);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.0F, 0.0F, 0.0F, 0.0F);
}

// 定义上下cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20.0F;
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

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//
//    UICollectionReusableView *reusableview = nil;
//    
//    if (kind == UICollectionElementKindSectionHeader){
//        
//        TSWFinancingCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCell forIndexPath:indexPath];
//        reusableview = headerView;
//        
//    }
//    return reusableview;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
