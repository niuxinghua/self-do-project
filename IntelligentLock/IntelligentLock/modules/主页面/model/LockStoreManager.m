//
//  LockStoreManager.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/23.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "LockStoreManager.h"

static LockStoreManager *manager;

@implementation LockStoreManager
- (instancetype)init
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [super init];
        }
    });
    return manager;
}
+ (instancetype)sharedManager
{
    
    return  [[self alloc] init];
    
}
- (void)setSelectedLock:(NSDictionary *)selectedLock
{
    _selectedLock = selectedLock;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"lockchanged" object:nil];
    
    
}
@end
