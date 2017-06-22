RF-gbm comparison with California Housing data

This directory contains code and data to generate a plot that compares Random Forest and Gradient Boosting Machine. It is to reproduce Figure 15.3 in the textbook below [1].

The data (California Housing) was obtained from http://www.dcc.fc.up.pt/~ltorgo/Regression/cal_housing.html.

The code is written in R, and it uses RandomForest package and gbm package in R. They need to be installed beforehand.

The top-level shell script is src/run-2.sh. It needs three arguments: number of points, increment of trees, and the output plot file. Here's an example to generate two plots.

    % cd src
    % ./run-2.sh 100 3 run2-300.pdf
    % ./run-2.sh 100 30 run2-3k.pdf     

The log files and the output pdf files are in the out/ directory, for reference.

[1] Hastie, Tibshirani and Friedman
    The Elements of Statistical Learning (2nd edition),
    2009, Springer-Verlag

