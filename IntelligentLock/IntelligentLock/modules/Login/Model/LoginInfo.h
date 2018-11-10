//
//  LoginInfo.h
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/10.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginInfo : NSObject
+ (instancetype)sharedInfo;

@property (nonatomic,strong)NSString *token;
@end
