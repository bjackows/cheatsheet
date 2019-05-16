### For each 10 lines, emit a new array
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
