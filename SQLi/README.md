### Trailing spaces for char() type

https://charlesnagy.info/it/mysql/varchar-vs-char-in-mysql-understanding-trailing-spaces

Character type is pretty simple. You specify the length and it will become a character string with that amount of characters. But how a ‘cat’ becomes a CHAR(8). Simply it gets padded with spaces. Physically it stored as ‘cat     ‘ (with 5 spaces).
