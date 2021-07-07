  
import os
from pyats.easypy import run
from genie import testbed
import yaml


def main(runtime):
    runtime.mailbot.mailto = ['agorbachev']
    tb = testbed.load(os.path.join('./testbed.yaml'))
        
    with open("./.credentials.yaml", 'r') as stream:
        tmp_creds = yaml.safe_load(stream)
    
    for seq in range(18):
    #for seq in [0]:
        prefix = "comp-{:02d}".format(seq + 1)
        
        tb.devices['localhost'].custom.rg = 'rg-' + prefix
        tb.devices['localhost'].custom.prefix = prefix
        tb.devices['tshoot-cisco-eastus'].connections.ssh.ip = 'eastus.' + prefix + '.az.skillscloud.company'
        tb.credentials['default']['username'] = 'azadmin'  
        tb.credentials['default']['password'] = tmp_creds['credentials'][seq]
        
        
        run(testscript = './ut.py', testbed=tb, datafile=yaml.safe_load('./marking.yaml'), taskid = "Competitor {:02d}".format(seq + 1))
    
