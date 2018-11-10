//
//  SocketManager.m
//  caxjh
//
//  Created by niuxinghua on 2017/11/23.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "SocketManager.h"
#import "HQAlertViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "MapViewController.h"
@interface SocketManager ()
@property(nonatomic, strong) GCDAsyncSocket *mySocket;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, assign) BOOL isSocketOnLine;
@property(nonatomic, strong) NSMutableArray *locationArr;
@end
@implementation SocketManager
static id socketManager = nil;
+ (id)allocWithZone:(struct _NSZone *)zone {
  if (!socketManager) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      socketManager = [super allocWithZone:zone];
    });
  }
  return socketManager;
}
- (id)init {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    socketManager = [super init];
    if ([[UIApplication sharedApplication] currentUserNotificationSettings]
            .types != UIUserNotificationTypeNone) {

    } else {
      [[UIApplication sharedApplication]
          registerUserNotificationSettings:
              [UIUserNotificationSettings
                  settingsForTypes:UIUserNotificationTypeAlert |
                                   UIUserNotificationTypeBadge |
                                   UIUserNotificationTypeSound
                        categories:nil]];
    }
  });
  return socketManager;
}
+ (instancetype)sharedInstance {
  return [[self alloc] init];
}

#pragma mark - scoket

- (void)connectToServer {
  if (!_mySocket) {
    _mySocket =
        [[GCDAsyncSocket alloc] initWithDelegate:self
                                   delegateQueue:dispatch_get_main_queue()];
  }
  NSError *error = nil;
  if (![self.mySocket connectToHost:SocketIP
                             onPort:SocketPort
                        withTimeout:2.0f
                              error:&error]) {
    NSLog(@"error:%@", error);
    [self.mySocket readDataWithTimeout:30 tag:0];
  }
}

#pragma mark -socket delegate
//连接
- (void)socket:(GCDAsyncSocket *)sock
    didConnectToHost:(NSString *)host
                port:(uint16_t)port {
  _isSocketOnLine = YES;
  NSLog(@"didConnectToHost");
  //连上之后可以每隔30s发送一次心跳包
  if (!self.timer) {
    self.timer =
        [NSTimer scheduledTimerWithTimeInterval:30.f
                                         target:self
                                       selector:@selector(heartbeatFunc)
                                       userInfo:nil
                                        repeats:YES];
    [self.timer fire];
  }
}

