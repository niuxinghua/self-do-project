//
//  HMAudioRecorder.m
//  HM_server_demo
//
//  Created by 邹 万里 on 13-8-2.
//  Copyright (c) 2013年 邹 万里. All rights reserved.
//

#import "HMAudioRecorder.h"

@implementation HMAudioRecorder

@synthesize IsRunning;
@synthesize mQueue;
@synthesize mOutDataFormat;
@synthesize audioRecorderDelegate;

-(NSInteger)ComputeRecordBufferSize:(AudioStreamBasicDescription *)format duration:(float)seconds
{
	NSInteger packets, frames, bytes = 0;
    
	frames = (int)ceil(seconds * format->mSampleRate);
	
	if (format->mBytesPerFrame > 0)
		bytes = frames * format->mBytesPerFrame;
	else {
		UInt32 maxPacketSize;
		if (format->mBytesPerPacket > 0)
			maxPacketSize = format->mBytesPerPacket;	// constant packet size
		else {
			UInt32 propertySize = sizeof(maxPacketSize);
			AudioQueueGetProperty(mQueue,
								  kAudioQueueProperty_MaximumOutputPacketSize,
								  &maxPacketSize,
								  &propertySize);
		}
		if (format->mFramesPerPacket > 0)
			packets = frames / format->mFramesPerPacket;
		else
			packets = frames;	// worst-case scenario: 1 frame in a packet
		if (packets == 0)		// sanity check
			packets = 1;
		bytes = packets * maxPacketSize;
	}
    
	return bytes;
}

//回调
void InputBufferHandler(void *								inUserData,
                        AudioQueueRef							inAQ,
                        AudioQueueBufferRef					inBuffer,
                        const AudioTimeStamp *				inStartTime,
                        UInt32								inNumPackets,
                        const AudioStreamPacketDescription*	inPacketDesc)
{	
	HMAudioRecorder *recorder = (__bridge HMAudioRecorder *)inUserData;
    
//    DLog(@"buffer=%p,inNumPackets=%d",inBuffer,(int)inNumPackets);
	
	if(![recorder IsRunning]) return;		//如果未运行状态，直接返回
	
	if (inNumPackets > 0)
    {
		//回调
		[recorder.audioRecorderDelegate HMAudioQueueInputBufferingCallack:inAQ
																 buffer:(char*)inBuffer->mAudioData
															  startTime:inStartTime
														  numberPackets:inBuffer->mAudioDataByteSize];
	}
	
	// if we're not stopping, re-enqueue the buffe so that it gets filled again
	if ([recorder IsRunning])
		AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
}


-(id)initAudioRecorder
{
	if (!(self=[super init])) return nil;
	
	memset(&mRecordFormat, 0, sizeof(mRecordFormat));
    
	mRecordFormat.mFormatID = kAudioFormatLinearPCM;
	mRecordFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
	mRecordFormat.mSampleRate = 8000;
	mRecordFormat.mChannelsPerFrame = 1;
	mRecordFormat.mBitsPerChannel = 16;
	mRecordFormat.mBytesPerPacket = mRecordFormat.mBytesPerFrame = (mRecordFormat.mBitsPerChannel / 8) * mRecordFormat.mChannelsPerFrame;
	mRecordFormat.mFramesPerPacket = 1;
	
	// create the queue
	AudioQueueNewInput(&mRecordFormat,
					   InputBufferHandler,
					   (__bridge void * _Nullable)(self) /* userData */,
					   NULL /* run loop */,
					   NULL /* run loop mode */,
					   0 /* flags */,
					   &mQueue);
	
	int bufferByteSize;
	
	// allocate and enqueue buffers
	bufferByteSize = [self ComputeRecordBufferSize:&mRecordFormat duration:kTALK_DATA_SAMPLE_DURATION];	// enough bytes for half a second
    
	for (int i = 0; i < kAUDIO_QUEUE_NUM_BUFFERS; ++i) {
		AudioQueueAllocateBuffer(mQueue, bufferByteSize, &mBuffers[i]);
		AudioQueueEnqueueBuffer(mQueue, mBuffers[i], 0, NULL);
	}

	
	return self;
}

-(void)dealloc
{
	for(int i=0; i<kAUDIO_QUEUE_NUM_BUFFERS; i++) {
		AudioQueueFreeBuffer(mQueue, mBuffers[i]);
	}
	AudioQueueDispose(mQueue, YES);
	
	//[super dealloc];
}

-(void)start
{
	// start the queue
	IsRunning = YES;
	AudioQueueStart(mQueue, NULL);
}

-(void)stop
{
	IsRunning = NO;
	AudioQueueStop(mQueue, YES);
}

@end
