//
//  HMRecordListViewController.h
//  Demo
//
//  Created by guofeixu on 15/11/6.
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
@interface HMRecordListViewController : UIViewController

@property (strong, nonatomic) HMNodeObject *nodeObject;
@property (strong, nonatomic) HMChannelObject *channelObject;

@end
