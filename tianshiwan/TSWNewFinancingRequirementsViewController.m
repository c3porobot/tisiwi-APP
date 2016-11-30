//
//  TSWNewFinancingRequirementsViewController.m
//  tianshiwan
//
//  Created by 刘鸿博 on 16/3/17.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "TSWNewFinancingRequirementsViewController.h"
#import "TSWFinancingRequirement.h"
#import "TSWFeedbackList.h"
#import "SVPullToRefresh.h"
#import "TSWFeedbackCell.h"

@interface TSWNewFinancingRequirementsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) TSWFinancingRequirement *financeDetail;
@property (nonatomic, strong) TSWFeedbackList *feedbackList;
@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *financingLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *FALabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIView *midView;
@property (nonatomic, strong) UILabel *companyStatus;
@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@end
#define kCell @"financing"
@implementation TSWNewFinancingRequirementsViewController

- (void)dealloc
{
    [_financeDetail removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [_feedbackList removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

- (instancetype)initWithFinanceId:(NSString *)financeId {
    self = [super init];
    if (self) {
        self.sid = financeId;
        self.financeDetail = [[TSWFinancingRequirement alloc] initWithBaseURL:TSW_API_BASE_URL path:[[FINANCE_DETAIL stringByAppendingString:self.sid]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [self.financeDetail addObserver:self
                             forKeyPath:kResourceLoadingStatusKeyPath
                                options:NSKeyValueObservingOptionNew
                                context:nil];
    }
    return self;
}

- (void)viewDidLoad {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    [super viewDidLoad];
    self.view.backgroundColor = RGB(234, 234, 234);
    self.navigationBar.title = @"融资需求";
    self.navigationBar.bottomLineView.hidden = YES;
    
    self.dataArray = [NSMutableArray array];
    NSMutableArray *first = [[NSMutableArray alloc]init];
    [_dataArray addObject:first];
    
    self.feedbackList = [[TSWFeedbackList alloc] initWithBaseURL:TSW_API_BASE_URL path:[[[FEEDBACK_LIST stringByAppendingString:self.sid] stringByAppendingString:@"/financing"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"**************%@", self.sid);
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
    _logoImageView.image = [UIImage imageNamed:@"money"];
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
    
    self.financingLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame), width - 30, CGRectGetHeight(self.titleLabel.frame))];
    self.financingLabel.textAlignment = NSTextAlignmentLeft;
    self.financingLabel.font = [UIFont systemFontOfSize:14.0f];
    self.financingLabel.numberOfLines = 0;
    [_topView addSubview:_financingLabel];
    
    self.FALabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.financingLabel.frame), width - 30, CGRectGetHeight(self.financingLabel.frame))];
    self.FALabel.textAlignment = NSTextAlignmentLeft;
    self.FALabel.font = [UIFont systemFontOfSize:14.0f];
    self.FALabel.numberOfLines = 0;
    [_topView addSubview:_FALabel];
    
    self.midView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topView.frame), width, 60)];
    _midView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_midView];
    
    self.companyStatus = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.logoImageView.frame) + 10, 20, width - CGRectGetMaxX(self.logoImageView.frame) - 100, 30)];
    self.companyStatus.textAlignment = NSTextAlignmentLeft;
    self.companyStatus.font = [UIFont systemFontOfSize:14.0f];
    self.companyStatus.numberOfLines = 0;
    [_midView addSubview:_companyStatus];
    
//    [self setupPullToRefresh];
//    [self setupInfiniteScrolling];
    
    
//    _scrollView.contentSize = CGSizeMake(width, self.navigationBarHeight + _topView.frame.size.height + _midView.frame.size.height + self.collectionView.frame.size.height);
    [self refreshData];

    
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
    [self.financeDetail loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
    [self.feedbackList loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:@{@"sid":self.sid, @"type":@"financing"}];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Key-value observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
        if (object == _financeDetail) {
            if (_financeDetail.isLoaded) {
                [self setDetail:_financeDetail];
            }
            else if (_financeDetail.error) {
                [self showErrorMessage:[_financeDetail.error localizedFailureReason]];
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
- (void)setDetail:(TSWFinancingRequirement *)financeDetail{
    CGFloat width = CGRectGetWidth(self.view.bounds);
    _financeDetail = financeDetail;
    if(_financeDetail.status == 0){
        _statusLabel.text = @"已提交";
    }else if(_financeDetail.status == 1){
        _statusLabel.text = @"处理中";
    }else if(_financeDetail.status == 2){
        _statusLabel.text = @"已完成";
    }else if(_financeDetail.status == 3){
        _statusLabel.text = @"关闭";
    }
    // 设置所有控件的值
    NSString *str = @"融资需求";
    _titleLabel.text = [[[[str stringByAppendingString:@" / "] stringByAppendingString:_statusLabel.text] stringByAppendingString:@" / "] stringByAppendingString:@"小侠"];
//    if([_financeDetail.amountType isEqualToString:@"rmb"]){
//        _currencyLabel.text = @"人民币";
//    }else{
//        _currencyLabel.text = @"美元";
//    }
    //_timeLabel.text = _financeDetail.start;
    if(_financeDetail.fa == 1){
        _FALabel.text = [[@"愿意接受FA" stringByAppendingString:@" / 启动 "] stringByAppendingString:_financeDetail.start];
    }else{
        _FALabel.text = [[@"不接受FA" stringByAppendingString:@" / 启动 "] stringByAppendingString:_financeDetail.start];
    }
    NSString *money;
    if ([financeDetail.amountType isEqualToString:@"rmb"]) {
        money = @"万人民币";
    } else {
        money = @"万美元";
    }
    _financingLabel.text = [[[[@"融资" stringByAppendingString:financeDetail.amount] stringByAppendingString:money] stringByAppendingString:@" / 估值"] stringByAppendingString:financeDetail.valuation] ;
    
    _companyStatus.text = [@"公司现状:" stringByAppendingString:_financeDetail.projectStatus];
    _companyStatus.numberOfLines = 0;
    CGSize titleSize = [_companyStatus.text boundingRectWithSize:CGSizeMake(width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    _companyStatus.frame = CGRectMake(CGRectGetMaxX(self.logoImageView.frame) + 10, 5, width - 60, titleSize.height);
    [_midView addSubview:_companyStatus];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateStyle:NSDateFormatterMediumStyle];
    [formatter1 setTimeStyle:NSDateFormatterShortStyle];
    //[formatter1 setDateFormat:@"yyyy-MM-dd HH:MM:ss"];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    NSDate *datea1 = [NSDate dateWithTimeIntervalSince1970:[_financeDetail.time doubleValue]];
    NSString *dateString1 = [formatter1 stringFromDate:datea1];
    _timeLabel.text = [[NSString alloc]initWithFormat:@"%@",dateString1];
    
//
//    self.top.frame = CGRectMake(12.0f, 18.0f, width-2*12.0f, 10.0f+12.0f+15.0f+12.0f+15.0f+12.0f+15.0f+12.0f+15.0f+titleSize.height+40.0f);
//    self.bottom.frame = CGRectMake(15.0f, CGRectGetHeight(_top.frame)+12.0f+12.0f, width-2*15, 12.0f);
//    self.scrollView.contentSize = CGSizeMake(width,CGRectGetHeight(self.top.frame)+12.0f+12.0f+12.0f);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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

@end
