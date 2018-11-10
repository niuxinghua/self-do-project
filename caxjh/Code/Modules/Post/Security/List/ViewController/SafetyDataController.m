//
//  SafetyDataController.m
//  caxjh
//
//  Created by niuxinghua on 2017/9/1.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "SafetyDataController.h"

@implementation SafetyDataController
+(void)getSafetyArticleDataFromStart:(NSString*)start OnSuccess:(SuccessBlock)success fail:(failBlock)fail{
    NSDictionary *dic = @{@"table":@"Article",@"order":@{},@"start":start,@"length":@"8",@"id":@"",@"columns":@[@"id",@"name",@"image",@"publishingSource",@"createTime",@"type",@"detail"],@"fields":@{},@"filter":@{@"type":@{@"eq":@"safety"}}};
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper POST:kAPIQueryUrl parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        fail(error);
    }];
    
    
}

@end
