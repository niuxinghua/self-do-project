//
//  MultiLanTool.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/16.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "MultiLanTool.h"
static MultiLanTool *instance = nil;

@interface MultiLanTool()

@property (nonatomic,strong)NSDictionary *multiDic;


@end

@implementation MultiLanTool

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    
    return instance;
}

- (NSString *)getMultiLanByKey:(NSString *)key
{
       NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
        NSArray* languages = [defs objectForKey:@"AppleLanguages"];
        NSString* preferredLang = [languages objectAtIndex:0];
     //   NSLog(@"Preferred Language:%@", preferredLang);
    if ([preferredLang containsString:@"en"]) {
        //英文环境
        NSString *path = [[NSBundle mainBundle] pathForResource:@"English" ofType:@"plist"];
        
        NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
        if ([data objectForKey:key]) {
            return [data objectForKey:key];
        }else{
            
            return @"";
        }
    }else
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Chinese" ofType:@"plist"];
        
        NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
        if ([data objectForKey:key]) {
            return [data objectForKey:key];
        }else{
            
            return @"";
        }
        
        
    }
    
    return @"";
}
@end
