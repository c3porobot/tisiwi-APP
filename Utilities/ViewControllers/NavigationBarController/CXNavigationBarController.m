//
//  CXNavigationBarController.m
//
//  Created by zhouhai on 15/1/13.
//  Copyright (c) 2015年 zhouhai. All rights reserved.
//

#import "CXNavigationBarController.h"

static const float kNavigationBarDefaultHeight = 44.0F;

@interface CXNavigationBar (Private)

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated;

@end

@implementation CXNavigationBar (Private)

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated
{
    if (hidden) {
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.frame = CGRectMake(0.0f, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
        } completion:^(BOOL finished) {
            self.hidden = hidden;
        }];
    }
    else {
        self.hidden = hidden;
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
        } completion:nil];
    }
}

@end

@interface CXNavigationBarController ()

@property (nonatomic, assign) CGFloat navigationBarHeight;

@property (nonatomic, strong) CXNavigationBar *navigationBar;

@property(nonatomic, assign) BOOL navigationBarHidden;

//@property(nonatomic, strong) CXNavigationBarController *controller;

@end

@implementation CXNavigationBarController
{
    BOOL   _backOnce;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.navigationBarHeight = kNavigationBarDefaultHeight;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.navigationBarHeight = kNavigationBarDefaultHeight;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithNavigationBarHeight:kNavigationBarDefaultHeight];
}

- (instancetype)initWithNavigationBarHeight:(CGFloat)navigationBarHeight;
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.navigationBarHeight = navigationBarHeight;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _backOnce = YES;
    [self setupNavigationBar];
    [self addScreenEdgePanGuesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    //[super viewWillAppear:animated];
    
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    self.navigationBarHidden = hidden;
    [self.navigationBar setHidden:hidden animated:animated];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark Private Method
- (void)setupNavigationBar
{
    if (!_navigationBar) {
        _navigationBar = [[CXNavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), self.navigationBarHeight)];
    //    _navigationBar.backgroundColor = [UIColor colorWithRed:79.0f/255.0f green:84.0f/255.0f blue:89.0f/255.0f alpha:1.0f];
      //  _navigationBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navBarBack"]];
      //  _navigationBar.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];

        _navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    
    [self.view addSubview:self.navigationBar];
    
    if ([self.navigationController.viewControllers indexOfObject:self] != 0) {
        CGRect backButtonFrame = CGRectMake(10.0f, 0.0f, 21.0f+30.0, _navigationBarHeight);
        
        UIButton *backButton = [[UIButton alloc] initWithFrame:backButtonFrame];
        backButton.backgroundColor = [UIColor clearColor];
        [backButton setImage:[UIImage imageNamed:@"back_icon_normal"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"back_icon_highlighted"] forState:UIControlStateHighlighted];
        [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 23)];//expand touch area

        [backButton setTitle:@" " forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor colorWithRed:228.0f/255.0f green:82.0f/255.0f blue:80.0f/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationBar.leftButton = backButton;
    }
}

#pragma mark - Override getter

- (CGFloat)navigationBarHeight
{
    if (self.navigationBarHidden) {
        return 0.0f;
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return _navigationBarHeight + 20.0f;
    }
    else {
        return _navigationBarHeight;
    }
}

#pragma button click response
- (void)back:(UIButton *)sender
{
//    NSArray *array = [self.navigationController viewControllers];
//    if([array count] >2)
//    {
//        [[self getAppdelegate] removeTrackingArrayLastObject];
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addScreenEdgePanGuesture
{
    UIScreenEdgePanGestureRecognizer *edgePanGuesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGuesture:)];
    [edgePanGuesture setDelegate:self];
    [edgePanGuesture setEdges:UIRectEdgeLeft];
    [self.view addGestureRecognizer:edgePanGuesture];
}

- (void)edgePanGuesture:(UIScreenEdgePanGestureRecognizer *)guesture
{
//    NSArray *array = self.navigationController.viewControllers;
//    if([array count] > 1)
//        [self.navigationController popViewControllerAnimated:YES];
    if(_backOnce)
    {
        [self back:nil];
        _backOnce = NO;
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    BOOL result = NO;
    
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        result = YES;
    }
    
    return result;
}
//If data is nil class
- (id)archiveData:(id)dat
{
    if(!dat || [dat isKindOfClass:[NSNull class]] || dat == nil)
    {
        return nil;
    }
    else
    {
        return dat;
    }
}

@end
