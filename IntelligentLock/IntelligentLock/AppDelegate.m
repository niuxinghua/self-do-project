//
//  AppDelegate.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/1/26.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "AppDelegate.h"
#import "Const.h"
#import "IQKeyboardManager.h"
#import "LoginModel.h"
#import "LoginViewController.h"
#import "MainTabBarViewController.h"
#import "MainViewController.h"
#import "MessageViewController.h"
#import "MineViewController.h"
#import "RecordViewController.h"
#import "BlueToothManager.h"
#import "MMDrawerController.h"
#import "LeftViewController.h"
#import "AFNetworking.h"
#import "LockStoreManager.h"
#import "NSDictionary+Null.h"
#import <Bugly/Bugly.h>
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#define kMaxATime [NSString stringWithFormat:@"maxatime%@%@",kLoginModel.retval.n,[kdicSelected objectForKey:@"key_id"]]
#define kRecordListKey [NSString stringWithFormat:@"%@%@",kLoginModel.retval.n,[kdicSelected objectForKey:@"key_id"]]
#define kRecordUpdateTime [NSString stringWithFormat:@"lastupdatetime%@%@",kLoginModel.retval.n,[kdicSelected objectForKey:@"key_id"]]
@interface AppDelegate ()<JPUSHRegisterDelegate>
@property (nonatomic,strong)MainTabBarViewController *rootTab;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    [Bugly startWithAppId:@"0757ac62d5"];
    [NetWorkTool sharedInstance];
   
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"e7677863dbe04d1da2962f1d"
                          channel:@"App Store"
                 apsForProduction:0
            advertisingIdentifier:advertisingId];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    [JPUSHService resetBadge];
    [application setApplicationIconBadgeNumber:0];
    
    NSDictionary *logindic = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    
    if (loginModel.retval.token) {
        self.window.rootViewController = [self getTabBar];
        [self.window makeKeyAndVisible];
    } else {
        LoginViewController *login = [[LoginViewController alloc] init];
        UINavigationController *loginNav =
        [[UINavigationController alloc] initWithRootViewController:login];
        self.window.rootViewController = loginNav;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoTab)
                                                 name:kLoginNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logout)
                                                 name:@"logout"
                                               object:nil];
    [IQKeyboardManager sharedManager].enable = YES;
    if (launchOptions) {
        NSDictionary *logindic = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
        
        LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
        
        if (loginModel.retval.token) {
            MainTabBarViewController *root = [self getTabBar];
            self.window.rootViewController = root;
            
            [root setSelectedIndex:2];
            [self.window makeKeyAndVisible];
        }
    }
        
    return YES;
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }

    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    NSDictionary *logindic = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    
    if (loginModel.retval.token) {
        MainTabBarViewController *root = [self getTabBar];
        self.window.rootViewController = root;

        [root setSelectedIndex:2];
        [self.window makeKeyAndVisible];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    if ([@"REFRESH_RECORD" isEqualToString:content]) {
        [self getRecord];
    }else  if ([@"REFRESH_MSG" isEqualToString:content]) {
        if(![[self topViewController]isKindOfClass:[MessageViewController class]])
        {
            [_rootTab setNewMessageBarIcon];
        }
        [self getMsg];
    }else  if ([@"REFRESH_LOCK" isEqualToString:content]) {
        [self getLockList];
    }
//    NSString *messageID = [userInfo valueForKey:@"_j_msgid"];
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];
//    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
    
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

#pragma mark methods

- (void)gotoTab {
    self.window.rootViewController = [self getTabBar];
    [self.window makeKeyAndVisible];
}

- (MainTabBarViewController *)getTabBar {
    MainTabBarViewController *tabbar = [[MainTabBarViewController alloc] init];
    _rootTab = tabbar;
    [CYTabBarConfig shared].selectedTextColor = [UIColor whiteColor];
    [CYTabBarConfig shared].textColor = [UIColor whiteColor];
    [CYTabBarConfig shared].backgroundColor = [UIColor colorWithRed:(105/255.0) green:(181/255.0) blue:(57/255.0) alpha:1.0];
    [CYTabBarConfig shared].selectIndex = 0;
    [CYTabBarConfig shared].centerBtnIndex = 2;
    [CYTabBarConfig shared].HidesBottomBarWhenPushedOption = HidesBottomBarWhenPushedAlone;
    
    MainViewController *main = [[MainViewController alloc] init];
    UIViewController *left = [[LeftViewController alloc]init];
    MMDrawerController * drawerController = [[MMDrawerController alloc]
                                             initWithCenterViewController:main
                                             leftDrawerViewController:left
                                             rightDrawerViewController:nil];
    
    RecordViewController *record = [[RecordViewController alloc] init];
    MessageViewController *message = [[MessageViewController alloc] init];
    MineViewController *mine = [[MineViewController alloc] init];
    
    UINavigationController *nav1 =
    [[UINavigationController alloc] initWithRootViewController:drawerController];
    [tabbar addChildController:nav1
                         title:[kMultiTool getMultiLanByKey:@"home"]
                     imageName:@"maintab"
             selectedImageName:@"maintabselected"];
    UINavigationController *nav2 =
    [[UINavigationController alloc] initWithRootViewController:record];
    [tabbar addChildController:nav2
                         title:[kMultiTool getMultiLanByKey:@"record"]
                     imageName:@"record"
             selectedImageName:@"recordselected"];
    
    [tabbar addCenterController:nil
                          bulge:YES
                          title:[kMultiTool getMultiLanByKey:@"add"]
                      imageName:@"addicon"
              selectedImageName:@"addicon"];
    
    Boolean hasMSg=[[NSUserDefaults standardUserDefaults] boolForKey:@"hasmsg"];
    UINavigationController *nav3 =
    [[UINavigationController alloc] initWithRootViewController:message];
    [tabbar addChildController:nav3
                         title:[kMultiTool getMultiLanByKey:@"message"]
                     imageName:hasMSg?@"xiaoxi_new":@"message"
             selectedImageName:@"messageselected"];
    UINavigationController *nav4 =
    [[UINavigationController alloc] initWithRootViewController:mine];
    [tabbar addChildController:nav4
                         title:[kMultiTool getMultiLanByKey:@"mine"]
                     imageName:@"mine"
             selectedImageName:@"mineselected"];

    return tabbar;
}

