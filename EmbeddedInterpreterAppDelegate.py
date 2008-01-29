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

    # The input fields have formatters that convert the text
    # value to a number. If we wouldn't do that, exchangeRate
    # and dollarsToConvert would be set to strings.
    #
    # The alternative is using objc instance variables of the
    # right type (in this case doubles) and let the Cocoa 
    # implementation worry about the conversion:
    #   exchangeRate = ivar('exchangeRate', 'd')
    #   dollarsToConvert = ivar('dollarsToConvert', 'd')
	
    def init(self):
        self = super(EmbeddedInterpreterAppDelegate, self).init()
        self.exchangeRate = 3
        self.dollarsToConvert = 4
        return self
    
    def amountInOtherCurrency(self):
        return self.dollarsToConvert * self.exchangeRate
    
    def applicationDidFinishLaunching_(self, sender):
        if EmbeddedInterpreterPlugIn.alloc().init().plugInLoaded():
            from EmbeddedInterpreterPlugIn import InterpreterKeyController
            keyController = InterpreterKeyController.new().start()

    def showPythonConsole_(self, sender):
        if self.pythonConsoleController is None:
            self.pythonConsoleController = NSWindowController.alloc().initWithWindowNibName_("PyInterpreter")
        self.pythonConsoleController.showWindow_(self)

EmbeddedInterpreterAppDelegate.setKeys_triggerChangeNotificationsForDependentKey_(
    [u"dollarsToConvert", u"exchangeRate"],
    u"amountInOtherCurrency"
)
