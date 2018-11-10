//
//  HMNodeObject.h
//  Demo
//
//  Created by guofeixu on 15/10/10.
//  Copyright © 2015年 guofeixu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "hm_sdk.h"
#import "define.h"
#import "HMNodeObject.h"
#import "HMChannelObject.h"
#import "HMAudioPlayer.h"
#import "HMAudioRecorder.h"
#import "HMRecordVideoObject.h"
@interface HMNodeObject : NSObject

@property (assign, nonatomic) node_handle nodeHandle;
@property (assign, nonatomic) NODE_TYPE_INFO nodeType;
@property (strong, nonatomic) NSString *nodeName;
@property (assign, nonatomic) BOOL nodeIsOnline;
@property (strong,nonatomic)  NSString *SN;

@property (strong,nonatomic)  NSString *showName;



@end
