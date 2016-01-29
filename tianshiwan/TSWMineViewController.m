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

#define kCellIndentifier @"mine"
#define kMineCell @"cell"
@interface TSWMineViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, passImageValueDelegate>

@end

@implementation TSWMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.title = @"我的";
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self configureTbaleView];
}

- (void)configureTbaleView {
    UITableView *mineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
     [mineTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIndentifier];
     [mineTableView registerClass:[TSWMineTableViewCell class] forCellReuseIdentifier:kMineCell];
    mineTableView.delegate = self;
    mineTableView.dataSource = self;
    [self.view addSubview:mineTableView];
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
    
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIndentifier forIndexPath:indexPath];
                NSArray *titleArray = @[@[],@[ @"我的需求", @"我的收藏"], @[@"使用协议", @"用户反馈", @"关于我们"], @[@"退出登录"]];
                NSArray *picArray = @[@[],@[@"gongguan", @"gongguan"], @[@"gongguan", @"gongguan", @"gongguan"], @[@""]];
                cell.textLabel.text = titleArray[indexPath.section][indexPath.row];
                cell.imageView.image =[UIImage imageNamed:picArray[indexPath.section][indexPath.row]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if ([cell.textLabel.text isEqualToString:@"退出登录"]) {
                    cell.textLabel.textColor = [UIColor redColor];
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                }
                return cell;
    }
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section && 0 == indexPath.row) {
        TSWEditMineViewController *pushController = [[TSWEditMineViewController alloc] init];
        pushController.delegate = self; //代理传值
        [self.navigationController pushViewController:pushController animated:YES];
    }
    if (1 == indexPath.section && 0 == indexPath.row) {
        TSWMyRequirementsViewController *pushController = [[TSWMyRequirementsViewController alloc] init];
        [self.navigationController pushViewController:pushController animated:YES];
    }
    if (2 == indexPath.section && 1 == indexPath.row) {
        TSWFeedbackController *feedBack = [[TSWFeedbackController alloc] init];
        [self.navigationController pushViewController:feedBack animated:YES];
    }
    if (2 == indexPath.section && 0 == indexPath.row) {
        TSWAboutController *aboutView = [[TSWAboutController alloc] init];
        [self.navigationController pushViewController:aboutView animated:YES];
    }
    
    if ( 3 == indexPath.section) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定退出" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alertView show];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        return 100;
    }
    return 60;
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

- (void)passImageValue:(UIImage *)value {
    TSWMineTableViewCell *cell = (TSWMineTableViewCell *)[self.view viewWithTag:101];
    cell.avatarView.image = value;
}
@end
