# Milestone 6: Country Facts

[![](https://img.shields.io/badge/Hacking%20with%20iOS-2020.01.31-36A9AE?logo=gumroad)](https://www.hackingwithswift.com/store/hacking-with-ios) [![](https://img.shields.io/badge/Xcode-11.4.1-3d8af0?logo=xcode)](#) [![](https://img.shields.io/badge/Swift-5.2-FA7343?logo=swift)](#)

### Personal Notes
- using [**country data**](https://github.com/mledoze/countries) maintained by **@mledoze** in JSON format
- conforming only to `Decodable` protocol; `Encodable` is unused for project
- custom `DetailField` used to stack information on detail screen
- using **nil-coelescing operator** for potentially unknown or undefined country details

### Challenge
> Your challenge is to make an app that contains facts about countries: show a list of country names in a table view, then when one is tapped bring in a new screen that contains its capital city, size, population, currency, and any other facts that interest you. The type of facts you include is down to you – Wikipedia has a huge selection to choose from.
>
> To make this app, I would recommend you blend parts of project 1 project 7. That means showing the country names in a table view, then showing the detailed information in a second table view.
>
> How you load data into the app is going to be an interesting problem for you to solve. I suggested project 7 above because a sensible approach would be to create a JSON file with your facts in, then load that in using `contentsOf` and parse it using `Codable`. Regardless of how you end up solving this, I suggest you don’t just hard-code it into the app – i.e. typing all the facts manually into your Swift code. You’re better than that!

### Solution Preview
<img src="https://user-images.githubusercontent.com/4438390/72212536-002a1a80-34ac-11ea-8f5a-f7eb25fc860b.png">
