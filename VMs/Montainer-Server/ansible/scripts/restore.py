'''
Montainer Server Restore Script
Restore Montainer Server (10.0.50.10) from TrueNAS NFS Share (10.0.40.5)
'''
import os
import glob
import subprocess

# Constants
SERVERS = '/home/ase/montainer_servers'
BACKUP = '/home/ase/NFS'
TRUENAS_IP = '10.0.40.5'

# Check if TrueNAS is online
response = os.system(f"ping -c 1 {TRUENAS_IP}")
if response != 0:
    print(f"TrueNAS {TRUENAS_IP} is Offline")
    exit()
print(f"TrueNAS {TRUENAS_IP} is Online")

# Get list of servers
servers = os.listdir(BACKUP)

# Restore each server
for server in servers:
    # Get the newest backup file for a given server
    backups = glob.glob(f'{BACKUP}/{server}/*.tar.gz')
    backups.sort()
    newest = backups[-1]

    # Extract a backup file to the corresponding server directory
    target = f'{SERVERS}/{server}'
    os.makedirs(target, exist_ok=True)
    subprocess.run(['tar', '-xzvf', newest, '-C', target], check=True)

    # Run docker-compose up in the server directory
    subprocess.run(['docker-compose', '-f', f'{SERVERS}/{server}/docker-compose.yaml', 'up', '-d'], check=True)

    print(f"RESTORED {server} from {newest}")