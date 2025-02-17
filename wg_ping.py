import os
import time
import argparse
from pythonping import ping

# Function to parse command-line arguments
def parse_args():
    parser = argparse.ArgumentParser(description='Ping WireGuard server and restart interface on failure.')
    parser.add_argument('server_ip', type=str, help='The WireGuard server IP address (e.g., 10.6.0.1)')
    parser.add_argument('--interface', type=str, default='wg0', help='WireGuard interface (default: wg0)')
    return parser.parse_args()

# Function to restart WireGuard interface
def restart_wireguard(interface):
    print(f"Restarting WireGuard connection ({interface})...")
    os.system(f'sudo systemctl restart wg-quick@{interface}')

def main():
    # Parse command-line arguments
    args = parse_args()
    failed_tries = 0
    server_ip = args.server_ip
    interface = args.interface

    # Continuous pinging loop
    while True:
        print('Waiting 3 seconds for the next ping...')
        time.sleep(3)
        # Test Ping Success
        if ping(server_ip)._responses[0].success:
            print('Ping successful!')
            # Reset failed tries
            failed_tries = 0
        else:
            print(f'Ping failed! Restarting {interface} connection...')
            # Restart WireGuard interface
            restart_wireguard(interface)
            # Increment failed tries
            failed_tries += 1

        # If more than 50 failed tries, add a 30-minute timeout
        if failed_tries >= 50:
            failed_tries = 0
            print('More than 50 failed pings. Waiting 30 seconds for next ping!')
            # Sleep for 30 minutes
            time.sleep(30)
            

if __name__ == '__main__':
    main()

