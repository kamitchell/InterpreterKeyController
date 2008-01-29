#
#  EmbeddedInterpreterAppDelegate.py
#  EmbeddedInterpreter
#

from Foundation import *
from AppKit import *
from EmbeddedInterpreterPlugIn import *
from objc import ivar

from PyObjCTools import NibClassBuilder

class EmbeddedInterpreterAppDelegate(NibClassBuilder.AutoBaseClass):
    pythonConsoleController = ivar('pythonConsoleController')

    def applicationDidFinishLaunching_(self, sender):
        pass

    def showPythonConsole_(self, sender):
        if self.pythonConsoleController is None:
            self.pythonConsoleController = NSWindowController.alloc().initWithWindowNibName_("PyInterpreter")
        self.pythonConsoleController.showWindow_(self)
