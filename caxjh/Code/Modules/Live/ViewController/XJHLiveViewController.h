//
//  XJHLiveViewController.h
//  caxjh
//
//  Created by Yingchao Zou on 30/08/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHBaseViewController.h"
#import "HMSDKConst.h"
@interface XJHLiveViewController : XJHBaseViewController<UIGestureRecognizerDelegate,UIScrollViewDelegate>
//下面的属性是从demo里copy过来的
@property (strong, nonatomic) HMNodeObject *nodeObject;
@property (strong, nonatomic) HMChannelObject *channelObject;
@property (assign, nonatomic) int64_t powerActor;
@property (nonatomic) BOOL isDirectDevice;
@property (strong, nonatomic) NSString *ip;
@property (nonatomic) uint16 port;
@property (strong, nonatomic) NSString *sn;
@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) NSString *pwd;



@end
