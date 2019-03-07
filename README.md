# bootstrapping
hobby project bootstrapping

This is a comparison between bootstrapping with k-fold comparison. 

##What is Bootstrapping ?
Bootstrapping is a statistical technique originally designed for estimating quantities about populations. The whole idea is to randomly draw a small data sample with replacement from the entire dataset and compute the statistics on the sample (such as mean and standard deviation). 
Repeat this process and then calculate the average statistics across all the samples to describe the population statistics. Bootstrapping can also be used to evaluate a machine learning model. When it comes to that task, bootstrapping would sound very similar to cross validation. 
There are two parameters to be chosen before performing bootstrapping:
Sample size :  


##What is cross validation?
It is a model validation technique, also known as out-of-sampling testing, primarily designed to measure how well 
machine learning models perform. The general procedure of k-fold cross validation works as follows. 
1. Shuffle the dataset randomly.
2. Split the dataset into k groups
3. For each unique group:
  3.1 Take the group as a hold out or test data set
  3.2 Take the remaining groups as a training data set
  3.3 Fit a model on the training set and evaluate it on the test set
  3.4 Retain the evaluation score and discard the model
4. Summarize the skill of the model using the sample of model evaluation scores


##How bootstrapping compares to cross validation?

They are both in fact resampling methods. However there are some differences between them:
Bootstrapping resamples with replacement. Hence, bootstrapped data set may contain multiple instances of the same original case 
and may completely omit other original cases.
Cross validation resamples without replacement which produces a data set that is smaller than the original dataset. 
Cross validation is primarily designed for measuring performance of machine learning models. 
Bootstrapping is however primarily designed for estimating empirical distribution functions statistics. 
There is a leave-one-out cross validation technique analogous to bootstrapping called jackknifing
There is also a bootstrapping technique analogous to cross validation called out-of-bootstrap estimate.  
In practice there's often not much of a difference between iterated kk-fold cross validation and out-of-bootstrap. 
With a similar total number of evaluated surrogate models, total error [of the model prediction error measurement] 
has been found to be similar, although oob (out-of-bootstrap) typically has more bias and less variance than the corresponding CV estimates.


