//
//  AppDelegate.m
//  caxjh
//
//  Created by Yingchao Zou on 30/08/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "AppDelegate.h"
#import "XJHPostIndexViewController.h"
#import "XJHIndexOfMallViewController.h"
#import "XJHLiveViewController.h"
#import "MapViewController.h"
#import "XJHUserIndexViewController.h"
#import "HMSDKManager.h"
#import "XJHCommonLoginViewController.h"
#import "IQKeyboardManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import <Bugly/Bugly.h>
#import <RongIMKit/RongIMKit.h>
#import "SocketManager.h"
#import "Const.h"
#import "MapManager.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "XJHBaseTabViewController.h"
#import "XJHBaseNavViewController.h"
#import "HQAlertViewController.h"
@interface AppDelegate ()

<
XJHCommonLoginViewControllerDelegate,
WXApiDelegate
>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    BuglyConfig * config = [[BuglyConfig alloc] init];
    config.blockMonitorEnable = YES;
    config.reportLogLevel = BuglyLogLevelDebug;
    [Bugly startWithAppId:@"d07e948288" config:config];
    [WXApi registerApp:@"wxa1fbfdb142a2f2e1"];
    [AMapServices sharedServices].apiKey = @"8d603054d29c342521fda1c2476b8e80";
    [IQKeyboardManager sharedManager].previousNextDisplayMode = IQPreviousNextDisplayModeAlwaysHide;
    
    // Override point for customization after application launch.
    [[HMSDKManager sharedInstance] initSDK];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    if ([userID isEqual:[NSNull null]]) {
        self.window.rootViewController = [self loginNavigationController];
    }
    
    else if (userID.length == 0) {
        self.window.rootViewController = [self loginNavigationController];
//        [self getIMToken];
    }
    
    else {
        self.window.rootViewController = [self mainTabBarController];
        
       // [[SocketManager sharedInstance]connectToServer];
//        [self getIMToken];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldLogout) name:@"NOTIFICATION_SHOULD_LOGOUT" object:nil];
   // NOTIFICATION_InValidToken
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldLogoutInValidToken) name:@"NOTIFICATION_InValidToken" object:nil];
    
//    // XJHTODO 融云用的安卓的Key
//    [[RCIM sharedRCIM] initWithAppKey:@"0vnjpoad0glbz"];
//
//    [[RCIM sharedRCIM] connectWithToken:@"h5tHFh+SvOmF2ghTE0xX5ilUMa8SrAT6n0NYJr9o+Qs3PrD/EGn+eEHqO2bt59082xhmygeIAln08FVS2JJZhmwnN+AVOdBq" success:^(NSString *userId) {
//
//    } error:^(RCConnectErrorCode status) {
//
//    } tokenIncorrect:^{
//
//    }];
    
    // [[RCIM sharedRCIM] initWithAppKey:@"k51hidwqknxeb"];
    
    // 生产环境
    [[RCIM sharedRCIM] initWithAppKey:@"tdrvipkstqo75"];
    
    [[MapManager sharedInstance]initSDK];

    
    // 使用 UNUserNotificationCenter 来管理通知
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    //监听回调事件
    center.delegate = self;
    
    //iOS 10 使用以下方法注册，才能得到授权
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              // Enable or disable features based on authorization.
                          }];
    
    
    return YES;
}

//- (void)getIMToken {
//    NSDictionary *dic = @{};
//    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
//    [PPNetworkHelper POST:kAPIIMTokenURL parameters:dic success:^(id responseObject) {
//
//    } failure:^(NSError *error) {
//
//    }];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@", resultDic);
        }];
    }
    
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)app openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@", resultDic);
        }];
    }
    
    return [WXApi handleOpenURL:url delegate:self];;
}

- (void)onReq:(BaseReq *)req {

}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        // 只要有起调，不管结果是什么，就通知一下，用来刷新套餐
        [[NSNotificationCenter defaultCenter] postNotificationName:@"XJH_PAYMENT_HAVE_RESULT" object:nil];
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
                NSLog(@"服务器端查询支付通知或查询API返回的结果再提示成功");
                [self.window makeToast:@"微信支付成功" duration:2.0 position:CSToastPositionTop];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WECHAT_PAY_SUCCESS" object:nil];
                break;
                
            default:
                NSLog(@"支付失败, retcode=%d", resp.errCode);
                [self.window makeToast:@"微信支付失败" duration:2.0 position:CSToastPositionTop];
                break;
        }
    }
}

- (XJHBaseNavViewController *)loginNavigationController {
    XJHCommonLoginViewController *loginViewController = [[XJHCommonLoginViewController alloc] init];
    loginViewController.delegate = self;
    XJHBaseNavViewController *navigationController = [[XJHBaseNavViewController alloc] initWithRootViewController:loginViewController];
    return navigationController;
}

