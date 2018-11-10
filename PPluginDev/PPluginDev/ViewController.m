//
//  ViewController.m
//  PPluginDev
//
//  Created by ZhuHong on 2018/11/8.
//  Copyright © 2018年 CoderHG. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    // Do any additional setup after loading the view.
    /*
    NSDictionary *environmentDict = [[NSProcessInfo processInfo] environment];
    NSString* shellStr = [environmentDict objectForKey:@"SHELL"];
    NSString *shellString =
     shellStr?: @"/bin/bash";
    
    NSPipe *outputPipe = [NSPipe pipe];
    NSPipe *errorPipe = [NSPipe pipe];
    
    NSTask *task = [[NSTask alloc] init];
    task.standardOutput = outputPipe;
    task.standardError = errorPipe;
    task.launchPath = shellString;
    task.arguments = @[ @"-c", @"which clang-format" ];
     */
    
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
