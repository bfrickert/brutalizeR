
# coding: utf-8

# In[493]:

import pandas as pd
import matplotlib.pyplot as plt
from sklearn import datasets, svm, metrics
from sklearn.cross_validation import train_test_split
import numpy as np
from os import listdir
from os.path import isfile, join
from sknn.mlp import Regressor, Layer
import itertools
import theano
np.random.seed(666)


# In[494]:

mypath = '../matrices/black/'
onlyfiles_black = [f for f in listdir(mypath) if isfile(join(mypath, f,)) and f.endswith('.csv')]
targets_black = np.repeat(np.array(['is.black.metal']), len(onlyfiles_black), axis=0)

#mypath = '../matrices/death/'
#onlyfiles_death = [f for f in listdir(mypath) if isfile(join(mypath, f)) and f.endswith('.csv')]
#targets_death = np.repeat(np.array(['is.death.metal']), len(onlyfiles_death), axis=0)

mypath = '../matrices/gogos/'
onlyfiles_gogos = [f for f in listdir(mypath) if isfile(join(mypath, f)) and f.endswith('.csv')]
targets_gogos = np.repeat(np.array(['is.gogos']), len(onlyfiles_gogos), axis=0)


# In[495]:

mypath = '../matrices/vacation/'
onlyfiles_vacation = [f for f in listdir(mypath) if isfile(join(mypath, f)) and f.endswith('.csv')]
targets_vacation = np.repeat(np.array(['is.gogos']), len(onlyfiles_vacation), axis=0)


# In[496]:

def format_matrices(filename):
    df = pd.DataFrame()
    df = df.from_csv(filename, index_col=None, header=None)
    return df.values
  


# In[497]:

matrices_black = [format_matrices('../matrices/black/{0}'.format(f)) for f in onlyfiles_black]
minimum_black = min([len(m) for m in matrices_black])
#matrices_death = [format_matrices('../matrices/death/{0}'.format(f)) for f in onlyfiles_death]
#minimum_death = min([len(m) for m in matrices_death])
matrices_gogos = [format_matrices('../matrices/gogos/{0}'.format(f)) for f in onlyfiles_gogos]
minimum_gogos = min([len(m) for m in matrices_gogos])
#minimum = min(minimum_black, minimum_death, minimum_gogos)
minimum = min(minimum_black, minimum_gogos)


# In[498]:

matrices_vacation = [format_matrices('../matrices/vacation/{0}'.format(f)) for f in onlyfiles_vacation]
minimum_vacation = min([len(m) for m in matrices_vacation])


# In[499]:

#matrices = np.asarray([m[:minimum] for m in matrices_black + matrices_death + matrices_gogos])
matrices = np.asarray([m[:minimum] for m in matrices_black + matrices_gogos])


# In[500]:

#matrices = np.asarray([m[:minimum] for m in matrices_black + matrices_death + matrices_gogos])
matrices_vacation = np.asarray([m[:minimum] for m in matrices_vacation])


# In[501]:

#targets = np.concatenate((targets_black, targets_death, targets_gogos))
targets = np.concatenate((targets_black, targets_gogos))


# In[502]:

n_samples = len(matrices)
data = matrices.reshape((n_samples, -1))


# In[503]:

n_samples = len(matrices_vacation)
data_vacation = np.asarray(matrices_vacation).reshape((n_samples, -1))


# In[504]:

# Create a classifier: a support vector classifier
classifier = svm.SVC(gamma=.001)


# In[554]:

X_train, X_test, y_train, y_test = train_test_split(
    data, targets, test_size=0.25, random_state=667)


# In[555]:

classifier.fit(X_train, y_train)


# In[556]:

# Now predict the value of the digit on the second half:
predicted = classifier.predict(X_test)
predicted


# In[557]:

# Now predict the value of the digit on the second half:
predicted = classifier.predict(data_vacation)
predicted


# In[558]:

np.mean(predicted == y_test)


# In[559]:

y_test

