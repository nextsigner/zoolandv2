#!/bin/bash

# Definir la ruta de la carpeta de efemérides
# Ajusta esta ruta si el script no está en la raíz del proyecto
TARGET_DIR="./android/assets/ephe"

if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: El directorio $TARGET_DIR no existe."
    exit 1
fi

echo "Iniciando limpieza de efemérides en: $TARGET_DIR"

# Entrar al directorio
cd "$TARGET_DIR" || exit

# Lista de archivos a CONSERVAR (Patrones)
# sepl_12, semo_12, seas_12 -> Rango 1200-1799 (Cubre desde 1400)
# sepl_18, semo_18, seas_18 -> Rango 1800-2399 (Cubre hasta 2100)
# fixstars.cat, seorbel.txt -> Archivos maestros
# *.TXT / LICENSE -> Documentación (opcional, pero recomendada)

# Usamos un array para definir qué queremos mantener
KEEP_PATTERNS=(
    "sepl_12.se1"
    "semo_12.se1"
    "seas_12.se1"
    "sepl_18.se1"
    "semo_18.se1"
    "seas_18.se1"
    "fixstars.cat"
    "seorbel.txt"
    "LICENSE.TXT"
    "README.TXT"
)

# Crear una lista temporal de archivos a borrar
# Empezamos listando todos los archivos .se1, .txt y .cat
all_files=$(ls *.se1 *.txt *.cat 2>/dev/null)

count_deleted=0

for file in $all_files; do
    keep=false

    # Comprobar si el archivo actual coincide con alguno de la lista de preservación
    for pattern in "${KEEP_PATTERNS[@]}"; do
        if [[ "$file" == "$pattern" ]]; then
            keep=true
            break
        fi
    done

    # Si no está en la lista de preservación, se borra
    if [ "$keep" = false ]; then
        echo "Eliminando: $file"
        rm "$file"
        ((count_deleted++))
    fi
done

echo "------------------------------------------"
echo "Limpieza completada."
echo "Archivos eliminados: $count_deleted"
echo "Archivos restantes en la carpeta:"
ls -1