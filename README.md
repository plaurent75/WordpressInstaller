# WordpressInstaller
A wordpress installer for OVH Release 3 (but should work on other linux distrib whith a few small modifications)

## Required
1. WP CLI installed (SEE : HOW-TO : Install WP-CLI in less than 1 minut : http://www.patricelaurent.net/installer-wp-cli-wordpress-en-ligne-de-commande/)
2. Create alias for this script : alias wpinstall="/USERFOLDER/install-wordpress.sh" then source ~/.bashrc

Simple script to install a new Wordpress Site with Your usual Plugins.
Also include a step by step prompt to add your plugins from Wordpress Repository or from a zip file

After added to your source profile, just run wpinstall in your terminal

Follow the steps and the prompte (asking you DB password, DB user, DB Name, WP USERNAME, WP USER PASSWORd WP USER MAIL, WP URL, WP Site TITLE and finally, Server USER for the Folder Rights.

If you want to add Plugins, just answer Y when asking. Then Copy/past the Plugin SLUG or the url to the zip file.
You can add as many plugin you want like this.
When done, just answer N to the questions "Would You Like To Install others plugins".

## Jobs done by the script :

1. Download latest Wordpress release in the selected language
2. Configure and create wp-config.php
3. Install Wordpress (files and Database)
4. Delete automatic post and page create by the default wordpress install
5. Delete Hello Plugin (who relally need it ?)
6. Free widget's Sidebar
7. Delete Some Worpdress Theme
8. Install Plugins in your Plugins lists
9. Ask you if you need to install More plugins
10. Rewrite permalink to /%postname%/
11. Set good rights for the folder, as the script was probably ran as ROOT
 
##That's all. With only one simple command.

More details to come at http://www.patricelaurent.net
