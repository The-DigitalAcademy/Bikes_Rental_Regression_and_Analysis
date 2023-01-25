import joblib as jb
from joblib import dump, load
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestRegressor



my_day = pd.read_csv("day.csv")

my_day = my_day.drop(columns=['instant','dteday', 'atemp',	'casual','registered'])

X = my_day.drop(['cnt'], axis=1)
y = my_day['cnt']

# train the model
lm = RandomForestRegressor()
from sklearn.tree import DecisionTreeClassifier
dt = RandomForestRegressor()

X_train,X_test,y_train,y_test = train_test_split(X,y, test_size= 0.1,random_state=49)
dt.fit(X_train, y_train)
y_pred_test = dt.predict(X_test)
# save the model to a file
jb.dump(dt, 'linear_regression_model.joblib')

# load the model from the file
loaded_model = load('linear_regression_model.joblib')
from sklearn.metrics import r2_score

filename = 'linear_regression_model.joblib'
jb.dump(dt,filename)
print('Model saved successfully')
r2=r2_score(y_test,y_pred_test)
print(r2)
