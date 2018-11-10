//
//  BlueToothManager.h
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/10.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginModel.h"
#import "CircleLoaderView.h"
@interface BlueToothManager : NSObject

+ (instancetype)sharedManager;

-(void)openLock;

- (void)addPermit;

- (void)BindAdmin:(NSString *)mac_blue;

- (void)getLockInfo;

- (void)deleteLockInfo;

- (void)addKey:(NSString *)account;

- (void)cancelCheck;

- (void)getLockLogs;


- (void)syncBlueTooth;

- (void)addorDeleteUser:(int)sn isAdd:(BOOL)isadd type:(int)type;
- (void)destroy;

@property (nonatomic,strong)LoginModel *loginModel;

@property (nonatomic,strong)CircleLoaderView *loader;

@end
