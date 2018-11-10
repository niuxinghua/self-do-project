//
//  UCLog.h
//  WuRenJi
//
//  Created by San Zhang on 13/04/2017.
//  Copyright © 2017 Casey. All rights reserved.
//

#ifndef UCLog_h
#define UCLog_h

#ifdef DEBUG
#define UCLog(s, ...) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define UCLog(s, ...)
#endif

#endif /* UCLog_h */
