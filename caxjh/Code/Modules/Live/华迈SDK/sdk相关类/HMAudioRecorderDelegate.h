//
//  HMAudioRecorderDelegate.h
//  HM_server_demo
//
//  Created by 邹 万里 on 13-8-2.
//  Copyright (c) 2013年 邹 万里. All rights reserved.
//

#ifndef HM_server_demo_HMAudioRecorderDelegate_h
#define HM_server_demo_HMAudioRecorderDelegate_h

#import <Foundation/Foundation.h>

@protocol HMAudioRecorderDelegate

@required

-(void)HMAudioQueueInputBufferingCallack:(AudioQueueRef)inAQ
						   		buffer:(char *)buffer
							 startTime:(const AudioTimeStamp*)inStartTime
						 numberPackets:(NSInteger)inNumPackets;

@end

#endif
