//
//  HMPlayerViewController.h
//  Demo
//
//  Created by guofeixu on 15/10/22.
//  Copyright © 2015年 guofeixu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "hm_sdk.h"
#import "define.h"
#import "HMNodeObject.h"
#import "HMChannelObject.h"
#import "HMAudioPlayer.h"
#import "HMAudioRecorder.h"
#import "HMRecordVideoObject.h"

@interface HMPlayerViewController : UIViewController

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
