//
//  AppDelegate.m
//  tianshiwan
//
//  Created by zhouhai on 15/9/6.
//  Copyright (c) 2015年 tianshiwan. All rights reserved.
//

#import "AppDelegate.h"
#import "CXLog.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "TSWSplashViewController.h"
#import "Lotuseed.h"
#import "GeTuiSdk.h"
#import "RDVTabBarController.h"
#import "TSWArticleDetailsViewController.h"
#import "TSWPassValue.h"

#import <Instabug/Instabug.h>
#define NotifyActionKey "NotifyAction"
//生成静态的, 不可被改变的字符串
NSString* const NotificationCategoryIdent  = @"ACTIONABLE";
NSString* const NotificationActionOneIdent = @"ACTION_ONE";
NSString* const NotificationActionTwoIdent = @"ACTION_TWO";

@interface AppDelegate ()<GeTuiSdkDelegate>
@property (nonatomic, strong) NSString *deviceToken; //推送令牌
@property (nonatomic, strong) NSString *payloadId;
@property (nonatomic, assign) int lastPaylodIndex;
@property (nonatomic) BOOL isLaunchedByNotification;
@property (nonatomic, strong) NSDictionary *userinfo;
@property (nonatomic) int backgroundCount;
@property (nonatomic) BOOL isBackground;
@property (nonatomic) BOOL fromTerminate;
@property (nonatomic) int count;
@end

@implementation AppDelegate

- (void)registerRemoteNotification {
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        //IOS8 新的通知机制category注册 ,创建交互通知
        //action1 和 action2 分别为消息推送的两个按钮
        UIMutableUserNotificationAction *action1;
        action1 = [[UIMutableUserNotificationAction alloc] init];
        [action1 setActivationMode:UIUserNotificationActivationModeBackground];
        [action1 setTitle:@"取消"];
        [action1 setIdentifier:NotificationActionOneIdent];
        [action1 setDestructive:NO];
        [action1 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationAction *action2;
        action2 = [[UIMutableUserNotificationAction alloc] init];
        [action2 setActivationMode:UIUserNotificationActivationModeBackground];
        [action2 setTitle:@"回复"];
        [action2 setIdentifier:NotificationActionTwoIdent];
        [action2 setDestructive:NO];
        [action2 setAuthenticationRequired:NO];
        
        UIMutableUserNotificationCategory *actionCategory;
        actionCategory = [[UIMutableUserNotificationCategory alloc] init];
        [actionCategory setIdentifier:NotificationCategoryIdent];
        [actionCategory setActions:@[action1, action2]
                        forContext:UIUserNotificationActionContextDefault];
        
        NSSet *categories = [NSSet setWithObject:actionCategory];
        UIUserNotificationType types = (UIUserNotificationTypeAlert|
                                        UIUserNotificationTypeSound|
                                        UIUserNotificationTypeBadge);
        
        UIUserNotificationSettings *settings;
        settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
//    } else {
//        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|
//                                                                       UIRemoteNotificationTypeSound|
//                                                                       UIRemoteNotificationTypeBadge);
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
//    }
#else
    UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge);
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
#endif
    
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //[NSThread sleepForTimeInterval:5.0];
    //[window addSubview:viewController.view];
    //[_window makeKeyAndVisible];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    

    // Override point for customization after application launch.
    _backgroundCount = 0;
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:0 diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];

    //------莲子统计 开始 ----//
    [Lotuseed setDebugMode:NO]; //SDK处于DEBUG模式，发布时请关闭
//    [Lotuseed setSessionContinueSeconds:15]; //更改应用默认Session重启间隔，单位：秒
    [Lotuseed setCrashReportEnabled:YES]; //是否提交程序异常报告
    [Lotuseed startWithAppKey:@"R0ZX7N5i8Lscs2G8pR8I"]; //必须添加的接口调用
    //其他Lotuseed API调用请放在startWithAppKey()后！！！
