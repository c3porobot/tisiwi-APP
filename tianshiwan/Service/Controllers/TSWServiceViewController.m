//
//  TSWServiceViewController.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/6.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWServiceViewController.h"
#import "RDVTabBarController.h"
#import "TSWServiceList.h"
#import "TSWServiceCell.h"
#import "TSWServiceSearchCell.h"
#import "TSWFinanceViewController.h"
#import "TSWOtherViewController.h"
#import "TSWFinanceCell.h"
#import "TSWResultList.h"
#import "TSWResult.h"
#import "TSWOtherCell.h"
#import "TSWOther.h"
#import "TSWFinanceDetailViewController.h"
#import "TSWOtherDetailViewController.h"
#import "GVUserDefaults+TSWProperties.h"
#import "TSWSendRequest.h"
#import "BeforeAuditFinaceViewController.h"
static const CGFloat searchCellHeight = 50.0f+13.0f+3.0f+10.0f; // icon高+标题高+3px的间隙+10px的下边距

@interface TSWServiceViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,TSWServiceCellDelegate,TSWFinanceCellDelegate,TSWOtherCellDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionView *searchResultCollectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *searchDataArray;
@property (nonatomic, strong) TSWServiceList *serviceList;
@property (nonatomic, strong) TSWResultList *resultList;
@property (nonatomic, strong) TSWSendRequest *sendRequest; //发送请求
@property (nonatomic, strong) NSString *tempStr;
@property (nonatomic, strong) NSString *tempName; //姓名
@property (nonatomic, strong) NSString *tempID; //ID
@property (nonatomic, strong) UIView *searchBox;
@property (nonatomic, strong) UIView *searchBoxView;
@property (nonatomic, strong) UIView *searchResultBox;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *cancelBtn;
@end

