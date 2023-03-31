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
    while len(ids) < 12:
        ids.append(0)
    return ids

import hashlib

xdata = [] # 10 + 10 ids each
ydata = [] # one score
for ll in l:
    for k in db[ll].keys():
        for kk in db[ll][k]:
            hfield = int(hashlib.sha256(ll.encode()).hexdigest(), 16) % (10 ** 9)
            #print(hfield)
            res = db[ll][k][kk].split(" ")
            if int(res[-1]) > 10000:
                xdata.append([hfield] + hash_to_ids_ext_b64(k) +  hash_to_ids_ext_b64(kk))
                ydata.append(float(res[0]) / float(res[-1]))
                print(k,hash_to_ids_ext_b64(k), kk , hash_to_ids_ext_b64(kk), float(res[0]) / float(res[-1]), res[-1])

# evaluate xgboost algorithm for classification
from numpy import asarray, asmatrix
from numpy import mean
from numpy import std
from sklearn.datasets import make_regression
from sklearn.model_selection import cross_val_score
from sklearn.model_selection import RepeatedStratifiedKFold
from xgboost.sklearn import XGBRegressor
from sklearn.model_selection import RepeatedKFold

#X, y = make_regression(n_samples=1000, n_features=20, n_informative=15, noise=0.1, random_state=7)
X, y = asmatrix(xdata), asarray(ydata)
#print(xdata)
# define the model
model = XGBRegressor()
model.fit(X,y)
# evaluate the model
#cv = RepeatedKFold(n_splits=10, n_repeats=3, random_state=1)
#n_scores = cross_val_score(model, X, y, scoring='neg_mean_absolute_error', cv=cv, n_jobs=-1, error_score='raise')
# report performance
#print('MAE: %.3f (%.3f)' % (mean(n_scores), std(n_scores)))

# aOhdOsUVtZJvZJvXSwPN9dW9cO+MN/ [1498, 12765, 14004, 15673, 15673, 16983, 30127, 30429, 31196, 32172, 0, 0] aOhdOsUVtZJvZJvXSwPN9dW9cO+ME/MN/ [1498, 12765, 14004, 15673, 15673, 16983, 30127, 30429, 31196, 31884, 32172, 0]
print(model.predict([[1498, 12765, 14004, 15673, 15673, 16983, 30127, 30429, 31196, 32172, 0, 0,1498, 12765, 14004, 15673, 15673, 16983, 30127, 30429, 31196, 31884, 32172, 0]]))
from sklearn2pmml import sklearn2pmml
from sklearn2pmml.pipeline import PMMLPipeline

pmml_pipeline = PMMLPipeline([
  ("regressor", XGBRegressor())
])
pmml_pipeline.fit(X, y)
pmml_pipeline.configure(compact = False)
sklearn2pmml(pmml_pipeline, "tuo.pmml")

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
