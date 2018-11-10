//
//  CodeFragment.h
//  PPluginExtension
//
//  Created by ZhuHong on 2018/11/10.
//  Copyright © 2018年 CoderHG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CodeFragment : NSObject

/** 构造 */
+ (instancetype)fragmentWithLines:(NSArray*)lines lineRange:(NSRange)lineRange;

/** 当前文档的所有内容 */
@property (nonatomic, copy, readonly) NSString* string;

@end
