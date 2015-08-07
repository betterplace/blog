---
layout: post
title: Provision runit with ansible
---

Recently we migrated our server provisioning from [chef](https://www.chef.io/) to [ansible](http://www.ansible.com/) and we wrote some ansible roles to run our services with [runit](http://smarden.org/runit/).

In this quickstart blog post, I want to show you how to use them to get started with runit. Please note that we're using CentOS 6.6 machines to provision to, and our Vagrant setup is built accordingly.

**1. Installation**

We usually use git submodules to put roles into one of our provisioning repos, one could of course use the [ansible-galaxy](http://docs.ansible.com/ansible/galaxy.html) command as well.


{% highlight sh %}
$ git submodule add https://github.com/betterplace/ansible-runit roles/runit
$ git submodule add https://github.com/betterplace/ansible-runit-structure roles/runit_structure
{% endhighlight %}

Your roles directory should look something like this now:

{% highlight sh %}
$ tree
…
|-- roles
|   |-- runit
|   |-- runit_structure
|   |-- nginx
{% endhighlight %}


**2. Add runit to your playbook**

In your playbooks you should now use the runit role. Let's assume you want to install and run `nginx`:

{% highlight yaml %}
# File: playbooks/webservers.yml
---
- hosts: webservers
  roles:
    - runit
    - nginx
{% endhighlight %}

and run your provisioning

{% highlight sh %}
$ ansible-playbook playbooks/webservers.yml
{% endhighlight %}


**3. Use runit for nginx**

Require the structure role as dependency

<div class='filename'>File: roles/nginx/meta/main.yml</div>
{% highlight yaml %}
---
dependencies:
  - { role: runit_structure, runit_name: 'nginx' }
{% endhighlight %}

Provision a runit run script

<div class='filename'>File: roles/nginx/tasks/main.yml</div>
{% highlight yaml %}
---
- name: Create runit run script
  template:
    src=run.j2
    dest=/etc/sv/nginx/run
    mode=0755
{% endhighlight %}

And add the run script template to use

<div class="filename">File: roles/nginx/templates/run.j2</div>
{% highlight sh %}
#!/bin/sh

exec 2>&1
exec /usr/sbin/nginx -c /etc/nginx/nginx.conf -g "daemon off;"

{% endhighlight %}

Provision again `$ ansible-playbook playbooks/webservers.yml` and your done: nginx is already running because runit noticed your run script and started it. From now on it'll keep your nginx up and running!
