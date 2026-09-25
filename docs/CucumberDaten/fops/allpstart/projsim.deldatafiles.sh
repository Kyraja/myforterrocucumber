#!/bin/sh

# Name             : projsim.export.sh
# Autor            : Thomas Saalborn
# Copyright        : (c)1990-2013 alltrotec GmbH
# Funktion         :
# Loeschen temp. Dateien in ProjSim Datenverzeichnis
# manddirs: Array <m> von abas-ERP-Mandantenverzeichnissen
# datdirs: Array von <n> Unterverzeichnissen, in denen geloescht werden soll
# datages: Array von <n> Zahlen, ab deren Alter in Tagen geloescht werden soll

#  woerter=("bla" "blu" "bli"); for((i=0;i<${#woerter};i++)); do echo ${woerter[$i]};done

manddirs=("$MANDANTDIR")
datdirs=("win/projectsuite/projsim/Daten")
datages=(90)

nmanddirs=${#manddirs[*]}
ndatdirs=${#datdirs[*]}

for(( imanddir=0; imanddir < ${nmanddirs}; imanddir++ ))  ; do
  idatdir=1
  for(( idatdir=0; idatdir < ${ndatdirs}; idatdir++ ))  ; do
    for file in `find "${manddirs[$imanddir]}/${datdirs[$idatdir]}" -type f -daystart -mtime +${datages[$idatdir]}` ; do
      echo "Delete File / Dir older then ${datages[$idatdir]} days at `date`: "`ls -ald "${file}"`
      rm -rf "${file}"
    done
  done
done
