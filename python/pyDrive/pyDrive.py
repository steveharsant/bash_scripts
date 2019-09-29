#!/usr/bin/python

# pyDrive - Python based script to sync Google Drive.
# 1.1.0
# A simple script for downloading Google Drive contents with support for multiple user accounts.
# pyDrive uses drive (https://github.com/odeke-em/drive) to download files
# and notify (https://github.com/mashlol/notify) to trigger push messages.

import datetime
import json
import os

script_start = datetime.datetime.now()

# Settings
settings_json = './settings.json'
drive_bin = '/usr/bin/drive'
# drive_path = '/STORAGE/homes/steve/gDrive'
notify_path = '/usr/bin/notify'

# drive commands
drive_pull = 'drive pull'

def valid_check(check_path, message, end):
    if not os.path.exists(check_path):
        print message
        if end == 'true':
            quit()

valid_check(drive_bin, 'drive binary not found. Install drive from: https://github.com/odeke-em/drive \nIf drive is already installed, change the drive_bin variable to point to the binary file.', 'true')
valid_check(settings_json, "settings.json file not found\n Current path to settings.json is: {}\n Change the settings_json variable to the settings.json path, if required".format(settings_json), 'true')
valid_check(notify_path, 'notify does not exist. Push notifications will not function. \nInstall notify from: https://github.com/mashlol/notify', 'false')

with open(settings_json, 'r') as file:
    settings_json = file.read()
    settings_json = json.loads(settings_json)



n = 0
for user in settings_json:
    drive_user = settings_json[n]['drive_user']
    drive_path = settings_json[n]['drive_path']
    
    n += 1

    valid_check(drive_path, 'drive path does not exist for {}. Create path and configure drive to use this script.'.format(drive_user), 'true')
    
    os.system('cd ' + drive_path + ' && ' +  drive_pull)

    script_time = str(datetime.datetime.now() - script_start)
    notify_command = "notify -i 'pyDrive backup executed for {}' -t 'Run time: ".format(drive_user) + script_time + "'"
    os.system(notify_command)
