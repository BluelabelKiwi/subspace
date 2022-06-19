#!/bin/bash

echo -e "\033[1;93m"
echo "========================================================================"
echo "    /II   /II  /IIIIII        /II   /II                 /II          ";
echo "   | II  /II/ /II__  II      | III | II                | II          ";
echo "   | II /II/ | II  \__/      | IIII| II  /IIIIII   /IIIIIII  /IIIIII ";
echo "   | IIIII/  |  IIIIII       | II II II /II__  II /II__  II /II__  II";
echo "   | II  II   \____  II      | II  IIII| II  \ II| II  | II| IIIIIIII";
echo "   | II\  II  /II  \ II      | II\  III| II  | II| II  | II| II_____/";
echo "   | II \  II|  IIIIII/      | II \  II|  IIIIII/|  IIIIIII|  IIIIIII";
echo "   |__/  \__/ \______/       |__/  \__/ \______/  \_______/ \_______/";
echo "========================================================================"
echo "==================== 18 Haziran Guncellemesi ==========================="
echo "========================================================================"
echo -e "\e[0m"

sleep 2

echo -e "\e[1m\e[32m1. Sistem Guncelleniyor... \e[0m" && sleep 1
sudo apt update && sudo apt upgrade --yes && sleep 1
sudo apt-get install libgomp1 --yes && sleep 1
sudo apt install ocl-icd-opencl-dev --yes && sleep 1
sudo apt install libopencl-clang-dev --yes && sleep 1
echo -e "\e[1m\e[32m2. Kullanilmayan Kutuphaneler Temizleniyor... \e[0m" && sleep 1
sudo apt --fix-broken install --yes && sleep 1
sudo apt-get autoremove --yes && sleep 1

echo "=================================================="

echo -e "\e[1m\e[32m3. wget Yukleniyor... \e[0m" && sleep 1
sudo apt install wget -y
cd $HOME

echo -e "\e[1m\e[32m4. SubSpace Node/Farmer Durduruluyor... \e[0m" 
sudo systemctl daemon-reload && sleep 1
sudo systemctl stop subspace-farmer.service && sleep 1
sudo systemctl stop subspace-node.service && sleep 2
sudo systemctl disable subspace-farmer.service && sleep 1
sudo systemctl disable subspace-node.service && sleep 1
	
echo "=================================================="

echo -e "\e[1m\e[32m5. Eski versiyon temizleniyor... \e[0m" 
rm -rf /usr/local/bin/subspace* && sleep 1

echo "=================================================="

echo -e "\e[1m\e[32m6. SubSpace Guncel node binary indiriliyor... \e[0m" && sleep 1
wget https://github.com/subspace/subspace/releases/download/gemini-1b-2022-jun-18/subspace-node-ubuntu-x86_64-gemini-1b-2022-jun-18

echo "=================================================="

echo -e "\e[1m\e[32m7. SubSpace Guncel farmer binary indiriliyor... \e[0m" && sleep 1
wget https://github.com/subspace/subspace/releases/download/gemini-1b-2022-jun-18/subspace-farmer-ubuntu-x86_64-gemini-1b-2022-jun-18

echo "=================================================="

echo -e "\e[1m\e[32m8. Node Tasiniyor.. /usr/local/bin/subspace-node ... \e[0m" && sleep 1
sudo mv subspace-node-ubuntu-x86_64-gemini-1b-2022-jun-18 /usr/local/bin/subspace-node

echo "=================================================="

echo -e "\e[1m\e[32m9. Farmer Tasiniyor.. /usr/local/bin/subspace-farmer ... \e[0m" && sleep 1
sudo mv subspace-farmer-ubuntu-x86_64-gemini-1b-2022-jun-18 /usr/local/bin/subspace-farmer

echo "=================================================="

echo -e "\e[1m\e[32m10. Dosya izinleri ayarlaniyor subspace-farmer & subspace-node ... \e[0m" && sleep 1
sudo chmod +x /usr/local/bin/subspace*

echo "==================================================

echo -e "\e[1m\e[32mDaemon Yeniden Baslatiliyor.. \e[0m"
sudo systemctl daemon-reload
echo -e "\e[1m\e[32mFarmer Yeniden Baslatiliyor.. \e[0m"
sudo systemctl enable subspace-farmer.service
echo -e "\e[1m\e[32mNode Yeniden Baslatiliyor.. \e[0m"
sudo systemctl enable subspace-node.service

sudo systemctl start subspace-node.service
sudo systemctl start subspace-farmer.service

echo "=================================================="

echo -e "\e[1m\e[32mNode Basladi \e[0m"
echo -e "\e[1m\e[32mFarmer Basladi \e[0m"

echo "==================================================" 	

echo -e "\e[1m\e[32m Node Loglari icin: \e[0m" 
echo -e "\e[1m\e[39m    journalctl -u subspace-node.service -f \n \e[0m" 

echo -e "\e[1m\e[32m Farmer Loglari icin: \e[0m" 
echo -e "\e[1m\e[39m    journalctl -u subspace-farmer.service -f \n \e[0m" 	

echo -e "\e[1m\e[93mNode Versiyonu: \e[0m" 
subspace-node --version