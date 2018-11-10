//
//  MemberDataController.h
//  caxjh
//
//  Created by niuxinghua on 2017/9/1.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Const.h"
@interface MemberDataController : NSObject
+(void)getMemberArticleDataFromStart:(NSString*)start OnSuccess:(SuccessBlock)success fail:(failBlock)fail;
@end
