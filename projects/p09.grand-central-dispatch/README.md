# Project 9: Grand Central Dispatch

### Personal Notes
- GCD calls get assigned to an existing background thread and executed in FIFO order
    - `DispatchQueue.global(qos: <target_thread>).async { ... }`
- available **Quality of Service** (QoS) levels:
    - `.userInteractive`: highest priority; meant for important tasks
    - `.userInitiated`: used for important tasks requested by user, non-UI changes
    - `.utility`: long-running tasks that user is aware of, but not waiting for
    - `.background`: long-running tasks that user is not aware of or isn’t highly concerned with completion
- **Important:** UI changes **must** be executed on the main thread
    - `DispatchQueue.main.async { ... }`

### Additional Challenges
> 1. Modify [**project 1**](https://github.com/seventhaxis/hacking-with-ios/tree/master/projects/p01.storm-viewer/) so that loading the list of NSSL images from our bundle happens in the background. Make sure you call `reloadData()` on the table view once loading has finished!
> 2. Modify [**project 8**](https://github.com/seventhaxis/hacking-with-ios/tree/master/projects/p08.7-swifty-words/) so that loading and parsing a level takes place in the background. Once you’re done, make sure you update the UI on the main thread!
> 3. Modify [**project 7**](https://github.com/seventhaxis/hacking-with-ios/tree/master/projects/p07.whitehouse-petitions/) so that your filtering code takes place in the background. This filtering code was added in one of the challenges for the project, so hopefully you didn’t skip it!

### Solution Preview
```swift
enum SearchType: Int {
    case recent = 1, top

    var address: String {
        return "https://hackingwithswift.com/samples/petitions-\(self.rawValue).json"
    }
}

fileprivate func loadPetitions() {
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        if let self = self, let targetUrl = URL(string: self.searchType.address), let rawData = try? Data(contentsOf: targetUrl) {
            let decoder = JSONDecoder()
            guard let jsonPetitions = try? decoder.decode(Petitions.self, from: rawData) else { self.showConnectionError(); return }
            self.allPetitions = jsonPetitions.results
            self.filteredPetitions = jsonPetitions.results

            DispatchQueue.main.async { self.tableView.reloadData() }
        }
    }
}
```
