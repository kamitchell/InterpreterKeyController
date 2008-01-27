#
#  EmbeddedInterpreterAppDelegate.py
#  EmbeddedInterpreter
#

from Foundation import *
from AppKit import *
from EmbeddedInterpreterPlugIn import *

from PyObjCTools import NibClassBuilder

class EmbeddedInterpreterAppDelegate(NibClassBuilder.AutoBaseClass):

    def applicationDidFinishLaunching_(self, sender):
        if EmbeddedInterpreterPlugIn.alloc().init().plugInLoaded():
            NSLog(u'Objective-C Plug-In Loaded!')
            NSBeep()
