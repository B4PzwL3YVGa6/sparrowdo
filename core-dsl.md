# SYNOPSIS

Sparrowdo core-dsl functions spec.

* User accounts

| function | description | usage | sparrow plugin |
| -------- | ----------- | ----- | -------------- |
| user-create | create user | `user-create($name)`| [user](https://sparrowhub.org/info/user) | 
| user-delete | delete user | `user-delete($name)`| [user](https://sparrowhub.org/info/user) |
| user        | create/delete user | `user($name,[%args])`| [user](https://sparrowhub.org/info/user) |

Examples:


    user-create 'alexey'; # create user `alexey'
    user-delete 'alexey'; # delete user `alexey'
    user 'alexey'; # short form of user create
    user 'alexey', %(action => 'create'); # hash parameters form of user create
    user 'alexey', %(action => 'delete'); # hash parameters form of user delete

* User groups

| function | description | usage | sparrow plugin |
| -------- | ----------- | ----- | -------------- |
| group-create | create group | `group-create($name)`| [group](https://sparrowhub.org/info/group) | 
| group-delete | delete group | `group-delete($name)`| [group](https://sparrowhub.org/info/group) |
| group        | create/delete group | `group($name,[%args])`| [group](https://sparrowhub.org/info/group) |

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
| cpan-package         | alias for cpan-install function | * | *  |

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
    
    # short form of above
    cpan-package ('CGI', 'Config::Tiny', 'HTTP::Tiny');
    
    # install 3 cpan modules, users install
    cpan-package-install 'CGI Config::Tiny HTTP::Tiny', %(
        user =>'foo',
        install-base => '/home/foo/',
    );
    
    # the same as above but passing cpan modules list as Array
    cpan-package-install ('CGI', 'Config::Tiny', 'HTTP::Path'), %(
        user =>'foo',
        install-base => '/home/foo/',
    );
      
* Services

| function | description | usage | sparrow plugin |
| -------- | ----------- | ----- | -------------- |
| service-start | start service | `service-start($name)`| [service](https://sparrowhub.org/info/service) | 
| service-restart | restart service | `service-restart($name)`| [service](https://sparrowhub.org/info/service) | 
| service-stop | stop service | `service-stop($name)`| [service](https://sparrowhub.org/info/service) | 
| service-enable | enable service | `service-enable($name)`| [service](https://sparrowhub.org/info/service) | 
| service-disable | disable service | `service-disable($name)`| [service](https://sparrowhub.org/info/service) | 
| service       | start/stop/restart/enable/disable service | `service($name, %args)`| [service](https://sparrowhub.org/info/service) |

Examples:

    service-enable 'nginx';
    
    service-start 'nginx';
    
    service-stop 'nginx';
    
    service-restart 'nginx';
    
    service 'nginx', %( action => 'stop' );
    
    service 'nginx', %( action => 'disable' );
    
    service-disable 'nginx';
    

* Directories

| function | description | usage | sparrow plugin |
| -------- | ----------- | ----- | -------------- |
| directory-create | create directory | `directory-create($name,%args)`| [directory](https://sparrowhub.org/info/directory) | 
| directory-delete | delete directory | `directory-delete($name)`| [directory](https://sparrowhub.org/info/directory) |
| directory        | create/delete directory | `directory($name,[%args])`| [directory](https://sparrowhub.org/info/directory) |

Examples:

    directory '/tmp/baz';

    directory-create '/tmp/baz';

    directory-create '/tmp/foo/bar', %(
      recursive => 1 ,
      owner => 'foo',
      mode => '755'
    );
    
    directory '/tmp/foo/bar/bar/123', %(
      action => 'create',
      recursive => 1 ,
      owner => 'foo',
      mode => '755'
    );
    
    
    directory-delete '/tmp/foo/bar';


