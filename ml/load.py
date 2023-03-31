import yaml
#from smpl_io import io
from yaml.loader import SafeLoader

# TODO switch to smpl_io sed
db = yaml.load(open("database.yml",'r').read().replace('\t',"  "),Loader=SafeLoader)
print(db.keys())
l = list(db.keys())[1:]
print(db[l[0]])