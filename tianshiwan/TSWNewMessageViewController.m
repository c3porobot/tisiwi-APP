//
//  TSWNewMessageViewController.m
//  tianshiwan
//
//  Created by 刘鸿博 on 16/3/21.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "TSWNewMessageViewController.h"
#import "SVPullToRefresh.h"
#import "TSWMessage.h"
#import "GVUserDefaults+TSWProperties.h"
#import "TSWNewMessageCell.h"
#import "TSWMessageList.h"

#define kCell @"messageCell"
@interface TSWNewMessageViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) TSWMessageList *messageList;
@property (nonatomic, strong) NSMutableArray *dataArray; //数据源
@end

@implementation TSWNewMessageViewController
- (void)dealloc {
    [self.messageList removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.title = @"新消息";
    self.view.backgroundColor = RGB(234, 234, 234);
    self.dataArray = [NSMutableArray array];
    NSMutableArray *first = [[NSMutableArray alloc]init];
    [_dataArray addObject:first];
    self.messageList = [[TSWMessageList alloc] initWithBaseURL:TSW_API_BASE_URL path:[[MESSAGE_LIST stringByAppendingString:[GVUserDefaults standardUserDefaults].member] stringByAppendingString:@"/getmessages"]];
    
    [self.messageList addObserver:self forKeyPath:kResourceLoadingStatusKeyPath options:NSKeyValueObservingOptionNew context:nil];
    [self configutreWithCollection];
//    [self setupPullToRefresh];
//    [self setupInfiniteScrolling];
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

- (void)configutreWithCollection {
    //布局collectionView
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - self.navigationBarHeight) collectionViewLayout:collectionViewFlowLayout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.backgroundColor = RGB(234, 234, 234);
    [_collectionView registerClass:[TSWNewMessageCell class] forCellWithReuseIdentifier:kCell];
   
    [self.view addSubview:_collectionView];
}


- (void) refreshData{
    [self.messageList loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:@{@"memberid":[GVUserDefaults standardUserDefaults].member}];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
        if (object == _messageList) {
            if (_messageList.isLoaded) {
                [self.collectionView.pullToRefreshView stopAnimating];
                [self.collectionView.infiniteScrollingView stopAnimating];
                if (_messageList.messages) {
                    [self.dataArray[0] addObjectsFromArray:_messageList.messages];
                    
//                    if (self.dataArray.count > 0) {
//                        [self.dataArray[0] removeAllObjects];
//                        [_dataArray addObjectsFromArray:_messageList.messages];
//                    } else {
//                        
//                            [self.dataArray[0] addObjectsFromArray:_messageList.messages];
//                        
//                    }
                }
                [self.collectionView reloadData];
            }
            else if (_messageList.error) {
                [self.collectionView.pullToRefreshView stopAnimating];
                [self.collectionView.infiniteScrollingView stopAnimating];
                [self showErrorMessage:[_messageList.error localizedFailureReason]];
            }
        }    }
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
        if ([object isKindOfClass:[TSWNewMessageCell class]]) {
            TSWNewMessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCell forIndexPath:indexPath];
           TSWMessage *temp =(TSWMessage *)object;
            cell.message = temp;
            return cell;
        }else{
            TSWNewMessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCell forIndexPath:indexPath];
            TSWMessage *temp =(TSWMessage *)object;
            cell.message = temp;
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
