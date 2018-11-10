//
//  SourceEditorCommand.m
//  PPluginExtension
//
//  Created by ZhuHong on 2018/11/8.
//  Copyright © 2018年 CoderHG. All rights reserved.
//

#import "SourceEditorCommand.h"
#import "Common.h"
#import "CodeFragmentBuilder.h"

@implementation SourceEditorCommand




- (void)performCommandWithInvocation:(XCSourceEditorCommandInvocation *)invocation completionHandler:(void (^)(NSError * _Nullable nilOrError))completionHandler
{
    // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
    
    // 创建一个重构器
    CodeFragmentBuilder* builder = [CodeFragmentBuilder builderWithInvocation:invocation];
    // 重构
    [builder builder];
    
    /*
    // Documents 目录路径
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString* executablePath =
    [[NSBundle mainBundle] pathForResource:@"clang-format" ofType:@""];
    NSString* fileString = [documents stringByAppendingString:@"/AppDelegate.h"];
    
    NSString* cmdString = [NSString stringWithFormat:@"%@ %@", executablePath, fileString];
    NSString* str = [self cmd:cmdString];
    
    XCSourceTextBuffer *textBuffer = invocation.buffer;
    XCSourceTextRange *insertPointRange = textBuffer.selections[0];
    NSInteger startLine = insertPointRange.start.line;
    
    NSString* sss = [NSString stringWithFormat:@"%@ == %@ == %@", fileString, cmdString, str];
    [textBuffer.lines insertObject:sss atIndex:startLine];
     */
    
    completionHandler(nil);
}

- (NSString *)cmd:(NSString *)cmd {
    // 初始化并设置shell路径
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/bash"];
    // -c 用来执行string-commands（命令字符串），也就说不管后面的字符串里是什么都会被当做shellcode来执行
    NSArray *arguments = [NSArray arrayWithObjects: @"-c", cmd, nil];
    [task setArguments: arguments];
    
    // 新建输出管道作为Task的输出
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    // 开始task
    NSFileHandle *file = [pipe fileHandleForReading];
    [task launch];
    
    // 获取运行结果
    NSData *data = [file readDataToEndOfFile];
    NSLog(@"%@", data);
    return [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
}

@end
