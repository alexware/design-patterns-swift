

# Observer

### Description </br>
Defines a one-to-many relationship so that when one object changes state, the others are notified and updated automatically. </br>

### iOS/MacOS adaptation </br>
NotificationCenter/NSNotificationCenter, Key-Value Observing. </br>

### Structure/UML*
--

### Rules of thumb*
--

### Why and where you should use the pattern*

### Pros </br>
Publisher is not coupled to concrete subscriber classes, can subscribe and unsubscribe objects dynamically. </br>
Follows the Open/Closed Principle. </br>

### Cons </br>
Subscribers are notified in random order. </br>

### More
--
