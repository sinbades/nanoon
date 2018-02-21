# nanoon

The aim of this project is to experiment ways to install/remove/re-install/upgrade servers, this is useful to reduce dependency to companies who harvest data.
Tested only on debian, but should work on any linux distribution and even Windows and OSX with a bit of effort.

#### State of the project:
This is currently a work in progress project. You can expect to run all with one command and configure most of the servers without too many problems.
This project is for server administrator willing to build a collection of privacy server and keep them running for them, family or friends.

#### Knowledge you need to use this project:
You need basic terminal usage knowledge to start the installation.
You need a good terminal usage knowledge to fix issues and make sure everything runs fine.
You need to know how each server logic works to make the right configurations.

*************containers list with pack and link ******************

#### Why use nanoon:
If you want to install many servers on the same machine but you like to not do extreme efforts.

#### How it works:
This project use many docker images to make services accessible from anywhere. All dockers are sorted by "pack". All dockers communicate on the internet via https.

#### What do you get with this project:
- More control other your own data (import/export - change your service provider at will - Only you and the administrator can access your data)
- Ability to reduce by a lot your dependency to big companies (less tracking, less ads, better battery life, your data are not shared secretly between private companies and governments)

#### Recommended hardware:
My test machine is a 4 core atom n3700 with 8go of ram. I found the machine too weak to run all easily I would recommend a much powerful 4 core processor.
This is of course while running all the servers at once, if you remove heavy ones you can use a weaker machine.
CPU : core i5 2500k, i3 8100, ryzen 3 2200g.
RAM : 16go.
DISK : one 128 SSD for servers, 1 large HDD for data.
Internet : Fastest internet you can get. I would recommend fiber(FFTH) if you plan to send data to other users, upload becomes critical. A 100/50 connection might not be enough if you have many users.
Router: If you self host you need to open port 80 and 443. (1194 for openvpn, 22222 for git ssh, 22000 for syncthing)

#### Requirements:
Dependencies : linux x64, docker-ce, docker-compose, wget, git
Get a valid domain name that points to your installation ip address

#### How to use this:
git clone ****** 
cd nanoon
open install.sh with your favourite text editor(nano, vim, textEditor...) and adapt filesdir, configdir and letencrypt email.
sudo ./install.sh
access your server at serveradress:port(use docker ps -a to know your service port) or https://service.yourdomain.extension (check install.sh to know your service name)

#### What works so far:
Installation : install dependencies then run install.sh
Removal: not done. Use docker to clean all containers and images then remove install and config directories. (commands are easy to find online)
Reinstall: not done. Import you save data in the correct configuration directory. (worked several times for me)
Upgrade: automatic using docker watchtower image.

#### Usage issues:
- You have to enter each server and configure to your likes, it is a time-consuming task if you want to understand all the servers.
- Upgrade issue with nextcloud : 
	-cron might disapear and nginx-nextcloud can lead to nowhere. You have to install.sh again to fix this.
        -nextcloud disable all apps on update. You have to enter each section to enable your app one by one. Only one app can be enable at once and there is no "queue".
- I have not set-up containers to send mail, this is untested

#### Where will it go:
I plan to add more containers depending for my own needs.
 - In testing:
   - mastodon
   - diaspora
   - hardware/mailserver
   - playmaker
 - Waiting for a proper image:
   - retroarch web player
   - peertube
I plan to test only servers with mail integration I consider necessary. 
I also plan to use the same machine as a linux htpc gaming, VFIO is my next goal.

#### Deep issues I will not fix :
Administrator has complete control over anything on the server. Trust goes from big companies to the administrator.

Inspiration comes from my own life experience plus initiatives like Framasoft, Yunohost and people like Edward Snowden.
Thanks to all the containers maintainers, all the programs used for this project.
