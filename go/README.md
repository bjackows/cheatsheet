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

### Print all goroutine stacks without sigquit

credits: https://stackoverflow.com/a/23355904

```
stacktrace := make([]byte, 8192)
length := runtime.Stack(stacktrace, true)
fmt.Println(string(stacktrace[:length]))
```
