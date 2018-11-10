//
//  MultiLanTool.h
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/16.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MultiLanTool : NSObject
+ (instancetype)sharedInstance;
- (NSString *)getMultiLanByKey:(NSString *)key;
@end
