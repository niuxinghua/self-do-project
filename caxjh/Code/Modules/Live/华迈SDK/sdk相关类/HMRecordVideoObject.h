//
//  HMRecordVideoObject.h
//  HMsee1000
//
//  Created by guofeixu on 15/9/23.
//  Copyright (c) 2015年 华迈. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "hm_sdk.h"
#import "define.h"
#import "HMNodeObject.h"
#import "HMChannelObject.h"
#import "HMAudioPlayer.h"
#import "HMAudioRecorder.h"
#import "HMRecordVideoObject.h"
//录像设备类型
typedef enum : NSUInteger {
    DeviceRecordTypeFromNormal, //普通设备录像
    DeviceRecordTypeFromNVS, //NVS设备录像，文件时长30分钟
    DeviceRecordTypeFromDVS, //DVS设备录像，存在不同通道
} DeviceRecordType;

//文件类型
typedef enum : NSUInteger {
    FileRecordTypeForAlarm = 1, //报警录像
    FileRecordTypeForHandle = 2, //手动录像
    FileRecordTypeForTimer = 4, //定时录像
} FileRecordType;

//文件来源类型
typedef enum : NSUInteger {
    FileRecordFlagFromLocal, //本地录像
    FileRecordFlagFromRemote, //远程录像
} FileRecordFlag;


@interface HMRecordVideoObject : NSObject

@property (strong, nonatomic) NSString *startTime; //文件开始时间
@property (strong, nonatomic) NSString *endTime; //文件结束时间
@property (strong, nonatomic) NSString *fileName; //文件名称
@property (assign, nonatomic) FileRecordType fileRecordType;
@property (assign, nonatomic) FileRecordFlag fileRecordFlag;
@property (assign, nonatomic) DeviceRecordType deviceRecordType;
@property (strong, nonatomic) NSString *channelId; //播放通道id
@property (assign, nonatomic) node_handle nodeHandle;
@property (assign, nonatomic) user_id userId;


@end
