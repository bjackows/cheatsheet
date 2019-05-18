### Psql to json

```
psql -tc "select row_to_json(t1) from (select * from table) t1;"
```
