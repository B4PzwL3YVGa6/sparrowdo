# SYNOPSIS

Sparrowdo core-dsl functions spec.

* User accounts

| function | description | usage | sparrow plugin |
| -------- | ----------- | ----- | -------------- |
| user-create | create linux/unix user | `user-create($name)`| [user](https://sparrowhub.org/info/user) | 
| user-delete | delete linux/unix user | `user-delete($name)`| [user](https://sparrowhub.org/info/user) |
| user        | create/delete linux/unix user | `user($name,[%args])`| [user](https://sparrowhub.org/info/user) |

Examples:


    user-create 'alexey'; # create user `alexey'
    user-delete 'alexey'; # delete user `alexey'
    user 'alexey'; # short form of user create
    user 'alexey', %(action => 'create'); # hash parameters form of user create
    user 'alexey', %(action => 'delete'); # hash parameters form of user delete

* group groups

| function | description | usage | sparrow plugin |
| -------- | ----------- | ----- | -------------- |
| group-create | create linux/unix group | `group-create($name)`| [group](https://sparrowhub.org/info/group) | 
| group-delete | delete linux/unix group | `group-delete($name)`| [group](https://sparrowhub.org/info/group) |
| group        | create/delete linux/unix group | `group($name,[%args])`| [group](https://sparrowhub.org/info/group) |

Examples:


    group-create 'sparrows'; # create group `sparrows'
    group-delete 'sparrows'; # delete group `sparrows'
    group 'sparrows'; # short form of group create
    group 'sparrows', %(action => 'create'); # hash parameters form of group create
    group 'sparrows', %(action => 'delete'); # hash parameters form of group delete

* Packages

| function | description | usage | sparrow plugin |
| -------- | ----------- | ----- | -------------- |
| package-install | install software package | `package-install(@list|$list)`| [package-generic](https://sparrowhub.org/info/package-generic) | 
| cpan-package-install | install CPAN package | `cpan-package-install(@list|$list,%opts)`| [cpan-package](https://sparrowhub.org/info/cpan-package) | 

Examples:

Packages

    # pass list as Array
    package-install ('nano', 'tree', 'mc');

    # pass list as String, 
    # packages are space separated items 
    package-install 'nano tree mc';
    package-install 'nano';

CPAN packages

    # install 3 cpan modules, system wide paths
    cpan-package-install ('CGI', 'Config::Tiny', 'HTTP::Tiny');
    
    # install 3 cpan modules, users install
    cpan-package-install 'CGI Config::Tiny HTTP::Tiny',
      %(
        user =>'foo',
        install-base => '/home/foo/',
      );
    
    # the same as above but passing cpan modules list as Array
    cpan-package-install ('CGI', 'Config::Tiny', 'HTTP::Path'),
      %(
        user =>'foo',
        install-base => '/home/foo/',
      );
      
