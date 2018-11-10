//
//  HMDevListViewController.h
//  Demo
//
//  Created by guofeixu on 15/10/10.
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

@interface HMDevListViewController : UIViewController

@property (assign, nonatomic) node_handle node;
@property (assign, nonatomic) int powerActor;

@end
