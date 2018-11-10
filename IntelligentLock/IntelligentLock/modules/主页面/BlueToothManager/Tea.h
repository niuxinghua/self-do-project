//
//  Tea.h
//  IntelligentLock
//
//  Created by lxc on 18/2/26.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tea : NSObject

+  (int) transform:(Byte* )temp;
+ (int*) byteToInt:(Byte *)content offset:(int)offset;
+ (Byte*)  intToByte:(int*)content offset:(int)offset;
+ (Byte*) teaencrypt:(Byte*) temp ;
+ (Byte*)decrypt:(Byte*) temp;
+ (int) check:(Byte*)temp;

@property (nonatomic,strong)NSDictionary *selectedLock;

@end
