//
//  NSString+Trimming.m
//  PPluginExtension
//
//  Created by ZhuHong on 2018/11/10.
//  Copyright © 2018年 CoderHG. All rights reserved.
//

#import "NSString+Trimming.h"

@implementation NSString (Trimming)

/** 移除空白字符 */
- (NSString*)stringByTrimmingCharactersInSet {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

// 是否为空白字符
- (BOOL)blankString {
    return ([self stringByTrimmingCharactersInSet].length == 0);
}
@end
