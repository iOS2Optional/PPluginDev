//
//  NSString+Trimming.h
//  PPluginExtension
//
//  Created by ZhuHong on 2018/11/10.
//  Copyright © 2018年 CoderHG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Trimming)

/** 移除空白字符 */ 
- (NSString*)stringByTrimmingCharactersInSet;

// 是否为空白字符
- (BOOL)blankString;

@end
