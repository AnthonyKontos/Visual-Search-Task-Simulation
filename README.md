# Visual-Search-Task-Simulation

## Instructions

   1. Adjust settings for the experiment in `searchSettings.m` 
      - amount of trials
      - amount of stimulus absent trials
      - image and results file paths
      - text/background color
      - rest period
   3. Run `visualSearch.m` with participant ID/number
      - `visualSearch(33)`
   4. Use appropriate keys to start or end the experiment and indicate whether a stimulus is present or absent
      - **Z** to begin the experiment
      - **Q** to quit the experiment
      - **Y** to indicate stimulus present
      - **N** to indicate stimulus absent

## Description & Statistics

Signal detection theory (SDT) allows us to statistically analyze decision-making in conditions of uncertainty. In this experiment, we will be evaluating the decision-maker's ability to differentiate between visual distractors and successfuly identify the target stimulus. Each trial will contain a set of rectangles with different attributes color (**black** or **grey**) and orientation (**horizontal** or **vertical**). The decision-maker will be tasked with identifying the target stimulus which will differ from all other distractors across one attribute. 

As a result, each decision will have four possible outcomes: 

![Outcome chart](https://i.ibb.co/GcJ7r6B/HIT-OR-MISS.png)

Using the compiled data over multiple trials, we can calculate the **sensitivity** and the **specificity** for each participant:

![Sensitivity and Specificity Calcs](https://i.ibb.co/GHLj9Cd/Specificity-Sensitivity.png)

We can illustrate the performance of each participant on this task by plotting the **true positive rate** against the **false positive rate** (or **sensitivity** vs. **1-speicificity**). This is called a **Receiver Operating Characteristic** (ROC) curve. We can use the Area Under the Curve (AUC) to determine the probability that a participant will be able to distinguish between stimulus trials and deception trials at random. This value generally falls between 0 and 1 -- 0 representing chance performance and 1 representing perfect performance:

![ROC and AUC](https://i.ibb.co/Y7K0Yzq/ROC-and-AUC.png)

## Rationale 

The goal of the visual search simulation I created in MATLAB is highly relevant to psychology of perception and is mainly concerned with two psychological constructs: visuo-spatial attention and visual perception. Somewhat like the change blindness simulation demonstrated in class, the visual search task attempts to assess the participant’s attentional skills by evaluating their ability to quickly discriminate between stimuli. Because attention cannot be psychometrically measured directly, researchers often operationalize attentional capacity temporally by the time elapsed between presentation of a particular image or set of images and detection of some target stimulus. Due to the high numerical precision and accuracy in measurement provided by computerized visual search tasks, they are highly effective for this purpose. The experiment emphasizes the process of endogenous orienting in the context of a visual search task; willful, goal-oriented attentional focus on some space or stimulus (Rohenkohl et al., 2011).

Our own program implements a visual search task in the form of a conjunction search – a search process characterized by identification of a target stimulus which differs from distractors possessing at least one feature in common. Though the experimental script can be loaded with any preconstructed images, the default images consist of black and grey rectangles also differing in orientation (but only between colors). Development of an assessment with these orientation differences in stimuli is justified by research which shows that search for a vertical or horizontal target among distractors is inefficient (Wolfe et al., 1992). The subject is tasked with identifying which rectangle is oriented in a different manner compared to others of the same color. Hence, the main visuo-spatial processing mechanism being evaluated in this experiment is parallel processing, the ability to process stimuli with different qualities simultaneously (McElree & Carrasco, 1999).

The task can also be said to reflect the Stroop effect to some extent – participants experience a delay in reaction time due to mismatches in features of the stimuli. However, a proportion of trials have no target stimuli present and thus the subject is often forced to make sacrifices between reaction time and accuracy. This is also meant to account for research findings which suggest that attention is relatively more efficient in visual search trials where the relevant features are the same as those searched for in previous trials (Kristjansson et al., 2002).


### References

Kristjánsson, Á., Wang, D. L., & Nakayama, K. (2002). The role of priming in conjunctive visual search. Cognition, 85(1), 37–52. https://doi.org/10.1016/s0010-0277(02)00074-4

McElree, B., & Carrasco, M. (1999). The temporal dynamics of visual search: Evidence for parallel processing in feature and conjunction searches. Journal of Experimental Psychology: Human Perception and Performance, 25(6), 1517–1539. https://doi.org/10.1037/0096-1523.25.6.1517

Rohenkohl, G., Coull, J. T., & Nobre, A. C. (2011). Behavioural Dissociation between Exogenous and Endogenous Temporal Orienting of Attention. PLoS ONE, 6(1). https://doi.org/10.1371/journal.pone.0014620

Wolfe, J. M. (1992). “Effortless” texture segmentation and “parallel” visual search are not the same thing. Vision Research, 32(4), 757–763. https://doi.org/10.1016/0042-6989(92)90190-t
