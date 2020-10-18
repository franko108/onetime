
# Sending content on secure manner

Sending of sensitive data on secure way is more and more on demand. Emails are not secure and this is one alternative way of sending the data on a quite secure manner.  
There are already several similar services but somebody might need or want to have it within own organization or company in order to have a full control over the process. 

The concept is simple, enter data in a provided form, submit it and unique uuid will be generated for the link usage. The program will create a row in the database with generated uuid for link and content as data.  
On the get request of provided URL, data will be shown in the browser and deleted from database.

Demo is available internally on [onetime.it-pu.com](https://onetime.it-pu.com)

Program is build on Ruby/Padrino with Sqlite3 as a database. Haml is used template.   
GUI is inspired by [Padrino Ruby tutorial](https://github.com/padrino/blog-tutorial), thanks for that.

## Requirements

Installed ruby (min.version 2.2.2 for Pardino framework) and SQLite 3 as a database.    
At this time, recommended ruby version is 2.7.

On Ubuntu 20.04 required versions are available out of box with command:  
`$ sudo apt-get install ruby sqlite3`  

On Ubuntu 18.04 make sure to have installed required programs:  
`$ sudo apt install gcc make libc6-dev libsqlite3-dev sqlite3`

Optionally for a new Ruby version on Ubuntu there is command:  
`sudo snap install ruby`

On CentOS 7, newer version of Ruby shall be compiled. Install dependencies with command:  
`# yum install -y gcc-6 bzip2 openssl-devel sqlite-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel`

Grab Ruby source code from [here](https://www.ruby-lang.org/en/downloads/) , compile it and install according to instructions within README.

Install *Ruby Padrino* framework ([official web](http://padrinorb.com)):  
`$ gem install padrino` 

## Installation  

Clone this repo on desired location with:   
`$ git clone https://git.sonnenbatterie.de:infrastructure/onetime.git`

Install dependencies defined within *Gemfile*:  
`$ bundle`

Initialize the sqlite database:  
`$ padrino rake sq:migrate`

Fire the application with:  
`$ padrino s`

That's it. Embedded **WEBrick** web server is active on port 3000.

One will probably put some web server or proxy in a front, like nginx, haproxy or apache. Haproxy is particularly effective in protecting the application.  
If your proxy or web server is on another server, you may want to remove CSRF protection.  
Edit the file `config/apps.rb` and comment out line:  
`set :protect_from_csrf, true`

Tested on Ubuntu and on Centos with Ruby version 2.7. I didn't test it on Windows, however, it should work as well.

###  Optional - setup as a service

Padrino can be fired as a daemon: `padrino s -d`. 
 
Another (better) option is to arrange *systemd* to take care of application.  
Create file like `/etc/systemd/system/onetime.service` with a following content:  
```
[Unit]
Description=Onetime Ruby WEBrick
After=httpd.service

[Service]
User=username
Group=username
Type=simple
Restart=always
RestartSec=3
ExecStart=/usr/local/bin/ruby /path/to/onetime/bin/padrino s -e production -c=/path/to/onetime/

[Install]
WantedBy=multi-user.target
```

Replace */path/to/onetime* with absolute path to application and `httpd` with `nginx` or `haproxy` or whatever you have in front of the ruby application.  
In this example, privileges are given to a simple user. Systemd will try to restart application within 3 second if inactive. This is also an optional parameter.

If application is hosted on another server, make sure to listen all ports, not just a locahost. In that case, replace the line ExecStart with:  
`ExecStart=/usr/local/bin/ruby /path/to/onetime/bin/padrino s -e production -c=/path/to/onetime/ -h=0.0.0.0`

(replace *h=0.0.0.0* with IP of your proxy server, or leave it like that if there are more than one server that act as a proxy)

Also, configure a production environment within file **config/boot.rb**:  
`RACK_ENV = 'production'`

After that, a production database can be initialized with same command:  
`$ padrino rake sq:migrate`

Enable and start this service with:  
`$ systemctl enable onetime && systemctl start onetime`

**NOTE:**  Ruby WEBrick gives out very verbose output in development environment, in logs as well. Make sure to prepare application for production environment as in systemd example above. Otherwise, the whole "secret" and hiding values doesn't make much sense.

## Usage

Enter your "secret" word, password in a form, onetime link will be generated. Upon first get request there will be message to proceed toward one time shown content. Afterwards, message will be shown and at the same time deleted from database. 

## Status

The program is finished, it has all needed functionalities.  
One can consider implementing the captcha mechanism if application will have a public access. Padrino provides support for using it.
 
However, the unit tests are missing.

## License

*Onetime app* is licensed under the MIT License.