- (XJHBaseTabViewController *)mainTabBarController {
    XJHBaseTabViewController *tabBarController = [[XJHBaseTabViewController alloc] init];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:253/255.0 green:97/255.0 blue:105/255.0 alpha:1.0] forKey:NSForegroundColorAttributeName];
   
    

    XJHPostIndexViewController *postIndexViewController = [[XJHPostIndexViewController alloc] init];
    postIndexViewController.title = @"首页";
    UINavigationController *postIndexNavigationViewController = [[UINavigationController alloc] initWithRootViewController:postIndexViewController];
    postIndexNavigationViewController.tabBarItem.title = @"首页";
    postIndexNavigationViewController.tabBarItem.image = [[UIImage imageNamed:@"homeTab.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    postIndexNavigationViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"homeTabSelected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
     [postIndexNavigationViewController.tabBarItem setTitleTextAttributes:dict forState:UIControlStateSelected];
    
    
    XJHIndexOfMallViewController *indexOfMallViewController = [[XJHIndexOfMallViewController alloc] init];
    indexOfMallViewController.title = @"商城";
    UINavigationController *indexOfMallNavigationViewController = [[UINavigationController alloc] initWithRootViewController:indexOfMallViewController];
    indexOfMallNavigationViewController.tabBarItem.title = @"商城";
    indexOfMallNavigationViewController.tabBarItem.image = [[UIImage imageNamed:@"shopTab.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    indexOfMallNavigationViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"shopTabSelected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
     [indexOfMallNavigationViewController.tabBarItem setTitleTextAttributes:dict forState:UIControlStateSelected];
    
    
    MapViewController *mapView = [[MapViewController alloc]init];
    UINavigationController *mapNavigationViewController = [[UINavigationController alloc]initWithRootViewController:mapView];
    mapNavigationViewController.tabBarItem.image = [[UIImage imageNamed:@"mapicon.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mapNavigationViewController.tabBarItem.title = @"地图";
    mapNavigationViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"mapiconhighlighted.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [mapNavigationViewController.tabBarItem setTitleTextAttributes:dict forState:UIControlStateSelected];
    
    
    
    XJHLiveViewController *liveViewController = [[XJHLiveViewController alloc] init];
    liveViewController.title = @"开放课堂";
    UINavigationController *liveNavigationViewController = [[UINavigationController alloc] initWithRootViewController:liveViewController];
    liveNavigationViewController.tabBarItem.title = @"开放学堂";
    liveNavigationViewController.tabBarItem.image = [[UIImage imageNamed:@"schoolTab.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
     liveNavigationViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"schoolTabSelected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
     [liveNavigationViewController.tabBarItem setTitleTextAttributes:dict forState:UIControlStateSelected];
    
    XJHUserIndexViewController *userIndexViewController = [[XJHUserIndexViewController alloc] init];
    userIndexViewController.title = @"我的";
    UINavigationController *userIndexNavigationViewController = [[UINavigationController alloc] initWithRootViewController:userIndexViewController];
    userIndexNavigationViewController.tabBarItem.title = @"我的";
    userIndexNavigationViewController.tabBarItem.image = [[UIImage imageNamed:@"MineTab.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    userIndexNavigationViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"MineTabSelected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
     [userIndexNavigationViewController.tabBarItem setTitleTextAttributes:dict forState:UIControlStateSelected];
    tabBarController.viewControllers = @[postIndexNavigationViewController, indexOfMallNavigationViewController,liveNavigationViewController, mapNavigationViewController,userIndexNavigationViewController];
    
    return tabBarController;
}

//
- (void)shouldLogoutInValidToken
{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"USER_ID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    UIViewController *viewController =  self.window.rootViewController.navigationController.viewControllers.lastObject;
    //     [[UIApplication sharedApplication].keyWindow makeToast:@"您的账号在别的终端登录"];
    //if (viewController) {
    [self.window makeToast:@"您的账号在别的终端登录"];
    // }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.window.rootViewController = [self loginNavigationController];
    });
    
}
- (void)shouldLogout {
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"USER_ID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.window.rootViewController = [self loginNavigationController];
    
}

// XJHCommonLoginViewControllerDelegate

- (void)toTab {
    self.window.rootViewController = [self mainTabBarController];
}
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    completionHandler(UNNotificationPresentationOptionSound);
}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[response.notification.request.content.userInfo objectForKey:@"body"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alert show];
    NSAttributedString *body = [[NSAttributedString alloc]initWithString:[response.notification.request.content.userInfo objectForKey:@"body"]];
    HQAlertViewController *alertVC =
    [HQAlertViewController alertWithTitle:[response.notification.request.content.userInfo objectForKey:@"title"]
                                 subTitle:nil
                              detailTitle:body
                        cancelButtonTitle:@"取消"
                          sureButtonTitle:@"查看"];
    alertVC.sureButtonBackgroundColor = [UIColor whiteColor];
    alertVC.sureButtonTitleColor = [UIColor colorWithRed:252/255.0 green:99/255.0 blue:102/255.0 alpha:1.0];
    [alertVC setSurenButtonClickBlock:^(UIButton *sureBtn) {
        NSLog(@"确认按钮被点击了");
        MapViewController *map = [[MapViewController alloc]init];
        map.isFromAlert = YES;
        NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]initWithDictionary:[response.notification.request.content.userInfo objectForKey:@"dataDic"]];
        [dic1 setObject:[response.notification.request.content.userInfo objectForKey:@"title"] forKey:@"title"];
        map.alertDic = dic1;
        UIViewController *keyViewController =
        [self topViewController];
        if (keyViewController) {
            [keyViewController.navigationController pushViewController:map animated:NO];
        }
    }];
    // 此处的self 为当前控制器
    UIViewController *keyViewController =
    [self topViewController];
    if (keyViewController) {
        [alertVC showWithPresentViewController:keyViewController];
    }
    
    completionHandler();
}
- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}
- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
@end
