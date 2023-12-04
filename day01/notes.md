## Part 1

```
1abc2 = 12
*   *

pqr3stu8vwx = 38
   *   *

a1b2c3d4e5f = 15
 * * * * *

treb7uchet = 77
    *
```

Seems like every number is 2 digits and we have two cases:

- 1 number
  - Number repeats twice
- 2+ numbers
  - First number and highest of remaining numbers?
  - Alternatively first number and last number?
- (what about 0 numbers??)
  - We will assume 0

Algorithm. We'll start with first/last number since it should be simpler

- Scan for first number in string from beginning
- Scan string backwards for first number
- Concat

edit: Just solved the first part, but I am actually an idiot lol because it says

> On each line, the calibration value can be found by combining the first digit
> and the last digit (in that order) to form a single two-digit number

and I did not need to reverse engineer it

## Part 2

Okay so I think the best way to approach this is probably to have a sliding
window of size 5 since it'll accomodate longest numbers (string length wise).
There's probably a way to super overengineer this by using a hard-coded trie to
try and lex the string. Let's do the window algorithm lol:

- Have a single pointer `start`

_Forwards_

- start begins at 0
- we check if start = digit and return if so
- else we check if substring (start,min(start+5, length)) contains any of the
  numbers
- if start+5 < length recurse with start + 1

_Backwards_

- `start` begins at length - 1
- we check if start = digit and return if so
- else we check if substring (max(start-5, 0), start) contains any of the
  numbers
- if start-5 > 0 recurse with start - 1

update: I am an idiot once again...there's an edgecase of this "six1q" where we
will find six, but not 1 since 1 isn't checked until it's the last element in
the window.

New algo will initially expand window instead of having it be static at 5. This
will get rid of having to check for boundaries and will check for digits leading
instead of trailing:

- Have two pointers `start` and `end`

_Forwards_

- `start` and `end` begin at 0
- increment `end` until substring len is 5
- check if s[end] = digit and return if so
- else check s[start..end] for numbers
- when substring is the size of the window, set `start` + 1 and `end` + 1

_Backwards_

- `start` and `end` begin at `len - 1`
- decrement `start` until substring len is 5
- check if s[start] = digit and return if so
- else check s[start..end] for numbers
- when substring is the size of the window, set `end` - 1 and `start` - 1
