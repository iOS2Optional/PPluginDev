//
//  SourceEditorExtension.m
//  PPluginExtension
//
//  Created by ZhuHong on 2018/11/8.
//  Copyright © 2018年 CoderHG. All rights reserved.
//

#import "SourceEditorExtension.h"
#import "Common.h"

@implementation SourceEditorExtension


- (void)extensionDidFinishLaunching
{
    // If your extension needs to do any work at launch, implement this optional method.
    // Documents 目录路径
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    // 创建一个文件
    NSString* tmpDir = [documents stringByAppendingFormat:@"/%@", FormatOnSaveTmpDir];
    [[NSFileManager defaultManager]createDirectoryAtPath:tmpDir
                             withIntermediateDirectories:YES
                                              attributes:nil
                                                   error:nil];
    // 生成一个 .clang-format 文件
    NSString* clangformatPath =
    [[NSBundle mainBundle] pathForResource:@"clang-format" ofType:@"txt"];
    NSString* fileString = [[NSString alloc] initWithContentsOfFile:clangformatPath encoding:NSUTF8StringEncoding error:nil];
    
     [fileString writeToFile:[tmpDir stringByAppendingString:@"/.clang-format"] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}


/*
- (NSArray <NSDictionary <XCSourceEditorCommandDefinitionKey, id> *> *)commandDefinitions
{
    // If your extension needs to return a collection of command definitions that differs from those in its Info.plist, implement this optional property getter.
    return @[];
}
*/

@end
