#!/bin/bash
NOMBRE_CARPETA="SENSE"
EXISTE=0

for usuario in /home/*; do
    if [ -d "$usuario/$NOMBRE_CARPETA" ]; then
        EXISTE=1
        break
    fi
done

if [ $EXISTE -eq 1 ]; then
    echo "SENSE is already installed"
    exit 1
fi

Salir=0
while [ $Salir -eq 0 ]; do
    	echo "Are you sure you want to install SENSE (y/n)?"
    	read Respuesta
    	Respuesta=$(echo "$Respuesta" | tr 'A-Z' 'a-z')
    	if [[ "$Respuesta" == "y" || "$Respuesta" == "n" ]]; then
        	Salir=1
    	else
        	echo "Only y/n is allowed"
    	fi
done

if [ "$Respuesta" = "y" ]; then
    	echo "Creating folders..."
    	REPO_URL="https://github.com/nasratullahjabarkhil/Sense-OS-manual"
	WALLPAPER_URL="https://github.com/Diego-Santos-M/SENSE-PACKS.git"
    	for usuario in /home/*; do
        	CARPETA_USUARIO="$usuario/$NOMBRE_CARPETA"
        	WALLPAPER_CARPETA="$CARPETA_USUARIO/Wallpapers"
		ARCHIVOS_DEL_PROGRAMA="$CARPETA_USUARIO/Program_Files"
        	sudo mkdir -p "$CARPETA_USUARIO"
        	echo "Folder created in: $CARPETA_USUARIO"

		echo "Downloading files..."
        	while true; do
            		sudo git clone "$REPO_URL" "$CARPETA_USUARIO"
            		if [ -f "$CARPETA_USUARIO/index.html" ]; then
                		echo "Files downloaded in: $CARPETA_USUARIO"
                		break
            		else
                		sudo rm -rf "$CARPETA_USUARIO"
            		fi
        	done
		echo "Creating subfolders"
		sudo mkdir -p "$WALLPAPER_CARPETA"
		echo "Subfolder created"
		echo "Downloading images...."
		while true; do
                        sudo git clone "$WALLPAPER_URL" "$CARPETA_USUARIO/Wallpapers"
			ZIP_FILE=$(find "$CARPETA_USUARIO/Wallpapers" -name "*.zip" | head -n 1)

    			if [ -n "$ZIP_FILE" ]; then
        			sudo unzip -o "$ZIP_FILE" -d "$CARPETA_USUARIO/Wallpapers"
        			sudo rm "$ZIP_FILE"
    			fi

                        if [ -f "$CARPETA_USUARIO/Wallpapers/Wallpaper/Leonardo_Phoenix_09_Design_a_logo_for_SENSE_a_Unixbased_operat_3.jpg" ]; then
                                echo "Downloaded and decompressed images"
                                break
                        else
                                sudo rm -rf "$CARPETA_USUARIO/Wallpapers"
                        fi
                done
		echo "Creating more subfolders, giving them permissions and sorting the downloaded files"
		sudo mkdir -p "$ARCHIVOS_DEL_PROGRAMA"
		sudo touch "$ARCHIVOS_DEL_PROGRAMA/SHELL_HISTORY"
		sudo chmod 777 "$ARCHIVOS_DEL_PROGRAMA/SHELL_HISTORY"
		UNINSTALL="$CARPETA_USUARIO/Wallpapers/uninstall.sh"
		sudo mv "$UNINSTALL" "$ARCHIVOS_DEL_PROGRAMA/"
		COMMANDS="$CARPETA_USUARIO/Wallpapers/comandossc.sh"
		sudo mv "$COMMANDS" "$ARCHIVOS_DEL_PROGRAMA/"

		echo "The installation is almost finished..."
		echo "Creating aliases to facilitate the use of the system"
		ALIAS_CMD_SENSE="alias SENSE='bash $ARCHIVOS_DEL_PROGRAMA/comandossc.sh'"
		ALIAS_CMD="alias uninstall-sense='sudo bash $ARCHIVOS_DEL_PROGRAMA/uninstall.sh'"
        	if ! grep -Fxq "$ALIAS_CMD" /etc/bash.bashrc; then
            		echo "$ALIAS_CMD" | sudo tee -a /etc/bash.bashrc > /dev/null
		fi
		if ! grep -Fxq "$ALIAS_CMD_SENSE" /etc/bash.bashrc; then
    			echo "$ALIAS_CMD_SENSE" | sudo tee -a /etc/bash.bashrc > /dev/null
		fi
		echo "Aliases created"
		eval "$ALIAS_CMD_SENSE"
		eval "$ALIAS_CMD"
	done
	echo "Installation completed"
        echo "We recommend that you restart the console to ensure that the changes have been applied."
        echo "Enjoy SENSE "
elif [ "$Respuesta" = "n" ]; then
    	echo "Installation cancelled."
fi
