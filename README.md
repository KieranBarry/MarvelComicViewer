# MarvelComicViewer
Simple iOS app to view comic data from Marvel API.

**Note:** Currently viewing comic with ID 52646. To change this, edit the comicId property in Resources/Constants.swift

## Adding Developer Keys
For the sake of simplicity, I have made two constants to hold the Marvel API's private and public keys.
**To use this app, please add keys to Resources/MarvelAPIKeys.swift**

## Libraries Used
I have opted not to use any third-party libraries, but am using the following built-in libraries:
  - **URLSession** for all network requests
  - **XCTest** for unit and UI Testing

## Notes
- Currently built on MVC architecture with added networking layer to conform to SOLID principles
- I have opted to use UIKit instead of SwiftUI after discussing the techonologies Disney primarily uses in technical screen. I hope to integrate with Combine if I have time.
- Though the app is currently static and loads one predetermined comic, I built it to be robust to dynamic data response from server. UI addapts to what information the server does or does not supply and gives user feedback if network request fails
- Unit tests provide near-exhaustive coverage of MarvelAPIManager.fetchComic method
- Currently only one UI Test, as interface is static
- Please note I am pushing all basic functionality and testing up in one commit because I did not initially plan on submitting via github. I will continue to commit additional features as I execute them from here on out.
- Further talking points: Comic's init(from decoder:), some programmatic interface, extension functions

## Where to go from here
- [ ] Update UI
- [ ] Make fonts dynamic to accommodate accessibility concerns
- [ ] Fetch a list of comics to display as Master/Detail and update UI Tests
- [ ] Integrate with Combine
- [ ] Add persistence layer for offline use
- [ ] Add filters/search bar to comic list
- [ ] Complete robust testing suite
- [ ] Add Localization and further accessibility features


