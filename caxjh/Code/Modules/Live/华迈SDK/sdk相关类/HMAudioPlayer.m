//
//  HMAudioPlayer.m
//  HM_server_demo
//
//  Created by 邹 万里 on 13-7-30.
//  Copyright (c) 2013年 邹 万里. All rights reserved.
//

#import "HMAudioPlayer.h"


static UInt32 gBufferSizeBytes= 1000; //It must be pow(2,x)

@implementation HMAudioPlayer
@synthesize queue;
@synthesize audioLock;
@synthesize IsRunning;
@synthesize audioData;
@synthesize mInputDataFormat;

static void BufferCallback(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef buffer)
{
    HMAudioPlayer *player = (__bridge  HMAudioPlayer*)inUserData;
//    UInt32 ifmt = [player mInputDataFormat];
    
    NSInteger nlen = 0;
    [[player audioLock] lock];
    const char* pBuf = [[player audioData] dequeue:&nlen];  //获取解码后的数据
    [[player audioLock] unlock];
    
    if (![player IsRunning])
    {
       memset(buffer->mAudioData, 0, 320);   //创造空数据
    }
    else
    {
        if ( pBuf!=nil && nlen >0)
        {
            memcpy(buffer->mAudioData, pBuf, nlen);
        }
        else
        {
             memset(buffer->mAudioData, 0, 320); //创造空数据,清除杂音
        }
    }
    
    buffer->mAudioDataByteSize = 320;
    AudioQueueEnqueueBuffer(inAQ, buffer, 0, nil);
}


- (id)initAudioPlayer:(UInt32)format bitsPerChannel:(NSInteger)bitsPerChannel SampleRate:(int32)sample Channel:(uint32)channel
{
    
    [self initAudioSession];
   
    if (!(self = [super init])) return nil;
    
    //音频数据缓冲区
	audioData = [[NSCycleBuffer alloc] initWithCapacity:kAUDIO_DATA_BUFFER_MAXLENGTH*1.5 bytesPerBuffer:kAUDIO_DATA_BUFFER_BYTES];
    
    mInputDataFormat = format;    //音频数据格式
    
    //设置音频队列参数
    dataFormat.mSampleRate=sample;						//采样频率
	dataFormat.mFormatID=kAudioFormatLinearPCM;			//线性PCM
	dataFormat.mFormatFlags=kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    dataFormat.mFramesPerPacket=1;						//每一个packet一侦数据
    dataFormat.mChannelsPerFrame=1;				        //通道数 单声通道
	dataFormat.mBitsPerChannel=bitsPerChannel;		   //采样的位数 每个采样点16bit或者8bit量化
    dataFormat.mReserved = 0;
    dataFormat.mBytesPerFrame = (dataFormat.mBitsPerChannel/8) * dataFormat.mChannelsPerFrame;
    dataFormat.mBytesPerPacket = dataFormat.mBytesPerFrame ;
    
    
    //创建播放用的音频队列
    AudioQueueNewOutput(&dataFormat, BufferCallback, (__bridge void *)(self), nil, nil, 0, &queue);
    
    //创建音频队列缓冲区
    for(int i=0; i<kAUDIO_QUEUE_NUM_BUFFERS; i++){
        AudioQueueAllocateBuffer(queue, gBufferSizeBytes, &buffers[i]);
    }
    
    audioLock = [[NSLock alloc] init];
    return self;
}


-(void)dealloc
{
	for(int i=0; i<kAUDIO_QUEUE_NUM_BUFFERS; i++) {
		AudioQueueFreeBuffer(queue, buffers[i]);
	}
	[self dispose];	
//	[super dealloc];
}


-(void)start
{
	IsRunning = YES;
//	AudioQueueStart(queue, nil);  //队列处理开始，此后系统开始自动调用回调(Callback)函数
}

-(void)stop
{
	IsRunning = NO;
//	AudioQueueStop(queue, YES);
//	[audioData reset];
    
}

-(void)startWithEmptyDataSize: (NSInteger)size;
{

    IsRunning = YES;
    AudioQueueStart(queue, nil);
    for(int i=0; i<kAUDIO_QUEUE_NUM_BUFFERS; i++)
    {
		memset(buffers[i]->mAudioData, 0, 320);
		buffers[i]->mAudioDataByteSize = 320;
		AudioQueueEnqueueBuffer(queue, buffers[i], 0, nil);
	}
        
}


-(void)dispose
{
	AudioQueueDispose(queue, YES);
}

-(void)resetAudioData
{
    [audioLock lock];
    [audioData reset];
    [audioLock unlock];
}

-(void)enqueueData:(const char *)bytes dataBytesSize:(NSInteger)length
{
	if(IsRunning == NO) return;	
	if ([audioData count] > kAUDIO_DATA_BUFFER_MAXLENGTH) return;//大于最大缓冲区个数，则丢弃
	[audioData enqueue:bytes dataBytesSize:length];
}


//播放与录音同步
-(void)initAudioSession
{
    //初始化：如果这个忘了的话，可能会第一次播放不了
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    
    UInt32 category =  kAudioSessionCategory_PlayAndRecord;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
    
    //kAudioSessionOverrideAudioRoute_None   kAudioSessionOverrideAudioRoute_Speaker
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof                    (audioRouteOverride),&audioRouteOverride);
//    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof                    (audioRouteOverride),&audioRouteOverride);
    
    AudioSessionSetActive(true);
    
}


@end
