import yaml
#from smpl_io import io
from yaml.loader import SafeLoader
base64_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

# TODO switch to smpl_io sed
db = yaml.load(open("database.yml",'r').read().replace('\t',"  "),Loader=SafeLoader)
print(db.keys())
l = list(db.keys())[1:]
print(db[l[0]])

def hash_to_ids_ext_b64(hash):
    ids = []
    c = 0 
    while c < len(hash):
    #for pc in hash:
        id = 0
        factor = 1
        p = base64_chars.find(hash[c])
        if p == -1:
            raise RuntimeError("Invalid hash character")
        d = p
        while d < 32:
            id += factor * d
            factor *= 32
            c = c +1
            pc = hash[c]
            p = base64_chars.find(pc)
            if p == -1:
                raise RuntimeError("Invalid hash character")
            d = p
        id += factor * (d - 32)
        c = c +1
        ids.append(id)
    return ids


for k in db[l[0]].keys():
    print(hash_to_ids_ext_b64(k))

#	const char* pc = hash;
#	while (*pc)
#	{
#		unsigned id = 0;
#		unsigned factor = 1;
#		const char* p = strchr(base64_chars, *pc);
#		if (!p)
#		{ throw std::runtime_error("Invalid hash character"); }
#		size_t d = p - base64_chars;
#		while (d < 32)
#		{
#			id += factor * d;
#			factor *= 32;
#			++ pc;
#			p = strchr(base64_chars, *pc);
#			if (!p)
#			{ throw std::runtime_error("Invalid hash character"); }
#			d = p - base64_chars;
#		}
#		id += factor * (d - 32);
#		++ pc;
#		ids.push_back(id);
#	}
