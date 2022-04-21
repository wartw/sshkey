echo "zram" >> /etc/modules-load.d/zram.conf
echo "options zram num_devices=1" >> /etc/modprobe.d/zram.conf
echo "KERNEL=="zram0", ATTR{disksize}="10G",TAG+="systemd"" >> /etc/udev/rules.d/99-zram.rules
cat > /etc/systemd/system/zram.service <<EOF
[Unit]
Description=Swap with zram
After=multi-user.target

[Service]
Type=oneshot
RemainAfterExit=true
ExecStartPre=/sbin/mkswap /dev/zram0
ExecStart=/sbin/swapon /dev/zram0
ExecStop=/sbin/swapoff /dev/zram0

[Install]
WantedBy=multi-user.target
EOF

systemctl enable zram
systemctl start zram
