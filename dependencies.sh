#!/usr/bin/env bash

# On Ubuntu 18.04, assumes OCCAM / GLLVM dependencies have been installed: https://github.com/SRI-CSL/OCCAM/blob/master/vagrants/18.04/basic/bootstrap.sh#L3

# --- portfolio.set ---

# readelf
sudo apt-get install texinfo bison flex

# openssh
sudo apt-get install autoconf

# apache
sudo apt-get install libtool

# --- trimmer.set ---

# aircrack
sudo apt-get install libssl-dev

# bzip2
sudo apt-get install libbz2-dev

# curl

# dnsproxy
sudo apt-get install libevent1-dev

# httping
sudo apt-get install gettext

# knockd
sudo apt-get install libpcap-dev

# wget
sudo apt-get install libgnutls28-dev libidn11-dev libpcre3-dev uuid-dev

# yices
sudo apt-get install gperf