- (void)logout {
    [LockStoreManager sharedManager].selectedLock = nil;
    [LockStoreManager sharedManager].lockList = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginmodel"];
    LoginViewController *login = [[LoginViewController alloc] init];
    UINavigationController *loginNav =
    [[UINavigationController alloc] initWithRootViewController:login];
    self.window.rootViewController = loginNav;
}

- (void)getLockList
{
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    
    if (loginModel&&loginModel.retval) {
        
        
        NSDictionary *dic = @{@"app":@"userloginapp",@"act":@"lock",@"token":loginModel.retval.token};
        
        
        //[PPNetworkHelper setValue:<#(NSString *)#> forHTTPHeaderField:<#(NSString *)#>];
        [PPNetworkHelper  GET:kBaseUrl parameters:dic success:^(id responseObject) {
            
            NSString *msg = [responseObject objectForKey:@"msg"];
            if ([msg containsString:@"login failed"]) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"logout" object:nil];
                return ;
            }
            if([responseObject objectForKey:@"retval"]){
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary nullArr:[responseObject objectForKey:@"retval"]] forKey:@"locklist"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSArray *array = [responseObject objectForKey:@"retval"];
                if (array.count <= 0) {
                }
                if (array.count > 0) {
                    if (![array containsObject:[LockStoreManager sharedManager].selectedLock]) {
                        [LockStoreManager sharedManager].selectedLock = array[0];
                    }
                    
                    [LockStoreManager sharedManager].lockList = array.copy;
                    
                }
            }
            if ([LockStoreManager sharedManager].lockList){
                for (NSDictionary *dic in [LockStoreManager sharedManager].lockList) {
                    //判断本地是否存储了offnume
                    NSString *offnumkey = [NSString stringWithFormat:@"off%@%@",kLoginModel.retval.n,[dic objectForKey:@"key_id"]];
                    NSString *usenumkey = [NSString stringWithFormat:@"use%@%@",kLoginModel.retval.n,[dic objectForKey:@"key_id"]];
                    //                    if(![[NSUserDefaults standardUserDefaults] objectForKey:offnumkey])
                    //                    {
                    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"offline_num"] forKey:offnumkey];
                    
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    //                    }
                    //                    if(![[NSUserDefaults standardUserDefaults] objectForKey:usenumkey])
                    //                    {
                    [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"usetime"] forKey:usenumkey];
                    
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    //                    }
                }
                
            }
            
        } failure:^(NSError *error) {
            
        }];
        
    }
    
}

