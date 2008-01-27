//
//  InterpreterKeyController.m
//  EmbeddedInterpreter
//
//  Created by Kevin on 1/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "InterpreterKeyController.h"
#include "Python.h"

static CGEventRef eventTapFunction(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon)
{
    UniChar unicodeString[10];
    UniCharCount actualStringLength;
    
    if (![InterpreterKeyController enabled])
        return event;
    
    CGEventKeyboardGetUnicodeString(event, sizeof(unicodeString) / sizeof(*unicodeString), &actualStringLength, unicodeString);
    
    if ((CGEventGetFlags(event) & kCGEventFlagMaskControl == kCGEventFlagMaskControl) && 
        actualStringLength == 1 &&
        unicodeString[0] == 3)
    {
        NSLog(@"control-c");

        // Really important to get the GIL lock. Python gives it up
        // every 100 bytecodes, so we won't wait too long.
        PyGILState_STATE gilstate = PyGILState_Ensure();
        // And once the main thread gets control again, it'll get a
        // KeyboardInterrupt
        PyErr_SetInterrupt();
        PyGILState_Release(gilstate);
        
        // In this case, we used the event, so just make it null
        CGEventSetType(event, kCGEventNull);
    }
    return event;
}


@implementation InterpreterKeyController
static BOOL interruptsEnabled = NO;

+ (BOOL) enabled
{
    return interruptsEnabled;
}

+ (void) setEnabled: (BOOL) enabled
{
    interruptsEnabled = enabled;
}

- (void) start
{
    [NSThread detachNewThreadSelector: @selector(threadproc:) toTarget: self withObject: NULL];
}

- (void) threadproc: (void*) arg
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    
    [runLoop run];
    
    CFMachPortRef machPortRef = NULL;
    ProcessSerialNumber currentProcess;
    GetCurrentProcess(&currentProcess);
    machPortRef =  CGEventTapCreateForPSN(&currentProcess,
                                          kCGHeadInsertEventTap,
                                          0,
                                          CGEventMaskBit(kCGEventKeyDown),
                                          (CGEventTapCallBack)eventTapFunction,
                                          NULL);
    if (machPortRef == NULL)
        NSLog(@"CGEventTapCreate failed!");
    
    CFRunLoopSourceRef eventSrc = CFMachPortCreateRunLoopSource(NULL, machPortRef, 0);
    if ( eventSrc == NULL )
        NSLog(@"CFMachPortCreateRunLoopSource failed!");
    
    CFRunLoopAddSource([runLoop getCFRunLoop],  eventSrc, kCFRunLoopDefaultMode);
    
    [runLoop run];
    
    [runLoop release];
    
    [pool release];
}
@end
/*
Local variables:
mode: ObjC
tab-width: 4
indent-tabs-mode: nil
c-basic-offset: 4
End:
*/
