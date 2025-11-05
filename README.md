# WireGuard Auto Reconnect Service

自動監控 WireGuard 連線並在失敗時重新連線的 systemd 服務。

## 功能

- 定期 ping WireGuard 伺服器
- 在連續 10 次失敗後自動重啟 WireGuard 介面
- 使用 systemd 管理，開機自動啟動
- **可配置的伺服器 IP 和介面名稱**

## 安裝

### 快速安裝

```bash
sudo make install
```

### 配置

安裝後，編輯配置文件來設定你的 WireGuard 伺服器 IP 和介面名稱：

```bash
sudo nano /etc/wireguard/wg_ping.conf
```

修改以下參數：

```bash
# The WireGuard server IP address to ping
SERVER_IP=10.8.0.1

# The WireGuard interface name
WG_INTERFACE=wg0
```

儲存後，重啟服務：

```bash
sudo systemctl restart wireguard_ping.service
```

## 使用方法

### 查看服務狀態

```bash
sudo systemctl status wireguard_ping.service
```

### 查看即時日誌

```bash
sudo journalctl -u wireguard_ping.service -f
```

### 停止服務

```bash
sudo systemctl stop wireguard_ping.service
```

### 啟動服務

```bash
sudo systemctl start wireguard_ping.service
```

### 重啟服務

```bash
sudo systemctl restart wireguard_ping.service
```

## 卸載

```bash
sudo systemctl stop wireguard_ping.service
sudo systemctl disable wireguard_ping.service
sudo make uninstall
```

## 配置文件位置

- **腳本**: `/usr/local/bin/wg_ping.py`
- **配置**: `/etc/wireguard/wg_ping.conf`
- **服務**: `/etc/systemd/system/wireguard_ping.service`

## 修改配置

如果需要更改伺服器 IP 或介面名稱：

1. 編輯配置文件：
   ```bash
   sudo nano /etc/wireguard/wg_ping.conf
   ```

2. 修改 `SERVER_IP` 和 `WG_INTERFACE` 參數

3. 重啟服務：
   ```bash
   sudo systemctl restart wireguard_ping.service
   ```

## 手動執行（測試用）

如果你想手動測試腳本：

```bash
python3 wg_ping.py 10.8.0.1 --interface wg0
```

## 工作原理

1. 每 3 秒 ping 一次指定的伺服器 IP
2. 如果連續失敗 10 次，自動執行 `systemctl restart wg-quick@wg0`
3. 如果累計失敗超過 50 次，會等待 30 秒後再繼續
4. 成功 ping 後會重置連續失敗計數器

