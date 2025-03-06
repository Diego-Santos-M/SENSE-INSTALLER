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
    echo "SENSE ya esta instalado"
    exit 1
fi

Salir=0
while [ $Salir -eq 0 ]; do
    	echo "¿Estás seguro que quieres instalar SENSE? (si/no)"
    	read Respuesta
    	Respuesta=$(echo "$Respuesta" | tr 'A-Z' 'a-z')  # Convertir a minúsculas
    	if [[ "$Respuesta" == "si" || "$Respuesta" == "no" ]]; then
        	Salir=1
    	else
        	echo "Solo se admite si/no"
    	fi
done

if [ "$Respuesta" = "si" ]; then
    	echo "Creando carpetas..."
    	REPO_URL="https://github.com/nasratullahjabarkhil/Sense-OS-manual"
	WALLPAPER_URL="https://github.com/Diego-Santos-M/SENSE-PACKS.git"
    	for usuario in /home/*; do
        	CARPETA_USUARIO="$usuario/$NOMBRE_CARPETA"
        	WALLPAPER_CARPETA="$CARPETA_USUARIO/Wallpapers"
		ARCHIVOS_DEL_PROGRAMA="$CARPETA_USUARIO/Program_Files"
        	mkdir -p "$CARPETA_USUARIO"
        	echo "Carpeta creada en: $CARPETA_USUARIO"

        	while true; do
            		git clone "$REPO_URL" "$CARPETA_USUARIO"
            		if [ -f "$CARPETA_USUARIO/index.html" ]; then
                		echo "Repositorio clonado en: $CARPETA_USUARIO"
                		break
            		else
                		rm -rf "$CARPETA_USUARIO"
            		fi
        	done
		mkdir -p "$WALLPAPER_CARPETA"
		echo "Subcarpeta Wallpapers creada"
		while true; do
                        git clone "$WALLPAPER_URL" "$CARPETA_USUARIO/Wallpapers"
			ZIP_FILE=$(find "$CARPETA_USUARIO/Wallpapers" -name "*.zip" | head -n 1)

    			if [ -n "$ZIP_FILE" ]; then
        			unzip -o "$ZIP_FILE" -d "$CARPETA_USUARIO/Wallpapers"
        			rm "$ZIP_FILE"
    			fi

                        if [ -f "$CARPETA_USUARIO/Wallpapers/Wallpaper/Leonardo_Phoenix_09_Design_a_logo_for_SENSE_a_Unixbased_operat_3.jpg" ]; then
                                echo "Repositorio clonado"
                                break
                        else
                                rm -rf "$CARPETA_USUARIO/Wallpapers"
                        fi
                done
		mkdir -p "$ARCHIVOS_DEL_PROGRAMA"
		echo "Subcarpeta Program_Files creada"
		touch "$ARCHIVOS_DEL_PROGRAMA/SHELL_HISTORY"
		chmod 777 "$ARCHIVOS_DEL_PROGRAMA/SHELL_HISTORY"
		UNINSTALL="$CARPETA_USUARIO/Wallpapers/uninstall.sh"
		mv "$UNINSTALL" "$ARCHIVOS_DEL_PROGRAMA/"
		COMMANDS="$CARPETA_USUARIO/Wallpapers/comandossc.sh"
		mv "$COMMANDS" "$ARCHIVOS_DEL_PROGRAMA/"

		ALIAS_CMD_SENSE="alias SENSE='bash $ARCHIVOS_DEL_PROGRAMA/comandossc.sh'"
		ALIAS_CMD="alias uninstall-sense='sudo bash $ARCHIVOS_DEL_PROGRAMA/uninstall.sh'"
        	if ! grep -Fxq "$ALIAS_CMD" /etc/bash.bashrc; then
            		echo "$ALIAS_CMD" | sudo tee -a /etc/bash.bashrc > /dev/null
		fi
		if ! grep -Fxq "$ALIAS_CMD_SENSE" /etc/bash.bashrc; then
    			echo "$ALIAS_CMD_SENSE" | sudo tee -a /etc/bash.bashrc > /dev/null
		fi
		eval "$ALIAS_CMD_SENSE"
		eval "$ALIAS_CMD"
	done
elif [ "$Respuesta" = "no" ]; then
    	echo "Instalación cancelada."
fi
