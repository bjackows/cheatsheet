### Read file from scratch

```
input {
        file {
                path => ["/tmp/last.json"]
                codec => json_lines{}
                mode => "read"
                exit_after_read => true
                sincedb_path => "/dev/null"
                file_completed_action => "log"
                file_completed_log_path => "/dev/null"
        }
}
```
