# Clash-Shell

一个用于在Linux系统上快速部署和管理Clash代理服务的自动化脚本项目。

## 项目描述

Clash-Shell 提供了完整的部署流程，包括：
- 自动下载和配置Clash代理服务
- Systemd服务集成（支持开机自启）
- 快速启动/停止脚本
- 支持多个CPU架构（amd64, armv8）

## 前置要求

- Ubuntu/Debian Linux系统（18.04 LTS或更高版本）
- Root或sudo权限（用于systemd配置）
- 网络连接（用于下载Clash配置）

## 项目结构

```
Clash-shell/
├── README.md                        # 项目文档
├── install.sh                       # 安装脚本
├── start.sh                         # 启动脚本
├── stop.sh                          # 停止脚本
├── clash.service                    # Systemd服务文件
├── clash-linux-amd64                # AMD64架构的Clash可执行文件
└── clashpremium-linux-armv8         # ARM64架构的Clash可执行文件
```

## 快速开始

### 1. 安装Clash服务

```bash
sudo bash install.sh
```

此脚本将：
- 在系统中注册Clash服务
- 配置开机自启
- 创建必要的目录和权限

### 2. 启动服务

```bash
bash start.sh
```

或使用systemd：
```bash
sudo systemctl start clash
```

### 3. 停止服务

```bash
bash stop.sh
```

或使用systemd：
```bash
sudo systemctl stop clash
```

## 常见命令

### 查看服务状态
```bash
sudo systemctl status clash
```

### 查看Clash日志
```bash
tail -f /home/ubuntu/clash/clash.log
```

### 重启Clash服务
```bash
sudo systemctl restart clash
```

### 启用开机自启
```bash
sudo systemctl enable clash
```

### 禁用开机自启
```bash
sudo systemctl disable clash
```

## 配置说明

Clash服务使用`/home/ubuntu/clash/`目录作为工作目录。

### 修改执行用户（可选）

编辑 `clash.service` 文件中的用户信息：

```ini
User=ubuntu      # 修改此处
Group=ubuntu     # 修改此处
```

然后重新安装：
```bash
sudo bash install.sh
sudo systemctl daemon-reload
sudo systemctl restart clash
```

## 文件说明

| 文件 | 说明 |
|------|------|
| `install.sh` | 自动化安装和配置脚本 |
| `start.sh` | 启动Clash服务的脚本 |
| `stop.sh` | 停止Clash服务的脚本 |
| `clash.service` | Systemd服务文件，用于系统集成 |
| `clash-linux-amd64` | AMD64架构可执行文件（x86-64） |
| `clashpremium-linux-armv8` | ARM64架构可执行文件（ARM v8） |

## 故障排除

### 1. 权限不足

```bash
# 确保以root或sudo运行安装脚本
sudo bash install.sh
```

### 2. 服务启动失败

检查日志文件：
```bash
sudo journalctl -u clash -n 50
# 或
tail -f /home/ubuntu/clash/clash.log
```

### 3. 选择正确的可执行文件

根据您的CPU架构选择相应的可执行文件：

```bash
# 查看您的系统架构
uname -m
```

- `x86_64` 或 `amd64` → 使用 `clash-linux-amd64`
- `aarch64` 或 `armv8` → 使用 `clashpremium-linux-armv8`

### 4. 修改工作目录路径

如需更改Clash的工作目录（默认为 `/home/ubuntu/clash`），请编辑 `clash.service`：

```ini
ExecStart=bash -c "cd /YOUR/PATH && ./clashpremium-linux-armv8 -d . > /YOUR/PATH/clash.log"
WorkingDirectory=/YOUR/PATH
```

## 注意事项

- ⚠️ 安装脚本需要**管理员权限**
- ⚠️ Clash服务默认运行用户为 `ubuntu`，确保该用户存在
- ⚠️ 确保 `/home/ubuntu/clash/` 目录存在且有适当的权限
- ⚠️ 在修改服务配置后，需要运行 `sudo systemctl daemon-reload`

## 卸载

若要完全卸载Clash服务：

```bash
sudo systemctl stop clash
sudo systemctl disable clash
sudo systemctl daemon-reload
# 可选：删除Clash目录
sudo rm -rf /home/ubuntu/clash
```

## License

该项目仅供学习和个人使用。

## 支持

如遇到问题，请检查：
1. 系统架构是否与可执行文件匹配
2. 工作目录权限是否正确
3. Systemd日志和应用日志
4. 网络连接状态
