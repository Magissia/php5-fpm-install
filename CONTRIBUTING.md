Contributing to php5-fpm install
--------------------------

This script is open source and is intended to help people slot a PHP5 version alongside their repo version.

Scripts must use tools available by default in supported distros.
Currently supported distros are :
* ArchLinux using systemd
* Debian using systemd

You may add support for a new distro while keeping the current way of working the script has.
This script is intended for unintended use, if you have to babysit it, this is a faillure.

Contributors should follow the following process:

1. Create your Github account, if you do not have one already.
2. Fork the project to your Github account.
3. Clone your fork to your local machine.
4. Create a branch in your local clone for your changes.
5. Change the files in your branch.
6. Push your changed branch to your fork in your Github account.
7. Create a pull request for your changes on the project. Be sure to do things the way the distro you are working on do things. If you need help to make a pull request, read the [Github help page about creating pull requests][1].
8. Wait for one of the project maintainer either to include your change in the codebase, or to comment on possible improvements you should make to your code.


[1]: https://help.github.com/articles/using-pull-requests
