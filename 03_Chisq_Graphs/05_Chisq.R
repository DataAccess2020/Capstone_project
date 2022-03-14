trevtable <- ftable(trevtable)
chisq <- chisq.test(trevtable)
tibblechisq <- tibble(
  Chisquare=chisq[["statistic"]],
  df=chisq[["parameter"]],
  pvalue=chisq[["p.value"]]
)
tibblechisq
tab <- round(chisq$residuals, 3)
tab

