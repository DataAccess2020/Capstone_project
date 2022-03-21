# Sensitivity on gender equality in Italian parliament: a comparison between genders and parties 
_Capstone project data access and regulation 2022_ :dart:

1. :microscope:Domanda di ricerca: do women deputies talk about gender equality and gender discrimination more than men deputies? Do left women talk about gender equality more than right men and women?
Previous research investigating similar issues:
- Bratton, K. A., Haynie, Kerry L., Agenda Setting and Legislative Success in State Legislatures: The Effects of Gender and Race
- Reingold, B., Concepts of Representation Am Female and Male State Legislators
- Bratton, A.K., Haynie, K.L., Reingold, B., Agenda Setting and African American Women in State Legislatures
- Caul, M., Women's Representation in Parliament
2. :question:  Hypothesis
 - 1: women tend to talk about gender equality more than men 
 - 2: left women thend to talk about gender equality more than right men and women
Theory: political representativeness as a mirror: is similarity required in order to achieve a representative parliament? (https://www.senato.it/application/xmanager/projects/leg18/file/repository/relazioni/libreria/novita/XVIII/sartori_lezione_def.pdf)
3.	:open_file_folder: I will use open data from the site https://dati.camera.it/it/dati/.
I will take into consideration the XVII legislature because, with the exception of the current one which is still ongoing, the XVII is the legislature in which the highest number of women deputies has been elected. I will select interventions in which deputies have been talking about gender equality and will verify if they were mostly made by women or men. Then, I will differentiate according to the belonging parliamentary group of the deputy, in order to detect potential differences between left and right wing parites.
At a later time, I will take into consideration all interventions which took place in 2015 (the only year, during the XVII leguslature, in which no changes in terms of  ruling parties occurred), and I will verify if the percentage of women is higher within discussions about gender equality, differentiating for parliamentary group.
4.	:chart_with_upwards_trend: I will test the association between gender and gender-related discussions through a chi-squared test. Then, I will analise standardized residuals in order to determine the direction of the possible association between these variables. 
5. :bulb: I expect that both the chi-squared statistic and the p-value will be greater than zero. Moreover, I expect that women who belong to progressive parties (i.e. left-wing parties) will tend to draw the attention of the patliament on women rights more than their conservative collegues (i.e right-wing parties). If this hypothesis will turn out to be true, I will obtain a positive value of my standardized residuals for the category 'left-wing women', since they express the number of standard errors that f0 − fe falls from the value of 0 that we expect when there is independence.

# Folder structure 
 
- 00_UsefulDocuments: bibliographic references
- 01_DataImport_Cleaning: data import + data cleaning 
- 02_TextMining_DataVis: Text mining + data visualization
- 03_Chisq_graphs: Chi-squared test + graphs.pdf
- 04_Report: Report (.Rmd, .pdf)
- Data.csv: datasets 

