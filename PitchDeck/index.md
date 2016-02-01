---
title       : A Comparison of a Linear Model with Neural Networks for Solubility Data
subtitle    : Applying models to solubility data from "Applied Predictive Modeling"
author      : Brian Costa
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## Background

This application builds 3 predictive models in order to compare the performance of a linear model with two variations of neural networks in the context of compound solubility data.

The source data comes from "Applied Predictive Modeling" by Kuhn and Johnson, and is described in chapter 6.1 - "Case Study: Quantitative Structure-Activity Relationship Modeling". In summary the data contains a large number of predictors related to quantified characteristics of the compound and one response variable, the solubility of each compound.

Code for loading the data:



```r
library(AppliedPredictiveModeling)
data(solubility)
```

---

## Approach

This application follows the approach outlined in section 6.2 for creating the linear regression model for the solubility data and uses those results as the baseline against which the neural network models are compared.

The desired outcome is to determine if a non-linear neural network model can achieve greater prediction accuracy with this data when compared to ordinary least squares linear regression using an unseen "hold out" test set.

Neural networks are highly non-linear systems that are iteratively adjusted through supervised learning.  They have a number of tune-able parameters for which no closed form optimization formula exists - it's all just trial and error.  Primers on neural networks include "Neural Networks for Pattern Recognition" - Christopher M. Bishop, and "Neurcomputing" - Robert Hecht-Nielsen

---

## Approach

Given the nature of the system NNs are prone to over-fitting the training data resulting in poor generalization.  In this application an adjustable regularization parameter is included in an attempt to penalize large coefficients in the final model in an attempt to fight over-fitting.  Additionally it is possible to adjust the number of neurons in the hidden layer (the model only supports a single hidden layer), to allow the user to experiment with different network configurations.

Can Adjust:

- Number of neurons in the hidden layer of the neural networks
- A regularization parameter (penalty) that attempts to reduce the coefficients (weights) on the neurons
- The number of independent neural networks that are averaged together in the third model 

---

## Data

The data that is used for all three approaches consists of Box-Cox transformed continuous and binary predictors with the high correlation predictors removed so that no absolute pairwise correlations greater than 0.75 exist.  The remaining predictors are used to predict a continuous "solubility" variable.


```r
ncol(trainingData)
```

```
## [1] 141
```

```r
nrow(trainingData)
```

```
## [1] 951
```


```r
nrow(testingData)
```

```
## [1] 316
```

---

## The Models

lm - The baseline model is an ordinary least squares regression linear model and is fit when the application starts since it is a static model.

single NNet - This is a single neural network where the user has the ability to adjust the number of hidden neurons in the model and the regularization parameter that is used to coerce the neural network weights toward "0" in an attempt to fight the NNs natural tendency to over-fit the training data.

averaged NNets - This is a model with the average response from a number of independently trained NNs are averaged to produce a prediction.  The reason for this is that by their nature NNs tend to train to "local optima" in their models rather than a "global optima", and better results can often be had using multiple networks and then averaging the results.  This is not guaranteed though.




---
## Results

I've run the models a number of times and typically the single neural network does not perform as well as the linear regression (higher RMSE and lower RSquared).  The single neural network is starting from a different randomly initialized starting point each time it is trained, so adjust the controls and try it a few times.

The averaged approach to the neural networks is capable of performing better than the linear model, but not always and rarely by very much.  The regularization penalty seems to work will in that the performance on the hold-out data indicates reasonable generalization.

Overall given the simplicity and interpretability of the linear model it performs really well.


