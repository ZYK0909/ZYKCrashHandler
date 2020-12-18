//
//  ZYKCrashHandler.m
//  zykTools
//
//  Created by ZYK on 2020/12/4.
//

#import "ZYKCrashHandler.h"

// 沙盒的地址
NSString * applicationDocumentsDirectory() {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

// 崩溃时的回调函数
void UncaughtExceptionHandler(NSException * exception) {
    NSArray *stackSymbols = [exception callStackSymbols];
    NSString *reason = [exception reason];//原因
    NSString *name = [exception name];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy:MM:dd:HH:mm:ss"];
    NSString *time = [dateFormatter stringFromDate:[NSDate date]]; //时间
    NSString *exceptionInfo = [NSString stringWithFormat:@"====异常报告====%@\nException name:%@\nException reason:%@\nException stackSymbols :\n%@",time,name,reason,[stackSymbols componentsJoinedByString:@"\n"]];
    NSLog(@"%@",exceptionInfo);
    NSString * path = [applicationDocumentsDirectory() stringByAppendingPathComponent:@"Exception.txt"];
    // 将一个txt文件写入沙盒
    [exceptionInfo writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}


@implementation ZYKCrashHandler

+ (instancetype)shareInstance {
    static ZYKCrashHandler *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ZYKCrashHandler alloc]init];
    });
    return instance;
}
- (void)setDefaultHandler {
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    [self collectionExceptionMessage];
}
// 获取崩溃统计的函数指针
- (NSUncaughtExceptionHandler *)getHandler {
    return NSGetUncaughtExceptionHandler();
}

- (void)collectionExceptionMessage {
    // 发送崩溃日志
    NSString *dataPath = [applicationDocumentsDirectory() stringByAppendingPathComponent:@"Exception.txt"];
    NSData *data = [NSData dataWithContentsOfFile:dataPath];
    if (data != nil) {
        [self sendExceptionLogWithData:data path:dataPath];
    }
}

#pragma mark -- 发送崩溃日志
- (void)sendExceptionLogWithData:(NSData *)data path:(NSString *)path {

//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer.timeoutInterval = 10.0f;
//    //告诉AFN，接受 text/xml 的数据
//    [AFJSONResponseSerializer serializer].acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
//    NSString *urlString = @"后台地址";
//    [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileData:data name:@"file" fileName:@"Exception.txt" mimeType:@"txt"];
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        // 删除文件
//        NSFileManager *fileManger = [NSFileManager defaultManager];
//        [fileManger removeItemAtPath:path error:nil];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        // 发送Bug失败
//    }];
}

@end
