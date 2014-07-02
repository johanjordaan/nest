nest
====

Node Example Site Template

This is a template project that includes all the things I need each time I strat a new project.

Site Features
=============
nginx
express
mongodb
coffeescript
less


Global Requirements (Those not in the generated package.json)
===================

sudo npm install coffee-script -g
sudo npm install grunt -g
sudo npm install bower -g 


Example usage:
==============
Lets say you want to create a new project called, mytest

* npm install nest
* nest init mytest
* cd mytest
* npm install
* bower install
* grunt run
* browse to localhost and log into the new site 

I then create a repo for this new site. I then develop locally until IO am happy. Then I check the project out on the server which will host it. I then run enable the site by executing the enable_site.

* enable_site/disable site 


A sample module named mytest (or whatever you called your site when you ran nest) will be created. Please feel free to have a look insite the modules. Also, in order to ann more modules to you project simplye add the new module to the app.coffee file.

