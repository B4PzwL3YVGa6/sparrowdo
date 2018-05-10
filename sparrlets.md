# Sparrlets


Sparrlets are Git based Sparrowdo scenarios.


# How it works?

1. Create a sparrow scenario

```
    $ nano sparrowfile
      my $name  = config<name>;
      bash "echo Hi $name, I am Sparrlet"
```
    
2. Commit your code to Git 

```
    $ git init .
    $ git add sparrowfile
    $ git commit -a -m 'my Sparrlet'
```

3. Push you code

```
    $ git remote add origin https://github.com/melezhik/sparrlet-example.git
    $ git push origin master
```

4. Run sparrlet

```
    $ sparrowdo --git=https://github.com/melezhik/sparrlet-example.git
```

# Sparrlet configuration

  
Create config.pl6 file in $CWD directory and it will be copied into sparrlet environment during execution

```
    $ nano config.pl6

    {
      name => "Alexey"
    }

```

```
    $ sparrowdo --git=https://github.com/melezhik/sparrlet-example.git

```

# Caveats

* You need to install edge version of Sparrowdo ( `zef install https://github.com/melezhik/sparrowdo.git` ) to start playing with sparrlets

* Sparrlets are alpha feature, don't blame me if something goes awry :)), but I promise to response to GH issues :))
