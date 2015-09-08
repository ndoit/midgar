Starting Your BI Portal
===

Make sure that you have VirtualBox, Vagrant, wget, and can ssh to github on your machine:

  * https://www.virtualbox.org/
  * https://www.vagrantup.com/
  * https://help.github.com/articles/generating-ssh-keys/
  * http://brew.sh/ `brew install wget`

# Walkthrough
---
1. `git clone git@github.com:ndoit/midgar.git`
2. `cd midgar`
3. `sh midgar_setup.sh`
4. `vagrant ssh`
5. `[vagrant@localhost ~]$ cd /vagrant`
6. `[vagrant@localhost vagrant]$ sh keys.sh`  You will need the keys for these

That's it! Your environment is now ready to develop Rails applications. Fenrir is NOT running yet though.

To visit fenrir - start your dev neo4j server: type in your vagrant machine `neos`. Then restart your services:
```
[vagrant@localhost ~]$ neos
# Restart your services
[vagrant@localhost ~]$ cd /vagrant
[vagrant@localhost vagrant]$ sh restart_services.sh
```
You should now be able to visit localhost:4443

### Things to keep in mind
There are 2 running instances of Neo4j databases. A regular Dev running on port 7474 and a Test running on 7475. I've created short cut alias commands to start and stop the databases.

`neos` - starts the dev DB  
`neop` - stops the dev DB  
`teos` - starts the Test DB  
`teop` - stops the Test DB  

Lingo:
the '**t**est' database starts with 't'. the dev (or **n**eo4j) database starts with 'n'.
to **s**tart either database- end with 's'.
to sto**p** either database- end with 'p'.

In case you wanted to know what the actual commands that are running  
`neos` - `sudo /usr/local/share/neo4j/bin/neo4j start`  
`neop` - `sudo /usr/local/share/neo4j/bin/neo4j stop`  
`teos` - `sudo /test_neo4j/neo4j/bin/neo4j start`  
`teop` - `sudo /test_neo4j/neo4j/bin/neo4j stop`  

In addition, you can string the 2 together
`neop && teos` - stop Dev, start Test
or
`teop && neos` - stop Test, start Dev

---
BOTH DATABASES CANNOT RUN AT THE SAME TIME. If you are getting localhost:7474 connetion errors, you probably aren't running the right database.

In addition to these errors, sometimes you might be getting goofy errors that shouldn't. Sometimes it's worth it to stop all databases with `teop` and then `neop`. Then check that there aren't any stray processes with `ps aux | grep java`. this will print out a list of processes running on vagrant with java. Keep in mind, elastic search uses this too but, if you see a neo4j instance running, you can take that process # and kill it with `sudo kill -9 1234567`

### YOU DON'T EXIST
YOU AREN'T REAL! OH NO!

no just kidding, you've probably noticed that you're logged in on the portal as a 'nonexistant user' at first. This is true, you probably are not in the database yet. make sure the dev DB is running, and go to the rails console and create yourself.
```
[vagrant@localhost ~]$ cd /vagrant/fenrir/
[vagrant@localhost fenrir]$ neos
...
[vagrant@localhost fenrir]$ rails c
Loading development environment (Rails 4.0.2)
2.0.0-p353 :001 > User.create(net_id: 'yournetidhere', admin: true)
 => #<User admin: nil, net_id: "yournetidhere">
```

### Rspec Testing
the test evnironment is actually called `rspec`. To run the rspec tests, the test DB must be running. 
```
[vagrant@localhost ~]$ neop && teos
...
[vagrant@localhost ~]$ cd /vagrant/fenrir/
[vagrant@localhost fenrir]$ rspec
Run options: include {:focus=>true}

All examples were filtered out; ignoring {:focus=>true}
.....
```

and hopefully you should see green dots flying by!

> Because the rspec environment runs on a different database, if you ever want to manipulate the test environment in the console, you have to call the console with that environment with `rails c rspec`

### Github
Don't commit anything to github until you can ssh from within vagrant and define your credentials. Vagrant's default user is 'vagrant' and all your commits by default go to him. Actually, you're going to be logged in as me `Ryan Snodgrass`. I appreciate all the hard work you would do on my behalf, but you might want your commits to go to yourself.

To fix this follow the directions on github for [username](https://help.github.com/articles/setting-your-username-in-git/) and [email](https://help.github.com/articles/setting-your-email-in-git/)

You should be able to ssh from github automatically once you tell it to. type:
```
vagrant@localhost ~]$ ssh -T git@github.com
Hi RyanSnodgrass! You've successfully authenticated, but GitHub does not provide shell access.
```

If it does not and gives you `PermissionDenied Public Key` errors, checkout this [walkthrough](https://github.com/ndoit/midgar/blob/master/PermissionDeniedPublicKey.md) I created on fixing it. Before you look at that, make sure you can SSH to github from your local machine.

### browser connectivity issues
In order for the browser to be able to hit localhost:4443, that restart_services.sh script must be run atleast once per session. It has a couple of commands in it that shuts down a couple of security features, opens ports, then starts unicorn and nginx. In order for unicorn to start properly, the neo4j dev server must be running with `teop && neos`.
