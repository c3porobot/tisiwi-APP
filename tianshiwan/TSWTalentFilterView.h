//
//  TSWTalentFilterView.h
//  tianshiwan
//
//  Created by 刘鸿博 on 16/1/27.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSWTalentFilterView : UIView
@property (nonatomic, strong) UILabel *expirceLabel; //工作经验
@property (nonatomic, strong) UITextField *expTextField;
@property (nonatomic, strong) UILabel *salaryLabel; //薪资要求
@property (nonatomic, strong) UITextField *salaryTextField;
@property (nonatomic, strong) UILabel *yearLabel; //年
@property (nonatomic, strong) UILabel *KLabel; //K
@property (nonatomic, strong) UIButton *resettingBtn; //重置
@property (nonatomic, strong) UIButton *completeBtn; //完成
@end
