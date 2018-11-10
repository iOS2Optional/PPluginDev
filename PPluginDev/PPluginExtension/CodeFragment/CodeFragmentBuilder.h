//
//  CodeFragmentBuilder.h
//  PPluginExtension
//
//  Created by ZhuHong on 2018/11/10.
//  Copyright © 2018年 CoderHG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XcodeKit/XcodeKit.h>

@interface CodeFragmentBuilder : NSObject

/** 构造 */
+ (instancetype)builderWithInvocation:(XCSourceEditorCommandInvocation *)invocation;

/** 重构代码 */
- (void)builder;

@end
