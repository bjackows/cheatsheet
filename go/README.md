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

### Build to stdout

```
go build -o /dev/stdout | cat -e > a.out
```
