### status of channel in loop

```
  for {
    select {
      case message, opened <- c:
        if ! opened {
          // logic
          return
        }
     }
  }
```
