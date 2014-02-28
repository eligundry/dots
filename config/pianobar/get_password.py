import os, yaml

file_path = '%s/passwords.yml' % os.environ['PWD']
print(yaml.load(open(file_path, 'r'))['pandora'])