@implementation TSWServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationBar.title = @"服务";
    
    /**
     *  设置搜索框
     */
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    _searchBox = [[UIView alloc]initWithFrame:CGRectMake(0, self.navigationBarHeight, width, 48.0f)];
    _searchBox.backgroundColor = [UIColor whiteColor];
    
    _searchBoxView = [[UIView alloc]initWithFrame:CGRectMake(15.0f, 10.0f, width-2*15.0f, 28.0f)];
    _searchBoxView.backgroundColor = [UIColor whiteColor];
    _searchBoxView.layer.cornerRadius = 14.0f;
    _searchBoxView.layer.borderWidth = 0.5f;
    _searchBoxView.layer.borderColor = [RGB(226, 226, 226) CGColor];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.0f, 3.0f, 21.0f, 21.0f)];
    self.imageView.image = [UIImage imageNamed:@"search"];
    self.imageView.backgroundColor = [UIColor whiteColor];
    [_searchBoxView addSubview:self.imageView];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(5.0f+21.0f+5.0f, 0.0f, width-2*31.0f, 28.0f)];
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.font = [UIFont systemFontOfSize:14.0f];
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.backgroundColor = [UIColor clearColor];
    _textField.autocapitalizationType = NO;
    _textField.placeholder = @"搜索公司、联系人、标签、服务地区";
    [_textField addTarget:self action:@selector(searchBegin) forControlEvents: UIControlEventEditingDidBegin];
    [_textField addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
    [_searchBoxView addSubview:_textField];
    
    self.cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(width - 60.0f, 0.0f, 60.0f, 48.0f)];
    self.cancelBtn.backgroundColor = [UIColor clearColor];
    [self.cancelBtn setTitleColor:RGB(32, 158, 217) forState:UIControlStateNormal];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.cancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    self.cancelBtn.hidden = YES;
    
    [_searchBox addSubview:_searchBoxView];
    [_searchBox addSubview:self.cancelBtn];
    [self.view addSubview:_searchBox];
    
    //天使湾服务列表
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight + 48.0f, width, height - self.navigationBarHeight - 48.0f) collectionViewLayout:collectionViewFlowLayout];
    _collectionView.tag = 1;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[TSWServiceCell class] forCellWithReuseIdentifier:@"TSWServiceCell"];
    
    //搜索结果的列表
    UICollectionViewFlowLayout *searchResultCollectionViewFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    _searchResultCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, 0, width, height - self.navigationBarHeight - 48.0f - 60.0f) collectionViewLayout:searchResultCollectionViewFlowLayout];
    _searchResultCollectionView.tag = 2;
    _searchResultCollectionView.alwaysBounceVertical = YES;
    _searchResultCollectionView.delegate = self;
    _searchResultCollectionView.dataSource = self;
    _searchResultCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _searchResultCollectionView.backgroundColor = [UIColor clearColor];
    [_searchResultCollectionView registerClass:[TSWFinanceCell class] forCellWithReuseIdentifier:@"TSWFinanceCell"];
    [_searchResultCollectionView registerClass:[TSWOtherCell class] forCellWithReuseIdentifier:@"TSWOtherCell"];
    _searchResultCollectionView.hidden = YES;
    
    
    // 处理数据
    self.serviceList = [[TSWServiceList alloc] initWithBaseURL:TSW_API_BASE_URL path:SERVICE_LIST];
    [self.serviceList addObserver:self
                       forKeyPath:kResourceLoadingStatusKeyPath
                          options:NSKeyValueObservingOptionNew
                          context:nil];
    self.resultList = [[TSWResultList alloc] initWithBaseURL:TSW_API_BASE_URL path:RESULT_LIST];
    
    [self.resultList addObserver:self
                       forKeyPath:kResourceLoadingStatusKeyPath
                          options:NSKeyValueObservingOptionNew
                          context:nil];
    
    //新的接口
   
    _dataArray = [NSMutableArray array];
    _searchDataArray = [NSMutableArray array];
    
    NSMutableArray *temp1 = [[NSMutableArray alloc]init];
    NSMutableArray *temp2 = [[NSMutableArray alloc]init];
    
    [_dataArray addObject:temp1];
    [_searchDataArray addObject:temp2];
    
    [self refreshData];
    
    // 搜索结果框
    _searchResultBox = [[UIView alloc]initWithFrame:CGRectMake(0.0f, self.navigationBarHeight+48.0f, width, height - self.navigationBarHeight - 48.0f - 60.0f)];
    _searchResultBox.backgroundColor = RGB(234, 234, 234);
    _searchResultBox.hidden = YES;
    [self.view addSubview:_searchResultBox];
    [_searchResultBox addSubview:_searchResultCollectionView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:NO];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    //    _firIn = NO;
    //    _locateTool = nil;
    //    _bannerCell = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_serviceList removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
    [_resultList removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

#pragma mark Key-value observing
//随着内容的增加,页面加高
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
        if (object == _serviceList) {
            if (_serviceList.isLoaded) {
                [self hideLoadingView];
                //  [self.collectionView.pullToRefreshView stopAnimating];
                
                [self.dataArray addObject:_serviceList.services];
                
                [self.collectionView reloadData];
            }
            else if (_serviceList.error) {
                [self hideLoadingView];
                //  [self.collectionView.pullToRefreshView stopAnimating];
                [self showErrorMessage:[_serviceList.error localizedFailureReason]];
            }
            
        }else if(object == _resultList){
            if (_resultList.isLoaded) {
                NSMutableArray *tempArray = [NSMutableArray array];
                for (TSWResult *result in _resultList.results) {
                    //self.tempStr = result.currentstatus;
                    self.tempID = result.sid;
                    if([result.type isEqualToString:@"financing"]){
                        for(TSWFinance *finance in result.items){
                            [tempArray addObject:finance];
//                            NSDictionary *dic = [result.items firstObject];
//                            self.tempStr = [dic valueForKey:@"currentstatus"];
                        }
                        [self.searchDataArray removeAllObjects];
                        [self.searchDataArray addObject:tempArray];
                    }else{
                        for(TSWOther *other in result.items){
                            [tempArray addObject:other];
                        }
                        [self.searchDataArray removeAllObjects];
                        [self.searchDataArray addObject:tempArray];
                    }
                                   }
                [self.searchResultCollectionView reloadData];
            }
            else if (_serviceList.error) {
                [self showErrorMessage:[_serviceList.error localizedFailureReason]];
            }
        }
    }
}

- (void) refreshData{
    //[self showLoadingView]; //刷新视图提示
    [self.serviceList loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
    //[self.resultList loadDataWithRequestMethodType:kHttpRequestMethodTypePost parameters:@{@"member":[GVUserDefaults standardUserDefaults].member, @"text": _textField.text}];
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
    if(collectionView.tag == 1){
        return [self.dataArray count];
    }else{
        return [self.searchDataArray count];
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView.tag == 1){
        NSArray *array = self.dataArray[section];
        return [array count];
    }else{
        NSArray *array = self.searchDataArray[section];
        return [array count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag == 1){
        NSArray *array = self.dataArray[indexPath.section];
        id object = array[indexPath.row];
        
        if ([object isKindOfClass:[TSWService class]]) {
            TSWServiceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TSWServiceCell" forIndexPath:indexPath];
            TSWService *temp =(TSWService *)object;
            cell.service = temp;
            cell.delegate = self;
            cell.service.sort = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            [cell relayout];
            return cell;
            
        }else{
            TSWServiceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TSWServiceCell" forIndexPath:indexPath];
            TSWService *temp =(TSWService *)object;
            cell.service = temp;
            cell.delegate = self;
            cell.service.sort = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
            [cell relayout];
            return cell;
        }

    }else{
        NSArray *array = self.searchDataArray[indexPath.section];
        id object = array[indexPath.row];
        
        if ([object isKindOfClass:[TSWFinance class]]) {
            TSWFinanceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TSWFinanceCell" forIndexPath:indexPath];
            TSWFinance *temp =(TSWFinance *)object;
            cell.finance = temp;
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
}

#pragma mark UICollectionViewDelegateFlowLayout
// 定义cell的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = CGRectGetWidth(self.collectionView.bounds);
    if(collectionView.tag == 1){
        // 如果是icon，则采用此size
        if(indexPath.row % 4 == 3 || indexPath.row % 4==0){
            return CGSizeMake((width-2*15.0f)/4 , searchCellHeight);// 15px为图标的右边距，第4个没有右边距
        }else{
            return CGSizeMake((width-2*15.0f)/4, searchCellHeight);
        }
    }else{
        // 如果是搜索结果，则采用此size
        return CGSizeMake(width,110);
    }
    
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.0F, 0.0F, 0.0F, 0.0F);
}

// 定义上下cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0F;
}

// 定义左右cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}
/**
 *点击cell跳转页面在这里
 */
#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
   }

