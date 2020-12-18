//
//  ZYKCrashHandler.h
//  zykTools
//
//  Created by ZYK on 2020/12/4.
//

#import <Foundation/Foundation.h>
#define UncaughtExceptionManager [ZYKCrashHandler shareInstance]
@interface ZYKCrashHandler : NSObject

+ (instancetype)shareInstance;
- (void)setDefaultHandler;
- (void)collectionExceptionMessage;
- (NSUncaughtExceptionHandler *)getHandler;

@end

