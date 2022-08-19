# Project 13: Instafilter

### Personal Notes
- set content hugging priority to `.defaultHigh` for image preview wrapper `previewWindow`
- you can set the minimum and maximum values for a `UISlider` instance
- created enum for `CIFilter` types; conforming to `CaseIterable` allowing for easy `forEach` loops
- custom, failable initializer for enum `CIFilterType` used for changing button title

### Additional Challenges
> 1. Try making the _Save_ button show an error if there was no image in the image view.
> 2. Make the _Change Filter_ button change its title to show the name of the currently selected filter.
> 3. Experiment with having more than one slider, to control each of the input keys you care about. For example, you might have one for radius and one for intensity.

### Solution Preview
<img src="https://user-images.githubusercontent.com/4438390/185159017-ee299fa0-8dbe-4594-a2d6-206974ed46c8.png" style="float:left; width: 30%; margin-left: 1%"><img src="https://user-images.githubusercontent.com/4438390/185159057-bcc41263-e080-4542-8195-32f46b8bbe6e.png" style="float:left; width: 30%; margin-left: 1%"><img src="https://user-images.githubusercontent.com/4438390/185159104-ff14f925-9147-4f00-9b8b-72774ab54fa7.png" style="float:left; width: 30%; margin-left: 1%">
