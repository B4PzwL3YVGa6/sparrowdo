# Sparrowdo

Simple configuration engine based on [sparrow](https://sparrowhub.org) plugin system.

# Build status

[![Build Status](https://travis-ci.org/melezhik/sparrowdo.svg)](https://travis-ci.org/melezhik/sparrowdo)

# Usage


There are 3 essential things in Sparrowdo:

* [Core DSL](#core-dsl)

* [Plugins DSL](#plugins-dsl)

* [Modules](#sparrowdo-modules)


## Core DSL

Core DSL is probably easiest way to start using Sparrowdo right away. It offers some
high level functions to accomplish most common configuration tasks, like
create directories or users, populate files from templates or start services.

    $ cat sparrowfile

    user-create 'create foo user', %( name => 'foo' );
    service-start 'start nginx web server', %( service => 'nginx' );
    file-create 'create this file', %( 
        target => '/opt/file.txt', 
        owner => 'root', 
        mode => '0644', 
        content => 'hello world'
    );

Under the hood core dsl ends up in calling so called sparrow plugins with parameters.

If you want direct access to sparrow plugins API you may use a plugin DSL:

# Plugins DSL
  
Examples above could be rewritten with low level API: 

    $ cat sparrowfile

    task_run  %(
      task        => 'create foo user',
      plugin      => 'user',
      parameters  => %( 
        action => 'create' , 
        name => 'foo'
      )
    );

    task_run  %(
      task => 'start nginx web server',
      plugin => 'service',
      parameters => %( 
        action      => 'start',
        service     => 'nginx'
      )
    );


    task_run  %(
      task => 'create this file',
      plugin => 'file',
      parameters => %( 
        action      => 'create',
        target      => '/opt/file.txt',
        owner       => 'root',
        mode        => '0644',
        content     => 'hello world'
      )
    );

# Core DSL vs Plugins DSL
    
Core DSL is kinda high level adapter bringing some "syntax sugar" to make your code terse.
As well as adding Perl6 type/function checking as core-dsl functions are plain Perl6 functions.

From other hand core-dsl is limited. **Not every sparrow plugin** has a related core-dsl method.

So it's up to you use core dsl or low level sparrow plugin API. Once I found some sparrow plugin
very common and highly useful I add a proper core-dsl method for it. In case you need 
core-dsl wrappers for new plugins - let me know!

[Here](/core-dsl.md) is the list of core-dsl function available at current Sparrowdo version.

# Running sparrowdo scenario

Now having ready sparrowfile you can run your scenario against some remote hosts:

    $ sparrowdo --host=192.168.0.1

# Schema

Here is textual schema of what is going on.

      +-----------------+
      |                 |    ssh
      |                 |------------> < host-1 > 192.168.0.1
      | <master host>   |    ssh
      | {sparrowdo}     |------------------> < host-2 > 192.168.0.2
      |                 |    ssh 
      |                 |-----------------------> < host-N > 127.0.0.1
      |                 |
      +-----------------+


      +-------------+
      |             |
      | <host>      |
      |             |
      | {sparrow}   | 
      | {curl}      |
      |             |
      +-------------+

## Master host

Master host is the dedicated server where you push sparrow tasks execution on remote hosts.

Sparrowdo client should be installed at master host:

    $ panda install Sparrowdo

Sparrowdo acts over ssh installing sparrow [plugins](https://metacpan.org/pod/Sparrow#Plugins-API), applying configurations and running them as sparrow [tasks](https://metacpan.org/pod/Sparrow#Tasks-API).

A list of available sparrow plugins could be found here - [https://sparrowhub.org/search](https://sparrowhub.org/search).
Only [public](https://metacpan.org/pod/Sparrow#Public-plugins) sparrow plugins are supported for the current version of sparrowdo.


## Remote hosts

Remote hosts are configured by running sparrow client on them and executing sparrow tasks.

A Sparrow CPAN module, version >= 0.2.20 should be installed on remote hosts:

    $ cpanm Sparrow

A minimal none Perl dependencies also should be satisfied - `curl`, so sparrow could manage it's index files and
upload plugins. Eventually I will replace it by proper Perl module to reduce none Perl dependencies, but for now
it's not a big deal:

    $ yum install curl

# SSH/User setup

An assumption made that ssh user you run `sparrowdo` with ( see --ssh_user command line parameter also ):

* ssh passwordless access to remote hosts
* sudo (passwordless?) rights on remote host

Eventually I will make user/ssh related stuff configurable so one could run sparrowdo with various ssh configurations and
users.

# Advanced usage

## Running private plugins

You should use `set_spl(%hash)` function to set up private plugin index file:


    $ cat sparrowfile

    set_spl %(
        package-generic-dev => 'https://github.com/melezhik/package-generic.git',
        df-check-dev => 'https://github.com/melezhik/df-check.git'
    );
    
    task_run  %(
      task => 'install my packages',
      plugin => 'package-generic-dev',
      parameters => %( list => 'cpanminus git-core' )
    );

    task_run  %(
      task => 'check my disk',
      plugin => 'df-check-dev'
    );
    

# Sparrowdo client command line parameters

## --help

Prints brief usage info.

## --sparrowfile

Alternative location of sparrowfile. If `--sparrowfile` is not set a file named `sparrowfile` at CWD is looked.

    $ sparrowdo --sparrowfile=~/sparrowfiles/sparrowfile.pl6

## --http\_proxy

Sets http\_proxy environment variable on remote host.

## --https\_proxy

Sets https\_proxy environment variable on remote host.

## --ssh\_user

Sets user for ssh connection to remote host.

## --ssh\_private\_key

Selects a file from which the identity (private key) for public key authentication is read. 

Is equal to `ssh -i` parameter.

## --ssh\_port

Sets shh port for ssh connection to remote host. Default value is `22`.

## --no\_sudo

If set to true - do not initiate ssh command under `sudo`, just as is. Default value is false - use `sudo`.
Optional parameter.

## --no\_index\_update

If set to true - do not run `sparrow index update` command at the beginning`. This could be useful if you
are not going to update sparrow index to save time.

Optional parameter.

## --module\_run

Runs a sparrowdo module instead of executing tasks from sparrowfile. For example:


    $ sparrowdo --host=127.0.0.1 --module_run=Nginx


## --verbose

Sets verbose mode ( low level information will be printed at console ).


# Bootstrapping 

One may use `bootstrap` mode to install Sparrow on target host first:

    $ sparrowdo --host=192.168.0.0.1 --bootstrap

Currently only CentOS platform is supported for bootstrap operation. 

# Sparrowdo modules

Sparrowdo modules are collection of sparrow tasks. They are very similar to sparrow task boxes,
with some differences though:

* They are Perl6 modules.

* They implemented in terms of sparrowdo tasks ( relying on sparrowdo API ) rather then with sparrow tasks. 

An example of sparrowdo module:

    use v6;
    
    unit module Sparrowdo::Nginx;
    
    use Sparrowdo;

    our sub tasks (%args) {

      task_run  %(
        task => 'install nginx',
        plugin => 'package-generic',
        parameters => %( list => 'nginx' )
      );

      task_run  %(
        task => 'enable nginx',
        plugin => 'service',
        parameters => %( service => 'nginx', action => 'enable' )
      );

      task_run  %(
        task => 'start nginx',
        plugin => 'service',
        parameters => %( service => 'nginx', action => 'start' )
      );
  

    }
        

Later on, in your sparrowfile you may have this:


    $ cat sparrowfile

    module_run 'Nginx';

You may pass parameters to sparrowdo module:

    module_run 'Nginx', port => 80;

In module definition one access parameters as:

    our sub tasks (%args) {

        say %args<port>;

    }


A module naming convention is:

    Sparrowdo::Foo::Bar ---> module_run Foo::Bar

`module_run($module_name)` function loads  module Sparrowdo::$module_name at runtime and calls 
function `tasks` defined at module global context.


## Helper functions

Module developers could rely on some helper function, when creating their modules.

* `target_os()`

This function returns OS name for the target server.

For example:

    if target_os() ~~ m/centos/ {
    
      task_run  %(
        task => 'install epel-release',
        plugin => 'package-generic',
        parameters => %( list => 'epel-release' )
      );
    
    }
    

A list of OS names provided by `target_os()` function:

    centos5
    centos6
    centos7
    ubuntu
    debian

* `input_params($param)`

Input\_params function returns command line parameter one provides running sparrowdo client. 

For example:


    task_run  %(
      task => 'install great CPAN module',
      plugin => 'cpan-package',
      parameters => %( 
        list => 'Moose',
        http_proxy => input_params('HttpProxy'), 
        https_proxy => input_params('HttpsProxy'), 
      )
    );

This is the list of arguments valid for input\_params function:

    Host 
    HttpProxy 
    HttpsProxy 
    SshPort 
    SshUser 
    SshPrivateKey 
    Verbose
    NoSudo
    NoIndexUpdate

See also [sparrowdo client command line parameters](#sparrowdo-client-command-line-parameters) section.

# Scenarios configuration

There is no "magic" way to load configuration into sparrowdo scenarios. You are free to
choose any Perl6 modules to deal with configuration data. But if `config.pl6` file exists
at the current working directory it will be loaded via `EVALFILE` at the _beginning_ of
scenario. For example:


    $ cat config.pl6

    {
      user         => 'foo',
      install-base => '/opt/foo/bar'
    };

Later on in scenario you may access config data via `config` function:

    $ cat sparrowfile

    my $user         = config<user>;
    my $install-base = config<install-base>;
    
# AUTHOR

[Aleksei Melezhik](mailto:melezhik@gmail.com)

# Home page

[https://github.com/melezhik/sparrowdo](https://github.com/melezhik/sparrowdo)

# Copyright

Copyright 2015 Alexey Melezhik.

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

# See also

* [Sparrow](https://metacpan.org/pod/Sparrow) - Multipurpose scenarios manager.

* [SparrowHub](https://sparrowhub.org) - Central repository of sparrow plugins.

* [Outthentic](https://metacpan.org/pod/Outthentic) - Multipurpose scenarios devkit.

# Thanks

To God as the One Who inspires me to do my job!

