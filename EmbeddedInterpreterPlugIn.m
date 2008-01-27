//
//  EmbeddedInterpreterPlugIn.m
//  EmbeddedInterpreter
//

#import "EmbeddedInterpreterPlugIn.h"
#import "InterpreterKeyController.h"

@implementation EmbeddedInterpreterPlugIn

-(BOOL)plugInLoaded
{
    [[InterpreterKeyController new] start];
    return YES;
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
