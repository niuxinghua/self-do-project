//
//  HisoryDataController.m
//  caxjh
//
//  Created by niuxinghua on 2017/8/30.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "HisoryDataController.h"
#import "PPNetworkHelper.h"
@implementation HisoryDataController

+(void)getHisoryArticleDataFromStart:(NSString*)start OnSuccess:(SuccessBlock)success fail:(failBlock)fail{
    NSDictionary *dic = @{@"table":@"Article",@"order":@{},@"start":start,@"length":@"8",@"id":@"",@"columns":@[@"id",@"name",@"image",@"publishingSource",@"createTime",@"type",@"detail"],@"fields":@{},@"filter":@{}};
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper POST:kAPIQueryUrl parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        fail(error);
    }];
    
    
}

@end
