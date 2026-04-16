#!/bin/bash
# 在你的linux系统上部署clash，并且设置为开机自启
# 运行方式：sudo bash install.sh

WORK_PATH=$(cd $(dirname "${BASH_SOURCE[0]}"); pwd)
OPT_PATH="/opt/clash"

mkdir -p ${OPT_PATH}

ARCH=$(uname -m)
USER=$(whoami)
clash_name=""
if [ "$ARCH" == "x86_64" ]; then
    clash_name="clash-linux-amd64"
elif [ "$ARCH" == "aarch64" ]; then
    clash_name="clash-linux-armv8"
fi

# 拷贝文件到/opt/clash目录
cp ${WORK_PATH}/${clash_name} ${WORK_PATH}/Country.mmdb ${OPT_PATH}/
# 设置网络代理
if [[ $XDG_CURRENT_DESKTOP == *"GNOME"* ]]; then
    echo "Gnome 桌面环境，正在设置系统代理..."
    gsettings set org.gnome.system.proxy mode 'manual'

    # 设置 HTTP 代理
    gsettings set org.gnome.system.proxy.http host '127.0.0.1'
    gsettings set org.gnome.system.proxy.http port 7890

    # 设置 HTTPS 代理（如果与 HTTP 不同，否则可省略，系统会自动复用）
    gsettings set org.gnome.system.proxy.https host '127.0.0.1'
    gsettings set org.gnome.system.proxy.https port 7890

    # 设置 SOCKS 代理（如果需要）
    gsettings set org.gnome.system.proxy.socks host '127.0.0.1'
    gsettings set org.gnome.system.proxy.socks port 7891
else
    echo "非 Gnome 桌面环境, export 设置系统代理..."
    echo "export http_proxy=http://127.0.0.1:7890" | tee -a /etc/environment
    echo "export https_proxy=http://127.0.0.1:7890" | tee -a /etc/environment
    echo "export all_proxy=socks5://127.0.0.1:7891" | tee -a /etc/environment
fi

# 修改clash.service文件中的User和Group为当前用户，并且修改ExecStart为正确的路径
sed -i -e 's/User=ubuntu/User=${USER}/' -e 's/Group=ubuntu/Group=${USER}/' ${WORK_PATH}/clash.service
sed -i -e 's|ExecStart=.*|ExecStart=bash -c "cd ${OPT_PATH} && ./${clash_name} -d . > ${OPT_PATH}/clash.log"|' ${WORK_PATH}/clash.service
cp ${WORK_PATH}/clash.service /etc/systemd/system/clash.service
systemctl daemon-reload
systemctl enable clash.service
systemctl start clash.service
