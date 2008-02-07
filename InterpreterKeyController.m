//
//  InterpreterKeyController.m
//  EmbeddedInterpreter
//
//  Created by Kevin on 1/20/08.
//  Copyright (c) 2008 Kevin A. Mitchell
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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
