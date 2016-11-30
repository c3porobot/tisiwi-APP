//
//  MyRequireViewController.m
//  tianshiwan
//
//  Created by 刘鸿博 on 16/3/16.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "MyRequireViewController.h"
#import "MyRequirementsCollectionViewCell.h"
#import "TSWMyRequirementsList.h"
#import "TSWFinanceRequirementViewController.h"
#import "TSWPersonelRequirementViewController.h"
#import "TSWOtherRequirementViewController.h"
#import "TSWNewFinancingRequirementsViewController.h"
#import "TSWNewTalentRequirementsViewController.h"
@interface MyRequireViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, TSWMyRequirementsCellDelegate>
@property (nonatomic, strong) UIView *nullView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) TSWMyRequirementsList *myRequirementsList;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation MyRequireViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    self.navigationBar.title = @"我的需求";
    self.view.backgroundColor = RGB(234, 234, 234);
    
    self.nullView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, self.navigationBarHeight + 100.0f, CGRectGetWidth(self.view.bounds), 100)];
    self.nullView.hidden = NO;
    UILabel *nullLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.bounds), 12.0f)];
    nullLabel.textAlignment = NSTextAlignmentCenter;
    nullLabel.textColor = RGB(199, 199, 199);
    nullLabel.font = [UIFont systemFontOfSize:12.0f];
    nullLabel.backgroundColor = [UIColor clearColor];
    nullLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    nullLabel.text = @"你暂时还没有需求";
    nullLabel.numberOfLines = 0;
    //[self.nullView addSubview:nullLabel];
    
    UILabel *nullDesc1 = [[UILabel alloc]initWithFrame:CGRectMake((width - 12.0f*11 - 36.0f)/2, 16.0f+10.0f, 12.0f*7, 12.0f)];
    nullDesc1.textAlignment = NSTextAlignmentLeft;
    nullDesc1.textColor = RGB(199, 199, 199);
    nullDesc1.font = [UIFont systemFontOfSize:12.0f];
    nullDesc1.backgroundColor = [UIColor clearColor];
    nullDesc1.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    nullDesc1.text = @"可以到首页点击";
    nullDesc1.numberOfLines = 0;
    //[self.nullView addSubview:nullDesc1];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((width - 12.0f*11 - 36.0f)/2+12.0f*7, 16.0f, 36.0f, 36.0f)];
    imageView.image = [UIImage imageNamed:@"tabbar_3highlighted"];
    //[self.nullView addSubview:imageView];
    
    UILabel *nullDesc2 = [[UILabel alloc]initWithFrame:CGRectMake((width - 12.0f*11 - 36.0f)/2+12.0f*7+36.0f, 16.0f+10.0f, 12.0f*4, 12.0f)];
    nullDesc2.textAlignment = NSTextAlignmentLeft;
    nullDesc2.textColor = RGB(199, 199, 199);
    nullDesc2.font = [UIFont systemFontOfSize:12.0f];
    nullDesc2.backgroundColor = [UIColor clearColor];
    nullDesc2.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    nullDesc2.text = @"发布需求";
    nullDesc2.numberOfLines = 0;
    //[self.nullView addSubview:nullDesc2];
    
    [self.view addSubview:self.nullView];
    
    [self configureWithCollection];
    
    // 处理数据
    self.myRequirementsList = [[TSWMyRequirementsList alloc] initWithBaseURL:TSW_API_BASE_URL path:MY_REQUIREMENTS_LIST];
    [self.myRequirementsList addObserver:self
                              forKeyPath:kResourceLoadingStatusKeyPath
                                 options:NSKeyValueObservingOptionNew
                                 context:nil];
    
    _dataArray = [NSMutableArray array];
    [self refreshData];
}

- (void)refreshData{
    [self.myRequirementsList loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
}

- (void)configureWithCollection {
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight + 10, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - self.navigationBarHeight) collectionViewLayout:collectionViewFlowLayout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //_collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.backgroundColor = RGB(234, 234, 234);

    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[MyRequirementsCollectionViewCell class] forCellWithReuseIdentifier:@"TSWMyRequirementsCell"];
}


#pragma mark Key-value observing
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
        if(object == _myRequirementsList){
            if (_myRequirementsList.isLoaded) {
                if(_myRequirementsList.myRequirements){
                    self.nullView.hidden = YES;
                    [_dataArray addObject:_myRequirementsList.myRequirements];
                    [_collectionView reloadData];
                    _collectionView.hidden = NO;
                }else{
                    self.nullView.hidden = NO;
                    _collectionView.hidden = YES;
                }
            }
            else if (_myRequirementsList.error) {
                [self showErrorMessage:[_myRequirementsList.error localizedFailureReason]];
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
    if([obj isKindOfClass:[TSWMyRequirement class]]){
        MyRequirementsCollectionViewCell *myRequirementCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TSWMyRequirementsCell" forIndexPath:indexPath];
        TSWMyRequirement *temp = (TSWMyRequirement *)obj;
        myRequirementCell.myRequirement = temp;
        myRequirementCell.delegate = self;
        return myRequirementCell;
    }else{
        MyRequirementsCollectionViewCell *myRequirementCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TSWMyRequirementsCell" forIndexPath:indexPath];
        TSWMyRequirement *temp = (TSWMyRequirement *)obj;
        myRequirementCell.myRequirement = temp;
        myRequirementCell.delegate = self;
        return myRequirementCell;
    }
}

#pragma mark UICollectionViewDelegateFlowLayout
// 定义cell的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = CGRectGetWidth(self.collectionView.bounds);
    return CGSizeMake(width, 90.0f);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.0F, 0.0F, 0.0F, 0.0F);
}

// 定义上下cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0F;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [self refreshData];
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
    [_myRequirementsList removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
}

-(void) gotoList:(MyRequirementsCollectionViewCell *)cell withRequirement:(TSWMyRequirement*)myRequirement
{
    if([myRequirement.type isEqualToString: @"financing"]){
//        TSWFinanceRequirementViewController *controller = [[TSWFinanceRequirementViewController alloc]initWithFinanceId:myRequirement.sid];
//        [self.navigationController pushViewController:controller animated:YES];
        TSWNewFinancingRequirementsViewController *controller = [[TSWNewFinancingRequirementsViewController alloc] initWithFinanceId:myRequirement.sid];
        [self.navigationController pushViewController:controller animated:YES];
        
    }else if([myRequirement.type isEqualToString: @"personnel"]){
//        TSWPersonelRequirementViewController *controller = [[TSWPersonelRequirementViewController alloc]initWithPersonnelId:myRequirement.sid];
//        [self.navigationController pushViewController:controller animated:YES];
        TSWNewTalentRequirementsViewController *controller = [[TSWNewTalentRequirementsViewController alloc] initWithPersonnelId:myRequirement.sid];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        TSWOtherRequirementViewController *controller = [[TSWOtherRequirementViewController alloc]initWithOtherId:myRequirement.sid];
        [self.navigationController pushViewController:controller animated:YES];
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
