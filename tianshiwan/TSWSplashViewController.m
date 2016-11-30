//
//  TSWSplashViewController.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/6.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWSplashViewController.h"

#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "TSWHomeRootController.h"
#import "TSWServiceViewController.h"
#import "TSWPublishViewController.h"
#import "TSWTalentViewController.h"
#import "TSWContactsViewController.h"
#import "TSWCommonTool.h"
#import "TSWArticleDetailsViewController.h"
#import "TSWTalentAndFilterViewController.h"
#import "TSWFinanceAndFilterViewController.h"
@interface TSWSplashViewController ()

@property (nonatomic, strong) UINavigationController *navigationController;

@property (nonatomic, retain) NSTimer        *animationTimer;

@property (nonatomic, retain) UIImageView     *animateImgView;

@property (nonatomic, retain) UIImageView     *backImgView;

@end

@implementation TSWSplashViewController
{
    NSArray     *_aniArray;
}

- (id)init{
    if(self = [super init])
    {
        _aniArray = @[@[@(117*31/18), @(146*41/99)],@[@(132*31/18), @(145*36/99)], @[@(156*31/18), @(171*31/99)], @[@(166*33/18), @(191*31/99)]];
        [self createBlurryAnimationImgView:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    }
    return self;
}

-(instancetype)initWithArticleId:(NSString *)articleId{
    if(self = [super init])
    {
        _aniArray = @[@[@(117*31/18), @(146*41/99)],@[@(132*31/18), @(145*36/99)], @[@(156*31/18), @(171*31/99)], @[@(166*33/18), @(191*31/99)]];
        [self createBlurryAnimationImgView:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    }
    return self;
}

- (void)createBlurryAnimationImgView:(CGRect)frame
{
    DeviceIdiomCode cod = [TSWCommonTool getCurrentDeviceModelIdiom];
    
    NSArray *distanceArray = [_aniArray objectAtIndex:cod];
    
    NSInteger start = [[distanceArray objectAtIndex:0] integerValue];
    NSInteger end = [[distanceArray objectAtIndex:1] integerValue];
    
    if(!_backImgView)
    {
        _backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
    }
    if(cod != DeviceIdiomIphone4)
    {
        [_backImgView setImage:[UIImage imageNamed:@"launch"]];
    }
    else
    {
        [_backImgView setImage:[UIImage imageNamed:@"launch4"]];
    }
    [self.view  addSubview:_backImgView];
    //在执行动画的时候, 状态条依然为白色
    [UIView animateWithDuration:10 animations:^{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;//设置状态条为白色
        [_animateImgView setFrame:CGRectMake((CGRectGetWidth(frame)-182)/2 ,CGRectGetHeight(frame) - end-start, 182, 27)];
        [_animateImgView setAlpha:1.0];
        
    } completion:^(BOOL finish){}];
    
    [self createAnimationTimer];
}

- (void)createAnimationTimer
{
    if(!_animationTimer)
    {
        _animationTimer = [NSTimer scheduledTimerWithTimeInterval:1.7 target:self selector:@selector(animationTimerRun:) userInfo:nil repeats:NO];
    }
}
- (void)animationTimerRun:(NSTimer *)timer
{
    [self setupViewControllers];
    NSArray *arr = [[UIApplication sharedApplication] windows];
    UIWindow *mainWindow = [arr objectAtIndex:0];
    [mainWindow setRootViewController: self.navigationController];
    
    [self destoryTimer];
}

- (void)destoryTimer
{
    if(_animationTimer)
    {
        if([_animationTimer isValid])
        {
            [_animationTimer invalidate];
        }
        _animationTimer = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self setupViewControllers];
    NSArray *arr = [[UIApplication sharedApplication] windows];
    UIWindow *mainWindow = [arr objectAtIndex:0];
    [mainWindow setRootViewController: self.navigationController];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)setupViewControllers {
    self.view.backgroundColor = RGB(255, 255, 255);
    TSWHomeRootController *homeRootController = [[TSWHomeRootController alloc] init];
    homeRootController.title = @"资讯";
    RDVTabBarItem *homeItem = [[RDVTabBarItem alloc] init];
    homeItem.title = @"资讯";
    homeItem.titlePositionAdjustment = UIOffsetMake(0.0f, 2.0f);
    [homeItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_1highlighted"] withFinishedUnselectedImage:[UIImage imageNamed:@"Tabbar_b1_n"]];
    UIViewController *homeNavigationController = [[UINavigationController alloc]
                                                  initWithRootViewController:homeRootController];
    
    TSWFinanceAndFilterViewController *serviceViewController = [[TSWFinanceAndFilterViewController alloc] init];
    serviceViewController.title = @"投资机构";
    RDVTabBarItem *serviceItem = [[RDVTabBarItem alloc] init];
    serviceItem.title = @"融资";
    serviceItem.titlePositionAdjustment = UIOffsetMake(0.0f, 2.0f);
    [serviceItem setFinishedSelectedImage:[UIImage imageNamed:@"Tabbar_b2_p"] withFinishedUnselectedImage:[UIImage imageNamed:@"Tabbar_b2_n"]];
    UIViewController *serviceNavigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:serviceViewController];
    
    TSWServiceViewController *publishViewController = [[TSWServiceViewController alloc] init];
    publishViewController.title = @"服务";
    RDVTabBarItem *publishItem = [[RDVTabBarItem alloc] init];
    publishItem.title = @"服务";
    publishItem.titlePositionAdjustment = UIOffsetMake(0.0f, 2.0f);
    [publishItem setFinishedSelectedImage:[UIImage imageNamed:@"Tabbar_b3_p"] withFinishedUnselectedImage:[UIImage imageNamed:@"Tabbar_b3_n"]];
    UIViewController *publishNavigationController = [[UINavigationController alloc]
                                                     initWithRootViewController:publishViewController];
    TSWTalentAndFilterViewController *talentViewController = [[TSWTalentAndFilterViewController alloc] init];
    talentViewController.title = @"人才";
    RDVTabBarItem *talentItem = [[RDVTabBarItem alloc] init];
    talentItem.title = @"人才";
    talentItem.titlePositionAdjustment = UIOffsetMake(0.0f, 2.0f);
    [talentItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_4highlighted"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_b3_np"]];
    UIViewController *talentNavigationController = [[UINavigationController alloc]
                                                      initWithRootViewController:talentViewController];
    
    TSWContactsViewController *contactsViewController = [[TSWContactsViewController alloc] init];
    contactsViewController.title = @"联系人";
    RDVTabBarItem *contactsItem = [[RDVTabBarItem alloc] init];
    contactsItem.title = @"湾仔";
    contactsItem.titlePositionAdjustment = UIOffsetMake(0.0f, 2.0f);
    [contactsItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_5highlighted"] withFinishedUnselectedImage:[UIImage imageNamed:@"Tabbar_b4_n"]];
    UIViewController *contactsNavigationController = [[UINavigationController alloc]
                                                      initWithRootViewController:contactsViewController];
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    
    [tabBarController setViewControllers:@[homeNavigationController, serviceNavigationController,publishNavigationController,talentNavigationController,contactsNavigationController]];
    
    tabBarController.tabBar.items = @[homeItem, serviceItem, publishItem, talentItem, contactsItem];
    
    
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        item.selectedTitleAttributes = @{
                                         NSFontAttributeName: [UIFont systemFontOfSize:11],
                                         NSForegroundColorAttributeName: RGB(33, 159, 218),
                                         };
        item.unselectedTitleAttributes = @{
                                           NSFontAttributeName: [UIFont systemFontOfSize:11],NSForegroundColorAttributeName: RGB(120, 120, 120),
                                           };
    }
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:tabBarController];
    self.navigationController.navigationBarHidden = YES;
}


@end
