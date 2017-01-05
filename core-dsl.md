# SYNOPSIS

Sparrowdo core-dsl functions.

| function | description | usage | sparrow plugin |
| -------- | ----------- | ----- | -------------- |
| user-create | create linux/unix user | `user-create($label,%args)`| [user](https://sparrowhub.org/info/user) | 
| user-delete | delete linux/unix user | `user-create($label,%args)`| [user](https://sparrowhub.org/info/user) |

Examples:


    user-create 'create foo user', %(name => 'alexey');
    user-delete 'delete foo user', %(name => 'alexey');







  
