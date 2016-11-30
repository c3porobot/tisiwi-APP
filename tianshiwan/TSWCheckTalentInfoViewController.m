//
//  TSWCheckTalentInfoViewController.m
//  tianshiwan
//
//  Created by 刘鸿博 on 16/11/27.
//  Copyright © 2016年 tianshiwan. All rights reserved.
//

#import "TSWCheckTalentInfoViewController.h"
#import "AFNetworking.h"
#import "CXNavigationBarController.h"
#define kURL @"http://120.132.70.218/attachments/"
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
@interface TSWCheckTalentInfoViewController ()
@property (nonatomic, copy) NSString *pdfPath;
@end

@implementation TSWCheckTalentInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBar];
    [self createQLPreviewController];
}

- (void)setNavigationBar {
    UIView *navigationview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigationview.backgroundColor = [UIColor colorWithRed:33.0f/255.0f green:159.0f/255.0f blue:218.0f/255.0f alpha:1.0f];
    [self.view addSubview:navigationview];
     CGRect backButtonFrame = CGRectMake(10.0f, 22.0f, 21.0f+30.0, 44);
    UIButton *backButton = [[UIButton alloc] initWithFrame:backButtonFrame];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setImage:[UIImage imageNamed:@"back_icon_normal"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"back_icon_highlighted"] forState:UIControlStateHighlighted];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 23)];//expand touch area
    
    [backButton setTitle:@" " forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor colorWithRed:228.0f/255.0f green:82.0f/255.0f blue:80.0f/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [navigationview addSubview:backButton];
}

- (void)createQLPreviewController {
    
    QLPreviewController *qlpreview = [[QLPreviewController alloc] init];
    qlpreview.view.backgroundColor = [UIColor whiteColor];
    [[UINavigationBar appearanceWhenContainedIn:[QLPreviewController class], nil] setTintColor:[UIColor whiteColor]];
    [UINavigationBar appearanceWhenContainedIn:[QLPreviewController class], nil].barTintColor = [UIColor colorWithRed:33.0f/255.0f green:159.0f/255.0f blue:218.0f/255.0f alpha:1.0f];
    NSDictionary *dic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:20], NSForegroundColorAttributeName:[UIColor whiteColor]};
    [UINavigationBar appearanceWhenContainedIn:[QLPreviewController class], nil].titleTextAttributes = dic;
    [self presentViewController:qlpreview animated:NO completion:nil];
    if(SYSTEM_VERSION_LESS_THAN(@"10.0"))
    {
        [self addChildViewController:qlpreview];
    }
    qlpreview.dataSource = self;
    qlpreview.delegate = self;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    qlpreview.view.frame = CGRectMake(0, 64, width, height);
    [qlpreview didMoveToParentViewController:self];
    [self.view addSubview:qlpreview.view];
    [self reloadDataFounction];
    [qlpreview reloadData];
}


- (void)reloadDataFounction {
    //获取沙盒路径
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    //创建一个文件路径. 文件名
    NSString *filePath = [cachesPath stringByAppendingPathComponent:self.attachment];
    self.pdfPath = filePath; //将路径传给下边方法
    //判断该文件是否存在
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        //不存在该文件,进行下载
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[kURL stringByAppendingString:self.attachment]]];
        //下载 AFHTTPRequestOperation 专门针对下载 上传一个类.
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        //append:是否拼接数据
        [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:filePath append:NO]];
        //下载成功方法回调
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
        }];
        //暂停下载
        //[operation pause];
        //手动开启下载任务
        [operation start];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//当网络连接不成功或出现异常的时候会调用，提供一个NSError以解释失败的原因
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //加载的是一个警告框
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle: [error localizedDescription]
                               message: [error localizedFailureReason]
                               delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil];
    [errorAlert show];
    
    
}

#pragma mark - previewControllerDataSource
-(NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1; //需要显示的文件的个数
}
-(id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    NSURL * url = [NSURL fileURLWithPath:self.pdfPath];
    return url;
}
#pragma mark - previewControllerDelegate

-(CGRect)previewController:(QLPreviewController *)controller frameForPreviewItem:(id<QLPreviewItem>)item inSourceView:(UIView *__autoreleasing *)view
{
    //提供变焦的开始rect，扩展到全屏
    return CGRectMake(110, 190, 100, 100);
}

-(void)previewControllerWillDismiss:(QLPreviewController *)controller
{
    
}
-(void)previewControllerDidDismiss:(QLPreviewController *)controller
{
    //控制器消失后调用
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)back:(UIButton *)sender {
[self dismissViewControllerAnimated:NO completion:nil];
}
@end
