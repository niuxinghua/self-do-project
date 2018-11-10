//
//  BaseModel.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/10.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }

- (instancetype)initWithdic:(NSDictionary*)dictionary
{
    
    if (self = [super init]) {
       [[self class] yy_modelWithJSON:dictionary];
    }
    return self;
}
    




@end

@implementation BaseNestValue

- (void)encodeWithCoder:(NSCoder *)aCoder { [self yy_modelEncodeWithCoder:aCoder]; }
- (id)initWithCoder:(NSCoder *)aDecoder { self = [super init]; return [self yy_modelInitWithCoder:aDecoder]; }

@end
