GitHub
===
Install github from the website

GitHub's vagrant issue
---

>When trying to push or pull github commits from inside vagrant, github spits back permission denied errors

Make sure you can ssh to github from your comp. Go to the [webpage](https://help.github.com/articles/generating-ssh-keys/) on github's docs.

Once you've followed the steps on that page make sure it runs on your comp.

```
rsnodgra$ ssh -T git@github.com
Hi RyanSnodgrass! You've successfully authenticated, but GitHub does not provide shell access.
```

Once you get your ssh going on your mac we need to see if it runs on our vagrant machine. It shouldn't because it doesn't have a SSH key. We can try inside vagrant and see that it denies us

```bash
[vagrant@localhost ~]$ ssh -T git@github.com
Warning: Permanently added the RSA host key for IP address '192.xx.xxx.xxx' to the list of known hosts.
Permission denied (publickey).
```

But we know from githubs documentation that we can check whether it has the keys or not. And we can even look in the folder to see if they're there.

```
[vagrant@localhost ~]$ cd ~/.ssh/
[vagrant@localhost .ssh]$ ls
authorized_keys  known_hosts
```
We can check that our agent id matches whats on the
```
[vagrant@localhost ~]$ eval `ssh-agent -s`
Agent pid 28679
[vagrant@localhost ~]$ env | grep SOCK
SSH_AUTH_SOCK=/tmp/ssh-WBtRY28682/agent.28682
```

Keep in mind that for all intents and purposes, the vagrant machine is its own unique machine. In our Vagrantfile we have it set up to pipe the SSH key automatically but that isn't happening.

What's happening is your keyring on vagrant doesn't have your ssh key from the mac. We need to forward to your vagrant machine. This only happens if:

1. We are forwarding the ssh key to vagrant
2. That key is on our key ring in the first place.

We know problem 1 is solved in our Vagrantfile
```ruby
  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  config.ssh.forward_agent = true
 ```
 
 So we just have to add the ssh key on our comp to our key ring

The solution:
```
rsnodgra$ ssh-add -l
The agent has no identities.

rsnodgra$ ssh-add ~/.ssh/id_rsa
Identity added: /Users/rsnodgra/.ssh/id_rsa (/Users/rsnodgra/.ssh/id_rsa)

rsnodgra$ ssh-add -l
2048 5c:b4:1a:f9:5a:sd:e2:35:4c:21:22:05:6c:ab:fc:91 /Users/rsnodgra/.ssh/id_rsa (RSA)
rsnodgra$ pwd
/Users/rsnodgra/IceCream/rails-default-box

rsnodgra$ vagrant ssh
Last login: Mon Dec  1 21:13:15 2014 from 10.0.2.2
Welcome to your Vagrant-built virtual machine.

[vagrant@localhost ~]$ ssh git@github.com
PTY allocation request failed on channel 0
Hi RyanSnodgrass! You've successfully authenticated, but GitHub does not provide shell access.
```
