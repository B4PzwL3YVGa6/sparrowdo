# SYNOPSIS

Sparrowdo core-dsl functions spec.

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
| package-install | install software package | `package-install(@list|$list)`| [package-generic](https://sparrowhub.org/info/package-generic) | 
| cpan-package-install | install CPAN package | `cpan-package-install(@list|$list,%opts)`| [cpan-package](https://sparrowhub.org/info/cpan-package) | 

Examples:

1. packages

    # pass list as Array
    package-install ('nano', 'tree', 'mc');

    # pass list as String, 
    # packages are space separated items 
    package-install 'nano tree mc';
    package-install 'nano';

2. CPAN packages

    # install 3 modules, system wide paths
    cpan-package-install ('CGI', 'Config::Tiny', 'HTTP::Tiny') ,
    
    # install 3 modules, users install
    cpan-package-install
      'CGI Config::Tiny HTTP::Tiny',
      %(
        user =>'foo',
        install-base => '/home/foo/',
      );
    
    # the same as above but passing modules list as Array
    cpan-package-install
      ('CGI', 'Config::Tiny', 'HTTP::Path'),
      %(
        user =>'foo',
        install-base => '/home/foo/',
      );
      
