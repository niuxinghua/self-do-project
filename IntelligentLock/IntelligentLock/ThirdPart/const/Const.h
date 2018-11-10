//
//  Const.h
//  IntelligentLock
//
//  Created by niuxinghua on 2018/1/30.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#ifndef Const_h
#define Const_h
#import "UIView+Toast.h"
#import "RegisterViewController.h"
#import "UIBarButtonItem+UC.h"
#import "NetWorkTool.h"
#import "MultiLanTool.h"
#import "LockStoreManager.h"
#import "Masonry.h"
#import "PPNetworkHelper.h"
#import "LockStoreManager.h"
#import "loginModel.h"
#define kScreenWidth   [UIApplication sharedApplication].keyWindow.frame.size.width
#define kScreenHeight    [UIApplication sharedApplication].keyWindow.frame.size.height
#define WeakSelf(type) autoreleasepool{} __weak __typeof__(type) weakSelf = type;
#define StrongSelf(type) autoreleasepool{} __strong __typeof__(type) strongSelf = type;

//iPhone X
#define isiPhoneX     (kScreenWidth == 375.f && kScreenHeight == 812.f)
#define UICOLOR_HEX(hexString) [UIColor colorWithRed:((float)((hexString & 0xFF0000) >> 16))/255.0 green:((float)((hexString & 0xFF00) >> 8))/255.0 blue:((float)(hexString & 0xFF))/255.0 alpha:1.0]


#define vCFBundleShortVersionStr [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]





#endif /* Const_h */
