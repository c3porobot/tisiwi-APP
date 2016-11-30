//
//  TSWCheckTalentInfoViewController.h
//  tianshiwan
//
//  Created by 刘鸿博 on 16/11/27.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>
@interface TSWCheckTalentInfoViewController : UIViewController<QLPreviewControllerDelegate, QLPreviewControllerDataSource>
@property (nonatomic, copy) NSString *PDFid;
@property (nonatomic, copy) NSString *attachment;
@property (nonatomic, copy) NSString *name;
@end
