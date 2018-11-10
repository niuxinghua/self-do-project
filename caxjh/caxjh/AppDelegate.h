//
//  AppDelegate.h
//  caxjh
//
//  Created by Yingchao Zou on 30/08/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate, WXApiDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

