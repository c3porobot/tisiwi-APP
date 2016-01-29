//
//  MineController.m
//  WeChatDemo
//
//  Created by lanouhn on 15/8/5.
//  Copyright (c) 2015年 Lanou. All rights reserved.
//

#import "MineController.h"
#define kCellIndentifier @"mine"
@interface MineController ()

@end

@implementation MineController
- (void)configureNavigationBarContent {
    //导航条内容渲染颜色.
    //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //导航条标题的颜色.
    //NSDictionary *attributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    //self.navigationController.navigationBar.titleTextAttributes = attributes;
}
//配置tableView
- (void)configureTableView {
    //注册cell -- tabeView处理重用.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIndentifier];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationBarContent];
    [self configureTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIndentifier forIndexPath:indexPath];
    NSArray *titleArray = @[@[@"头像"],@[ @"我的需求", @"我的收藏"], @[@"使用协议", @"用户反馈", @"关于我们"], @[@"退出登录"]];
    NSArray *picArray = @[@[@""], @[@"gongguan", @"gongguan"], @[@"gongguan", @"gongguan", @"gongguan"], @[@""]];
    cell.textLabel.text = titleArray[indexPath.section][indexPath.row];
    cell.imageView.image =[UIImage imageNamed:picArray[indexPath.section][indexPath.row]];
    if ([cell.textLabel.text isEqualToString:@"退出登录"]) {
        cell.textLabel.textColor = [UIColor redColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        return 100;
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
