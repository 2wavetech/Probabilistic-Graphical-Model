# Probabilistic Graphical Model - Programming Assignements

## 1. Simple Bayesian Network for Knowledge Engineering
In the first part of the assignment, we will use the SAMIAM package to design a small Bayesian network for evaluating credit-worthiness. Then, in the second part of the assignment, we will replicate some of the functionality in SAMIAM for answering probability queries in the network using the factor operations discussed in the lectures. We will test our implementation on the network we designed in the first part of the assignment.

More details can be found [here](https://github.com/2wavetech/Probabilistic-Graphical-Model-I---Representations/blob/master/Decision-Making-Release/PA-Decision-Making.pdf).

## 2. Decision Making
We have learned how to model uncertainty in the world using graphical models and how to perform queries on those models to ask questions about the world. We have also learned the basics of decision making in this uncertain world using the principle of maximum expected utility. In this assignment, we will explore how to represent decision making in the framework of graphical models along with some of the algorithmic issues that arise. Specifically, we will learn how to represent influence diagrams as a sort of Bayes Net and perform inference over this representation. By the end of this assignment, we will have applied these new techniques to solve a real-world problem in medical care and treatment.

More details can be found [here](https://github.com/2wavetech/Probabilistic-Graphical-Model-I---Representations/blob/master/Decision-Making-Release/PA-Decision-Making.pdf).

## 3. Bayes Nets for Genetic Inheritance
Genetic counselors want your help in advising couples with a family history of a genetic disease. Specifically, they want to help such couples decide whether to have a biological child or to adopt by assessing the probability that their un-born child will have the disease. Through this assignment, we will see how Bayesian networks can be used to determine such probabilities through modeling the mechanism of genetic inheritance.

More details can be found [here](https://github.com/2wavetech/Probabilistic-Graphical-Model-I---Representations/blob/master/BNs-for-Genetic-Inheritance-Release/PA-BNs-for-Genetic-Inheritance.pdf).

## 4 Markov Networks for OCR
In the last assignment, you used Bayesian networks to model real-world genetic inheritance networks. Your rival claims that this application to genetic inheritance underscores the limited applicability of graphical models, because one doesn’t often find problems with network structures that clear. To prove him wrong, you decide to apply the graphical model framework to the task of
optical character recognition (OCR), a problem that is considerably messier than that of geneticinheritance. Your goal is to accept as input an image of text and output the text content itself.

More details can be found [here](https://github.com/2wavetech/Probabilistic-Graphical-Model-I---Representations/blob/master/PA-Markov-Networks-for-OCR-Release/PA-Markov-Networks-for-OCR.pdf).

## 5. Belief Propagation Algorithm for Exact Inference

We will explore clique tree message passing in this assignment, and by its end, will have created an inference engine powerful enough to handle probabilistic queries and find MAP assignments over the genetic inheritance networks from the second programming assignment and the OCR networks from the third programming assignment, respectively. Here are the steps:

    1. Clique Tree Construction
    2. Message Passing in a Clique Tree
    3. Message Ordering
    4. Sum-Product Message Passing
    5. Max-Sum Message Passing

More details can be found [here](https://github.com/2wavetech/Probabilistic-Graphical-Model/blob/master/Exact-Inference/PA4Description_release.pdf).

## 6. Sampling Methods
In the last project, we focused on implementing exact inference methods. Unfortunately, sometimes performing exact inference is intractable and cannot be done as performing exact inference in general networks is NP-hard. Fortunately, there are a number of approximate inference methods that one can use instead. In this programming assignment, we will investigate a class
of approximate inference methods based on Markov chain Monte Carlo (MCMC) sampling.

We'll start with implementing Gibbs and Metropolis-Hastings sampling, both of which are MCMC methods that sample from the posterior of a probabilistic graphical model.

Now that we have that baseline, let's move on to Swendsen-Wang. Swendsen-Wang was designed to propose more global moves in the context of MCMC for pairwise Markov networks of the type used for image segmentation or Ising models, where adjacent variables like to take the same value. At its core, it is a graph node clustering algorithm.

More details can be found [here](https://github.com/2wavetech/Probabilistic-Graphical-Model/blob/master/Sampling%20Methods/PA-Sampling-Methods.pdf).

## 7. CRF Learning for OCR

Earlier in this course, you learned how to construct a Markov network to perform the task of optical character recognition (OCR). The values in each factor, however, were provided for you.

This assignment returns to the same OCR task, but this time you will write the code to learn the factor values automatically from data.  This assignment is divided into two parts. In the first part, we use a small (but real) parameter learning task to introduce a handful of key concepts applicable to nearly any machine learning problem:

- Stochastic gradient descent for parameter learning
- Training, validation, and test data
- Regularization

In the second part of the assignment, you will apply these techniques to the OCR task. In particular, you will construct a Markov network similar to the one from before and use stochastic gradient descent to learn the parameters of the network from a set of training data. Be sure to get a head start on this assignment! The first part introduces a set of new concepts,
and the second is rather intricate.

More details can be found [here](https://github.com/2wavetech/Probabilistic-Graphical-Model/blob/master/CRF-Learning-For-OCR/PA-CRF-Learning-For-OCR.pdf).

## 8. Learning Tree-structured Networks

In previous projects, you have learned about parameter estimation in probabilistic graphical models, as well as structure learning. In this programming assignment, you will explore structure learning in probabilistic graphical models from a synthetic dataset. In particular, we will provide you synthetic human and alien body pose data. We use a directed model to represent their body poses. You will tackle problems including learning CPDs for continuous variables and learning tree-structured graphs among body parts. Finally, you will use the learned models to classify unseen pose data as either humans or aliens.

More details can be found [here]().

## 9. Learning with Incomplete Data

In the previous programming assignment, you learned tree-structured Bayesian networks to represent body poses. In this assignment, you will be using the network you learned for human poses (in the previous assignment) to perform action recognition on real-world KinectTMdata.

The KinectTMdata was collected by performing actions and extracting the human pose data associated with each action. We have collected data for the following three actions: \clap", \high kick", and \low kick". Your goal in this assignment is to build a model that is able to identify the action performed.

The approach that we will take in this assignment is to model an action as a sequence of poses. However, unlike in the previous programming assignment, we do not have the class labels for these poses. More specifically, in that assignment we knew whether a pose belonged to a human or an alien, but in the KinectTMdata, we do not know in advance what poses comprise an action. In fact, we do not even know what the possible poses that comprise the various actions are. As such, we will have to build and learn models that incorporate a latent variable for pose classes, which makes this a more challenging task than the classification problem you previously solved. You will make extensive use of the Expectation-Maximization (EM) algorithm to learn these models with latent variables.
