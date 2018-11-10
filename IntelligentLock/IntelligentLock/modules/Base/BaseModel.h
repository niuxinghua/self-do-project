//
//  BaseModel.h
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/10.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
@interface BaseNestValue:NSObject<NSCoding>

@property(nonatomic,strong)NSString *device;

@property(nonatomic,strong)NSString *bluemac;
@property(nonatomic,strong)NSString *h;
@property(nonatomic,strong)NSString *real_name;
@property(nonatomic,strong)NSString *n;
@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *user_id;
@property(nonatomic,strong)NSString *area_code;

@end


@interface BaseModel : NSObject<NSCoding>

@property (nonatomic,strong)NSString *msg;

@property (nonatomic,strong)NSString* done;

@property (nonatomic,strong)BaseNestValue *retval;

- (instancetype)initWithdic:(NSDictionary*)dictionary;

@end
