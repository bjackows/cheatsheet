### nwise

For each 10 lines, emit a new array

```
seq 1 20 | jq \
  -n -R \
  'def nwise(stream; $n):
    foreach (stream, nan) as $x ([];
      if length == $n then [$x] else . + [$x] end;
      if (.[-1] | isnan) and length>1 then .[:-1]
      elif length == $n then .
      else empty
    end);
  nwise(inputs; 10)'
```

### Reduce

Declare a root object `0`, for each object in `.[]`, save it as the variable `$item`.

The result of `. + ($item | tonumber)` is saved for the next iteration.

IE:
  * `0 + 1`
  * `1 + 2`
  * `3 + 3`
  * `6 + 4`
  * ...

```
seq 1 20 | \
  jq  \
    -n -R \
    '[inputs] | reduce .[] as $item (0; . + ($item | tonumber))'
```

### Keys

Output the keys of each fields

```
jq -n '{"blih": true, "blah": false} | keys'
````
