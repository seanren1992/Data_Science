### Data visualization R
### R_Correlation
### Author: David Li

plot(SEMSummary(
  ~ MOOD + SOLacti + DBAS + DAS + Stress + SSQ,
  data = adosleep), plot = "cor") +
  theme(axis.text.x = element_text(
          angle = 45, hjust = 1, vjust = 1))
