March 17, 2020
======================================

Outcomes: 
  - NodalStage
  - HPV
  - LVI
  - PNI

Covariates:
  - Smoking
  - Drinking
  - TstageGroup

Radiological Features:
  - c("SSF0.mean", "SSF0.sd", "SSF0.entropy", "SSF0.mpp", 
"SSF0.skewness", "SSF0.kurtosis", "SSF2.mean", "SSF2.sd", "SSF2.entropy", 
"SSF2.mpp", "SSF2.skewness", "SSF2.kurtosis", "SSF3.mean", "SSF3.sd", 
"SSF3.entropy", "SSF3.mpp", "SSF3.skewness", "SSF3.kurtosis", 
"SSF4.mean", "SSF4.sd", "SSF4.entropy", "SSF4.mpp", "SSF4.skewness", 
"SSF4.kurtosis", "SSF5.mean", "SSF5.sd", "SSF5.entropy", "SSF5.mpp", 
"SSF5.skewness", "SSF5.kurtosis", "SSF6.mean", "SSF6.sd", "SSF6.entropy", 
"SSF6.mpp", "SSF6.skewness", "SSF6.kurtosis")







Feb 19, 2020
============================
Hey Sahir,

Data that we input -> Smoking.Hx, Drinking.hx, T
Outcomes that we predicted-> HPV, LVI, PNI

The last outcome we wanted to predict was image-based nodal stage (N). Note that the column pN. is the pathology-based nodal stage. This is not available for all patient but we used it to replace the nodal stage where possible. Therefore the final nodal stage outcome was a mix between image-based and pathology-based nodal stages. 

Note that the image-based nodal stage was converted to a binary outcome (N0 was negative, everything else was considered positive). 

Let me know if you have any more questions.

Regards,
Nikesh


January 24, 2020
===========================
- Call with Nikesh about radiological datasets
- Three major datasets:
	- HNSCC (95-100 patients have both 2D and 3D), patients who had surgery, pyradiomics
	- Toronto (Princess Margaret), 600 patients (Texrad/2d? 36 feautres), havent been contoured. Trying to using GE but having issues. Nodal stage (had all 600) has 6 levels, but they turned it into a binary response (265 to 338). Three major sites. The three sites can't combine. It's possible that its not optimal to taining everyone from the same site. It might be better to train: 47 hypo pharynx +  larynx 194, lip and oral 162 (70 to 92), oral pharynx was 200 (32 to 168 for nodal stage)).
	- Nanostring (85-90 patients), CT/MRI, had surgery within a certain range of the surgery, nanotring on normal and cancerous tissue. Has not been contoured. Nanostring is ongoing (20-30 patients). Currently doesn't have the data. HNSCC
