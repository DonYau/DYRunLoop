//
//  DYCustomSourceThread.m
//  DYRunLoop
//
//  Created by DonYau on 2017/9/3.
//  Copyright © 2017年 DonYau. All rights reserved.
//

#import "DYCustomSourceThread.h"
#import "DYRunLoopSource.h"

@interface DYCustomSourceThread (){
    
}

@end

@implementation DYCustomSourceThread


void currentRunLoopObserver(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    NSString *threadName = [NSThread currentThread].name;
    if (activity & kCFRunLoopEntry) {
        NSLog(@"%@进入runloop",threadName);
    }else if (activity & kCFRunLoopBeforeTimers){
        NSLog(@"%@即将处理Timers",threadName);
    }else if (activity & kCFRunLoopBeforeSources){
        NSLog(@"%@即将处理Sources",threadName);
    }else if (activity & kCFRunLoopBeforeWaiting){
        NSLog(@"%@即将处理进入睡眠",threadName);
    }else if (activity & kCFRunLoopAfterWaiting){
        NSLog(@"%@从睡眠中唤醒",threadName);
    }else if (activity & kCFRunLoopExit){
        NSLog(@"%@退出runloop",threadName);
    }
}

-(void)main{
    @autoreleasepool {
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        _runLoopSource = [[DYRunLoopSource alloc] init];
        [_runLoopSource addToCurrentRunLoop];
        
        CFRunLoopObserverContext context = {0, (__bridge void*)(self),NULL,NULL,NULL};
        
        CFRunLoopObserverRef observer =  CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &currentRunLoopObserver, &context);
        if (observer) {
            CFRunLoopRef runLoop = CFRunLoopGetCurrent();
            CFRunLoopAddObserver(runLoop, observer, kCFRunLoopDefaultMode);
        }
        [runLoop run];
    }
}

@end
