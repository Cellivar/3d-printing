# Fusion 360 General Notes

I have distant history with learning CAD tools and took a hand-drafting course in high school that I enjoyed quite a bit. When I started getting into 3D printing I knew I was going to want to jump into parametric modelling.

I chose to dive into Fusion 360 mostly becuase it does what I needed without a lot of fuss. The tradeoff is that it is commercial software that definitely shows its upsell points. I remain concerned that someday Autodesk will decide it's time to further limit the tool in a way that makes it impossible for me to work with. Until then though it's working for me.

## General Guides

I honestly found some of the shorter intro videos on YouTube to be plenty enough introduction. Searching for the particular thing I was trying to accomplish usually brought up relevant results. Once you watch someone do something once or twice you can start to get the hang of the interface yourself.

Remember that there's an undo button. Hitting <ESC> when you're using a tool you don't want to use or CTRL + Z when you make a change you don't want is a great way to learn the tools available.

The [Absolute Beginners Guide](https://productdesignonline.com/fusion-360-for-beginners-2022-tutorial-by-kevin-kennedy/) is an excellent place to start, the link there is to the transcript of the video which I absolutely love.

A big final note: If you find yourself feeling frustrated that something is repetive or difficult to do it's very likely there's a better way to do what you want.
 
* Copy/pasting a lot? [The pattern tool](https://www.youtube.com/watch?v=POqHGvsyUgE) is easier. [The rectangular tool can be used for other shapes too](https://www.youtube.com/watch?v=AFZVNVvmXJ4).
* Need to adjust the depth of a surface a lot? Re-edit the extrude operation in the timeline instead of adding additional operations.
* Sketching a lot of objects to 'cut' out of something else? Start with a sketch on that surface instead to define your shape then 'extrude' in a negative direction to cut.
  
The more you play with the tool the easier it will be to figure out how to go from where you are to where you want to be with your design. The more different tools you try out the fewer steps it will take in the future.
  
### Terminology
  
Fusion 360 uses a lot of CAD lingo. I don't have a resource for this as I learned it in class ages ago. Find a glossary of CAD terms, this will help to understand the interface.

### Sketching
  
Get very comfortable jumping into the sketch interface. Parametric modelling is all about specific measurements and angles, getting comfortable drawing out your design via the sketch interface can make it much faster and easier to bash those measurements into a design.
  
You can sketch both directly on the plane, however sketching on _a surface_ is often the fastest way to alter your design. When creating a new sketch select the specific surface you want to work on.
  
### Timeline
  
The timeline is easily one of the most powerful features of Fusion 360. You can edit previous steps in your process, including sketches, and the changes will automatically flow through the latter steps.
  
If there's a conflict with a later step you'll automatically get a warning for it that explains what you need to fix.
  
## Neat tricks
  
* You can combine different measurement scales in the input fields. I have a very nice set of dial calipers that measure in thousandths of an inch, whereas I prefer to work with my designs in millimeters. If I enter `0.156in` into a field in Fusion 360 it'll automatically handle that (and convert where appropriate).
* You can perform math in input fields. IF you measure a diameter with your calipers but need a radius instead, you can enter `53mm / 2` right there in the input field. It'll calculate the value accordingly.

## Companion Tools
  
* [Gridfinity Generator Plugin](https://github.com/Le0Michine/FusionGridfinityGenerator) for generating bins and baseplates automatically. Makes it incredibly easy to slap together custom bins for my parts.
  
