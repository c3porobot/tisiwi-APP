//
//  TSWMineViewController.m
//  tianshiwan
//
//  Created by 刘鸿博 on 16/1/22.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "TSWMineViewController.h"
#import "TSWAboutController.h"
#import "GVUserDefaults+TSWProperties.h"
#import "TSWMyRootCell.h"
#import "TSWClearReusableView.h"
#import "TSWLoginViewController.h"
#import "TSWFeedbackController.h"
#import "TSWMyRequirementsViewController.h"
#import "TSWMineTableViewCell.h"
#import "TSWEditMineViewController.h"
#import "TSWMyFavoritesViewController.h"
#import "TSWProfile.h"
#import "UIImageView+WebCache.h"
#import "MyRequireViewController.h"
#import "TSWNewMessageViewController.h"
#define kCellIndentifier @"mine"
#define kMineCell @"cell"
#import <Instabug/Instabug.h>
@interface TSWMineViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, passImageValueDelegate>
@property (nonatomic, strong) TSWProfile *profile;
@property (nonatomic, strong) UIButton *messageBtn; //消息按钮
@property (nonatomic, strong) UILabel *messageCount;
@end

@implementation TSWMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.title = @"我";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self configureTbaleView];
    [self addRightNavigatorButton];
   // [self messageCount:@"1" hidden:NO];
}

- (void)configureTbaleView {
    UITableView *mineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
     [mineTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIndentifier];
     [mineTableView registerClass:[TSWMineTableViewCell class] forCellReuseIdentifier:kMineCell];
    mineTableView.delegate = self;
    mineTableView.dataSource = self;
    [self.view addSubview:mineTableView];
    
    
    [self refreshData];
}
- (void)addRightNavigatorButton
{
    self.messageBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 50, 30, 32, 30)];
    [self.messageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.messageBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    //    [self.filterBtn setTitle:@"新增" forState:UIControlStateNormal];
    [self.messageBtn setImage:[UIImage imageNamed:@"message_n"] forState:UIControlStateNormal];
    [self.messageBtn addTarget:self action:@selector(rightButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationBar setRightButton:self.messageBtn];
}

- (void)rightButtonTapped:(UIButton *)sender {
    TSWNewMessageViewController *controller = [[TSWNewMessageViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)messageCount:(NSString *)message hidden:(BOOL)hidden {
    self.messageCount = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds) - 30, 23, 10, 10)];
    self.messageCount.backgroundColor = [UIColor redColor];
    self.messageCount.layer.masksToBounds = YES;
    self.messageCount.layer.cornerRadius = 5;
    //self.messageCount.text = message;
    self.messageCount.textAlignment = NSTextAlignmentCenter;
//    self.messageCount.font = [UIFont systemFontOfSize:5];
    self.messageCount.textColor = [UIColor whiteColor];
    UIButton *btn = (UIButton *)_messageCount;
    //[self.navigationBar setRightButton:btn];
    btn.hidden = hidden;
    [self.view addSubview:btn];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//更新数据
-(void) refreshData{
    [self showLoadingView];
    //[self disableBtns]; //让三个按钮消失
    [self.profile loadDataWithRequestMethodType:kHttpRequestMethodTypeGet parameters:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:kResourceLoadingStatusKeyPath]) {
        if(object == _profile){
            if (_profile.isLoaded) {
                [self hideLoadingView];
                [self setDetail:_profile];
            }
            else if (_profile.error) {
                [self hideLoadingView];
                [self showErrorMessage:[_profile.error localizedFailureReason]];
            }
        }
    }
}

