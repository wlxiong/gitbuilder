from fabric.api import env

env.roles = ['tester', 'master', 'shadow', 'logger', 'chunk', 'client']
env.hosts = ['10.10.200.114',
             '10.10.200.115',
             '10.10.200.116',
             '10.10.200.117',
             '10.10.200.118',
             '10.10.200.119']
env.roledefs['tester'] = ['10.10.200.114']
env.roledefs['master'] = ['10.10.200.114']
env.roledefs['shadow'] = ['10.10.200.115',
                          '10.10.200.116']
env.roledefs['logger'] = ['10.10.200.114',
                          '10.10.200.115',
                          '10.10.200.116']
env.roledefs['chunk']  = ['10.10.200.114',
                          '10.10.200.115',
                          '10.10.200.116',
                          '10.10.200.117',
                          '10.10.200.118',
                          '10.10.200.119']
env.roledefs['client'] = ['10.10.200.114',
                          '10.10.200.115',
                          '10.10.200.116',
                          '10.10.200.117',
                          '10.10.200.118',
                          '10.10.200.119']
user = 'root1'

gfs_build_dir   = "../build"
gfs_install_dir = '/usr/local/gfs'
gfs_bin_dir  = '/usr/local/gfs/bin'
gfs_conf_dir = '/usr/local/gfs/conf'
gfs_test_dir = '/home/%s/gfstest' % user
