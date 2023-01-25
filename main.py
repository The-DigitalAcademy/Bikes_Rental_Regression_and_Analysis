from flask import Flask, render_template, request
from joblib import load
import joblib as jb
import numpy as np


app = Flask(name)

model = jb.load('linear_regression_model.joblib')

@app.route('/')
def index():
    return render_template("index2.html")

@app.route('/predict', methods=['POST'])
def predict():
    # get the input data from the form
    temp = float(request.form['temp'])
    hum = float(request.form["hum"])
    windspeed = float(request.form["windspeed"])
    season = int(request.form["season"])
    yr = int(request.form["yr"])
    mnth = int(request.form["mnth"])
    holiday = int(request.form["holiday"])
    weekday = int(request.form["weekday"])
    workingday = int(request.form["workingday"])
    weathersit = int(request.form["weathersit"])

    input_data= np.array([[season,yr,mnth,holiday,weekday,workingday,weathersit,temp,hum,windspeed]])

    prediction=model.predict(input_data)

    return render_template('predict2.html', prediction = prediction)

if name == "main":
    app.run(debug=True, port=5001)