- (void)heartbeatFunc {

  NSString *userID =
      [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
  NSString *heart = [NSString stringWithFormat:@"[App*%@*0*LK]", userID];
  NSMutableData *data =
      [heart dataUsingEncoding:NSUTF8StringEncoding].mutableCopy;
  [data appendData:[GCDAsyncSocket CRLFData]];
  [self.mySocket writeData:data withTimeout:1.0f tag:0];
  [self.mySocket readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock
    didReadData:(NSData *)data
        withTag:(long)tag {

  NSString *str =
      [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  NSLog(@"read --%@", str);
  [self handleRecieveData:str];
  [self.mySocket readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
  [self connectToServer];
  if (self.locationDic) {
    dispatch_after(
        dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
          [self beginGetLocation:[self.locationDic objectForKey:@"imei"]];
        });
  }
}

#pragma mark--location

- (void)beginGetLocation:(NSString *)imei {

  NSString *userID =
      [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];

  if (_isSocketOnLine) {
    NSString *locationReq =
        [NSString stringWithFormat:@"[App*%@*0*DD_START,%@]", userID, imei];
    NSMutableData *data =
        [locationReq dataUsingEncoding:NSUTF8StringEncoding].mutableCopy;
    [data appendData:[GCDAsyncSocket CRLFData]];
    [self.mySocket writeData:data withTimeout:1.0f tag:0];
    [self.mySocket readDataWithTimeout:-1 tag:0];
  } else {
    dispatch_after(
        dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
          [self beginGetLocation:imei];
        });
  }
}
- (void)endGetLocation:(NSString *)imei {

  NSString *userID =
      [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];

  if (_isSocketOnLine) {
    NSString *locationReq =
        [NSString stringWithFormat:@"[App*%@*0*DD_END,%@]", userID, imei];
    NSMutableData *data =
        [locationReq dataUsingEncoding:NSUTF8StringEncoding].mutableCopy;
    [data appendData:[GCDAsyncSocket CRLFData]];
    [self.mySocket writeData:data withTimeout:1.0f tag:0];
    [self.mySocket readDataWithTimeout:-1 tag:0];
  }
}
- (void)dogetTraceData:(NSString *)starttime endTime:(NSString *)endtime {

  NSString *userID =
      [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];

  if (_isSocketOnLine) {
    NSString *locationReq =
        [NSString stringWithFormat:@"[App*%@*10*TRACE,%@,%@,%@,1,20]", userID,
                                   [self.locationDic objectForKey:@"imei"],
                                   starttime, endtime];
    NSMutableData *data =
        [locationReq dataUsingEncoding:NSUTF8StringEncoding].mutableCopy;
    [data appendData:[GCDAsyncSocket CRLFData]];
    [self.mySocket writeData:data withTimeout:1.0f tag:0];
    [self.mySocket readDataWithTimeout:-1 tag:0];
  }
}
- (void)setCenterNumber:(NSString *)number {

  NSString *userID =
      [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];

  if (_isSocketOnLine) {
    NSString *locationReq = [NSString
        stringWithFormat:@"[App*%@*0*CENTER,%@,%@]", userID,
                         [self.locationDic objectForKey:@"imei"], number];
    NSMutableData *data =
        [locationReq dataUsingEncoding:NSUTF8StringEncoding].mutableCopy;
    [data appendData:[GCDAsyncSocket CRLFData]];
    [self.mySocket writeData:data withTimeout:1.0f tag:0];
    [self.mySocket readDataWithTimeout:-1 tag:0];
  }
}

- (void)setTimeInterval:(NSString *)timestr {
  // [App*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX*LEN*UPLOAD,YYYYYYYYYY，时间间隔]

  NSString *userID =
      [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];

  if (_isSocketOnLine) {
    NSString *locationReq = [NSString
        stringWithFormat:@"[App*%@*0*UPLOAD,%@,%@]", userID,
                         [self.locationDic objectForKey:@"imei"], timestr];
    NSMutableData *data =
        [locationReq dataUsingEncoding:NSUTF8StringEncoding].mutableCopy;
    [data appendData:[GCDAsyncSocket CRLFData]];
    [self.mySocket writeData:data withTimeout:1.0f tag:0];
    [self.mySocket readDataWithTimeout:-1 tag:0];
  }
}

- (void)setSOSSMS:(BOOL)isOn {
  NSString *userID =
      [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];

  if (_isSocketOnLine) {
    NSString *locationReq = [NSString
        stringWithFormat:@"[App*%@*0*SOSSMS,%@,%d]", userID,
                         [self.locationDic objectForKey:@"imei"], isOn];
    NSMutableData *data =
        [locationReq dataUsingEncoding:NSUTF8StringEncoding].mutableCopy;
    [data appendData:[GCDAsyncSocket CRLFData]];
    [self.mySocket writeData:data withTimeout:1.0f tag:0];
    [self.mySocket readDataWithTimeout:-1 tag:0];
  }
}
- (void)setDROP:(BOOL)isOn {
  NSString *userID =
      [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];

  if (_isSocketOnLine) {
    NSString *locationReq = [NSString
        stringWithFormat:@"[App*%@*0*REMOVESMS,%@,%d]", userID,
                         [self.locationDic objectForKey:@"imei"], isOn];
    NSMutableData *data =
        [locationReq dataUsingEncoding:NSUTF8StringEncoding].mutableCopy;
    [data appendData:[GCDAsyncSocket CRLFData]];
    [self.mySocket writeData:data withTimeout:1.0f tag:0];
    [self.mySocket readDataWithTimeout:-1 tag:0];
  }
}
- (void)setSOSNumber:(NSString *)numbers {

  NSString *userID =
      [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];

  if (_isSocketOnLine) {
    NSString *locationReq = [NSString
        stringWithFormat:@"[App*%@*0*SOS,%@,%@]", userID,
                         [self.locationDic objectForKey:@"imei"], numbers];
    NSMutableData *data =
        [locationReq dataUsingEncoding:NSUTF8StringEncoding].mutableCopy;
    [data appendData:[GCDAsyncSocket CRLFData]];
    [self.mySocket writeData:data withTimeout:1.0f tag:0];
    [self.mySocket readDataWithTimeout:-1 tag:0];
  }
}
#pragma mark -handle all read stream

- (void)handleRecieveData:(NSString *)data {
  NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
  //心跳
  if ([data containsString:@"LK"]) {
    _isSocketOnLine = YES;
    // [self addLocalNotification:@"手表脱落报警"];
  }
  if ([data containsString:@"DD"] && [data containsString:@"latitude"]) {

    NSRange startRange = [data rangeOfString:@"{"];
    NSRange endRange = [data rangeOfString:@"}"];
    NSRange range = NSMakeRange(startRange.location + startRange.length - 1,
                                endRange.location - startRange.location -
                                    startRange.length + 2);
    NSString *dicstr = [data substringWithRange:range];
    NSData *jsonData = [dicstr dataUsingEncoding:NSUTF8StringEncoding];

    NSError *err;
    NSDictionary *dic =
        [NSJSONSerialization JSONObjectWithData:jsonData

                                        options:NSJSONReadingMutableLeaves

                                          error:&err];

    [defaultCenter postNotificationName:LocationNew object:dic];
  }

  //处理获取设置中心号码成功的消息
  if ([data containsString:@"CENTER"]) {

    [defaultCenter postNotificationName:SetCenterSuccess object:data];
  }

  //处理获取历史轨迹的问题
  if ([data containsString:@"trace"]) {

    NSRange startRange = [data rangeOfString:@"<"];
    NSRange endRange = [data rangeOfString:@">"];
    if (startRange.length > 0 && endRange.length > 0) {

      //        if(endRange.length == 0)
      //        {
      //
      //            endRange = [data rangeOfString:@"}"];
      //
      //        }
      NSRange range = NSMakeRange(startRange.location + startRange.length - 1,
                                  endRange.location - startRange.location -
                                      startRange.length + 2);
      NSString *dicstr = [data substringWithRange:range];
      dicstr =
          [dicstr stringByReplacingOccurrencesOfString:@"<" withString:@"["];
      dicstr =
          [dicstr stringByReplacingOccurrencesOfString:@">" withString:@"]"];
      NSData *jsonData = [dicstr dataUsingEncoding:NSUTF8StringEncoding];

      NSError *err;
      NSDictionary *dic =
          [NSJSONSerialization JSONObjectWithData:jsonData

                                          options:NSJSONReadingMutableLeaves

                                            error:&err];

      [defaultCenter postNotificationName:TraceSuccess object:dic];
    }
  }

  if ([data containsString:@"SOS"] && ![data containsString:@"AL_SOS"]) {
    [defaultCenter postNotificationName:@"SOSSetting" object:data];
  }
  if ([data containsString:@"UPLOAD"]) {
    [defaultCenter postNotificationName:@"TimeIntervalSetting" object:data];
  }
  if ([data containsString:@"SOSSMS"]) {
    [defaultCenter postNotificationName:@"SOSSMS" object:data];
  }
  // REMOVESMS
  if ([data containsString:@"REMOVESMS"]) {
    [defaultCenter postNotificationName:@"DROP" object:data];
  }
  if ([data containsString:@"AL_DROP"]) {
    //脱落报警
      NSString *sosImei = [[self getSOSImei:data] objectForKey:@"IMEI"];
      NSString *name = [self fiterNameWithImei:sosImei];
      [self addLocalNotification:[NSString stringWithFormat:@"您的监控对象%@于%@发生手表脱落，请注意", name,[self getTime]] title:@"手表脱落报警" dataDic: [self getSOSImei:data]];
  }
  if ([data containsString:@"AL_SOS"]) {
    //脱落报警
    NSString *sosImei = [[self getSOSImei:data] objectForKey:@"IMEI"];
    NSString *name = [self fiterNameWithImei:sosImei];
    [self
        addLocalNotification:[NSString stringWithFormat:@"您的监控对象%@于%@发出SOS求救，请注意", name,[self getTime]]
                       title:@"SOS报警" dataDic: [self getSOSImei:data]];
  }
  if ([data containsString:@"AL_FENCE_IN"]) {
    //脱落报警
    // [self addLocalNotification:@"入围栏报警"];
    NSString *sosImei = [[self getSOSImei:data] objectForKey:@"IMEI"];
    NSString *name = [self fiterNameWithImei:sosImei];
    [self addLocalNotification:[NSString stringWithFormat:@"您的监控对象%@于%@进入围栏，请注意", name,[self getTime]] title:@"入围栏报警" dataDic: [self getSOSImei:data]];
  }
  if ([data containsString:@"AL_FENCE_OUT"]) {
    //脱落报警
      NSString *sosImei = [[self getSOSImei:data] objectForKey:@"IMEI"];
      NSString *name = [self fiterNameWithImei:sosImei];
      [self addLocalNotification:[NSString stringWithFormat:@"您的监控对象%@于%@出围栏，请注意", name,[self getTime]] title:@"出围栏报警" dataDic: [self getSOSImei:data]];
  }
}
- (NSString *)fiterNameWithImei:(NSString *)imei {
  NSString *name = @"";

  for (NSDictionary *dic in _watchArray) {
    if ([[dic objectForKey:@"imei"] isEqualToString:imei]) {
      name = [dic objectForKey:@"name"];
      return name;
    }
  }

  return name;
}
- (NSMutableDictionary *)getSOSImei:(NSString *)data {
  NSMutableDictionary *dic;
    NSRange startRange = [data rangeOfString:@"{"];
    NSRange endRange = [data rangeOfString:@"}"];
    if (startRange.length > 0 && endRange.length > 0) {
        NSRange range = NSMakeRange(startRange.location + startRange.length - 1,
                                    endRange.location - startRange.location -
                                    startRange.length + 2);
        NSString *dicstr = [data substringWithRange:range];
        NSData *jsonData = [dicstr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *err;
        dic =
        [NSJSONSerialization JSONObjectWithData:jsonData
         
                                        options:NSJSONReadingMutableLeaves
         
                                          error:&err];
    }

  return dic;
}
#pragma mark 添加本地通知
- (void)addLocalNotification:(NSString *)contentbody title:(NSString *)title dataDic:(NSDictionary *)dic{
  if ([UIApplication sharedApplication].applicationState ==
      UIApplicationStateBackground) {

    UNUserNotificationCenter *center =
        [UNUserNotificationCenter currentNotificationCenter];

    //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是
    //UNNotificationContent ,此对象为不可变对象。
    UNMutableNotificationContent *content =
        [[UNMutableNotificationContent alloc] init];
    content.body = contentbody;
    content.sound = [UNNotificationSound defaultSound];
      content.userInfo = @{@"body" : contentbody,@"title":title,@"dataDic":dic};
    // 在 设定时间 后推送本地推送
    UNTimeIntervalNotificationTrigger *trigger =
        [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.1
                                                           repeats:NO];

    UNNotificationRequest *request =
        [UNNotificationRequest requestWithIdentifier:@"FiveSecond"
                                             content:content
                                             trigger:trigger];

    //添加推送成功后的处理！
    [center addNotificationRequest:request
             withCompletionHandler:^(NSError *_Nullable error){

             }];
  } else {


    NSAttributedString *body = [[NSAttributedString alloc]initWithString:contentbody];
    HQAlertViewController *alertVC =
        [HQAlertViewController alertWithTitle:title
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
        NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]initWithDictionary:dic];
        [dic1 setObject:title forKey:@"title"];
        
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
  }
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
- (NSString *)getTime
{
    // 获取系统当前时间
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"HH:mm"];
    NSString * na = [df stringFromDate:currentDate];
    return na;
}


#pragma mark 移除本地通知，在不需要此通知时记得移除
- (void)removeNotification {
  [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end
