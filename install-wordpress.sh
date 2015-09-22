#!/bin/bash


echo "================================================================="
echo "WordPress Installer!!"
echo "By Patrice LAURENT"
echo "http://www.patricelaurent.net"
echo "================================================================="

#Thank you GUILLAUME for this method
#https://twitter.com/iKonenn
control_c(){
	echo -en "\n*** Ouch! Brutal Exiting :) ***\n"
exit $?
}

trap control_c SIGINT

# accept user input for the databse name
echo "INSTALLPATH (WP CLI WILL WORK IN INSTALLPATH like /home/folder/wwww without SLASH at the END ): "
read -e folderpath

if [ ! -d "$folderpath" ]; then
	echo "$folderpath ....This folder Does Not exist"
	echo "You must create this folder before ...exiting"
	echo "================================================================="
	echo "END of SCRIPT .... ERROR"
	echo "================================================================="

	exit
fi

# accept user input
echo "Database Name: "
read -e dbname

echo "Database User: "
read -e dbuser

echo "Database Password: "
read -e dbpass

echo "WP username: "
read -e wpuser

echo "WP email: "
read -e wpemail

echo "WP Password: "
read -e wppassword

echo "WP URL: "
read -e wpurl

# accept the name of our website
echo "Site Title: "
read -e wptitle

# accept the name of our website
echo "Language (e.g: fr_FR ): "
read -e wplang

# add a simple yes/no confirmation before we proceed
echo "Run Install? (y/n)"
read -e run
# if the user didn't say no, then go ahead an install
if [ "$run" == n ] ; then
	exit
else
	if [ -d "$folderpath" ]; then
		cd $folderpath
	else
		echo "$folderpath ....This folder Does Not exist"
		echo "You must create this folder before ...exiting"
		echo "================================================================="
		echo "END of SCRIPT .... ERROR"
		echo "================================================================="

		exit
	fi
#NETTOYAGE
rm index.html
echo "Directory WWW clean"

echo "Downloading wordpress...."
wp core download --locale=$wplang --force
wp core version
echo "creating wp-config.php ...."
wp core config --dbname=$dbname --dbuser=$dbuser --dbpass=$dbpass --extra-php <<PHP
define('AUTOSAVE_INTERVAL', 300 );
define('WP_POST_REVISIONS', false );
define( 'WP_AUTO_UPDATE_CORE', true );
define( 'WP_DEBUG', false );
PHP
echo "Wordpress install in progress...."
wp core install --url=$wpurl --title="$wptitle" --admin_user=$wpuser --admin_email=$wpemail --admin_password=$wppassword
echo "Wordpress Isntallation Done"
wp site empty
echo "reseting wordpress....done: wordpress is now empty"

# PARAMETRAGE GENERAL
echo "modification des options en cours"
wp option update blog_public 0
wp option update timezone_string Europe/Paris
wp option update date_format 'j F Y'
wp option update time_format 'G \h i \m\i\n'
echo "Wordpress options done"

# NETTOYAGE
echo "Cleaning in progress....."
wp post delete 1 --force # Article exemple - no trash. Comment is also deleted
wp post delete 2 --force # page exemple
wp plugin delete hello
wp theme delete twentytwelve
wp theme delete twentythirteen
wp theme delete twentyfourteen
wp widget delete $(wp widget list sidebar-1 --format=ids)
echo "done"

#PLUGINS
echo "Installing Plugins ....."
wp plugin install akismet --activate
wp plugin install contact-form-7 --activate
wp plugin install cookie-law-info --activate
wp plugin install jetpack --activate
wp plugin install tablepress --activate
wp plugin install wordpress-seo --activate
wp plugin install really-simple-captcha --activate
echo "Plugins installed"

#Function Plugins supplémentaires
MorePlug()
{
	echo "Would you like to install more plugin? (y/n)"
	read -e supplements
	if [ "$supplements" == y ] ; then

		echo "URL(Direct zip link) or slug from Wordpress.org"
		read -e plugslug
		wp plugin install $plugslug --activate
		echo "$plugslug installed and activated"
		MorePlug
	else
		echo "All plugins have been installed. Go to the news Step of Wordpress Easy Install"
	fi
}

MorePlug



# PARAMETRAGE PERMALIENS (avec modif du .htaccess)
wp rewrite structure "/%postname%/" --hard
wp rewrite flush --hard

#Give right to the user
echo "Do you want to Fix rights to your new install? (y/n)? :"
read -e fixrights
if [ "$fixrights" == y ] ; then

	echo "set user (username):"
	read -e userright
	if [ -n "$userright" ]; then

		echo "set group (generallys :users) :"
		read -e groupright
		if [ -n "$groupright" ]; then
			chown -R $userright:$groupright $migratepath
		fi
	fi

fi

echo "================================================================="
echo "Installation ok."
echo ""
echo "Username WP: $wpuser"
echo "Password WP: $wppassword"
echo "URL WP: $wpurl"
echo ""
echo "By Patrice LAURENT"
echo "http://www.patricelaurent.net"
echo "Have a nice day"
echo "================================================================="

exit
fi
