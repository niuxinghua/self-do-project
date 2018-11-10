//
//  VIPRoomDataController.m
//  caxjh
//
//  Created by niuxinghua on 2017/9/2.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "VIPRoomDataController.h"

@implementation VIPRoomDataController
+(void)getVIPRoomDataOnSuccess:(SuccessBlock)success fail:(failBlock)fail;
{

    // 0老师 1家长 2学生
    
    NSString *userId;
    NSString *type = [[NSUserDefaults standardUserDefaults]objectForKey:@"USER_DATA_TYPE"];
    if (![type isEqualToString:@"2"]) {
        //非学生
        userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    }else
    {
        userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    }
    
    NSDictionary *dic = @{@"userId":userId,@"type":type,@"packageEType":@"1"};
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper POST:kAPIVIPROOMURL parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        fail(error);
    }];
    
}
@end
