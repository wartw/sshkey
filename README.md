# 躍空管理專用SSH公KEY安裝程序  
## 安裝時程序會解析最快的節點位置進行下載安裝程序  
### 安裝方法(以下節點隨機選一個直接複製指令到SSH貼上執行即可)   
節點1(github)
```
centos用
curl -O https://raw.githubusercontent.com/wartw/sshkey/master/install.sh
sh install.sh
OR
wget https://raw.githubusercontent.com/wartw/sshkey/master/install.sh
sh install.sh
以下適合centos以外系統
wget https://raw.githubusercontent.com/wartw/sshkey/master/install.sh
bash install.sh
OR
curl -O https://raw.githubusercontent.com/wartw/sshkey/master/install.sh
bash install.sh
```
# 網路流量監控關機
```
雙向流量
cd /home
mkdir net
cd net
wget https://raw.githubusercontent.com/wartw/sshkey/master/network.sh
單一方向超過
cd /home
mkdir net
cd net
wget https://raw.githubusercontent.com/wartw/sshkey/master/network2.sh
```
