//
//  BannerDataController.h
//  caxjh
//
//  Created by niuxinghua on 2017/8/31.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Const.h"
@interface BannerDataController : NSObject
+(void)getBannerDataOnSuccess:(SuccessBlock)success fail:(failBlock)fail;
@end
