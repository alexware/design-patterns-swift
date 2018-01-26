

# Strategy

### Description </br>
Used to create classes that can be extended without modification, basically switching or adding algorithm.  </br>

### iOS/MacOS adaptation </br>
UITableView/UICollectionView is using UITableViewUICollectionViewDataSource/UICollectionViewDataSource to define the strategy for generating rows/columns and providing data. </br>

### Structure/UML*
--

### Rules of thumb*
--

### Why and where you should use the pattern*

### Pros </br>
Follows the Open/Closed Principle, allows hot swapping algorithms at runtime. </br>
Isolates the code and data of the algorithms from the other classes. </br>
Replaces inheritance with delegation. </br>

### Cons </br>
Increases overall code complexity. </br>
Client must be aware of the differences between strategies to pick a proper one. </br>

### More
--