//    [Lotuseed checkUpate]; //允许应用更新提醒
    [Lotuseed updateOnlineConfig]; //更新在线参数配置
    //------莲子统计 结束 ----//
    
    
    //------个推 开始 ----//
    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
    
    [self startSdkWith:GETUI_APPID appKey:GETUI_APPKEY appSecret:GETUI_APPSECRET];
    
    // [2]:注册APNS
    
    [self registerRemoteNotification];
    
    // [2-EXT]: 获取启动时收到的APN数据
    //------个推 结束 ----//
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    CXLogFormatter *formatter = [[CXLogFormatter alloc] init];
    [[DDASLLogger sharedInstance] setLogFormatter:formatter];
    [[DDTTYLogger sharedInstance] setLogFormatter:formatter];
    
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) { // 判断是否是IOS7
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
        [application setStatusBarStyle:UIStatusBarStyleLightContent];//黑体白字
                [application setStatusBarStyle:UIStatusBarStyleDefault];//黑体黑字
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor clearColor];
    //   [self setupViewControllers];
    TSWSplashViewController *splashViewController = [[TSWSplashViewController alloc] init];
    
    [self.window setRootViewController:splashViewController];
    NSLog(@"*********************deviceToken:%@",_deviceToken);

    [self.window makeKeyAndVisible];
    
    
    NSDictionary *message=[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (message) {
        _fromTerminate = YES;
        NSString *payloadMsg = [message objectForKey:@"payload"];
        //        NSString *record = [NSString stringWithFormat:@"[APN]%@,%@",[NSDate date],payloadMsg];
        NSData *jsonData = [payloadMsg dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        if(dic){
            _userinfo = dic;
            double delayInSeconds = 2.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PresentView" object:[NSString stringWithFormat:@"%@", [_userinfo objectForKey:@"sid"]]];
            });
        }
    }else{
       
    }
    
    return YES;

}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // [EXT] APP进入后台时，通知个推SDK进入后台,APP在后台,个推也能通知
    _isBackground = YES;
    [GeTuiSdk enterBackground];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        _isBackground = NO;
    });
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [GeTuiSdk resume];  // 恢复个推SDK运行
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)startSdkWith:(NSString *)appID appKey:(NSString*)appKey appSecret:(NSString *)appSecret
{
    
    NSError *err =nil;
    
    //[1-1]:通过 AppId、appKey 、appSecret 启动SDK
    
    [GeTuiSdk startSdkWithAppId:appID appKey:appKey appSecret:appSecret delegate:self error:&err];
    
    //[1-2]:设置是否后台运行开关
    
    [GeTuiSdk runBackgroundEnable:YES];
    
    //[1-3]:设置地理围栏功能，开启LBS定位服务和是否允许SDK 弹出用户定位请求，请求NSLocationAlwaysUsageDescription权限,如果UserVerify设置为NO，需第三方负责提示用户定位授权。
    
    [GeTuiSdk lbsLocationEnable:YES andUserVerify:YES];
}

-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    
    NSString *token = [[deviceToken description]
                       stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    
    _deviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"*********************deviceToken:%@",_deviceToken);
    
    // [3]:向个推服务器注册deviceToken
    
    [GeTuiSdk registerDeviceToken:_deviceToken];
    
}


-(void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    // [3-EXT]:如果APNS注册失败，通知个推服务器
    [GeTuiSdk registerDeviceToken:@""];
}


-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [GeTuiSdk resume];  // 恢复个推SDK运行
    completionHandler(UIBackgroundFetchResultNewData);
    
}

-(void)GeTuiSdkDidReceivePayload:(NSString*)payloadId andTaskId:(NSString*)taskId andMessageId:(NSString *)aMsgId fromApplication:(NSString *)appId
{
    if(_isBackground){
        // [4]: 收到个推消息
        _payloadId = payloadId;
        NSData *payload = [GeTuiSdk retrivePayloadById:payloadId]; //根据payloadId取回Payload
        NSString *payloadMsg = nil;
        if (payload) {
            payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
                                                  length:payload.length
                                                encoding:NSUTF8StringEncoding];
            
        }
        NSData *jsonData = [payloadMsg dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        if(dic){
            _isLaunchedByNotification = YES;
            _userinfo = dic;
            if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
                TSWArticleDetailsViewController *articleDetailsController = [[TSWArticleDetailsViewController alloc]initWithArticleId:[dic valueForKey:@"sid"] withPresent:YES];
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:articleDetailsController];
                [self.window.rootViewController presentViewController:navigationController animated:YES completion:nil];
            }
        }
        
        NSLog(@"task id : %@, messageId:%@", taskId, aMsgId);
        _isBackground = NO;
    }
}

- (void)GeTuiSdkDidOccurError:(NSError *)error
{
    
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog([NSString stringWithFormat:@">>>[GexinSdk error]:%@", [error localizedDescription]]);
    
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo{
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{

}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}
@end