- (void)getMsg
{
    if (![PPNetworkHelper isNetwork]) {
        
        return;
    }
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    NSString *messageIdkey = [NSString stringWithFormat:@"%@-%@",loginModel.retval.user_id,@"message_id"];
    NSString *msgId = [[NSUserDefaults standardUserDefaults] objectForKey:messageIdkey];
    if ([msgId isEqual:[NSNull null]] || !msgId.length) {
        msgId = @"0";
    }
    NSDictionary *dic = @{@"app":@"userloginapp",@"act":@"get_message",@"token":loginModel.retval.token,@"msg_id":msgId};
    
    NSString *url = [NSString stringWithFormat:@"%@?app=userloginapp&act=get_message&token=%@&msg_id=%@",kBaseMessageUrl,loginModel.retval.token,msgId];
    NSLog(@"messageurl---%@",url);
    [PPNetworkHelper GET:kBaseUrl parameters:dic success:^(id responseObject) {
        
       NSMutableArray *dataList=[[NSMutableArray alloc]init];
        [dataList addObjectsFromArray:[responseObject objectForKey:@"retval"]];
        if (dataList&&dataList.count>0) {
            // [_dataList sortUsingFunction:compare context:NULL];
            NSDictionary *logindic =
            [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
            LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
            NSString *messagelistkey = [NSString stringWithFormat:@"%@-%@",loginModel.retval.user_id,@"message_id"];
            [[NSUserDefaults standardUserDefaults] setObject:dataList forKey:messagelistkey];
            NSDictionary *dic = dataList.lastObject;
            NSString *messageIdkey = [NSString stringWithFormat:@"%@-%@",loginModel.retval.user_id,@"message_id"];
            [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"msg_id"] forKey:messageIdkey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMessage" object:nil];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)getRecord
{
    
    //    锁记录
    NSDictionary *lock = [LockStoreManager sharedManager].selectedLock;
    if (!lock) {
        kWINDOW.userInteractionEnabled = YES;
        return;
    }
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    NSDictionary *dicSelected = [LockStoreManager sharedManager].selectedLock;
//    NSString *timeStr = [[NSUserDefaults standardUserDefaults] objectForKey:kRecordUpdateTime];
//    if (!timeStr) {
//        timeStr = @"";
//    }
//    
//    int log_id=0;
//    
//    NSString *add_time=@"";
//    if (![[[NSUserDefaults standardUserDefaults] objectForKey:kRecordListKey] isEqual:[NSNull null]]) {
//        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:kRecordListKey];
//        NSMutableArray *dataList1 = [self stringToJSON:str].copy;
//        if (dataList1!=nil) {
//            int count = dataList1.count;//减少调用次数
//            for( int i=0; i<count; i++){
//                NSDictionary *dic=[dataList1 objectAtIndex:i];
//                int g_id=[[dic objectForKey:@"log_id"] integerValue];
//                if (g_id>log_id) {
//                    log_id=g_id;
//                    add_time=[dic objectForKey:@"a_time"];
//                }
//            }
//        }
//    }
    
     NSString *add_time = [[NSUserDefaults standardUserDefaults] objectForKey:kMaxATime];
    if (!add_time) {
        add_time = @"";
    }
    
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    NSDictionary *dic = @{@"app":@"userloginapp",@"act":@"unlock_log",@"token":loginModel.retval.token,@"add_time": add_time,@"lock_id":[lock objectForKey:@"lock_id"]};
    [PPNetworkHelper GET:kBaseUrl parameters:dic success:^(id responseObject) {
       
        NSArray *array;
        if ([responseObject objectForKey:@"retval"] && ![[responseObject objectForKey:@"retval"] isEqual:[NSNull null]]) {
            array =[[[responseObject objectForKey:@"retval"] reverseObjectEnumerator] allObjects];
            if (![array isEqual:[NSNull null]] && array.count) {
                
            }
            
        }
        NSMutableArray *dataList = [NSMutableArray arrayWithArray:array];
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:kRecordListKey] isEqual:[NSNull null]]) {
            NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:kRecordListKey];
            if (str.length) {
                int log_id=0;
                NSString *add_time=@"";

                NSArray *array = [self stringToJSON:str];
                for (int i=0; i<array.count; i++) {
                    NSDictionary *dic = array[i];
                    int g_id=[[dic objectForKey:@"log_id"] integerValue];
                    if (g_id>log_id) {
                        log_id=g_id;
                        add_time=[dic objectForKey:@"a_time"];
                    }

                    if (![dataList containsObject:dic]) {
                        [dataList addObject:dic];
                    }
                }
                [[NSUserDefaults standardUserDefaults] setObject:add_time forKey:kMaxATime];
            }
            
            [[dataList reverseObjectEnumerator] allObjects];
            

        }
        [[NSUserDefaults standardUserDefaults] setObject:[self jsonStringWithArray:dataList] forKey:kRecordListKey];
        [[dataList reverseObjectEnumerator] allObjects];
        
    } failure:^(NSError *error) {
        
    }];
    
}

/**
 未知类型（仅限字典/数组/字符串）
 
 @param object 字典/数组/字符串
 @return 字符串
 */
-(NSString *) jsonStringWithObject:(id) object{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [self jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [self jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [self jsonStringWithArray:object];
    }
    return value;
}

/**
 字符串类型转JSON
 
 @param string 字符串类型
 @return 返回字符串
 */
-(NSString *) jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"%@",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]
            ];
}

/**
 数组类型转JSON
 
 @param array 数组类型
 @return 返回字符串
 */
-(NSString *) jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [self jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}

/**
 字典类型转JSON
 
 @param dictionary 字典数据
 @return 返回字符串
 */
-(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [self jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":\"%@\"",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}

- (NSArray *)stringToJSON:(NSString *)jsonStr {
    if (jsonStr) {
        id tmp = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        
        if (tmp) {
            if ([tmp isKindOfClass:[NSArray class]]) {
                
                return tmp;
                
            } else if([tmp isKindOfClass:[NSString class]]
                      || [tmp isKindOfClass:[NSDictionary class]]) {
                
                return [NSArray arrayWithObject:tmp];
                
            } else {
                return nil;
            }
        } else {
            return nil;
        }
        
    } else {
        return nil;
    }
}


@end