- (void) gotoServiceList:(TSWServiceCell *)cell withService:(TSWService *)service{
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    // 首先判断是融资服务还是其他服务（人才服务已经单独列出）
    if([service.type isEqualToString:@"financing"]){
        TSWFinanceViewController *financeController = [[TSWFinanceViewController alloc] init];
    [self.navigationController pushViewController:financeController animated:YES];
    }else{
        TSWOtherViewController *otherController = [[TSWOtherViewController alloc] initWithType:service.type withTitle:service.title];
        [self.navigationController pushViewController:otherController animated:YES];
    }
    
}

- (void)searchBegin{
    self.searchBox.backgroundColor = RGB(234, 234, 234);
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    //首尾式动画
    [UIView beginAnimations:nil context:nil];
    //执行动画
    //设置动画执行时间
    [UIView setAnimationDuration:0.5];
    //设置代理
    [UIView setAnimationDelegate:self];
    //设置动画执行完毕调用的事件
    [UIView setAnimationDidStopSelector:@selector(didStopAnimation)];
    self.searchBoxView.frame = CGRectMake(15.0f, 10.0f, width-15.0f - 60.0f, 28.0f);
    self.textField.frame = CGRectMake(5.0f+21.0f+5.0f, 0.0f, width-31.0f - 60.0f - 20.0f, 28.0f);
    [UIView commitAnimations];
    _searchResultBox.hidden = NO;
    _searchResultCollectionView.hidden = NO;
    
}

-(void)didStopAnimation{
    self.cancelBtn.hidden = NO;
}

-(void)cancel{
    self.searchBox.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    //首尾式动画
    [UIView beginAnimations:nil context:nil];
    //执行动画
    //设置动画执行时间
    [UIView setAnimationDuration:0.5];
    //设置代理
    [UIView setAnimationDelegate:self];
    //设置动画执行完毕调用的事件
    [UIView setAnimationDidStopSelector:@selector(didStopAnimation2)];
    self.searchBoxView.frame = CGRectMake(15.0f, 10.0f, width-2*15.0f, 28.0f);
    self.textField.frame = CGRectMake(5.0f+21.0f+5.0f, 0.0f, width-2*31.0f, 28.0f);
    [UIView commitAnimations];
    self.cancelBtn.hidden = YES;
    _searchResultBox.hidden = YES;
    // 清空
    _textField.text = @"";
    // 使失去焦点
    [_textField resignFirstResponder];
    _searchResultCollectionView.hidden = YES;
}

-(void)didStopAnimation2{
    
}
-(void)valueChanged:(id)sender{
    NSString *text = _textField.text;
    [self.resultList loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:@{@"text":text, @"member":[GVUserDefaults standardUserDefaults].member}];
}

-(void) gotoFinanceDetail:(TSWFinanceCell *)cell withFinance:(TSWFinance *)finance withResult:(TSWResult *)result{
        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    if ([finance.currentstatus isEqualToString:@"-2"] || [finance.currentstatus isEqualToString:@"-1"] || [finance.currentstatus isEqualToString:@"0"]) {
        BeforeAuditFinaceViewController *BAVC = [[BeforeAuditFinaceViewController alloc] initWithFinanceId:finance.sid];
       // BAVC.currentStatus = finance.currentstatus;
        BAVC.investorName = self.tempName;
        BAVC.sidValue = finance.sid;
        [self.navigationController pushViewController:BAVC animated:YES];
    } else if ([finance.currentstatus isEqualToString:@"1"]) {
        TSWFinanceDetailViewController *financeDetailController = [[TSWFinanceDetailViewController alloc] initWithFinanceId:finance.sid];
        financeDetailController.investorName = finance.name;
        [self.navigationController pushViewController:financeDetailController animated:YES];
        
    }

}

-(void) gotoOtherDetail:(TSWOtherCell *)cell withOther:(TSWOther *)other{
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    TSWOtherDetailViewController *otherDetailController = [[TSWOtherDetailViewController alloc] initWithType:other.type OtherId:other.sid withName:other.name];
    [self.navigationController pushViewController:otherDetailController animated:YES];
}


@end
