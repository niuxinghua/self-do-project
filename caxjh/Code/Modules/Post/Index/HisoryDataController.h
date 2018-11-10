//
//  HisoryDataController.h
//  caxjh
//
//  Created by niuxinghua on 2017/8/30.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Const.h"
@interface HisoryDataController : NSObject

//+(instancetype)sharedInstance;

+(void)getHisoryArticleDataFromStart:(NSString*)start OnSuccess:(SuccessBlock)success fail:(failBlock)fail;

@end
