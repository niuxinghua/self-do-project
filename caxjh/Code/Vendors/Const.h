//
//  Const.h
//  caxjh
//
//  Created by niuxinghua on 2017/8/30.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#ifndef Const_h
#define Const_h
#import "PPNetworkHelper.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
typedef void(^SuccessBlock)(id response);
typedef void(^failBlock)(id error);

#define kAPIQueryUrl [NSString stringWithFormat:@"https://children.xiangjianhai.com:998/app/query?token=%@&dt=0&u=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA_TOKEN"], [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"]]

#define kAPIUpdateURL [NSString stringWithFormat:@"https://children.xiangjianhai.com:998/app/update?token=%@&dt=0&u=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA_TOKEN"], [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"]]


#define kAPICreateURL [NSString stringWithFormat:@"https://children.xiangjianhai.com:998/app/create?token=%@&dt=0&u=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA_TOKEN"], [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"]]



#define kAPILoginURL @"https://children.xiangjianhai.com:998/app/login"
#define kAPIRegistURL @"https://children.xiangjianhai.com:998/app/register"
#define kAPIForgetPassURL @"https://children.xiangjianhai.com:998/app/findPassword"
#define kAPIChangePassURL [NSString stringWithFormat:@"https://children.xiangjianhai.com:998/webadmin/changePassword?token=%@&dt=0&u=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA_TOKEN"], [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"]]

// 拿聊天的token
#define kAPIIMTokenURL [NSString stringWithFormat:@"https://children.xiangjianhai.com:998/webadmin/imToken?token=%@&dt=0&u=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA_TOKEN"], [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"]]


#define kAPICaptchaURL @"https://children.xiangjianhai.com:998/webadmin/SMSVerify"


#define kAPIVIPROOMURL [NSString stringWithFormat:@"https://children.xiangjianhai.com:998/webadmin/getAuthority?token=%@&dt=0&u=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA_TOKEN"], [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"]]




#define kAPISignURl [NSString stringWithFormat:@"https://children.xiangjianhai.com:998/app/niu_pay/signature?token=%@&dt=0&u=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA_TOKEN"], [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"]]





#define kAPIPurchedOrder [NSString stringWithFormat:@"https://children.xiangjianhai.com:998/app/queryamountMoney?token=%@&dt=0&u=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA_TOKEN"], [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"]]

#define kAPIMallInfo [NSString stringWithFormat:@"%@%@",@"https://children.xiangjianhai.com:998/app/query?token=",[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA_TOKEN"]]




#define kAPIQRURL [NSString stringWithFormat:@"https://children.xiangjianhai.com:998/webadmin/qrUtil?token=%@&dt=0&u=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA_TOKEN"], [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"]]




// #define kAPIUploadImage @"http://children.xiangjianhai.com:20002/api/fileUpload?name="
#define kAPIUploadImage [NSString stringWithFormat:@"https://children.xiangjianhai.com:998/api/fileUpload?token=%@&dt=0&u=%@&name=",[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA_TOKEN"], [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"]]


#define kAPICreateOrder [NSString stringWithFormat:@"https://children.xiangjianhai.com:998/webadmin/orderGenerate?token=%@&dt=0&u=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA_TOKEN"], [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"]]

#define kAPIGoodsOrder [NSString stringWithFormat:@"https://children.xiangjianhai.com:998/webadmin/goodsOrderGenerate?token=%@&dt=0&u=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA_TOKEN"], [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"]]


#define kAPIQueryWatch [NSString stringWithFormat:@"https://children.xiangjianhai.com:998/app/query?token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA_TOKEN"]]

#define kAPIBindWatch [NSString stringWithFormat:@"https://children.xiangjianhai.com:998/app/watchBind?token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA_TOKEN"]]



#define kAPIQueryFence [NSString stringWithFormat:@"https://children.xiangjianhai.com:998/app/query?token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA_TOKEN"]]


#define kAPIAddFence [NSString stringWithFormat:@"https://children.xiangjianhai.com:998/app/create?token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA_TOKEN"]]

#define kAPIEditFence [NSString stringWithFormat:@"https://children.xiangjianhai.com:998/app/update?token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA_TOKEN"]]
//https://children.xiangjianhai.com:999/app/update?token=7205589feec837eba4ae654e200daa4

#define kAPISetUploadTimeInterval [NSString stringWithFormat:@"https://children.xiangjianhai.com:998/app/update?token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA_TOKEN"]]

#define kAPIQuerySortedCity [NSString stringWithFormat:@"https://children.xiangjianhai.com:998/app/getRegion?token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA_TOKEN"]]

#define kAPIAllCity [NSString stringWithFormat:@"https://children.xiangjianhai.com:998/app/query?token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA_TOKEN"]]
 

#define kAPICityID [NSString stringWithFormat:@"https://children.xiangjianhai.com:998/app/query?token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_DATA_TOKEN"]]

#define SocketIP @"children.xiangjianhai.com"
#define SocketPort 8083
#define LocationNew @"newLocation"
#define SetCenterSuccess @"didSetCenterNumber"
#define TraceSuccess @"didTraceSuccess"
typedef NS_ENUM(NSInteger, ArticleType)
{
    ArticleTypeVIP = 0,
    ArticleTypeSafety,
    ArticleTypeParent,
    ArticleTypeLost,
    ArticleTypeDonate,
    ArticleTypeSearch
};

#endif /* Const_h */
