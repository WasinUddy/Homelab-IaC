'''
Montainer Server Backup Script
Backup Montainer Server (10.0.50.10) to TrueNAS NFS Share (10.0.40.5)
'''
import os
import glob
import time
from datetime import datetime

# Constants
SERVERS = '/home/ase/montainer_servers'
BACKUP = '/home/ase/NFS'
MAX_BACKUPS = 4
TRUENAS_IP = '10.0.40.5'

# Check if TrueNAS is online
response = os.system(f"ping -c 1 {TRUENAS_IP}")
if response != 0:
    print(f"TrueNAS {TRUENAS_IP} is Offline")
    exit()
print(f"TrueNAS {TRUENAS_IP} is Online")

# Get timestamp and list of servers
timestamp = time.strftime('%Y-%m-%d_%H:%M:%S')
servers = os.listdir(SERVERS)

# Backup each server
for server in servers:
    # Create Directory if not exists in BACKUP
    if not os.path.exists(f'{BACKUP}/{server}'):
        os.mkdir(f'{BACKUP}/{server}')

    # If more than MAX_BACKUPS, delete oldest
    backups = glob.glob(f'{BACKUP}/{server}/*.tar.gz')
    if len(backups) >= MAX_BACKUPS:
        backups.sort(key=lambda f: datetime.strptime(f.split('/')[-1].rstrip('.tar.gz'), '%Y-%m-%d_%H:%M:%S'))
        os.remove(backups[0])

    # Backup Server
    os.system(f'tar -czvf {BACKUP}/{server}/{timestamp}.tar.gz -C {SERVERS}/{server} .')

    print(f"BACKUP {server} as {BACKUP}/{server}/{timestamp}.tar.gz")