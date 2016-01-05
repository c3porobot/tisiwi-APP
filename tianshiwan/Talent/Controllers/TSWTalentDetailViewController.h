//
//  TSWTalentDetailViewController.h
//  tianshiwan
//
//  Created by zhouhai on 15/9/7.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "CXNavigationBarController.h"

@interface TSWTalentDetailViewController : CXNavigationBarController
@property (nonatomic, copy) NSString *talentName;
- (instancetype)initWithTalentId:(NSString *)talentId;
@end
