#!/usr/bin/python3
#coding=utf-8
import sys,re,time,os
maxdata = 858993459200 #流量上限，包括流入和流出，单位Byte
networks = 'eth0'#網卡
memfilename = '/root/data.txt'
netcard = '/proc/net/dev'
def checkfile(filename):
    if os.path.isfile(filename):
        pass
    else:
        f = open(filename, 'w')
        f.write('0\n0\n')
        f.close()
def get_net_data():
    nc = netcard or '/proc/net/dev'
    fd = open(nc, "r")
    netcardstatus = False
    for line in fd.readlines():
        if line.find(networks) > 0:
            netcardstatus = True
            field = line.split()
            recv = field[0].split(":")[1]
            recv = recv or field[1]
            send = field[9]
    if not netcardstatus:
        fd.close()
        print("Please setup your netcard")
        sys.exit()
    fd.close()
    return (float(recv), float(send))

def net_loop():
    (recv, send) = get_net_data()
    checkfile(memfilename)
    lasttransdata = []
    with open(memfilename, 'r') as filehandle:
        lasttransdata = [data.rstrip() for data in filehandle.readlines()]

    filehandle.close()
    print(lasttransdata)
    totaltrans = lasttransdata or [0, 0]
    while True:
        time.sleep(3)
        nowtime = time.strftime('%d %H:%M',time.localtime(time.time()))
        sec = time.localtime().tm_sec
        if nowtime == '01 00:00':
            if sec < 10:
                totaltrans = [0, 0]
        (new_recv, new_send) = get_net_data()
        recvdata = new_recv - recv
        recv = new_recv

        senddata = new_send - send
        send = new_send
        totaltrans[0] = str(int(totaltrans[0]) + int(recvdata))
        totaltrans[1] = str(int(totaltrans[1]) + int(senddata))
        #写入数据
        with open(memfilename, 'w') as filehandle:
            filehandle.writelines("%s\n" % data for data in totaltrans)
        filehandle.close()
        if int(totaltrans[0]) >= maxdata or int(totaltrans[1]) >= maxdata:
            os.system('rm -f /root/data.txt && init 0')
if __name__ == "__main__":
    net_loop()