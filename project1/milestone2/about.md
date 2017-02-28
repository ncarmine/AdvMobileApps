###Favorites App

The favorites app is an app to place all your favorite links in one place. You can categorize your links in one of the preset categories, such as Music, Video, or Art, or create your own category.

I am currently deciding between two user flows for this app at the first view:

* Loading up to the first category (in the mockups, Music), and having a tab bar at the bottom for the other categories. I want the user to be able to modify the categories, however, I don't know how feasible that is with tab bars.
* Having the first view be a collection view of all categories of favorites and having the user tap on a category to go to the link list. This would make modifying the categories easy, but it would involve the flow of the app being a lot of back and forth. The categories would be less immediately accessible.

No major algorithms would be needed for this app other than searching. In order to preserve ordering, I'm considering nesting arrays instead of using dictionaries. All other logic comes from standard implementation of TableViews and possibly a CollectionView.
