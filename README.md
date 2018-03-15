# ff_marvel_test

The app has an initial `ViewController`, that is responsable for retrieving the list of superheroes, which is acomplished by using the `NetworkController`for making API calls. The items in the list are represented by `Superhero` struct.

The next view controller is the `SuperheroDetailViewController` and shows the list of events, comics, series & stories. Each one leads to the `ItemDetailViewController`, showing its details by making another API call. These are represented by the `Item` struct.
