//
//  LockStoreManager.h
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/23.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LockStoreManager : NSObject

+ (instancetype)sharedManager;

@property (nonatomic,strong)NSDictionary *selectedLock;

@property (nonatomic,strong)NSMutableArray *lockList;

@end
