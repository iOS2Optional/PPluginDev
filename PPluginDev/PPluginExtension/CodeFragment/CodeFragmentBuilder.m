//
//  CodeFragmentBuilder.m
//  PPluginExtension
//
//  Created by ZhuHong on 2018/11/10.
//  Copyright © 2018年 CoderHG. All rights reserved.
//

#import "CodeFragmentBuilder.h"
#import "Common.h"
#import "NSString+Trimming.h"

@implementation CodeFragmentBuilder

+ (NSString *)getCurrentDate
{
    //获取当前时间
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSInteger year = [dateComponent year];
    NSInteger month = [dateComponent month];
    NSInteger day = [dateComponent day];
    NSInteger hour = [dateComponent hour];
    NSInteger minute = [dateComponent minute];
    NSInteger second = [dateComponent second];
    NSString * currentDate = [NSString stringWithFormat:@"%ld%.2ld%.2ld%.2ld%.2ld%.2ld",year,month,day,hour,minute,second];
    return currentDate;
}

/** 构造 */
+ (instancetype)builderWithInvocation:(XCSourceEditorCommandInvocation *)invocation {
    CodeFragmentBuilder* builder = [CodeFragmentBuilder new];
    // 选中文本的区域
    XCSourceTextRange *textRange = invocation.buffer.selections.firstObject;
    NSInteger startLine = textRange.start.line;
    
    // 寻找第一行
    NSInteger fLine = startLine;
    for (NSInteger i=(fLine-1); i>=0; i++) {
        NSString* lineString = invocation.buffer.lines[i];
        if (!lineString.blankString) {
            startLine = i+1;
            // 就直接跳出去
            break;
        }
    }
    
    // 寻找最后一行
    NSInteger endLine = textRange.end.line;
    for (NSInteger i=(endLine+1); i<invocation.buffer.lines.count; i++) {
        NSString* lineString = invocation.buffer.lines[i];
        if (!lineString.blankString) {
            endLine = i-1;
            // 就直接跳出去
            break;
        }
    }
    
    // 选中的区域
    NSRange selectedLineRange = NSMakeRange(startLine, endLine - startLine + 1);
    // 选中区域的行
    NSArray<NSString *> *lines = [invocation.buffer.lines subarrayWithRange:selectedLineRange];
    // 选中区域的文本
    NSString* selectedString = [lines componentsJoinedByString:@""];
    if (selectedString.blankString) {
        // 选中为空白字符
        // [invocation.buffer.lines insertObject:@"选中为空白字符" atIndex:startLine];
        return nil;
    }
    
    
    // 生成一个临时文件
    // Documents 目录路径
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    // 创建一个文件
    NSString* tmpFileName = [documents stringByAppendingFormat:@"/%@/%@.m", FormatOnSaveTmpDir, FormatOnSaveTmpDir];
    
    // 保存为文件
    NSString* string = [invocation.buffer.lines componentsJoinedByString:@""];
    [string writeToFile:tmpFileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    // Mach-O文件(clang-format) 的路径
    NSString* executablePath =
    [[NSBundle mainBundle] pathForResource:@"clang-format" ofType:@""];
    
    // 拼接 cmd
    NSString* linesCmdString = [NSString
                                stringWithFormat:@"-lines=%tu:%tu",
                                selectedLineRange.location + 1,                  // 1-based
                                selectedLineRange.location + selectedLineRange.length];  // 1-based;
    NSString* cmdString = [NSString stringWithFormat:@"%@ %@ %@", executablePath, linesCmdString, tmpFileName];
    
    // 格式化文本
    NSString* resultString = [self cmd:cmdString];
    if ([string isEqualToString:resultString]) {
        // 内容一样, 无需调整
        return nil;
    }
    
    NSMutableString* strM = resultString.mutableCopy;
    
    {
        // 创建一个文件
        NSString* tmpDir123 = [documents stringByAppendingFormat:@"/%@/%@", FormatOnSaveTmpDir, [self getCurrentDate]];
        [cmdString writeToFile:tmpDir123 atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        tmpDir123 = [tmpDir123 stringByAppendingString:@"00"];
        [resultString writeToFile:tmpDir123 atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        
        {
            // 前
            NSArray* qLines = [invocation.buffer.lines subarrayWithRange:NSMakeRange(0,  startLine)];
            NSString* qString = [qLines componentsJoinedByString:@""];
            tmpDir123 = [tmpDir123 stringByAppendingString:@"1"];
            [qString writeToFile:tmpDir123 atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
            [strM deleteCharactersInRange:NSMakeRange(0, qString.length)];
            
            // 后
            NSArray* hLines = [invocation.buffer.lines subarrayWithRange:NSMakeRange(selectedLineRange.location + selectedLineRange.length, invocation.buffer.lines.count-(selectedLineRange.location + selectedLineRange.length))];
            
            NSString* hString = [hLines componentsJoinedByString:@""];
            tmpDir123 = [tmpDir123 stringByAppendingString:@"2"];
            [hString writeToFile:tmpDir123 atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
            [strM deleteCharactersInRange:NSMakeRange(strM.length-hString.length, hString.length)];
            
            
            tmpDir123 = [tmpDir123 stringByAppendingString:@"3"];
            [strM writeToFile:tmpDir123 atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
            // 删除
            [invocation.buffer.lines removeObjectsInRange:selectedLineRange];
            
            // 添加
            [invocation.buffer.lines insertObject:strM atIndex:startLine];
        }
        
    }
    
    
    
    /*
    {
        NSString* string = [invocation.buffer.lines componentsJoinedByString:@""];
        // Documents 目录路径
        NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        
        {
            // 创建一个文件
            NSString* tmpDir = [documents stringByAppendingFormat:@"/%@/%@", FormatOnSaveTmpDir, [self getCurrentDate]];
            [string writeToFile:tmpDir atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
            string = [lines componentsJoinedByString:@""];
            tmpDir = [tmpDir stringByAppendingString:@"0"];
            [string writeToFile:tmpDir atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
            NSString* tmpDir1 = [documents stringByAppendingFormat:@"/%@/.%@", FormatOnSaveTmpDir, [self getCurrentDate]];
            NSString* cmdS = [NSString stringWithFormat:@"mv %@ %@", tmpDir, tmpDir1];
            
            [self cmd:cmdS];
            
        }
    }
     */
    
    
    return builder;
}

+ (NSString *)cmd:(NSString *)cmd {
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

/** 重构代码 */
- (void)builder {
    
}

@end
