import os
import time
import argparse
import subprocess




# Function to restart WireGuard interface
def restart_wireguard(interface):
    print(f"Restarting WireGuard connection ({interface})...")
    os.system(f'sudo systemctl restart wg-quick@{interface}')

# Function to check if a ping is successful
def is_ping_successful(server_ip):
    try:
        result = subprocess.run(['ping', '-c', '1', '-W', '1', server_ip], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        return result.returncode == 0  # Return True if ping succeeds
    except Exception as e:
        print(f"Ping error: {e}")
        return False

def main():
    server_ip = os.getenv("SERVER_IP")
    interface = os.getenv("WG_INTERFACE")
    print(f"Server IP: {server_ip}, Interface: {interface}")
    failed_tries = 0
    consecutive_failures = 0

    # Continuous pinging loop
    while True:
        print('Waiting 3 seconds for the next ping...')
        time.sleep(3)

        if is_ping_successful(server_ip):
            print('Ping successful!')
            consecutive_failures = 0  # Reset consecutive failures
        else:
            consecutive_failures += 1
            print(f'Ping failed {consecutive_failures} times!')

        # Restart only after 10 consecutive failures
        if consecutive_failures >= 10:
            print(f"Restarting {interface} after {consecutive_failures} failures...")
            restart_wireguard(interface)
            consecutive_failures = 0  # Reset counter after restart

        # If more than 50 failed tries overall, wait 30 seconds before retrying
        if failed_tries >= 50:
            print("More than 50 failed pings. Waiting 30 seconds before retrying...")
            time.sleep(30)  # Sleep for 30 minutes
            failed_tries = 0

if __name__ == '__main__':
    main()
