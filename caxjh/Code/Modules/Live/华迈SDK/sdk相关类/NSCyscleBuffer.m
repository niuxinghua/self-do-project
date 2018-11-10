//
//  NSCyscleBuffer.m
//  HM_server_demo
//
//  Created by 邹 万里 on 13-7-23.
//  Copyright (c) 2013年 邹 万里. All rights reserved.
//

#import "NSCyscleBuffer.h"

@implementation NSCycleBuffer
@synthesize count;

-(id)initWithCapacity:(NSInteger)numItems bytesPerBuffer:(NSInteger)numBytes
{
	if((self = [super init]) == nil) return nil;
	
	capacity = numItems;
	m_array = [[NSMutableArray alloc] initWithCapacity:capacity];
	m_lock = [[NSLock alloc] init];
	count = 0;
	
	for(int i=0; i<capacity; i++)
	{
		NSMutableData* data = [[NSMutableData alloc] initWithCapacity:numBytes];
        [m_array insertObject:data atIndex:i];
//		[data release];
	}
	
	return self;
}

-(void)dealloc
{
	[m_lock lock];
	for(int i=0; i<capacity; i++)
	{
		[m_array removeObjectAtIndex: 0];
	}
	[m_lock unlock];
	
//	[m_array release];
//	[m_lock release];
	count = 0;
	
//	[super dealloc];
}

-(BOOL)enqueue:(const void *)buf dataBytesSize:(NSInteger)length
{
    
    
	[m_lock lock];
	
	if((rear+1) % capacity == front) {
		[m_lock unlock];
		return NO;
	}
	NSMutableData* data = [m_array objectAtIndex: rear];
	if(data.length < length) [data increaseLengthBy: length];
	[data replaceBytesInRange:NSMakeRange(0, length) withBytes:buf length:length];
	[data setLength:length];
	rear = (rear+1) % capacity;
	count++;
    buf = NULL;
	[m_lock unlock];
	return YES;
}

-(const char *)dequeue:(NSInteger *)length
{
	const void * buf;
	
	[m_lock lock];
	
	if(rear == front)
    {
		*length = 0;
		[m_lock unlock];
		return nil;
	}
	NSMutableData* data = [m_array objectAtIndex:front];
	*length = [data length];
	buf = [data bytes];
	front = (front+1) % capacity;
	count --;
	
	[m_lock unlock];
	
	return (const char *)buf;
}

-(void)reset
{
	[m_lock lock];
	rear = 0;
	front = 0;
	[m_lock unlock];
}

@end
