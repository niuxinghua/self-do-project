//
//  NetWorkTool.h
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/4.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkTool : NSObject
+ (instancetype)sharedInstance;
- (BOOL)netWorkOK;
@end
