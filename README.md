This is an iOS demo application for displaying the latest box office movies using the RottenTomatoes API.

Time spent: 12 hours spent in total

Completed user stories:

Required:  
[X] User can view a list of movies. Poster images load asynchronously.  
[X] User can view movie details by tapping on a cell.  
[X] User sees loading state while waiting for the API.  
[X] User sees error message when there is a network error: http://cl.ly/image/1l1L3M460c3C  
[X] User can pull to refresh the movie list.  
   
Optional:  
[X] Add a tab bar for Box Office and DVD.  
[X] Implement segmented control to switch between list view and grid view.  
[X] Add a search bar.  
[X] All images fade in.  
[X] For the large poster, load the low-res image first, switch to high-res when complete.  
[X] Customize the highlight and selection effect of the cell.  
[X] Customize the navigation bar.  

My favorite part of this assignment was figuring out how to use one UICollectionView for both the grid and list view and appying different layouts for each view. This cuts down on multiple delegates, views, and cells.

NOTE: There was an issue with the Rotten Tomatoes API near the end of the project so I added test data to the project. You can enable and disable the test data by adding or removing the -D USE_CACHED_DATA_FILES compiler flag from the build settings.

Walkthrough of all user stories:
  
![alt tag](https://github.com/longsview/Tomatoes/blob/master/tomatos.gif?raw=true)  

GIF created with LiceCap.  
Project uses https://github.com/AFNetworking/AFNetworking  
