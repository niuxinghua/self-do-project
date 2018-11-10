//
//  HMAudioPlayer.h
//  HM_server_demo
//
//  Created by 邹 万里 on 13-7-30.
//  Copyright (c) 2013年 邹 万里. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioFile.h>
#import "define.h"
#import "NSCyscleBuffer.h"
#import "AppDelegate.h"
#import "hm_sdk.h"
#import "define.h"
#import "HMNodeObject.h"
#import "HMChannelObject.h"
#import "HMAudioPlayer.h"
#import "HMAudioRecorder.h"
#import "HMRecordVideoObject.h"
@interface HMAudioPlayer : NSObject
{
    BOOL							IsRunning;
	
	//音频流描述对象
	AudioStreamBasicDescription 	dataFormat;
	//音频队列
	AudioQueueRef 					queue;
	AudioQueueBufferRef 			buffers[kAUDIO_QUEUE_NUM_BUFFERS];
    
    UInt32      					mInputDataFormat;
    
    NSCycleBuffer					*audioData;
    
    audio_codec_handle              localAudioHandel;
    
    NSLock*                         audioLock;
}

//定义队列为实例属性
@property AudioQueueRef queue;
//运行状态
@property BOOL			IsRunning;
@property (nonatomic) UInt32 mInputDataFormat;
@property (strong, nonatomic) NSLock         *audioLock;
@property (retain, nonatomic) NSCycleBuffer  *audioData;



//播放器初始化
- (id)initAudioPlayer:(UInt32)format bitsPerChannel:(NSInteger)bitsPerChannel SampleRate:(int32)sample Channel:(uint32)channel;

-(void)start;

-(void)startWithEmptyDataSize: (NSInteger)size;

-(void)stop;

-(void)dispose;

-(void)resetAudioData;

-(void)enqueueData:(const char *)bytes dataBytesSize:(NSInteger)length;

//定义回调(Callback)函数
static void BufferCallback(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef buffer);

@end
