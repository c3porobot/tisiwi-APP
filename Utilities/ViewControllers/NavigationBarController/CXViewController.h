//
//  CXViewController.h
//
//  Created by zhouhai on 15/1/13.
//  Copyright (c) 2015年 zhouhai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface CXViewController : UIViewController

#pragma mark - HUD

- (void)showLoadingView;
- (void)showLoadingViewWithText:(NSString *)text;
- (void)hideLoadingView;

- (void)showErrorMessage:(NSString *)errorMessage;

- (void)showSuccessMessage:(NSString *)successMessage;
- (void)showToastMessage:(NSString *)string;


/* GA tracking*/
@property (nonatomic, retain) NSString *curPath;

@property (nonatomic, retain) NSMutableArray *partTrackingArray;


- (AppDelegate *)getAppdelegate;


/**
 *  GA when new page appear
    Every page have an array, if push add into it, or pop remove.
 *
 *  @param string  ScreenName
 *  @param clearIt Clear current Page Array.
 *  @param send    If call GA send API
 */
- (void)archiveSingleViewDataIntoArray:(NSString *)string shouldClear:(BOOL)clearIt shouldSend:(BOOL)send;

@end
