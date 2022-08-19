# Project 33: What's that Whistle?

### Personal Notes
- iOS uses two classes to record audio
    - `AVAudioSession` enables and tracks recording in general
    - `AVAudioRecorder` tracks individual recordings
- the location of a recording is required at the time of the creation of an `AVAudioRecorder` object as iOS streams the recording to the file
- a `CKRecord` is essentially a dictionary with some extra functionality
- a `CKAsset` is an object to hold binary blobs; can be added to a `CKRecord`
- each app has a dedicated `CKContainer`
- each container has two `CKDatabase` objects
    - private: consumes user's personal iCloud quota
    - public: consumes developer's CloudKit quota
- all `CloudKit` calls are asynchronous
- a _forward reference_ is when a parent object is aware of which child object belongs to it; whereas a _back reference_ mechanism allows the child object to keep track of which parent object it belongs to

### Solution Preview
<img src="https://user-images.githubusercontent.com/4438390/185690929-3c2a10f8-2127-45c5-9b5d-7302935e3b46.png" style="float:left; width: 30%; margin-left: 1%"><img src="https://user-images.githubusercontent.com/4438390/185690976-da0c26a2-8547-4c5b-9547-f972a06f6b05.png" style="float:left; width: 30%; margin-left: 1%"><img src="https://user-images.githubusercontent.com/4438390/185691000-c9a77d05-eea8-4cf3-8989-55cf42be8e99.png" style="float:left; width: 30%; margin-left: 1%">
