# starry_night_contest
Coding Contest: How close can you come to Van Gogh's "Starry Night" with a kilobyte of code?

See the link here: 
http://codegolf.stackexchange.com/questions/69930/paint-starry-night-objectively-in-1kb-of-code

Here's how `go.rb` works:


Draw a white 386x320 rectangle.  
Put the rectangle in a list.
Build a ruby file to generate that list of rectangles (only one in this initial case)

While the generated ruby file is less than 1024 bytes:
* Search the list for the highest scoring rectangle
* Try halving that rectangle horizontally and vertically
* Replace that rectangle in the list with whichever pair scored lower
* Build a ruby file to generate that list of rectangles


*NOTE:* My scoring algorithm randomly samples a bunch of colors and picks the one that results in the smallest difference from `ORIGINAL.png`.  As it is probabilistic, I have rerun the script a bunch of times and picked the lowest scoring result.
