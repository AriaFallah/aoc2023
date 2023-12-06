## Part 1

Okay this seems relatively simple. We need to:

- Know what game it is
  - Index + 1 if we scan the file. No need to even parse anything out
- Know if the game matches the constraints
  - I don't even think splitting games on `;` is necessary, we just check if
    there's an occurence of a number higher than what we have for any color

I think we could even do this with regex with a easy pattern for each
constraint. Looking at the input, it seems like there's nothing greater than two
digits so this should work

- `/(?:1[3-9]|[2-9][0-9]) red|(?:1[4-9]|[2-9][0-9]) green|(?:1[5-9]|[2-9][0-9]) blue/`

and then we filter out any lines that match

## Part 2

Okay this part seems to be asking for the max for each color per line so it
requires some parsing. Since I'm already using regex and don't really feel like
manually parsing, I figure I can use it again here. We'll have three patterns we
run for each line

- `/([1-9][0-9]?) red/`
- `/([1-9][0-9]?) green/`
- `/([1-9][0-9]?) blue/`

Then we parse what's captured into a number, do a `max` on the list, and
multiply the result
