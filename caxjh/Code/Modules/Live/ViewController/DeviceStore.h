//
//  DeviceStore.h
//  caxjh
//
//  Created by niuxinghua on 2017/9/25.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceStore : NSObject
+ (instancetype)sharedInstance;
@property (nonatomic,strong)NSMutableArray *deviceList;
@end
