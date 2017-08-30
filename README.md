# Probabilistic Graphical Model I - Representations

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

## 5. Belief Propagation algorithm

We will explore clique tree message passing in this assignment, and by its end, will have created an inference engine powerful enough to handle probabilistic queries and find MAP assignments over the genetic inheritance networks from the second programming assignment and the OCR networks from the third programming assignment, respectively. Here are the steps:

    1. Clique Tree Construction
    2. Message Passing in a Clique Tree
    3. Message Ordering
    4. Sum-Product Message Passing
    5. Max-Sum Message Passing
