#!/usr/bin/python3
#coding=utf-8
import sys,re,time,os
maxdata = 858993459200 #流量上限，单位是Byte 
networks = 'eth0'#網卡 
memfilename = '/root/data.txt'
netcard = '/proc/net/dev'
def checkfile(filename):
    if os.path.isfile(filename):
        pass
    else:
        f = open(filename, 'w')
        f.write('0')
        f.close()
def get_net_data():
    nc = netcard or '/proc/net/dev'
    fd = open(nc, "r")
    netcardstatus = False
    for line in fd.readlines():
        if line.find(networks) > 0: #这里的网卡用的是ens3，请根据自己的网卡进行调整，可以通过cat /proc/net/dev查看
            netcardstatus = True
            field = line.split() #读取数据
            recv = field[0].split(":")[1]
            recv = recv or field[1] #流入流量
            send = field[9] #流出流量
    if not netcardstatus:
        fd.close()
        print("Please setup your netcard")
        sys.exit()
    fd.close()
    return (float(recv), float(send))

def net_loop():
    (recv, send) = get_net_data()
    checkfile(memfilename)
    lasttransdaraopen = open(memfilename,'r')
    lasttransdata = lasttransdaraopen.readline()
    lasttransdaraopen.close()
    totaltrans = int(lasttransdata) or 0
    while True:
        time.sleep(3)
        nowtime = time.strftime('%d %H:%M',time.localtime(time.time()))
        sec = time.localtime().tm_sec
        if nowtime == '01 00:00':
            if sec < 10:
                totaltrans = 0
        (new_recv, new_send) = get_net_data()
        recvdata = new_recv - recv
        recv = new_recv
        senddata = new_send - send
        send = new_send
        totaltrans += int(recvdata)
        totaltrans += int(senddata)
        memw = open(memfilename,'w')
        memw.write(str(totaltrans))
        memw.close()
        if totaltrans >= maxdata:
            os.system('rm -f /root/data.txt && init 0') #超出流量，删除记录并关机。
if __name__ == "__main__":
    net_loop()
