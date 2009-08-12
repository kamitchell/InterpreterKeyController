This project is based on the (most excellent) EmbeddedInterpreter and
CurrencyConvBinding projects shipped with PyObjC 1.4. It has been run
and tested on Mac OS X 10.4.11 with PyObjC 1.4 installed into Python
2.5.

To that I've added a calls called InterpreterKeyController.  This
class runs a thread that has an event tap, which can act upon key
presses "out of band". In other words, it can evaluate key presses as
they arrive in the process, even if the main thread's run loop is busy
doing something else.

It could be busy running the Python interpreter. InterpreterKeyController's
event tap looks for control-C keypresses, and safely interrupts the
Python interpreter. It's important to get Python's Global Interpreter
Lock when doing this to avoid corrupting the interpreter. The Python
interpreter gives up the lock every 100 bytecodes, allowing other
threads to run, so the GIL will become available before too long.

KeyboardInterrupt is always taken on the main thread in Python. Due to
the way EmbeddedInterpreter is written, it runs on the main thread. It
does, in fact, run the main thread's runloop while Python is blocking
on input, and in between I/O operations to the console.

The end result is a Python console that can be embedded into another
running program with some level of safety: If you run something from
the console that goes into an infinite loop, just press control-C and
it will be interrupted. There is no need to force quit the
application, as was necessary with the stock EmbeddedInterpreter.

This can be demonstrated by typing:

>>> while True: pass
... 

which then places the interpreter in an infinite loop. Pressing
control-C results in:

Traceback (most recent call last):
  File "<console>", line 1, in <module>
KeyboardInterrupt
>>>

One thing to note is that everything in the running program is
available in Python. For instance, the application delegate is
automatically included into the interpreter. Since the currency
conversion uses Cocoa bindings, executing a statement like

>>> appDelegate.dollarsToConvert=5

directly affects the model, with the appropriate text field changing
in the UI, and the calculation is triggered as well.

It is my hope that others will find this useful for more safely adding
a console as a diagnostic tool and to aid in experimentation and
diagnosis during application development.

More information on Quartz Event services can be found at:
http://developer.apple.com/documentation/Carbon/Reference/QuartzEventServicesRef/Reference/reference.html

The PyObjC project can be found at: http://pyobjc.sourceforge.net/

Kevin A. Mitchell
February 2008
