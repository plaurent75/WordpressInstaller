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
echo "USERPATH (sera installé dans /home/USERPATH/www: "
	read -e folderpath

	if [ ! -d "/home/$folderpath/www" ]; then
		echo "/home/$folderpath/www ....ce dossier n'existe pas"
		echo "vous devez créer le dossier auparavant ...exiting"
		echo "================================================================="
		echo "FIn DU PROGRAMME .... ECHEC"
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
	if [ -d "/home/$folderpath/www" ]; then
		cd /home/$folderpath/www
	else
		echo "/home/$folderpath/www ....ce dossier n'existe pas"
		echo "vous devez créer le dossier auparavant ...exiting"
		echo "================================================================="
		echo "FIn DU PROGRAMME .... ECHEC"
		echo "================================================================="
		exit
	fi
#NETTOYAGE
rm index.html
echo "Repertoire WWW clean"

echo "téléchargement de wordpress...."
wp core download --locale=$wplang --force
wp core version
echo "création du wp-config.php ...."
wp core config --dbname=$dbname --dbuser=$dbuser --dbpass=$dbpass --extra-php <<PHP
define('AUTOSAVE_INTERVAL', 300 );
define('WP_POST_REVISIONS', false );
define( 'WP_AUTO_UPDATE_CORE', true );
define( 'WP_DEBUG', false );
PHP
echo "installation de wordpress en cours...."
wp core install --url=$wpurl --title="$wptitle" --admin_user=$wpuser --admin_email=$wpemail --admin_password=$wppassword
echo "Wordpress est en place"
echo "reset de wordpress....done"

# PARAMETRAGE GENERAL
echo "modification des options en cours"
wp option update blog_public 0
wp option update timezone_string Europe/Paris
wp option update date_format 'j F Y'
wp option update time_format 'G \h i \m\i\n'
echo "options wordpress en place"

# NETTOYAGE
echo "nettoyage en cours....."
wp post delete 1 --force # Article exemple - no trash. Comment is also deleted
wp post delete 2 --force # page exemple
wp plugin delete hello
wp theme delete twentytwelve
wp theme delete twentythirteen
wp theme delete twentyfourteen
wp widget delete $(wp widget list sidebar-1 --format=ids)
echo "grand nettoyage....fait"

#PLUGINS
echo "installation des plugins en cours ....."
wp plugin install akismet --activate
wp plugin install contact-form-7 --activate
wp plugin install cookie-law-info --activate
wp plugin install jetpack --activate
wp plugin install tablepress --activate
wp plugin install wordpress-seo --activate
wp plugin install really-simple-captcha --activate
echo "Plugins installés"

#Function Plugins supplémentaires
MorePlug()
{
	echo "Voulez-vous installer des plugins supplémentaires? (y/n)"
	read -e supplements
	if [ "$supplements" == y ] ; then

		echo "URL(lien direct vers le zip) ou slug Wordpress.org"
		read -e plugslug
		wp plugin install $plugslug --activate
		echo "$plugslug installé et activé"
		MorePlug
	else
		echo "tous vos plugins sont installés. Suite de la configuration de Wordpress"
	fi
}

MorePlug



# PARAMETRAGE PERMALIENS (avec modif du .htaccess)
wp rewrite structure "/%postname%/" --hard
wp rewrite flush --hard

#Give right to the user
echo "Changement des droits des fichiers"
chown -R $folderpath:users /home/$folderpath/www

echo "================================================================="
echo "Installation ok."
echo ""
echo "Username WP: $wpuser"
echo "Password WP: $wppassword"
echo "URL WP: $wpurl"
echo ""
echo "================================================================="

exit
fi
