//
//  DYRunLoopSource.m
//  DYRunLoop
//
//  Created by DonYau on 2017/9/3.
//  Copyright © 2017年 DonYau. All rights reserved.
//

#import "DYRunLoopSource.h"

@interface DYRunLoopSource (){
    CFRunLoopSourceRef _runLoopSource;
    CFRunLoopRef _runLoop;
}

@end

@implementation DYRunLoopSource

#pragma mark 输入源添加进RunLoop时调用
void runLoopSourceScheduleRoutine (void *info, CFRunLoopRef rl, CFRunLoopMode mode){
    NSLog(@"RunLoop添加输入源");
}

#pragma mark 将输入源从RunLoop移除时调用
void runLoopSourceCancelRoutine (void *info, CFRunLoopRef runLoopRef, CFStringRef mode){
    NSLog(@"移除输入源");
}


#pragma mark 输入源需要处理信息时调用
void runLoopSourcePerformRoutine (void *info){
    NSLog(@"输入源正在处理任务");
}

-(instancetype)init{
    if (self = [super init]) {
        CFRunLoopSourceContext context = {0,(__bridge void *)(self),NULL,NULL,NULL,NULL,NULL,&runLoopSourceScheduleRoutine,&runLoopSourceCancelRoutine,&runLoopSourcePerformRoutine};
        
        _runLoopSource = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);

    }
    return self;
}

-(void)addToCurrentRunLoop{
    _runLoop = CFRunLoopGetCurrent();
    CFRunLoopAddSource(_runLoop, _runLoopSource, kCFRunLoopDefaultMode);
}

- (void)invalidate{
    
    CFRunLoopRemoveSource(_runLoop, _runLoopSource, kCFRunLoopDefaultMode);
    [self wakeUpRunLoop];
}

-(void)wakeUpRunLoop{
    if (CFRunLoopIsWaiting(_runLoop) && CFRunLoopSourceIsValid(_runLoopSource)) {
        CFRunLoopSourceSignal(_runLoopSource);
        CFRunLoopWakeUp(_runLoop);
    }
}

@end
