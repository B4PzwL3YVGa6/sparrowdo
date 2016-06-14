# sparrowdo

Simple configuration engine based on [sparrow](https://sparrowhub.org) plugin system.


# USAGE


    $ cat << EOF > sparrowfile

    use v6;
    
    use Sparrowdo;
    
    task_run  %(
      task => 'check disk available space',
      plugin => 'df-check',
      parameters => %( threshold => 80 )
    );
    
    task_run  %(
      task => 'install app',
      plugin => 'perl-app',
      parameters => %( 
        'app_source_url' => 'https://github.com/melezhik/web-app.git',
        'git_branch' => 'dev',
        'http_port' => 3030
      )
    );
    
    EOF


    $ sparrowdo --host 192.169.0.1

# AUTHOR

[Aleksei Melezhik](mailto:melezhik@gmail.com)

# Home page

[https://github.com/melezhik/sparrow](https://github.com/melezhik/sparrowdo)

# Copyright

Copyright 2015 Alexey Melezhik.

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

# See also

* [Sparrow](https://metacpan.org/pod/Sparrow) - Multipurposes scenarios manager.

* [SparrowHub](https://sparrowhub.org) - Central repository of sparrow plugins.

* [Outthentic](https://metacpan.org/pod/Outthentic) - Multipurposes scenarios devkit.

# Thanks

To God as the One Who inspires me to do my job!

