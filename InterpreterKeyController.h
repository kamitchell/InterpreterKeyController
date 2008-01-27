//
//  InterpreterKeyController.h
//  EmbeddedInterpreter
//
//  Created by Kevin on 1/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface InterpreterKeyController : NSObject {
} 

+ (BOOL) enabled;
+ (void) setEnabled: (BOOL) enabled;

- (void) start;
- (void) threadproc: (void*) arg;

@end
/*
Local variables:
mode: ObjC
tab-width: 4
indent-tabs-mode: nil
c-basic-offset: 4
End:
*/
