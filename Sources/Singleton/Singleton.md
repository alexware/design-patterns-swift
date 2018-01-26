

# Singleton

### Description </br>
The intent of a Singleton is to ensure a class only has one instance, and provide a global point of access to it.  </br>

### iOS/MacOS adaptation </br>
FileManager, URLSession, Notification, UserDefaults, ProcessInfo (Foundation), UIApplication and UIAccelerometer (UIKit), SKPaymentQueue (StoreKit) etc. </br>

### Structure/UML*
--

### Rules of thumb*
--

### Why and where you should use the pattern*

### Pros </br>
Ensures that class has only a single instance. </br>
Provides global access point to that instance. </br>

### Cons </br>
Violates Single Responsibility Principle.  </br>
Masks bad design. </br>
Requires endless mocking in unit tests. </br>
Requires special treatment in a multithreaded environment. </br>

### More
--
