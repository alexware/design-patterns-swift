

# Object Pool

### Description </br>
Design pattern that uses a set of initialized objects kept ready to use – a "pool" – rather than allocating and destroying them on demand. </br>

### iOS/MacOS adaptation </br>
Object recycling is quite a common pattern in iOS. </br>
UIKit's tableView/collectionView reusable cells use Object Pool pattern (not sure how it's implemented though, Apple does not publish the source code). </br>
The dequeueReusableCellWithIdentifier method combines Object Pool and Factory Method patterns. </br>

### Structure/UML*
--

### Rules of thumb*
--

### Why and where you should use the pattern*

### Pros </br>
Saves a lot of memory. </br>

### Cons </br>
Complexity and ocurrance concurrency issues. </br>
Inadequate resetting of objects may also cause an information leak. </br>
Object pools full of objects with dangerously stale state are sometimes called object cesspools and regarded as an anti-pattern. </br>

### More
--
