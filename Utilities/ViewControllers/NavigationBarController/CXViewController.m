//
//  CXViewController.m
//
//  Created by zhouhai on 15/1/13.
//  Copyright (c) 2015年 zhouhai. All rights reserved.
//

#import "CXViewController.h"

#import "SVProgressHUD.h"

@interface CXViewController ()

@property (nonatomic, strong) SVProgressHUD *hud;

@end

@implementation CXViewController

- (AppDelegate *)getAppdelegate
{
    AppDelegate *delg = [UIApplication sharedApplication].delegate;
    
    return delg;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)archiveSingleViewDataIntoArray:(NSString *)string shouldClear:(BOOL)clearIt shouldSend:(BOOL)send
{
    if(clearIt)
    {
//        [[self getAppdelegate] clearTrackingString];
    }
    
    if(!self.partTrackingArray)
    {
        self.partTrackingArray = [NSMutableArray arrayWithObjects:string, nil];
    }
    else
    {
        [self.partTrackingArray addObject:string];
    }
    
    if(send)
    {
//        [[self getAppdelegate] appendArrayToTrackingArray:self.partTrackingArray];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:NO];

}

- (NSUInteger)supportedInterfaceOrientations
{
    UIInterfaceOrientationMask orientationMask = UIInterfaceOrientationMaskAll;
    
    return orientationMask;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)hubShowInView
{
    return nil;
}

- (void)showLoadingView
{
    [self showLoadingViewWithText:@"加载中..."];
}

- (void)showLoadingViewWithText:(NSString *)text
{
    [SVProgressHUD showWithStatus:text maskType:SVProgressHUDMaskTypeNone];
}

- (void)hideLoadingView
{
    [SVProgressHUD dismiss];
}

- (void)showErrorMessage:(NSString *)errorMessage
{
    [SVProgressHUD showErrorWithStatus:errorMessage maskType:SVProgressHUDMaskTypeBlack];
}

- (void)showSuccessMessage:(NSString *)successMessage;
{
    [SVProgressHUD showSuccessWithStatus:successMessage];
}

- (void)showToastMessage:(NSString *)string
{
   // [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeClear];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"warn@2x" ofType:@"png"];
    [SVProgressHUD showImage:[UIImage imageWithContentsOfFile:path] status:string];
}


@end
