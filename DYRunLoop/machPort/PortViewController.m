//
//  PortViewController.m
//  DYRunLoop
//
//  Created by DonYau on 2017/9/3.
//  Copyright © 2017年 DonYau. All rights reserved.
//

#import "PortViewController.h"

@interface PortViewController ()<NSPortDelegate>{
    NSThread *_thread;
    NSPort *_machPort;
    NSMachPort *_mainPort;
    NSRunLoop *_threadRunLoop;
    BOOL _runLoop;
    CFRunLoopObserverRef _observer;
}

@end

@implementation PortViewController

void runLoopObserver(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
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


- (void)viewDidLoad {
    [super viewDidLoad];
    _thread = [[NSThread alloc] initWithTarget:self selector:@selector(execute) object:nil];
    [_thread start];
    
    _mainPort= [[NSMachPort alloc] init];
    [[NSRunLoop mainRunLoop] addPort:_mainPort forMode:NSDefaultRunLoopMode];
}


-(void)dealloc{
    NSLog(@"销毁");
}


- (void)execute{
    _machPort = [NSMachPort port];
    _machPort.delegate = self;
    _threadRunLoop = [NSRunLoop currentRunLoop];

    CFRunLoopObserverContext context = {0, (__bridge void*)(self),NULL,NULL,NULL};
    
    _observer =  CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &runLoopObserver, &context);
    if (_observer) {
        CFRunLoopRef runLoop = CFRunLoopGetCurrent();
        CFRunLoopAddObserver(runLoop, _observer, kCFRunLoopDefaultMode);
    }
    [_threadRunLoop addPort:_machPort forMode:NSDefaultRunLoopMode];
    _runLoop = YES;
    while (_runLoop && [_threadRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]) {
        
    }
}

- (IBAction)removePort:(id)sender {
    _runLoop = NO;
    [_threadRunLoop removePort:_machPort forMode:NSDefaultRunLoopMode];
    CFRunLoopRemoveObserver(_threadRunLoop.getCFRunLoop, _observer, kCFRunLoopDefaultMode);
    CFRelease(_observer);
    CFRunLoopStop(_threadRunLoop.getCFRunLoop);
}


- (IBAction)handleMessage:(id)sender {
    NSString *log = @"传递信息";
    NSData *data = [log dataUsingEncoding:NSUTF8StringEncoding];
    [_machPort sendBeforeDate:[NSDate date] msgid:1000 components:[NSMutableArray arrayWithObject:data] from:_mainPort reserved:0];
}

- (IBAction)executeTask:(id)sender {
    
    [self performSelector:@selector(log) onThread:_thread withObject:self waitUntilDone:NO];
}

- (void)log{
    NSLog(@"当前执行任务的线程:%@",[NSThread currentThread]);
}

- (void)handlePortMessage:(NSPortMessage *)message{
    NSLog(@"当前线程%@",[NSThread currentThread]);
    
    
}

@end
