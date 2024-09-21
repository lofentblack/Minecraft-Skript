#!/bin/bash

# Gucken ob der Benutzer root ist
if [ "$(id -u)" != "0" ]; then
  echo $(tput setaf 1)Bitte wechseln Sie zu einem Admin/Root Benutzer$(tput sgr0)
  exit 1;
fi

# Hier das Verzeichniss eintragen wo der der Server insterliert werden soll!
ServerVerzeichniss="Server"
SCRIPTNAME="MC - Server"
LOCK=".lock-mc"

# Fehler Codes
FEHLER1="Diese Version enthält nicht gültige Zeichen! FehlerCode(01)"
FEHLER2="Fehler beim Inserieren. FehlerCode(02)"
FEHLER3="Server wurde nicht gestartet da die Start Datei nicht gefunden wurde. FehlerCode(03)"
FEHLER4="In dem Verzeichnis befinden sich bereits Datein. FehlerCode(04)"

content=$(wget https://raw.githubusercontent.com/lofentblack/Minecraft-Skript/refs/heads/main/version.txt -q -O -)
Version=$content

checkUpdate() {
content=$(wget https://raw.githubusercontent.com/lofentblack/Minecraft-Skript/refs/heads/main/version.txt -q -O -)
version=$content

# Eingabedatei
AnzahlZeilen=$(wc -l ${LOCK} | awk ' // { print $1; } ')
for LaufZeile in $(seq 1 ${AnzahlZeilen})
 do
  Zeile=$(sed -n "${LaufZeile}p" ${LOCK})
  Test=${Zeile}
	if [[ "$Test" == *"version"* ]]; then
		if [[ "$Test" == *"version"* ]]; then
		  var1=$(sed 's/version=//' <<< "$Test")
		  var2=$(sed 's/^.//;s/.$//' <<< "$var1")
		  SkriptVersion=$var2
		fi
	fi
done

if ! [[ $version == $SkriptVersion ]]; then
	sudo apt-get install wget -y
	clear
	clear

	echo $(tput setaf 3)"Update von Version "$SkriptVersion" zu "$version"."
	echo "$(tput sgr0)"
	wget https://raw.githubusercontent.com/lofentblack/Minecraft-Skript/refs/heads/main/Minecraft-Server-Skript.sh -O Minecraft-new.sh
	rm $LOCK
	chmod 775 Minecraft-Server-Skript.sh-new.sh
	rm Minecraft-Server-Skript.sh
	mv Minecraft-Server-Skript.sh-new.sh Minecraft-Server-Skript.sh

fi
}

checkUpdate

lofentblackDEScript() {

rot="$(tput setaf 1)"
gruen="$(tput setaf 2)"
gelb="$(tput setaf 3)"
dunkelblau="$(tput setaf 4)"
lila="$(tput setaf 5)"
turkies="$(tput setaf 6)"

# Notwendige Packete
installations_packete() {

apt-get install sudo -y
sudo apt-get update -y
sudo apt-get install screen -y

screen=instalations_packete_lb.de_script
screen -Sdm $screen apt-get install figlet -y && screen -Sdm $screen sudo apt-get upgrade -y

sleep 10

echo "Notwendige Pakete Installiert"

sleep 1

clear
clear
echo $gruen"Bitte starte das Script neu!"
echo "$(tput sgr0)"

}

LOGO() {
clear
clear

echo "$(tput setaf 2)"
figlet -f slant -c $SCRIPTNAME
echo $rot
echo "Mit dem Ausführen des Skripts Akzeptierst du der Lizenz von LofentBlack.de und die Minecraft Eula."
echo "$(tput sgr0)"
}

# Script Verzeichniss
	reldir=`dirname $0`
	cd $reldir
	SCRIPTPATH=`pwd`

clear
clear

 if [ -s $SCRIPTPATH/$LOCK ]; then
	echo "$(tput setaf 2)"
	figlet -f slant -c $SCRIPTNAME
	echo $rot
	echo "Mit dem Ausführen des Skripts Akzeptierst du der Lizenz von LofentBlack.de und die Minecraft Eula."
	echo "$(tput sgr0)"

	echo "1) Minecraft Server starten"
	echo "2) Minecraft Server stoppen"
	echo "3) Minecraft Server installieren(spigot)"
	echo "4) BungeeCord Server insterlieren"
	echo "5) Beenden"
    read -p "Was möchten Sie machen?: " machen

	if ! [ -z $machen ] && [ $machen == "1" ]; then
		LOGO
		read -p "Bitte geben die nun den Namen des Server an: " name1
		if [ -d $SCRIPTPATH/$ServerVerzeichniss/$name1 ]; then
			if [ -f $SCRIPTPATH/$ServerVerzeichniss/$name1/restart.sh ]; then
				LOGO
				cd $SCRIPTPATH/$ServerVerzeichniss/$name1/
				screen -Sdm name1 ./restart.sh
				echo "Server wurde gestartet"
				sleep 1
			else
				echo $FEHLER3
				sleep 4
			fi
			else
			echo "Das Verzeichnis Existiert nicht"
			sleep 3
		fi
	fi

	if ! [ -z $machen ] && [ $machen == "2" ]; then
		LOGO
		read -p "Bitte geben die nun den Namen des Servers an: " name
		if screen -list | grep -q "$name"; then
  			screen -S $name -X quit
			screen -wipe
			LOGO
			echo "Der Server $name wurde Erfolgreich Beendet"
		else
			LOGO
			echo "Der Server ist Offline oder Existiert nicht!"
		fi
	fi

	if ! [ -z $machen ] && [ $machen == "3" ]; then
		if ! [ -d $SCRIPTPATH/$ServerVerzeichniss/ ]; then
			sudo mkdir $SCRIPTPATH/$ServerVerzeichniss/
  		fi
		LOGO
		read -p "Bitte gebe Sie den Namen des neuen Servers ein (möglichst keine Sonderzeichen): " name

		if ! [ -d $SCRIPTPATH/$ServerVerzeichniss/$name ] || [ -z "$(ls -A $SCRIPTPATH/$ServerVerzeichniss/$name)" ]; then
			
			if [ -z $SCRIPTPATH/$ServerVerzeichniss/$name ]; then
				LOGO
			else
				LOGO
				sudo mkdir $SCRIPTPATH/$ServerVerzeichniss/$name
				echo "Das Verzeichnis" /$ServerVerzeichniss/$name "wurde erstellt"
			fi
			
			cd $SCRIPTPATH/$ServerVerzeichniss/$name
			echo ""
			echo "Geben Sie nun die Server Version an z. B. "'"1.8.8"'" oder "'"1.15"'""
			read -p "Welche Version soll der Server haben: " Version
			ungueltig=$(echo "$Version" | sed 's/[^0-9,.]//g')

			if [ $Version == "1.4.6" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.4.6-R0.4-SNAPSHOT.jar
				
				elif [ $Version == "1.4.7" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.4.7-R1.1-SNAPSHOT.jar
				
				elif [ $Version == "1.5.1" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.5.1-R0.1-SNAPSHOT.jar
				
				elif [ $Version == "1.5.2" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.5.2-R1.1-SNAPSHOT.jar
				
				elif [ $Version == "1.6.2" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.6.2-R1.1-SNAPSHOT.jar
				
				elif [ $Version == "1.6.4" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.6.4-R2.1-SNAPSHOT.jar
				
				elif [ $Version == "1.7.2" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.7.2-R0.4-SNAPSHOT-1339.jar
				
				elif [ $Version == "1.7.5" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.7.5-R0.1-SNAPSHOT-1387.jar
				
				elif [ $Version == "1.7.8" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.7.8-R0.1-SNAPSHOT.jar
				
				elif [ $Version == "1.7.9" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.7.9-R0.2-SNAPSHOT.jar
				
				elif [ $Version == "1.7.10" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.7.10-SNAPSHOT-b1657.jar
				
				elif [ $Version == "1.8.3" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.8.3-R0.1-SNAPSHOT-latest.jar
				
				elif [ $Version == "1.8.4" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.8.4-R0.1-SNAPSHOT-latest.jar
				
				elif [ $Version == "1.8.5" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.8.5-R0.1-SNAPSHOT-latest.jar
				
				elif [ $Version == "1.8.6" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.8.6-R0.1-SNAPSHOT-latest.jar
				
				elif [ $Version == "1.8.7" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.8.7-R0.1-SNAPSHOT-latest.jar
				
				elif [ $Version == "1.8.8" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.8.8-R0.1-SNAPSHOT-latest.jar
				
				elif [ $Version == "1.9.2" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.9.2-R0.1-SNAPSHOT-latest.jar
				
				elif [ $Version == "1.9.4" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.9.4-R0.1-SNAPSHOT-latest.jar
				
				elif [ $Version == "1.10" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.10-R0.1-SNAPSHOT-latest.jar
				
				elif [ $Version == "1.10" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.10.2-R0.1-SNAPSHOT-latest.jar
				
				elif [ $Version == "1.10.2" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.10.2-R0.1-SNAPSHOT-latest.jar
				
				elif [ $Version == "1.11" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.11.jar
				
				elif [ $Version == "1.11.1" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.11.1.jar
				
				elif [ $Version == "1.11.2" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.11.2.jar
				
				elif [ $Version == "1.12" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.12.jar
				
				elif [ $Version == "1.12.1" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.12.1.jar
				
				elif [ $Version == "1.12.2" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.12.2.jar
				
				elif [ $Version == "1.13" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.13.jar
				
				elif [ $Version == "1.13.1" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.13.1.jar
				
				elif [ $Version == "1.13.2" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.13.2.jar
				
				elif [ $Version == "1.14" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.14.jar
				
				elif [ $Version == "1.14" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.14.jar
				
				elif [ $Version == "1.14.1" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.14.1.jar
				
				elif [ $Version == "1.14.2" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.14.2.jar
				
				elif [ $Version == "1.14.3" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.14.3.jar
				
				elif [ $Version == "1.14.4" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.14.4.jar
				
				elif [ $Version == "1.15" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.15.jar
				
				elif [ $Version == "1.15.1" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.15.1.jar
				
				elif [ $Version == "1.15.2" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-8-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.15.2.jar
				
				elif [ $Version == "1.16.1" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-15-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.16.1.jar
				
				elif [ $Version == "1.16.2" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-15-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.16.2.jar
				
				elif [ $Version == "1.16.3" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-15-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.16.3.jar
				
				elif [ $Version == "1.16.4" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-15-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.16.4.jar
				
				elif [ $Version == "1.16.5" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-15-jdk -y
				wget https://cdn.getbukkit.org/spigot/spigot-1.16.5.jar
				
				elif ! [ "$ungueltig" == "" ]; then
				screen -Sdm $screen sudo apt-get install openjdk-15-jdk -y
				wget https://download.getbukkit.org/spigot/spigot-$Version.jar
			else
				LOGO
				echo $FEHLER1
				exit 1;
			fi

			clear

			cd $SCRIPTPATH/$ServerVerzeichniss/$name
			> start.sh
			> restart.sh
			> eula.txt
			if [ -s spigot*.jar ]; then
				if ! [ spigot*.jar == spigot-$Version.jar ]; then
					mv spigot*.jar spigot-$Version.jar
				fi
			else
				echo $FEHLER2
				exit 1;
			fi

			MinimalScript() {
			read -p "Wie viel GB RAM soll der Server minimal haben: " Minimal
			if [ $Minimal -ge 1 ]; then

				echo Minimal = $Minimal

			else
			
				clear
				clear
				echo "Zahl darf nicht kleiner als 1 sein oder Buchstaben/Sonderzeichen enthalten!"

			MinimalScript

			fi
			}
			MinimalScript


			MaximalScript() {
			read -p "Wie viel GB RAM soll der Server maximal haben: " Maximal
			if [ $Maximal -ge $Minimal ]; then

				echo Maximal = $Maximal

			else

				clear
				clear
				echo Zahl darf nicht kleiner als $Minimal sein oder Buchstaben/Sonderzeichen Enthalten!

			MaximalScript

			fi
			}
			MaximalScript

			echo "screen -S "$name" ./restart.sh" > $SCRIPTPATH/$ServerVerzeichniss/$name/start.sh
			echo -e "#!/bin/sh\nwhile true\ndo\njava "-Xms"$Minimal"G -Xmx"$Maximal"G" -jar spigot-"$Version".jar nogui\necho "Wenn Sie den Server komplett stoppen wollen druecken Sie, Strg + C bevor die Zeit ablauft"\necho "Neustart in:"\nfor i in 5 4 3 2 1\ndo\necho "'$i...'"\nsleep 1\ndone\necho "Neustart Jetzt!"\ndone" > $SCRIPTPATH/$ServerVerzeichniss/$name/restart.sh

			date=`date`

			echo -e "#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).\n#"$date"\neula=true" > $SCRIPTPATH/$ServerVerzeichniss/$name/eula.txt

			chmod +x $SCRIPTPATH/$ServerVerzeichniss/$name/start.sh
			chmod +x $SCRIPTPATH/$ServerVerzeichniss/$name/restart.sh
			
			
			
			if [ $Maximal -ge 4 ]; then
				Empfohlen_Spieler="10+"
			elif [ $Maximal -le 3 ]; then
				if [ $Maximal -le 1 ]; then
					Empfohlen_Spieler="1-4"
				else
					Empfohlen_Spieler="5-10"
				fi
			else
				Empfohlen_Spieler="Null"
			fi

			clear
			clear
			
			echo "--- Information zum erstellten Server ---"
			echo ""
			echo Screen-name: $name
			echo Verzeichniss: $SCRIPTPATH/$ServerVerzeichniss/$name

			echo "Minecraft-version: $Version"

			echo "Minimal RAM: "$Minimal"G"
			echo "Maximal RAM: "$Maximal"G"
			echo "Empfohlen Spieler zahl: "${Empfohlen_Spieler}

			echo ""
			echo "--- Information zum erstellten Server ---"
			echo ""

			read -p "Soll der Server gestartet werden (Y/N): " server
			if [ $server = "y" ] || [ $server = "Y" ] || [ $server = "J" ] || [ $server = "j" ] || [ $server = "ja" ] || [ $server = "Ja" ] || [ $server = "Yes" ] || [ $server = "yes" ] || [ $server = "ok" ] || [ $server = "Ok" ] || [ $server = "OK" ] || [ $server = "oK" ] || [ $server = "JA" ] || [ $server = "jA" ] || [ $server = "YES" ] || [ $server = "YEs" ] || [ $server = "yES" ] || [ $server = "yeS" ] || [ $server = "YeS" ] || [ $server = "yES" ] || [ $server = "yEs" ]; then
				cd /$SCRIPTPATH/$ServerVerzeichniss/$name/ && screen -Sdm $name ./restart.sh
				echo "Server gestartet!"

			else
				echo "Server nicht gestartet"
			fi
				cd $SCRIPTPATH
			else
				$FEHLER4
			fi
		fi

		if ! [ -z $machen ] && [ $machen == "4" ]; then
			if ! [ -d $SCRIPTPATH/$ServerVerzeichniss/ ]; then
				sudo mkdir $SCRIPTPATH/$ServerVerzeichniss/
  			fi
			LOGO
			read -p "Bitte gebe Sie den Namen des neuen BungeeCord Server ein (möglichst keine Sonderzeichen): " name

			if ! [ -d $SCRIPTPATH/$ServerVerzeichniss/$name ]; then

				sudo mkdir $SCRIPTPATH/$ServerVerzeichniss/$name
				echo "Das Verzeichnis" /$ServerVerzeichniss/$name "wurde erstellt"
				echo ""

				cd $SCRIPTPATH/$ServerVerzeichniss/$name
				wget https://ci.md-5.net/job/BungeeCord/lastSuccessfulBuild/artifact/bootstrap/target/BungeeCord.jar
				clear

				> start.sh
				> restart.sh
				> eula.txt
				MinimalScript() {
				read -p "Wie viel GB RAM soll der BungeeCord Server minimal haben: " Minimal
				if [ $Minimal -ge 1 ]; then

					echo Minimal = $Minimal

				else
				
					clear
					clear
					echo "Zahl darf nicht kleiner als 1 sein oder Buchstaben/Sonderzeichen enthalten!"

				MinimalScript

				fi
				}
				MinimalScript


				MaximalScript() {
				read -p "Wie viel GB RAM soll der BungeeCord Server maximal haben: " Maximal
				if [ $Maximal -ge $Minimal ]; then

					echo Maximal = $Maximal

				else

				echo Zahl darf nicht kleiner als $Minimal sein oder Buchstaben/Sonderzeichen Enthalten!

				clear
				clear
				MaximalScript

				fi
				}
				MaximalScript

				echo "screen -S "$name" ./restart.sh" > $SCRIPTPATH/$ServerVerzeichniss/$name/start.sh
				echo -e "#!/bin/sh\nwhile true\ndo\njava "-Xms"$Minimal"G -Xmx"$Maximal"G" -jar BungeeCord.jar nogui\necho "Wenn Sie den BungeeCord Server komplett stoppen wollen druecken Sie, Strg + C bevor die Zeit ablauft"\necho "Neustart in:"\nfor i in 5 4 3 2 1\ndo\necho "'$i...'"\nsleep 1\ndone\necho "Neustart Jetzt!"\ndone" > $SCRIPTPATH/$ServerVerzeichniss/$name/restart.sh
				
				date=`date`

				echo -e "#By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula).\n#"$date"\neula=true" > $SCRIPTPATH/$ServerVerzeichniss/$name/eula.txt


				chmod +x $SCRIPTPATH/$ServerVerzeichniss/$name/start.sh
				chmod +x $SCRIPTPATH/$ServerVerzeichniss/$name/restart.sh

				clear
				clear
				echo "--- Information zum erstellten BungeeCord Server ---"
				echo ""
				echo Screen-name: $name
				echo Verzeichniss: $SCRIPTPATH/$ServerVerzeichniss/$name

				echo "Minecraft-version: BungeeCord Server"

				echo "Minimal RAM: "$Minimal"G"
				echo "Maximal RAM: "$Maximal"G"

				echo ""
				echo "--- Information zum erstellten BungeeCord Server ---"
				echo ""

				read -p "Soll der BungeeCord Server gestartet werden (Y/N): " server
				if [ $server = "y" ] || [ $server = "Y" ] || [ $server = "J" ] || [ $server = "j" ] || [ $server = "ja" ] || [ $server = "Ja" ] || [ $server = "Yes" ] || [ $server = "yes" ] || [ $server = "ok" ] || [ $server = "Ok" ] || [ $server = "OK" ] || [ $server = "oK" ] || [ $server = "JA" ] || [ $server = "jA" ] || [ $server = "YES" ] || [ $server = "YEs" ] || [ $server = "yES" ] || [ $server = "yeS" ] || [ $server = "YeS" ] || [ $server = "yES" ] || [ $server = "yEs" ]; then
					cd /$SCRIPTPATH/$ServerVerzeichniss/$name/ && screen -Sdm $name ./restart.sh
					echo "BungeeCord Server gestartet!"
				else
					echo "BungeeCord Server nicht gestartet"
				fi
			cd $SCRIPTPATH
			else
				echo "Das Verzeichnis existiert bereits!"
				echo ""
			fi
		fi
		
		
		if [ -z $machen ]; then
				echo "Keine Zahl erkannt"
		fi
		if [[ $machen =~ ^[a-z,A-Z]+$ ]];then
			echo "Bitte benutze keine buchstaben"
		fi


	elif ! [ -s $SCRIPTPATH/$LOCK ]; then
    > $LOCK
    echo -e 'int=true\nversion="'$Version'"\n\n#Mit dieser Datei erkennt das Skript das alle notwendigen Pakete installiert worden sind.' > $SCRIPTPATH/$LOCK
    installations_packete
fi


}
lofentblackDEScript
