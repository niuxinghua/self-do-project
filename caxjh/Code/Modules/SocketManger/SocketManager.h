//
//  SocketManager.h
//  caxjh
//
//  Created by niuxinghua on 2017/11/23.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h" // for TCP
#import "GCDAsyncUdpSocket.h" // for UDP
#import "Const.h"
@interface SocketManager : NSObject<GCDAsyncSocketDelegate>

+ (instancetype)sharedInstance;
- (void)connectToServer;
- (void)beginGetLocation:(NSString *)imei;
- (void)endGetLocation:(NSString *)imei;
- (void)setCenterNumber:(NSString *)number;
- (void)setSOSNumber:(NSString *)numbers;
- (void)setTimeInterval:(NSString *)timestr;
- (void)setSOSSMS:(BOOL)isOn;
- (void)setDROP:(BOOL)isOn;
- (void)dogetTraceData:(NSString *)starttime endTime:(NSString *)endtime;
@property (nonatomic,strong)NSDictionary *locationDic;
@property (nonatomic,strong)NSMutableArray *watchArray;
@end
