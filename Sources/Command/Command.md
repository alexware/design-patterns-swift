

# Command

### Description </br>
Pattern is used to incapsulate an operation (parameters required to execute the operation) so that it can be invoked later or by a different component. </br>

### iOS/MacOS adaptation </br>
NSInvocation (cannot be used in Swift because of the different ways that Swift and Objective-C invoke methods), NSUndoManager (Cocoa). </br>

### Structure/UML*
--

### Rules of thumb*
--

### Why and where you should use the pattern*

### Pros </br>
Decouples classes that invoke operations from classes that perform them, allows to create cancelable operations.  </br>
Allows assembling simple commands into larger ones. </br>
Follows Open/Closed Principle. </br>

### Cons </br>
Increases overall code complexity by creating multiple additional classes. </br>

### More
--
