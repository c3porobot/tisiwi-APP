
//
//  TSWSettingsViewController.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/7.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWSettingsViewController.h"
#import "GVUserDefaults+TSWProperties.h"
#import "TSWMyRootCell.h"
#import "TSWClearReusableView.h"
#import "TSWLoginViewController.h"

@interface TSWSettingsViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation TSWSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    // Do any additional setup after loading the view.
    self.navigationBar.title = @"设置";
    self.navigationBar.titleView.textColor = RGB(90, 90, 90);
    self.navigationBar.backgroundView.backgroundColor = [UIColor whiteColor];
    [self.navigationBar.leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    self.navigationBar.bottomLineView.hidden = YES;
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc]init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, self.navigationBarHeight+18.0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - self.navigationBarHeight-60.0f) collectionViewLayout:collectionViewFlowLayout];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.backgroundColor = [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f];//[UIColor clearColor];
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[TSWMyRootCell class] forCellWithReuseIdentifier:@"TSWMyRootCell"];
//    [_collectionView registerClass:[AJSettingHeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AJSettingHeaderReusableView"];
    [_collectionView registerClass:[TSWClearReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"TSWClearReusableView"];
    
    self.view.backgroundColor = RGB(234, 234, 234);
    
    UIButton *quitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0f, height - 60.0f, width, 60.0f)];
    quitBtn.backgroundColor = [UIColor whiteColor];
    [quitBtn setTitleColor:RGB(90, 90, 90) forState:UIControlStateNormal];
    [quitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    quitBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [quitBtn addTarget:self action:@selector(quit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quitBtn];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([[GVUserDefaults standardUserDefaults].shouldGoHome isEqualToString:@"YES"]){
        [GVUserDefaults standardUserDefaults].shouldGoHome = @"NO";
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        self.dataArray = @[@[@{@"text":@"关于天使湾", @"imageName":@"", @"remark":@"", @"className":@"TSWAboutController"}, @{@"text":@"意见反馈", @"imageName":@"", @"remark":@"", @"className":@"TSWFeedbackController", @"urlString":@"", }]];
        
        [self.collectionView reloadData];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    
    TSWMyRootCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TSWMyRootCell" forIndexPath:indexPath];
    cell.contentDic = object;
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionFooter] && indexPath.section != [self.dataArray count] - 1) {
        TSWClearReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"TSWClearReusableView" forIndexPath:indexPath];
        footerView.backgroundColor = [UIColor colorWithRed:239/255.0f green:237/255.0f blue:238/255.0f alpha:1.0f];
        
        return footerView;
    }
    else {
        return nil;
    }
}

#pragma mark UICollectionViewDelegateFlowLayout
// 定义cell的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.dataArray[indexPath.section];
    id object = array[indexPath.row];
    CGSize size = [TSWMyRootCell calculateCellSizeWithCategoryChild:object containerWidth:CGRectGetWidth(UIEdgeInsetsInsetRect(collectionView.bounds, UIEdgeInsetsMake(0.0F, 0.0F, 0.0F, 0.0F)))];
    
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.0F, 0.0F, 0.0F, 0.0F);
}

// 定义headview的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;

}

// 定义footerView的size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section != [self.dataArray count] - 1) {
        return CGSizeMake(CGRectGetWidth(collectionView.bounds), 15.0f);
    }
    else {
        return CGSizeZero;
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
    NSArray *array = self.dataArray[indexPath.section];
    NSDictionary *dic = array[indexPath.row];
    
    if ([dic[@"text"] isEqualToString:@"安全退出"]) {
        [GVUserDefaults standardUserDefaults].token = nil;
        [GVUserDefaults standardUserDefaults].refreshToken = nil;
        [GVUserDefaults standardUserDefaults].expire = nil;
        [GVUserDefaults standardUserDefaults].bookPhoneNumber = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([dic[@"className"] isKindOfClass:[NSString class]] && ((NSString *)dic[@"className"]).length > 0) {
        UIViewController *viewController = [[NSClassFromString(dic[@"className"]) alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}


-(void) quit{
    [GVUserDefaults standardUserDefaults].token = nil;
    [GVUserDefaults standardUserDefaults].refreshToken = nil;
    [GVUserDefaults standardUserDefaults].expire = nil;
    //        [APService setTags:[NSSet set] callbackSelector:nil object:nil];
    [GVUserDefaults standardUserDefaults].bookPhoneNumber = nil;
    [GVUserDefaults standardUserDefaults].shouldGoHome = @"YES";
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    TSWLoginViewController *loginController = [[TSWLoginViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
    [app.window.rootViewController presentViewController:navigationController animated:YES completion:^{
    }];
//    [self.navigationController popToRootViewControllerAnimated:NO];
}
@end
