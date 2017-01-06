# SYNOPSIS

Sparrowdo core-dsl functions.

* User accounts

| function | description | usage | sparrow plugin |
| -------- | ----------- | ----- | -------------- |
| user-create | create linux/unix user | `user-create($label,%args)`| [user](https://sparrowhub.org/info/user) | 
| user-delete | delete linux/unix user | `user-delete($label,%args)`| [user](https://sparrowhub.org/info/user) |

Examples:


    user-create 'create foo user', %(name => 'alexey');
    user-delete 'delete foo user', %(name => 'alexey');

* Packages

| function | description | usage | sparrow plugin |
| -------- | ----------- | ----- | -------------- |
| package-install | install software package ( OS independent ) | `package-install(@list|$list)`| [package-generic](https://sparrowhub.org/info/package-generic) | 

Examples:

    # pass list as Array
    package-install ('nano', 'tree', 'mc');

    # pass list as String, 
    # packages are space separated items 
    package-install 'nano tree mc';
    package-install 'nano';




  
