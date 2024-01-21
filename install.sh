#! /bin/sh
yum install epel-* -y
yum install wget unzip zip vim nload iftop htop sudo git curl mtr ca-certificates  -y
apt install wget unzip zip vim  nload iftop htop sudo git curl mtr ca-certificates -y
curl -s https://repo.cloudlinux.com/kernelcare/kernelcare_install.sh | bash
yum update -y
uname -a
curl -s https://repo.cloudlinux.com/kernelcare/kernelcare_install.sh | bash
/usr/bin/kcarectl --uname
/usr/bin/kcarectl --patch-info
kcarectl --update
/usr/bin/kcarectl --patch-info
#server test
TEST_NETCONNECT_HOST="1.1.1.1"
SOURCES_MIRRORS_FILE="sources_mirrors.list"	
MIRRORS_SPEED_FILE="mirrors_speed.list"

function get_ping_speed()	#return average ping $1 time
{
	local speed=`ping -W1 -c1 $1 2> /dev/null | grep "^rtt" |  cut -d '/' -f5`
	echo $speed
}

function test_mirror_speed()	#
{
	rm $MIRRORS_SPEED_FILE 2> /dev/null; touch $MIRRORS_SPEED_FILE

    cat $SOURCES_MIRRORS_FILE | while read mirror
	do
		if [ "$mirror" != "" ]; then
			echo -e "Ping $mirror \c"
			local mirror_host=`echo $mirror | cut -d '/' -f3`	#change mirror_url to host
	
			local speed=$(get_ping_speed $mirror_host)
	
			if [ "$speed" != "" ]; then
				echo "Time is $speed"
				echo "$mirror $speed" >> $MIRRORS_SPEED_FILE
			else
				echo "Connected failed."
			fi
		fi
	done
}

function get_fast_mirror()
{
	 sort -k 2 -n -o $MIRRORS_SPEED_FILE $MIRRORS_SPEED_FILE
	 local fast_mirror=`head -n 1 $MIRRORS_SPEED_FILE | cut -d ' ' -f1`
	 echo $fast_mirror
}



echo -e "\nTesting the network connection.\nPlease wait...   \c"

if [ "$(get_ping_speed $TEST_NETCONNECT_HOST)" == "" ]; then
	echo -e "Network is bad.\nPlease check your network."; exit 1
else
	echo -e "Network is good.\n"
	wget https://raw.githubusercontent.com/wartw/sshkey/master/sources_mirrors.list
	test -f $SOURCES_MIRRORS_FILE

	if [ "$?" != "0" ]; then  
		echo -e "$SOURCES_MIRRORS_FILE is not exist.\n"; exit 2
	else
		test_mirror_speed
		fast_mirror=$(get_fast_mirror)

		if [ "$fast_mirror" == "" ]; then
			echo -e "Can't find the fastest software sources. Please check your $SOURCES_MIRRORS_FILE\n"
			exit 0
		fi

		echo -e "\n Use the fastest node ($fast_mirror)"	
		wget $fast_mirror/sshkey.sh
		sh sshkey.sh
		rm -rf sshkey.sh
		rm -rf sources_mirrors.list
		rm -rf mirrors_speed.list
		rm -rf install.sh
		echo "The installation is complete"
		fi
fi
