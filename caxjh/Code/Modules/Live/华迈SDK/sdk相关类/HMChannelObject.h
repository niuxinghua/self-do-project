//
//  HMChannelObject.h
//  Demo
//
//  Created by guofeixu on 15/11/5.
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
@interface HMChannelObject : NSObject

@property (strong, nonatomic) NSString *channelName; //通道名称
@property (assign, nonatomic) node_handle channelNodeHandle; //通道句柄
@property (assign, nonatomic) NSInteger channelIndex; //通道号
@property (assign, nonatomic) NSInteger additionalIndex; //附加通道索引

@end
