# Sparrowdo

Configuration management tool based on [sparrow](https://sparrowhub.org) plugins system.

# Build status

[![Build Status](https://travis-ci.org/melezhik/sparrowdo.svg)](https://travis-ci.org/melezhik/sparrowdo)

# Usage

## Getting started
If you're just looking to get started with Sparrowdo, check out [Tyil's
tutorial on
Sparrowdo](https://www.tyil.nl/tutorials/sparrowdo-getting-started/). This
covers the absolute basics, including getting Perl 6 to run on your machine,
installing Sparrowdo and getting your first scenario up and running.

## In depth usage guide

There are 3 essential things in Sparrowdo:

* [Core DSL](#core-dsl)
* [Plugins DSL](#plugins-dsl)
* [Modules](#sparrowdo-modules)


### Core DSL
Core DSL is probably the easiest way to start using Sparrowdo right away. It
offers some high level functions to deal with the most common configuration
tasks, like a creation of directories or users, populating configuration files
from templates or starting services.

    $ cat sparrowfile

    user 'zookeeper';

    group 'birds';

    directory '/var/data/avifauna/greetings/', %( owner => 'zookeeper' );

    file-create '/var/data/avifauna/greetings/sparrow.txt', %( 
        owner => 'zookeeper',
        group => 'birds', 
        mode  => '0644', 
        content => 'I am little but I am smart'
    );

    service-start 'nginx';

    package-install ('nano', 'ncdu', 'mc' );

Read the [core-dsl](/core-dsl.md) doc to get familiar with core-dsl functions
available in the current sparrowdo version.

### Plugins DSL

Under the hood the plugins DSL is just a "call"(\*) of some [sparrow
plugins](https://github.com/melezhik/sparrow#sparrow-plugins) with parameters.

Thus, if you want a direct access to sparrow plugins API you use the plugins
DSL.

Examples above could be rewritten in the terms of the low level plugins API: 

    $ cat sparrowfile

    task-run  %(
      task        => 'create zookeeper user',
      plugin      => 'user',
      parameters  => %( 
        action => 'create' , 
        name => 'zookeeper'
      )
    );

    task-run  %(
      task        => 'create birds group',
      plugin      => 'group',
      parameters  => %( 
        action => 'create' , 
        name => 'birds'
      )
    );

    # the following code will use the short form of running tasks - task-run($task_desc, $plugin_name, %parameters)

    task-run 'create greetings directory', 'directory', %( 
      action  => 'create' , 
      path    => '/var/data/avifauna/greetings',
      owner   => 'zookeeper'
    );


    task-run 'create sparrow greeting file', 'file', %(
      action      => 'create',
      target      => '/var/data/avifauna/greetings/sparrow.txt',
      owner       => 'zookeeper',
      group       => 'birds' 
      mode        => '0644',
      content     => 'I am little but I am smart'
    );

    task-run 'start nginx web server', 'service',  %(
      action      => 'start',
      service     => 'nginx'
    );

    task-run 'install some handy packages', 'package-generic', %( list  => 'nano ncdu mc' );

(\*) Not that accurate. Technically speaking plugins DSL functions just
*return* a JSON data to **serialize** sparrow plugins with its binded
parameters ( so called [sparrow
tasks](https://github.com/melezhik/sparrow#tasks) ) and after that the data is
copied ( by scp ) to the target host, where it is finally **executed** by
sparrow client.

Reasons you may prefer plugins DSL:

* Not every sparrow plugin has a *related* core DSL function ( see below ).
* Core DSL methods are just wrappers to generated the proper JSON data to "map"
  sparrow plugins with parameters, however such a mapping could be limited in
  comparison with *original* plugins API, for example you might not have access
  to the some plugin's input parameters and so on. Thus, if you want to hack
  into the plugin details, you will need low level plugins API.
* Anyway core DSL API is enough for the most common configuration management
  tasks.

## Core DSL vs Plugins DSL

Core DSL is a kinda high level adapter with addition of some "syntax sugar" to
make your code terse and effective.  It is also important that as the core DSL
methods are Perl6 functions, you take advantage of input parameters validation.
However core DSL is limited. **Not every sparrow plugin** has _related_ core
DSL method.

So it's up to you whether to use the core DSL or low level plugins API. 

Once I've found some sparrow plugin very common and highly useful I will the
proper core DSL binded to the plugin.  In case you need core DSL wrappers for
the new plugins - let me know!

[Here](/core-dsl.md) is the list of core DSL functions available in the current
Sparrowdo version.

# Running sparrowdo scenario

Now, once we've created a sparrowfile let's run the scenario on some remote
host:

    $ sparrowdo --host=192.168.0.1

# Schema

Here is the visual presentation of sparrowdo system design:

![sparrowdo system design](https://sparrowdo.files.wordpress.com/2017/01/sparrowdo-system.png)

## Master host

Master host is a dedicated server where you "push" sparrow tasks from for being
executed on remote hosts.

Sparrowdo client should be installed at the master host:

    $ zef install Sparrowdo

Sparrowdo acts over ssh invoking sparrow client with input json data generated
by.

Sparrow client in turn downloads and installs the
[plugins](https://metacpan.org/pod/Sparrow#Plugins-API) and create plugins
configuration - sparrow [tasks](https://metacpan.org/pod/Sparrow#Tasks-API).
Finally tasks are executed converging the server to desired configuration.

A list of available sparrow plugins could be found here -
[https://sparrowhub.org/search](https://sparrowhub.org/search).

## Remote hosts

Remote hosts are configured by sparrow client which sets up and executes
sparrow tasks.

Sparrow client have to be installed on the remote host.

    $ cpanm Sparrow

A minimal none Perl dependencies also should be satisfied - `curl` utility.
Sparrow manages its index files and upload plugins by using curl:

    $ yum install curl

It is possible to automate the process of sparrow client installation on the
remote host, see the bootstrap section for details. 

# SSH/User setup

An assumption is made that ssh user you run `sparrowdo` with ( see `--ssh_user`
command line parameter also ) has:

* ssh passwordless access on the remote host
* sudo (passwordless?) rights on remote host

***NOTE!***

You can use password authentication with --password command line parameter or (
more preferred ) via shell environment `SSHPASS`. See info for `--password`
parameter below.


# Advanced usage

## Running private plugins

You should use `set_spl(%hash)` function to set up the private plugins index
file:

    $ cat sparrowfile

    set_spl %(
        package-generic-dev => 'https://github.com/melezhik/package-generic.git',
        df-check-dev => 'https://github.com/melezhik/df-check.git'
    );

    task-run 'install my packages', 'package-generic-dev', %( list => 'cpanminus git-core' );

    task-run 'check my disk', 'df-check-dev';

# Sparrowdo client command line parameters

## --help

Prints brief usage info.

## --host

Sets the remote host's IP address or hostname. This is mandatory parameter.
Default value is `127.0.0.1`.

## --docker

Sets the name of running docker container, use this if you want to run sparrow
tasks against docker.


## --sparrowfile

Alternative location of sparrowfile. 

If `--sparrowfile` is not set, sparrowdo will look for the file named
`sparrowfile` in the current working directory.

    $ sparrowdo --sparrowfile=~/sparrowfiles/sparrowfile.pl6

## --http\_proxy

Sets http\_proxy environment variable on the remote host.

## --https\_proxy

Sets https\_proxy environment variable on the remote host.

## --ssh\_user

Sets user for the ssh connection to the remote host.

## --password

Your password for authentication to the remote host. Also you can use shell
environment variable `SSHPASS`, e.g:

    $ export SSHPASS=12345; sparrowdo ...

You must install `sshpass` to use this feature.

## --ssh\_private\_key

Selects the file from which the identity (private key) for public key
authentication is read. 

Is equal to `-i` parameter of ssh client.

## --ssh\_port

Sets ssh port for the ssh connection to remote host. Default value is `22`.

## --sparrow\_root

Sets alternative location for sparrow client root directory. Default value is
`/opt/sparrow`;

Optional parameter.

## --no\_sudo

If set to true - do not initiate ssh command under `sudo`, just as is. Default
value is false - use `sudo`.

Optional parameter.

## --check_syntax

If set to true - only compiles scenarios and don't run anything on the remote
host. Optional parameter.

## --no\_index\_update

If set to true - do not run `sparrow index update` command on the remote host.

This could be useful if you are not going to install new versions of sparrow
plugins on the remote host and want to save the time as index operation is
quite time consuming.

Optional parameter.

## --no\_color

If set to true - disable color output of sparrowdo client.

## --format

Sets format for reports. One of possible values:

* default
* concise
* production

Default value is `default`

Optional parameter.

## --purge\_cache

Remove temporary/cache files left by sparrow run. Set this parameter to `True`
if you want to keep this files, which might be useful when troubleshooting.

Default value is `True` ( remove cache files )

Optional parameter.

## --module\_run

Runs a sparrowdo module instead of executing scenario from sparrowfile. For
example:

    $ sparrowdo --host=127.0.0.1 --module_run=Nginx

You can use task_run notation to pass parameter to modules:

    --module_run=module-name@p1=v1,p2=v2,p3=v3 ...

Where `module-name` - module name. `p1, p2 ...` - module parameters (separated
by `,`) 

For example:

    $ sparrowdo --host=127.0.0.1 --module_run=Cpanm::GitHub@user=leejo,project=CGI.pm,branch=master

## --task\_run

Runs a sparrow plugin instead of executing scenario from a sparrowfile. 

For example:

    $ sparrowdo --host=127.0.0.1 --task_run=df-check

You can run multiple tasks (plugins) with parameters as well:

    --task_run=plg-name@p1=v1,p2=v2,... --task-run=plg-name@p1=v1,p2=v2,...

Where `plg-name` - plugin name. `p1, p2 ...` - plugins parameters (separated by
`,`) 

For example:

    $ sparrowdo --host=127.0.0.1 \
    --task_run=user@name=foo \
    --task_run=bash@command='id &&  pwd && uptime && ls -l && ps uax|grep nginx|grep -v grep',user=foo \
    --task_run=df-check@threshold=54

## --verbose

Sets a verbose mode ( low level information will be printed at console ).

## --repo

This option sets the custom sparrow repository for being used when sparrow runs
on the remote machine.

For example:

    --repo=192.168.0.2:4441

## --cwd

This option sets the current working directory for the process which executes
sparrow scenarios.

Optional, no default values.

## --vagrant

Export ssh configuration from vagrant host and run sparrowdo against it.

Examples:

    $ sparrowdo --vagrant # assuming we are in a working directory with Vagrantfile
                          # exporting ssh configuration for "current" vagrant machine

    $ sparrowdo --vagrant --vagrant_id=6951606  # exporting ssh configuration 
                                                # from vagrant machine with ID `6951606`

## --var

Set sparrowdo variables. 

Use `key=value` format to set variables. Variables defined at [configuration file](#scenarios-configuration)
are overridden by this command line values.

You can use multiple `--var` constructs:

    --var='color=red' --var='color=green' --var='color=blue'
  

# Run sparrowdo in local mode

In case you need to run sparrowdo on localhost add `--local_mode` flag and get
things done locally, not remotely:

    $ sparrowdo --local_mode

# Sparrowdo configuration via ini file

You may pass _some_ sparrowdo client options via ini files at ~/sparrowdo.ini.

Here is the list of available options:

* no_index_update
* verbose
* repo
* sparrowhub_api
* format

For example:

    [sparrowdo]
    no_index_update = 1
    verbose         = 1
    repo            = 192.168.0.2:4441
    format          = production

# Bootstrapping 

One may use `bootstrap` mode to install sparrow client on the remote host
first:

    $ sparrowdo --host=192.168.0.0.1 --bootstrap

**CAVEAT** 

The bootstrap feature is still experimental and poorly tested, I urge you not
to run bootstrap on production, valuable hosts.

# Sparrowdo modules

Sparrowdo modules are collections of sparrow tasks. 

They are very similar to the sparrow task boxes, with some differences though:

* They are Perl6 modules.
* They implemented in terms of sparrowdo tasks ( relying on sparrowdo API )
  rather then with sparrow tasks. 

An example of sparrowdo module:

    use v6;

    unit module Sparrowdo::Nginx;

    use Sparrowdo;

    our sub tasks (%args) {

      task-run 'install nginx', 'package-generic', %( list => 'nginx' );

      task-run 'enable nginx', 'service', %(
        service => 'nginx', 
        action => 'enable'
      );

      task-run task => 'start nginx', 'service', %( 
        service => 'nginx', 
        action => 'start' 
      );

    }


Later on, in your sparrowfile you may have this:

    $ cat sparrowfile

    module_run 'Nginx';

You may pass parameters to a sparrowdo module:

    module_run 'Nginx', port => 80;

In module's definition one access the parameters as:

    our sub tasks (%args) {

        say %args<port>;

    }


The module naming convention is:

    Sparrowdo::Foo::Bar ---> module_run Foo::Bar

`module_run($module_name)` function loads  module Sparrowdo::$module_name at
runtime and calls function `tasks` defined in the module's global context.


## Helper functions

Module developers could rely on some helper functions, when creating their
modules.

* `target_os()`

This function returns the remote server OS name.

For example:

    if target_os() ~~ m/centos/ {
      task-run 'install epel-release', 'package-generic', %( list => 'epel-release' );
    }
    

The list of OS names is provided by `target_os()` function:

    centos5
    centos6
    centos7
    ubuntu
    debian
    minoca
    archlinux
    alpine
    fedora
    amazon
    funtoo
    
* `target_hostname()`

This function returns the remote server hostname.

* `input_params($param)`

The input\_params function returns command line parameter one provides when run
sparrowdo client. 

For example:


    task-run  %('install Moose', 'cpan-package', %( 
      list => 'Moose',
      http_proxy => input_params('HttpProxy'), 
      https_proxy => input_params('HttpsProxy'), 
    );

This is the list of arguments valid for the input\_params function:

    Host 
    HttpProxy 
    HttpsProxy
    SparrowRoot 
    SshPort 
    SshUser 
    SshPrivateKey
    Repo 
    Verbose
    NoSudo
    NoColor
    PurgeCache
    NoIndexUpdate
    Cwd
    LocalMode
    SparrowhubApi
    Password

See also the [sparrowdo client command line parameters](#sparrowdo-client-command-line-parameters) section.

# Scenarios configuration

There is no "magic" way to load a configuration into sparrowdo scenarios. You
are free to choose any Perl6 modules you want to deal with a configuration
data. 

But if `config.pl6` file exists at the current working directory it _will be
loaded_ via `EVALFILE` at the _beginning_ of scenario. 

For example:


    $ cat config.pl6

    {
      user         => 'foo',
      install-base => '/opt/foo/bar'
    };

Later on in the scenario you may access config data via `config` function:

    $ cat sparrowfile

    my $user         = config<user>;
    my $install-base = config<install-base>;

See also [variables section](#--var).

# Environment variables 

* `SPARROWDO-DEBUG`

Enable some sparrowdo debug messages printed in a console.

* `OUTTHENTIC_FORMAT`

Sets format for reports, see also `--format` option of sparrowdo client.
    
# AUTHOR

[Aleksei Melezhik](mailto:melezhik@gmail.com)

# Home page

[https://github.com/melezhik/sparrowdo](https://github.com/melezhik/sparrowdo)

# Copyright

Copyright 2015 Alexey Melezhik.

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

# See also

* [Sparrow](https://metacpan.org/pod/Sparrow) - Multipurpose scenarios manager.
* [SparrowHub](https://sparrowhub.org) - Central repository of sparrow plugins.
* [Outthentic](https://metacpan.org/pod/Outthentic) - Multipurpose scenarios devkit.

# Thanks

To God as the One Who inspires me to do my job!

