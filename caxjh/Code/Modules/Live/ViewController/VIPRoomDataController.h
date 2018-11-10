//
//  VIPRoomDataController.h
//  caxjh
//
//  Created by niuxinghua on 2017/9/2.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Const.h"
@interface VIPRoomDataController : NSObject
+(void)getVIPRoomDataOnSuccess:(SuccessBlock)success fail:(failBlock)fail;
@end
