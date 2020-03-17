DT1 <- fread("data/HNSCCT-input.csv", na.strings = c("",NA,"unknown"))
DT2 <- fread("data/HNSCCT-outcome.csv", na.strings = c("",NA,"unknown"))

type <- sapply(str_split(DT1$`Case ID`,"_"), function(i) i[1])
ID <- sapply(str_split(DT1$`Case ID`,"_"), function(i) as.numeric(as.character(i[2])))
table(DT2$Dx, type)
DT1[, `Anonymized ID`:= sapply(str_split(DT1$`Case ID`,"_"), function(i) as.numeric(as.character(i[2])))]
DT1[, `Site`:= factor(sapply(str_split(DT1$`Case ID`,"_"), function(i) i[1]))]

setkey(DT1, "Anonymized ID")
setkey(DT2, "Anonymized ID")

DT <- data.table::merge.data.table(DT2, DT1, by = "Anonymized ID")
data.table::setnames(DT, old = "T", new = "Tstage")
data.table::setnames(DT, old = "N", new = "Nstage")
data.table::setnames(DT, old = "pN+", new = "pN")


# clean Nodal Stage
DT$pN %>% table(useNA = "al")
DT$Nstage %>% table(useNA = "al")
DT[pN %in% c("no","No"), NodalStage := "NEG"]
DT[pN %in% c("yes","Yes"), NodalStage := "POS"]
DT[is.na(pN) & Nstage == "N0", NodalStage := "NEG"]
DT[is.na(pN) & Nstage %in% c("N1","N2a","N2b","N2c","N3"), NodalStage := "POS"]
DT[, table(NodalStage, useNA = "al")]

# Clean covariates
DT[,table(`Smoking Hx`, useNA = "al")]
DT[`Smoking Hx` %ni% "unknown", Smoking := `Smoking Hx`]
DT[`Smoking Hx` == "unknown", Smoking := NA]

DT[`Drinking hx` %in% c("ex-drinker", "heavy", "light", "Moderate", "non-drinker"), Drinking := `Drinking hx`]
DT[`Drinking hx` %in% c("unknown",""), Drinking := NA]

DT[Tstage %ni% c("","TX"), Tstage := Tstage]
DT[Tstage %in% c("","TX"), Tstage := NA]

DT[, table(`Smoking Hx`, useNA = "al")]
DT[, Smoking := factor(Smoking, levels = c("Non-smoker","Ex-smoker","Current"))]
DT[, table(Smoking, useNA = "al")]
DT[, table(`Drinking hx`, useNA = "al")]
DT[, table(Drinking, useNA = "al")]
DT[, Drinking := factor(Drinking, levels = c("non-drinker","ex-drinker","light","Moderate","heavy"))]
DT[, table(Tstage, useNA = "al")]
DT[Tstage %in% c("T1","T1a","T1b"), TstageGroup := "T1"]
DT[Tstage %in% c("T2"), TstageGroup := "T2"]
DT[Tstage %in% c("T3"), TstageGroup := "T3"]
DT[Tstage %in% c("T4","T4a","T4b"), TstageGroup := "T4"]
DT[, table(TstageGroup, useNA = "al")]
DT[, TstageGroup := factor(TstageGroup)]

# Clean other outcomes
DT[PNI %in% c("no","No"), PNI := "NEG"]
DT[PNI %in% c("yes","Yes"), PNI := "POS"]
DT[LVI %in% c("no","No"), LVI := "NEG"]
DT[LVI %in% c("yes","Yes"), LVI := "POS"]
DT[, table(HPV, useNA = "al")]
DT[, table(PNI, useNA = "al")]
DT[, table(LVI, useNA = "al")]
DT[, table(NodalStage, useNA = "al")]
DT[, PNI := factor(PNI)]
DT[, HPV := factor(HPV)]
DT[, LVI := factor(LVI)]
DT[, NodalStage := factor(NodalStage)]


DT$NodalStage %>% table(useNA = "al")
DT$`Smoking Hx` %>% table(useNA = "al")
DT$`Drinking hx` %>% table(useNA = "al")
DT$Tstage %>% table(useNA = "al")


texture_names <- grep("SS", colnames(DT), value = T)
length(texture_names)
colnames(DT)
covariates <- c("Site","Smoking","Drinking","TstageGroup")
outcomes <- c("NodalStage","HPV","PNI","LVI")




DT_final <- DT[, c(outcomes, covariates, texture_names), with = F]


rm(DT1, DT2, DT, ID, type)









