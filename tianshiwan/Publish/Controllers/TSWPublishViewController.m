//
//  PublishViewController.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/8.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "TSWPublishViewController.h"
#import "RDVTabBarController.h"
#import "TSWPublishFinanceController.h"
#import "TSWPublishTalentController.h"
#import "TSWPublishOtherController.h"

@interface TSWPublishViewController ()

@end

@implementation TSWPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    self.navigationBar.title = @"需求发布";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *center = [[UIView alloc]initWithFrame:CGRectMake(0.0f,self.navigationBarHeight+ 120.0f, width, 100.0f)];
    UIView *myProjects = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, width/3, 100.0f)];
    UIImage *image1 = [UIImage imageNamed:@"money"];
    UIImageView *mi1 = [[UIImageView alloc]initWithImage:image1];
    mi1.frame = CGRectMake((width/3 - 60)/2, 0.0f, 60.0f, 60.0f);
    [myProjects addSubview:mi1];
    UILabel *ml1 = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 60.0f, width/3, 16.0f)];
    ml1.textAlignment = NSTextAlignmentCenter;
    ml1.textColor = RGB(110, 110, 110);
    ml1.font = [UIFont systemFontOfSize:16.0f];
    ml1.backgroundColor = [UIColor clearColor];
    ml1.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    ml1.text = @"融资";
    ml1.numberOfLines = 0;
    [myProjects addSubview:ml1];
    UITapGestureRecognizer *myProjectsTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(publishFinance)];
    
    [myProjects addGestureRecognizer:myProjectsTapGesture];
    [center addSubview:myProjects];
    
    UIView *myRequirements = [[UIView alloc]initWithFrame:CGRectMake(width/3, 0.0f, width/3, 100.0f)];
    UIImage *image2 = [UIImage imageNamed:@"man"];
    UIImageView *mi2 = [[UIImageView alloc]initWithImage:image2];
    mi2.frame = CGRectMake((width/3 - 60)/2, 0.0f, 60.0f, 60.0f);
    [myRequirements addSubview:mi2];
    UILabel *ml2 = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 60.0f, width/3, 16.0f)];
    ml2.textAlignment = NSTextAlignmentCenter;
    ml2.textColor = RGB(110, 110, 110);
    ml2.font = [UIFont systemFontOfSize:16.0f];
    ml2.backgroundColor = [UIColor clearColor];
    ml2.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    ml2.text = @"人才";
    ml2.numberOfLines = 0;
    [myRequirements addSubview:ml2];
    UITapGestureRecognizer *myRequirementsTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(publishTalent)];
    
    [myRequirements addGestureRecognizer:myRequirementsTapGesture];
    [center addSubview:myRequirements];
    
    UIView *setting = [[UIView alloc]initWithFrame:CGRectMake(2*width/3, 0.0f, width/3, 100.0f)];
    UIImage *image3 = [UIImage imageNamed:@"other"];
    UIImageView *mi3 = [[UIImageView alloc]initWithImage:image3];
    mi3.frame = CGRectMake((width/3 - 60)/2, 0.0f, 60.0f, 60.0f);
    [setting addSubview:mi3];
    UILabel *ml3 = [[UILabel alloc]initWithFrame:CGRectMake(0.0f, 60.0f, width/3, 16.0f)];
    ml3.textAlignment = NSTextAlignmentCenter;
    ml3.textColor = RGB(110, 110, 110);
    ml3.font = [UIFont systemFontOfSize:16.0f];
    ml3.backgroundColor = [UIColor clearColor];
    ml3.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    ml3.text = @"其他";
    ml3.numberOfLines = 0;
    [setting addSubview:ml3];
    UITapGestureRecognizer *settingTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(publishOther)];
    
    [setting addGestureRecognizer:settingTapGesture];
    [center addSubview:setting];
    
    [self.view addSubview:center];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
}

#pragma mark - UIButton

- (void) publishFinance{
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
    TSWPublishFinanceController *financeController = [[TSWPublishFinanceController alloc] init];
    [self.navigationController pushViewController:financeController animated:YES];
}

- (void) publishTalent{
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
    TSWPublishTalentController *talentController = [[TSWPublishTalentController alloc] init];
    [self.navigationController pushViewController:talentController animated:YES];
}

- (void) publishOther{
    [[self rdv_tabBarController] setTabBarHidden:YES animated:NO];
    TSWPublishOtherController *otherController = [[TSWPublishOtherController alloc] init];
    [self.navigationController pushViewController:otherController animated:YES];
}

@end
