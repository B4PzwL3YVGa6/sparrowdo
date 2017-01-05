# SYNOPSIS

Sparrowdo core-dsl functions.

* User accounts

| function | description | usage | sparrow plugin |
| -------- | ----------- | ----- | -------------- |
| user-create | create linux/unix user | `user-create($label,%args)`| [user](https://sparrowhub.org/info/user) | 
| user-delete | delete linux/unix user | `user-create($label,%args)`| [user](https://sparrowhub.org/info/user) |

Examples:


    user-create 'create foo user', %(name => 'alexey');
    user-delete 'delete foo user', %(name => 'alexey');

* Packages

| function | description | usage | sparrow plugin |
| -------- | ----------- | ----- | -------------- |
| package-install | install software package ( OS independent ) | `package-install(@list)`| [package-generic](https://sparrowhub.org/info/package-generic) | 

Examples:

    package-install ('nano', 'tree', 'mc');




  
