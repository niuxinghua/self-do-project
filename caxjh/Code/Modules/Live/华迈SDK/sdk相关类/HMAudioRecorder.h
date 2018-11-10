//
//  HMAudioRecorder.h
//  HM_server_demo
//
//  Created by 邹 万里 on 13-8-2.
//  Copyright (c) 2013年 邹 万里. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioFile.h>
#import <AudioToolbox/AudioQueue.h>
#import "HMAudioRecorderDelegate.h"
#import "hm_sdk.h"
#import "define.h"
#import "HMNodeObject.h"
#import "HMChannelObject.h"
#import "HMAudioPlayer.h"
#import "HMAudioRecorder.h"
#import "HMRecordVideoObject.h"
@interface HMAudioRecorder : NSObject
{
	BOOL					    IsRunning;
	
	CFStringRef					mFileName;
	AudioQueueRef				mQueue;
	AudioQueueBufferRef			mBuffers[kAUDIO_QUEUE_NUM_BUFFERS];
	AudioFileID					mRecordFile;
	SInt64						mRecordPacket; 		// current packet number in record file
	AudioStreamBasicDescription	mRecordFormat;
	
	UInt32						mOutDataFormat;
	
	//id<HMAudioRecorderDelegate>	audioRecorderDelegate;
	
}

//运行状态
@property BOOL			IsRunning;
@property (nonatomic) AudioQueueRef mQueue;
@property (nonatomic) UInt32 mOutDataFormat;
@property (assign) id<HMAudioRecorderDelegate> audioRecorderDelegate;

-(NSInteger)ComputeRecordBufferSize:(AudioStreamBasicDescription *)format duration:(float)seconds;

-(id)initAudioRecorder;

-(void)start;

-(void)stop;

@end
