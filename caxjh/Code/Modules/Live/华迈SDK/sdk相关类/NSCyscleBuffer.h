//
//  NSCyscleBuffer.h
//  HM_server_demo
//
//  Created by 邹 万里 on 13-7-23.
//  Copyright (c) 2013年 邹 万里. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface NSCycleBuffer : NSObject
{
	NSInteger			count;
	NSInteger			capacity;
	NSMutableArray* 	m_array;
	NSLock*				m_lock;
	
	NSInteger			rear;
	NSInteger			front;
}

-(id)initWithCapacity:(NSInteger)numItems bytesPerBuffer:(NSInteger)numBytes;

-(BOOL)enqueue:(const void *)data dataBytesSize:(NSInteger)length;

-(const char *)dequeue:(NSInteger *)length;

-(void)reset;

@property (nonatomic, readonly) NSInteger count;

@end
