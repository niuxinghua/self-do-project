//
//  HMSDKManager.h
//  caxjh
//
//  Created by niuxinghua on 2017/8/30.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "hm_sdk.h"
#import "define.h"
@interface HMSDKManager : NSObject
+ (instancetype)sharedInstance;
- (void)initSDK;
- (NSArray*)getAllDevice:(NSString *)domain account:(NSString *)account passWord:(NSString *)passWord port:(int)port;



@property (assign, nonatomic) node_handle root;
@property (assign, nonatomic) tree_handle tree_hd;
@property (assign, nonatomic) server_id server_Id;
@property (assign, nonatomic) int64 actorPower;
@property (atomic,strong) NSMutableArray *realNodeList;
@end
