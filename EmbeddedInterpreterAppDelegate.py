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
    keyController = ivar('keyController')

    def applicationDidFinishLaunching_(self, sender):
        if EmbeddedInterpreterPlugIn.alloc().init().plugInLoaded():
            from EmbeddedInterpreterPlugIn import InterpreterKeyController
            keyController = InterpreterKeyController.new().start()

    def showPythonConsole_(self, sender):
        if self.pythonConsoleController is None:
            self.pythonConsoleController = NSWindowController.alloc().initWithWindowNibName_("PyInterpreter")
        self.pythonConsoleController.showWindow_(self)
