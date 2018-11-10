//
//  BannerDataController.m
//  caxjh
//
//  Created by niuxinghua on 2017/8/31.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "BannerDataController.h"

@implementation BannerDataController
+(void)getBannerDataOnSuccess:(SuccessBlock)success fail:(failBlock)fail
{
//    { "table":"Article", "order": {"createTime":"desc"}, "id":"","fields": {},"columns": ["id","name","createTime","image"],
//        "filter": {"type":{"eq":"slide"}} }
    NSDictionary *dic = @{@"table":@"Article",@"order":@{@"createTime":@"desc"},@"id":@"",@"fields":@{},@"columns":@[@"id",@"name",@"image",@"detail",@"createTime"],@"filter":@{@"type":@{@"eq":@"slide"}}};
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    NSLog(@"%@",kAPIQueryUrl);
    [PPNetworkHelper POST:kAPIQueryUrl parameters:dic success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        fail(error);
    }];

}
@end
