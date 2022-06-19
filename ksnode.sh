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
echo -e "\e[0m"


sleep 2

echo -e "\e[1m\e[32m1. Sistem Guncelleniyor... \e[0m" && sleep 1
sudo apt update && sudo apt upgrade --yes && sleep 1
sudo apt-get install libgomp1 && sleep 1
sudo apt install ocl-icd-opencl-dev && sleep 1
sudo apt install libopencl-clang-dev && sleep 1
sudo apt --fix-broken install && sleep 1
sudo apt-get autoremove

echo "=================================================="

echo -e "\e[1m\e[32m2. wget Yukleniyor... \e[0m" && sleep 1
sudo apt install wget -y
cd $HOME

echo "=================================================="

echo -e "\e[1m\e[91mNOTE. Eski Node uzerine kuruyorsaniz bazi datalarin silinmesi gerekli."
echo -e "\e[1m\e[91m3. Uzerine kurulum icin y / Yeni kurulum icin n (y/n) \e[0m"
read -p "(y/n)?" response
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then   
    sudo systemctl stop subspace-farmer.service
    sudo systemctl stop subspace-node.service
    subspace-farmer wipe
    subspace-node purge-chain --chain gemini-1
fi
echo "=================================================="

echo -e "\e[1m\e[32m3. SubSpace node binary indiriliyor... \e[0m" && sleep 1
wget https://github.com/subspace/subspace/releases/download/gemini-1b-2022-jun-18/subspace-node-ubuntu-x86_64-gemini-1b-2022-jun-18

echo "=================================================="

echo -e "\e[1m\e[32m4. SubSpace farmer binary indiriliyor... \e[0m" && sleep 1
wget https://github.com/subspace/subspace/releases/download/gemini-1b-2022-jun-18/subspace-farmer-ubuntu-x86_64-gemini-1b-2022-jun-18

echo "=================================================="

echo -e "\e[1m\e[32m5. Node Tasiniyor.. /usr/local/bin/subspace-node ... \e[0m" && sleep 1
sudo mv subspace-node-ubuntu-x86_64-gemini-1b-2022-jun-18 /usr/local/bin/subspace-node

echo "=================================================="

echo -e "\e[1m\e[32m6. Farmer Tasiniyor.. /usr/local/bin/subspace-farmer ... \e[0m" && sleep 1
sudo mv subspace-farmer-ubuntu-x86_64-gemini-1b-2022-jun-18 /usr/local/bin/subspace-farmer

echo "=================================================="

echo -e "\e[1m\e[32m7. Dosya izinleri ayarlaniyor subspace-farmer & subspace-node ... \e[0m" && sleep 1
sudo chmod +x /usr/local/bin/subspace*

echo "=================================================="

echo -e "\e[1m\e[32m8. Polkadot JS adresinizi girin \e[0m"
read -p "Address: " ADDRESS

echo "=================================================="

echo -e "\e[1m\e[32m9. Subspace Node adinizi girin \e[0m"
read -p "Node Name : " NODE_NAME

echo "=================================================="

echo -e "\e[1m\e[32m9. Subspace Farmer icin plot boyutu girin. Ornek 80GB icin 80G \e[0m"
read -p "Plot Size : " PLOTSIZE

echo "=================================================="

echo -e "\e[1m\e[92m Node Adi: \e[0m" $NODE_NAME

echo -e "\e[1m\e[92m Cuzdan Adresi:  \e[0m" $ADDRESS

echo -e "\e[1m\e[92m Plot Boyutu:  \e[0m" $PLOTSIZE

echo -e "\e[1m\e[91m    11.1 Dogru ise onaylayin (y/n) \e[0m"
read -p "(y/n)?" response
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then

    echo "=================================================="

    echo -e "\e[1m\e[32m12. Subspace Node servisleri olusturuluyor.. \e[0m"

    echo "[Unit]
Description=Subspace Node

[Service]
User=$USER
ExecStart=subspace-node --chain gemini-1 --execution wasm --pruning 1024 --keep-blocks 1024 --validator --name '$NODE_NAME'
Restart=always
RestartSec=10
LimitNOFILE=10000

[Install]
WantedBy=multi-user.target
    " > $HOME/subspace-node.service

    sudo mv $HOME/subspace-node.service /etc/systemd/system

    echo "=================================================="

    echo -e "\e[1m\e[32m13. Subspace Farmer servisleri olusturuluyor.. \e[0m"

    echo "[Unit]
Description=Subspace Farmer

[Service]
User=$USER
ExecStart=subspace-farmer farm --reward-address $ADDRESS --plot-size $PLOTSIZE
Restart=always
RestartSec=10
LimitNOFILE=10000

[Install]
WantedBy=multi-user.target
    " > $HOME/subspace-farmer.service

    sudo mv $HOME/subspace-farmer.service /etc/systemd/system

    echo "=================================================="

    # Enabling services
    sudo systemctl daemon-reload
    sudo systemctl enable subspace-farmer.service
    sudo systemctl enable subspace-node.service

    # Starting services
    sudo systemctl restart subspace-node.service
    sudo systemctl restart subspace-farmer.service

    echo "=================================================="

    echo -e "\e[1m\e[32mNode Basladi \e[0m"
    echo -e "\e[1m\e[32mFarmer Basladi \e[0m"

    echo "=================================================="
	
    echo -e "\e[1m\e[32m Thanks ZValid for Script zvalid.com \e[0m"  	

    echo -e "\e[1m\e[32m Node Loglari icin: \e[0m" 
    echo -e "\e[1m\e[39m    journalctl -u subspace-node.service -f \n \e[0m" 
	
    echo -e "\e[1m\e[32m Farmer Loglari icin: \e[0m" 
    echo -e "\e[1m\e[39m    journalctl -u subspace-farmer.service -f \n \e[0m" 	

    echo -e "\e[1m\e[32m Node durdurmak icin: \e[0m" 
    echo -e "\e[1m\e[39m    systemctl stop subspace-node.service \n \e[0m" 

    echo -e "\e[1m\e[32m Node baslatmak icin: \e[0m" 
    echo -e "\e[1m\e[39m    systemctl start subspace-node.service \n \e[0m" 

    echo -e "\e[1m\e[32m Farmer durdurmak icin: \e[0m" 
    echo -e "\e[1m\e[39m    systemctl stop subspace-farmer.service \n \e[0m" 

    echo -e "\e[1m\e[32m Farmer baslatmak icin: \e[0m" 
    echo -e "\e[1m\e[39m    systemctl start subspace-farmer.service \n \e[0m" 

    echo -e "\e[1m\e[32m Farmer imzali bloklari gormek icin: \e[0m" 
    echo -e "\e[1m\e[39m    journalctl -u subspace-farmer.service -o cat | grep 'Successfully signed block' \n \e[0m" 
	
	echo -e "\e[1m\e[32m Farmer imzali bloklari gormek icin (Odullu baslangici itibariyle): \e[0m" 
    echo -e "\e[1m\e[39m    journalctl -u subspace-farmer.service -o cat --since "2022-06-11 15:00:00 UTC" | grep 'reward' \n \e[0m" 

else
    echo -e "\e[1m\e[91m    islemi sonlandirdiniz \e[0m"
fi