-(void)setDetail:(TSWProfile *)profile{
    // 塞数据，布局
    TSWMineTableViewCell *minCell = (TSWMineTableViewCell *)[self.view viewWithTag:101];
//    [minCell.avatarView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profile.imgUrl_3x]]]];
     [minCell.avatarView sd_setImageWithURL:[NSURL URLWithString:profile.imgUrl_3x] placeholderImage:[UIImage imageNamed:@"default_face"]];
    //[_dFace setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:profile.imgUrl_3x]]]];
    minCell.nameLabel.text = profile.name;
    minCell.positionLabel.text = [[profile.title stringByAppendingString:@" · "] stringByAppendingString:profile.companyFullName];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        int count = [profile.unviewnum intValue];
        if (count > 0) {
            [self messageCount:profile.unviewnum hidden:NO];
        } else {
            [self.messageCount removeFromSuperview];
        }
    });

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.profile = [[TSWProfile alloc] initWithBaseURL:TSW_API_BASE_URL path:PROFILE];
    [self.profile addObserver:self
                   forKeyPath:kResourceLoadingStatusKeyPath
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    [self setNeedsStatusBarAppearanceUpdate];
    [self refreshData];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_profile removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (1 == section) {
        return 2;
    } else if (2 == section){
        return 3;
    } else {
        return 1;
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        TSWMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMineCell];
        cell.tag = 101;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;

    } else {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIndentifier forIndexPath:indexPath];
                NSArray *titleArray = @[@[],@[ @"我的需求", @"我的收藏"], @[@"使用协议", @"用户反馈", @"关于我们"], @[@"退出登录"]];
                NSArray *picArray = @[@[],@[@"1_puzzle_n", @"2_favourite_n"], @[@"3_contract_n", @"4_feedback_n", @"5_information_n"], @[@""]];
        UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
                logoImageView.image =[UIImage imageNamed:picArray[indexPath.section][indexPath.row]];
        [cell addSubview:logoImageView];
        UILabel *textView = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logoImageView.frame) + 10, CGRectGetMinY(logoImageView.frame), 200, 30)];
        textView.text = titleArray[indexPath.section][indexPath.row];
        textView.font = [UIFont systemFontOfSize:16];
        [cell addSubview:textView];
        UIImageView *enterView = [[UIImageView alloc] initWithFrame:CGRectMake(width - 0.12*width, 10, 30, 30)];
        enterView.image = [UIImage imageNamed:@"right_arrow_n"];//添加图片
        [cell addSubview:enterView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 3) {
           cell.textLabel.textColor = [UIColor redColor];
            textView.textColor = [UIColor redColor];
            textView.center = CGPointMake(([UIScreen mainScreen].bounds.size.width / 2), CGRectGetHeight(cell.frame) / 2); //中心
           textView.textAlignment = NSTextAlignmentCenter;
           [enterView removeFromSuperview];
        }
        return cell;
    }
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section && 0 == indexPath.row) {
        TSWEditMineViewController *pushController = [[TSWEditMineViewController alloc] init];
        //pushController.delegate = self; //代理传值
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:pushController animated:YES];
        });    }
    if (1 == indexPath.section && 0 == indexPath.row) {
        MyRequireViewController *pushController = [[MyRequireViewController alloc] init];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:pushController animated:YES];
        });
    }
    if (1 == indexPath.section && 1 == indexPath.row) {
        TSWMyFavoritesViewController *pushController = [[TSWMyFavoritesViewController alloc] init];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:pushController animated:YES];
        });
    }
    
    if (2 == indexPath.section && 1 == indexPath.row) {
//        TSWFeedbackController *feedBack = [[TSWFeedbackController alloc] init];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.navigationController pushViewController:feedBack animated:YES];
//        });
        [Instabug startWithToken:@"5efc3122c7ee446dd794a4bf11f24841" invocationEvent:IBGInvocationEventNone]; //Instabug SDK
        [Instabug setUserEmail:@"xj@tisiwi.com"];
        [Instabug invoke];// Instabug直接显示
    }
    if (2 == indexPath.section && 0 == indexPath.row) {
        TSWAboutController *aboutView = [[TSWAboutController alloc] init];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:aboutView animated:YES];
        });    }
    
    if ( 3 == indexPath.section) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定退出" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alertView show];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        return 90;
    }
    return 50;
}
#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
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

    }
}

//- (void)dealloc
//{
//    [_profile removeObserver:self forKeyPath:kResourceLoadingStatusKeyPath];
//}

- (void)passImageValue:(UIImage *)value {
//    TSWMineTableViewCell *cell = (TSWMineTableViewCell *)[self.view viewWithTag:101];
//    cell.avatarView.image = value;
}
@end
