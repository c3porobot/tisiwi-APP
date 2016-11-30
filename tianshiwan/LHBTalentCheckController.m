//
//  LHBTalentCheckController.m
//  tianshiwan
//
//  Created by 刘鸿博 on 15/12/14.
//  Copyright © 2015年 tianshiwan. All rights reserved.
//

#import "LHBTalentCheckController.h"
#import <QuickLook/QuickLook.h>
#import "AFNetworking.h"
#define kCheckInfoURL @"http://120.132.70.218/v1/service/personnel/%@/mail_attachment/"
#define kURL @"http://7xl8p4.com2.z0.glb.qiniucdn.com/resume_lirui.pdf"
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface LHBTalentCheckController ()<QLPreviewControllerDelegate, QLPreviewControllerDataSource>
@property (nonatomic, strong) NSMutableArray *PDFArray; //存储PDF文档的数据源
@property (nonatomic, copy) NSString *pdfPath; //PDF文件路径
@end

@implementation LHBTalentCheckController
//懒加载
- (NSMutableArray *)PDFArray {
    if (!_PDFArray) {
        self.PDFArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _PDFArray;
}





- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    QLPreviewController * qlPreview = [[QLPreviewController alloc]init];
    if (SYSTEM_VERSION_LESS_THAN(@"10.0")) {
        [self addChildViewController:qlPreview];
    }
    qlPreview.dataSource = self; //需要打开的文件的信息要实现dataSource中的方法
    qlPreview.delegate = self;  //视图显示的控制
    [self presentViewController:qlPreview animated:YES completion:^{
        //需要用模态化的方式进行展示
    }];
//    [self.navigationController pushViewController:qlPreview animated:YES];
    //创建一个文件路径
    //获取沙盒路径
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    //创建一个文件路径. 文件名
    NSString *filePath = [cachesPath stringByAppendingPathComponent:@"download.pdf"];
    self.pdfPath = filePath;
    //判断该文件是否存在
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        //不存在该文件,进行下载
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:kURL]];
        //下载 AFHTTPRequestOperation 专门针对下载 上传一个类.
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        //append:是否拼接数据
        [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:filePath append:NO]];
        //下载成功方法回调
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
          
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //下载成功
            NSLog(@"%@", error);
        }];
        //暂停下载
        //[operation pause];
        //手动开启下载任务
        [operation start];
        
        
    } else {
        //存在文件进行播放
    }
    
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







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - previewControllerDataSource
-(NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1; //需要显示的文件的个数
}
-(id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
        //返回要打开文件的地址，包括网络或者本地的地址
    NSURL * url = [NSURL fileURLWithPath:self.pdfPath];
    [controller reloadData];
    return url;
}
#pragma mark - previewControllerDelegate

-(CGRect)previewController:(QLPreviewController *)controller frameForPreviewItem:(id<QLPreviewItem>)item inSourceView:(UIView *__autoreleasing *)view
{
    //提供变焦的开始rect，扩展到全屏
    return CGRectMake(110, 190, 100, 100);
}
//-(UIImage *)previewController:(QLPreviewController *)controller transitionImageForPreviewItem:(id<QLPreviewItem>)item contentRect:(CGRect *)contentRect
//{
//    //返回控制器在出现和消失时显示的图像
//    return [UIImage imageNamed:@"gerenziliao_morentouxiang.png"];
//}
-(void)previewControllerDidDismiss:(QLPreviewController *)controller
{
    //控制器消失后调用
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)previewControllerWillDismiss:(QLPreviewController *)controller
{
    //控制器在即将消失后调用
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
