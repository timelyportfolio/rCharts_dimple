---
title: Sankey from Scratch
author: Timely Portfolio
github: {user: timelyportfolio, repo: rCharts_d3_sankey, branch: "gh-pages"}
framework: bootstrap
mode: selfcontained
highlighter: prettify
hitheme: twitter-bootstrap
ext_widgets: {rCharts: "libraries/dimple"}
assets:
  css:
    - "http://fonts.googleapis.com/css?family=Raleway:300"
    - "http://fonts.googleapis.com/css?family=Oxygen"
---

<style>
.container { width: 1000px; }

body{
  font-family: 'Oxygen', sans-serif;
  font-size: 16px;
  line-height: 24px;
}

h1,h2,h3,h4 {
  font-family: 'Raleway', sans-serif;
}

h3 {
  background-color: #D4DAEC;
  text-indent: 100px; 
}

h4 {
  text-indent: 100px;
}
</style>

<a href="https://github.com/timelyportfolio/rCharts_d3_sankey"><img style="position: absolute; top: 0; right: 0; border: 0;" src="https://s3.amazonaws.com/github/ribbons/forkme_right_darkblue_121621.png" alt="Fork me on GitHub"></a>



# Various Dimple Examples for [rCharts Issue #164](https://github.com/ramnathv/rCharts/issues/164)

## Example 1 - A Starting Point



```r
require(rjson)
require(rCharts)

data <- data.frame(rjson::fromJSON('{"Zscore": [  1.594,  0.024,  5.231,  3.933,  6.222,  0.164,  3.324,  2.913,  3.357,  4.041,  5.082,  2.727,  2.739,  3.042,  2.308,  0.286,  1.965,  3.534,  1.518,  4.553,  0.937,  5.124,    0.4,  2.467,  1.475,  1.591,  2.943,  2.081,  3.083,  4.252,  3.951,  3.006,  3.578,  3.332,  3.641,  1.918,  4.157,  1.074,  3.416,  1.729, -0.229,  2.765, -0.071,  0.321,  4.151,  2.497,  2.295,  0.911,  1.949,  3.285,      3,  -1.23, -0.894,  0.853,   3.59,  3.643,  1.772,  2.276,  2.301,  3.088,   0.07,  2.422,  1.572,  1.864,  0.408,  0.838,  1.202, -0.645,  0.794,  0.866,  1.978,   1.14,  0.603,  3.268, -1.378,  2.304,  2.038,  1.275,  1.486,  2.979,  1.657,  1.726,  3.169,  0.607,  4.511,  1.238,   0.71,  2.314,   0.68, -0.239,  2.588,  2.258,  0.951,  0.723,  1.665,  3.637,  3.317,  1.984,  1.638,  2.151,   2.29,  1.535,  0.732,  0.833,  2.519,  0.929,   2.12,  0.301,  0.817,   1.95,  2.226,  1.785,   1.66,  1.131,  0.883,  1.529,  2.457,  5.625,  1.475,  1.422,  2.935,  3.513,  2.931,  0.927, -0.246 ],
"Cell": [ "HTR8svn", "Adult_CD4+", "CD14+", "CD20+", "CD34+", "CLL", "CMK", "GM06990", "GM12864", "GM12865", "GM12878", "GM12891", "GM12892", "GM18507", "GM19238", "GM19239", "GM19240", "HL-60", "Jurkat", "K562", "NB4", "Th1", "Th2", "AoAF", "AoSMC", "HBMEC", "HMVEC-dAd", "HMVEC-dBl-Ad", "HMVEC-dBl-Neo", "HMVEC-dLy-Ad", "HMVEC-dLy-Neo", "HMVEC-dNeo", "HMVEC-LBl", "HMVEC-LLy", "HPAEC", "HPAF", "HUVEC", "Osteobl", "BE2_C", "Gliobla", "Medullo", "SK-N-MC", "SK-N-SH", "HA-h", "HMEC", "HMF", "MCF-7", "MCF-7", "T-47D", "HAc", "HeLa-S3", "HeLa-S3", "Caco-2", "HCT-116", "HVMF", "WI-38", "WI-38", "A549", "HAEpiC", "HCPEpiC", "HEEpiC", "HIPEpiC", "HNPCEpiC", "HPdLF", "HRCEpiC", "HRE", "HRPEpiC", "pHTE", "RPTEC", "SAEC", "HESC", "hESCT0", "H9ES", "HConF", "WERI-Rb-1", "Chorion", "HFF", "HFF-Myc", "AG09319", "HGF", "HCFaa", "HCF", "HCM", "iPS", "HRGEC", "8988T", "Hepatocytes", "HepG2", "Huh-7.5", "Huh-7", "Stellate", "AG04450", "HPF", "NHLF", "E_myoblast", "HSMM", "HSMM", "SKMC", "Myometr", "NH-A", "PANC-1", "PanIsletD", "PanIslets", "HPDE6-E6E7", "LNCaP", "LNCaP", "PrEC", "RWPE1", "AG04449", "AG09309", "AG10803", "BJ", "Fibrobl", "FibroP", "Melano", "NHDF-Ad", "NHDF-neo", "NHEK", "ProgFib", "HA-sp", "NT2-D1", "Urothelia", "Urothelia", "Ishikawa", "Ishikawa" ],
"Tissue": [ "Blastula", "Blood", "Blood", "Blood", "Blood", "Blood", "Blood", "Blood", "Blood", "Blood", "Blood", "Blood", "Blood", "Blood", "Blood", "Blood", "Blood", "Blood", "Blood", "Blood", "Blood", "Blood", "Blood", "Blood vessel", "Blood vessel", "Blood vessel", "Blood vessel", "Blood vessel", "Blood vessel", "Blood vessel", "Blood vessel", "Blood vessel", "Blood vessel", "Blood vessel", "Blood vessel", "Blood vessel", "Blood vessel", "Bone", "Brain", "Brain", "Brain", "Brain", "Brain", "Brain hippocampus", "Breast", "Breast", "Breast", "Breast", "Breast", "Cerebellar", "Cervix", "Cervix", "Colon", "Colon", "Connective", "Embryonic lung", "Embryonic lung", "Epithelium", "Epithelium", "Epithelium", "Epithelium", "Epithelium", "Epithelium", "Epithelium", "Epithelium", "Epithelium", "Epithelium", "Epithelium", "Epithelium", "Epithelium", "ES cell", "ES cell", "ES cell", "Eye", "Eye", "Fetal membrane", "Foreskin", "Foreskin", "Gingival", "Gingival", "Heart", "Heart", "Heart", "IPS", "Kidney", "Liver", "Liver", "Liver", "Liver", "Liver", "Liver", "Lung", "Lung", "Lung", "Muscle", "Muscle", "Muscle", "Muscle", "Myometrium", "Nervous", "Pancreas", "Pancreas", "Pancreas", "Pancreatic duct", "Prostate", "Prostate", "Prostate", "Prostate", "Skin", "Skin", "Skin", "Skin", "Skin", "Skin", "Skin", "Skin", "Skin", "Skin", "Skin", "Spinal cord", "Testis", "Urothelium", "Urothelium", "Uterus", "Uterus" ],
                         "Colour": [      2,      2,      0,      0,      0,      2,      1,      1,      1,      0,      0,      1,      1,      1,      2,      2,      2,      0,      2,      0,      2,      0,      2,      2,      2,      2,      1,      2,      1,      0,      0,      1,      0,      1,      0,      2,      0,      2,      0,      2,      2,      1,      2,      2,      0,      2,      2,      2,      2,      1,      1,      2,      2,      2,      0,      0,      2,      2,      2,      1,      2,      2,      2,      2,      2,      2,      2,      2,      2,      2,      2,      2,      2,      1,      2,      2,      2,      2,      2,      1,      2,      2,      1,      2,      0,      2,      2,      2,      2,      2,      1,      2,      2,      2,      2,      0,      1,      2,      2,      2,      2,      2,      2,      2,      2,      2,      2,      2,      2,      2,      2,      2,      2,      2,      2,      2,      2,      0,      2,      2,      1,      0,      1,      2,      2 ] 
                         }'))

d1 <- dPlot(
  y = "Zscore",
  x = "Cell",
  groups = "Colour",
  data = data,
  type = "bubble",
  width = 1000,
  height = 600,
  bounds = list(x=90,y=30,height=500,width=850),
  id = "chart1"
)
d1$xAxis( type = "addCategoryAxis", orderRule = "Cell" )
d1$yAxis( type = "addMeasureAxis" )
#generally just do d1 but do this to insure proper location
d1$print(d1$params$id)
```


<div id='chart1' class='rChart dimple'></div>
<script type="text/javascript">
  var opts = {
 "dom": "chart1",
"width":   1000,
"height":    600,
"x": "Cell",
"y": "Zscore",
"groups": "Colour",
"type": "bubble",
"bounds": {
 "x":     90,
"y":     30,
"height":    500,
"width":    850 
},
"id": "chart1" 
},
    data = [
 {
 "Zscore":  1.594,
"Cell": "HTR8svn",
"Tissue": "Blastula",
"Colour":      2 
},
{
 "Zscore":  0.024,
"Cell": "Adult_CD4+",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  5.231,
"Cell": "CD14+",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  3.933,
"Cell": "CD20+",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  6.222,
"Cell": "CD34+",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  0.164,
"Cell": "CLL",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  3.324,
"Cell": "CMK",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  2.913,
"Cell": "GM06990",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  3.357,
"Cell": "GM12864",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  4.041,
"Cell": "GM12865",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  5.082,
"Cell": "GM12878",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  2.727,
"Cell": "GM12891",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  2.739,
"Cell": "GM12892",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  3.042,
"Cell": "GM18507",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  2.308,
"Cell": "GM19238",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  0.286,
"Cell": "GM19239",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  1.965,
"Cell": "GM19240",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  3.534,
"Cell": "HL-60",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  1.518,
"Cell": "Jurkat",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  4.553,
"Cell": "K562",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  0.937,
"Cell": "NB4",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  5.124,
"Cell": "Th1",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":    0.4,
"Cell": "Th2",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  2.467,
"Cell": "AoAF",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  1.475,
"Cell": "AoSMC",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  1.591,
"Cell": "HBMEC",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  2.943,
"Cell": "HMVEC-dAd",
"Tissue": "Blood vessel",
"Colour":      1 
},
{
 "Zscore":  2.081,
"Cell": "HMVEC-dBl-Ad",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  3.083,
"Cell": "HMVEC-dBl-Neo",
"Tissue": "Blood vessel",
"Colour":      1 
},
{
 "Zscore":  4.252,
"Cell": "HMVEC-dLy-Ad",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  3.951,
"Cell": "HMVEC-dLy-Neo",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  3.006,
"Cell": "HMVEC-dNeo",
"Tissue": "Blood vessel",
"Colour":      1 
},
{
 "Zscore":  3.578,
"Cell": "HMVEC-LBl",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  3.332,
"Cell": "HMVEC-LLy",
"Tissue": "Blood vessel",
"Colour":      1 
},
{
 "Zscore":  3.641,
"Cell": "HPAEC",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  1.918,
"Cell": "HPAF",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  4.157,
"Cell": "HUVEC",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  1.074,
"Cell": "Osteobl",
"Tissue": "Bone",
"Colour":      2 
},
{
 "Zscore":  3.416,
"Cell": "BE2_C",
"Tissue": "Brain",
"Colour":      0 
},
{
 "Zscore":  1.729,
"Cell": "Gliobla",
"Tissue": "Brain",
"Colour":      2 
},
{
 "Zscore": -0.229,
"Cell": "Medullo",
"Tissue": "Brain",
"Colour":      2 
},
{
 "Zscore":  2.765,
"Cell": "SK-N-MC",
"Tissue": "Brain",
"Colour":      1 
},
{
 "Zscore": -0.071,
"Cell": "SK-N-SH",
"Tissue": "Brain",
"Colour":      2 
},
{
 "Zscore":  0.321,
"Cell": "HA-h",
"Tissue": "Brain hippocampus",
"Colour":      2 
},
{
 "Zscore":  4.151,
"Cell": "HMEC",
"Tissue": "Breast",
"Colour":      0 
},
{
 "Zscore":  2.497,
"Cell": "HMF",
"Tissue": "Breast",
"Colour":      2 
},
{
 "Zscore":  2.295,
"Cell": "MCF-7",
"Tissue": "Breast",
"Colour":      2 
},
{
 "Zscore":  0.911,
"Cell": "MCF-7",
"Tissue": "Breast",
"Colour":      2 
},
{
 "Zscore":  1.949,
"Cell": "T-47D",
"Tissue": "Breast",
"Colour":      2 
},
{
 "Zscore":  3.285,
"Cell": "HAc",
"Tissue": "Cerebellar",
"Colour":      1 
},
{
 "Zscore":      3,
"Cell": "HeLa-S3",
"Tissue": "Cervix",
"Colour":      1 
},
{
 "Zscore":  -1.23,
"Cell": "HeLa-S3",
"Tissue": "Cervix",
"Colour":      2 
},
{
 "Zscore": -0.894,
"Cell": "Caco-2",
"Tissue": "Colon",
"Colour":      2 
},
{
 "Zscore":  0.853,
"Cell": "HCT-116",
"Tissue": "Colon",
"Colour":      2 
},
{
 "Zscore":   3.59,
"Cell": "HVMF",
"Tissue": "Connective",
"Colour":      0 
},
{
 "Zscore":  3.643,
"Cell": "WI-38",
"Tissue": "Embryonic lung",
"Colour":      0 
},
{
 "Zscore":  1.772,
"Cell": "WI-38",
"Tissue": "Embryonic lung",
"Colour":      2 
},
{
 "Zscore":  2.276,
"Cell": "A549",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  2.301,
"Cell": "HAEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  3.088,
"Cell": "HCPEpiC",
"Tissue": "Epithelium",
"Colour":      1 
},
{
 "Zscore":   0.07,
"Cell": "HEEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  2.422,
"Cell": "HIPEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  1.572,
"Cell": "HNPCEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  1.864,
"Cell": "HPdLF",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  0.408,
"Cell": "HRCEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  0.838,
"Cell": "HRE",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  1.202,
"Cell": "HRPEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore": -0.645,
"Cell": "pHTE",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  0.794,
"Cell": "RPTEC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  0.866,
"Cell": "SAEC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  1.978,
"Cell": "HESC",
"Tissue": "ES cell",
"Colour":      2 
},
{
 "Zscore":   1.14,
"Cell": "hESCT0",
"Tissue": "ES cell",
"Colour":      2 
},
{
 "Zscore":  0.603,
"Cell": "H9ES",
"Tissue": "ES cell",
"Colour":      2 
},
{
 "Zscore":  3.268,
"Cell": "HConF",
"Tissue": "Eye",
"Colour":      1 
},
{
 "Zscore": -1.378,
"Cell": "WERI-Rb-1",
"Tissue": "Eye",
"Colour":      2 
},
{
 "Zscore":  2.304,
"Cell": "Chorion",
"Tissue": "Fetal membrane",
"Colour":      2 
},
{
 "Zscore":  2.038,
"Cell": "HFF",
"Tissue": "Foreskin",
"Colour":      2 
},
{
 "Zscore":  1.275,
"Cell": "HFF-Myc",
"Tissue": "Foreskin",
"Colour":      2 
},
{
 "Zscore":  1.486,
"Cell": "AG09319",
"Tissue": "Gingival",
"Colour":      2 
},
{
 "Zscore":  2.979,
"Cell": "HGF",
"Tissue": "Gingival",
"Colour":      1 
},
{
 "Zscore":  1.657,
"Cell": "HCFaa",
"Tissue": "Heart",
"Colour":      2 
},
{
 "Zscore":  1.726,
"Cell": "HCF",
"Tissue": "Heart",
"Colour":      2 
},
{
 "Zscore":  3.169,
"Cell": "HCM",
"Tissue": "Heart",
"Colour":      1 
},
{
 "Zscore":  0.607,
"Cell": "iPS",
"Tissue": "IPS",
"Colour":      2 
},
{
 "Zscore":  4.511,
"Cell": "HRGEC",
"Tissue": "Kidney",
"Colour":      0 
},
{
 "Zscore":  1.238,
"Cell": "8988T",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore":   0.71,
"Cell": "Hepatocytes",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore":  2.314,
"Cell": "HepG2",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore":   0.68,
"Cell": "Huh-7.5",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore": -0.239,
"Cell": "Huh-7",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore":  2.588,
"Cell": "Stellate",
"Tissue": "Liver",
"Colour":      1 
},
{
 "Zscore":  2.258,
"Cell": "AG04450",
"Tissue": "Lung",
"Colour":      2 
},
{
 "Zscore":  0.951,
"Cell": "HPF",
"Tissue": "Lung",
"Colour":      2 
},
{
 "Zscore":  0.723,
"Cell": "NHLF",
"Tissue": "Lung",
"Colour":      2 
},
{
 "Zscore":  1.665,
"Cell": "E_myoblast",
"Tissue": "Muscle",
"Colour":      2 
},
{
 "Zscore":  3.637,
"Cell": "HSMM",
"Tissue": "Muscle",
"Colour":      0 
},
{
 "Zscore":  3.317,
"Cell": "HSMM",
"Tissue": "Muscle",
"Colour":      1 
},
{
 "Zscore":  1.984,
"Cell": "SKMC",
"Tissue": "Muscle",
"Colour":      2 
},
{
 "Zscore":  1.638,
"Cell": "Myometr",
"Tissue": "Myometrium",
"Colour":      2 
},
{
 "Zscore":  2.151,
"Cell": "NH-A",
"Tissue": "Nervous",
"Colour":      2 
},
{
 "Zscore":   2.29,
"Cell": "PANC-1",
"Tissue": "Pancreas",
"Colour":      2 
},
{
 "Zscore":  1.535,
"Cell": "PanIsletD",
"Tissue": "Pancreas",
"Colour":      2 
},
{
 "Zscore":  0.732,
"Cell": "PanIslets",
"Tissue": "Pancreas",
"Colour":      2 
},
{
 "Zscore":  0.833,
"Cell": "HPDE6-E6E7",
"Tissue": "Pancreatic duct",
"Colour":      2 
},
{
 "Zscore":  2.519,
"Cell": "LNCaP",
"Tissue": "Prostate",
"Colour":      2 
},
{
 "Zscore":  0.929,
"Cell": "LNCaP",
"Tissue": "Prostate",
"Colour":      2 
},
{
 "Zscore":   2.12,
"Cell": "PrEC",
"Tissue": "Prostate",
"Colour":      2 
},
{
 "Zscore":  0.301,
"Cell": "RWPE1",
"Tissue": "Prostate",
"Colour":      2 
},
{
 "Zscore":  0.817,
"Cell": "AG04449",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":   1.95,
"Cell": "AG09309",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  2.226,
"Cell": "AG10803",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  1.785,
"Cell": "BJ",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":   1.66,
"Cell": "Fibrobl",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  1.131,
"Cell": "FibroP",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  0.883,
"Cell": "Melano",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  1.529,
"Cell": "NHDF-Ad",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  2.457,
"Cell": "NHDF-neo",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  5.625,
"Cell": "NHEK",
"Tissue": "Skin",
"Colour":      0 
},
{
 "Zscore":  1.475,
"Cell": "ProgFib",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  1.422,
"Cell": "HA-sp",
"Tissue": "Spinal cord",
"Colour":      2 
},
{
 "Zscore":  2.935,
"Cell": "NT2-D1",
"Tissue": "Testis",
"Colour":      1 
},
{
 "Zscore":  3.513,
"Cell": "Urothelia",
"Tissue": "Urothelium",
"Colour":      0 
},
{
 "Zscore":  2.931,
"Cell": "Urothelia",
"Tissue": "Urothelium",
"Colour":      1 
},
{
 "Zscore":  0.927,
"Cell": "Ishikawa",
"Tissue": "Uterus",
"Colour":      2 
},
{
 "Zscore": -0.246,
"Cell": "Ishikawa",
"Tissue": "Uterus",
"Colour":      2 
} 
],
    xAxis = {
 "type": "addCategoryAxis",
"showPercent": false,
"orderRule": "Cell" 
},
    yAxis = {
 "type": "addMeasureAxis",
"showPercent": false 
},
    zAxis = [],
    colorAxis = [],
    legend = [];
  var svg = dimple.newSvg("#" + opts.id, opts.width, opts.height);

  //data = dimple.filterData(data, "Owner", ["Aperture", "Black Mesa"])
  var myChart = new dimple.chart(svg, data);
  if (opts.bounds) {
    myChart.setBounds(opts.bounds.x, opts.bounds.y, opts.bounds.width, opts.bounds.height);//myChart.setBounds(80, 30, 480, 330);
  }
  //dimple allows use of custom CSS with noFormats
  if(opts.noFormats) { myChart.noFormats = opts.noFormats; };
  //for markimekko and addAxis also have third parameter measure
  //so need to evaluate if measure provided
  //x axis
  var x;
  if(xAxis.measure) {
    x = myChart[xAxis.type]("x",opts.x,xAxis.measure);
  } else {
    x = myChart[xAxis.type]("x", opts.x);
  };
  if(!(xAxis.type === "addPctAxis")) x.showPercent = xAxis.showPercent;
  if (xAxis.orderRule) x.addOrderRule(xAxis.orderRule);
  if (xAxis.grouporderRule) x.addGroupOrderRule(xAxis.grouporderRule);  
  if (xAxis.overrideMin) x.overrideMin = xAxis.overrideMin;
  if (xAxis.overrideMax) x.overrideMax = xAxis.overrideMax;
  if (xAxis.overrideMax) x.overrideMax = xAxis.overrideMax;
  if (xAxis.inputFormat) x.dateParseFormat = xAxis.inputFormat;
  if (xAxis.outputFormat) x.tickFormat = xAxis.outputFormat;
  //y axis
  var y;
  if(yAxis.measure) {
    y = myChart[yAxis.type]("y",opts.y,yAxis.measure);
  } else {
    y = myChart[yAxis.type]("y", opts.y);
  };
  if(!(yAxis.type === "addPctAxis")) y.showPercent = yAxis.showPercent;
  if (yAxis.orderRule) y.addOrderRule(yAxis.orderRule);
  if (yAxis.grouporderRule) y.addGroupOrderRule(yAxis.grouporderRule);
  if (yAxis.overrideMin) y.overrideMin = yAxis.overrideMin;
  if (yAxis.overrideMax) y.overrideMax = yAxis.overrideMax;
  if (yAxis.inputFormat) y.dateParseFormat = yAxis.inputFormat;
  if (yAxis.outputFormat) y.tickFormat = yAxis.outputFormat;
//z for bubbles
    var z;
  if (!(typeof(zAxis) === 'undefined') && zAxis.type){
    if(zAxis.measure) {
      z = myChart[zAxis.type]("z",opts.z,zAxis.measure);
    } else {
      z = myChart[zAxis.type]("z", opts.z);
    };
    if(!(zAxis.type === "addPctAxis")) z.showPercent = zAxis.showPercent;
    if (zAxis.orderRule) z.addOrderRule(zAxis.orderRule);
    if (zAxis.overrideMin) z.overrideMin = zAxis.overrideMin;
    if (zAxis.overrideMax) z.overrideMax = zAxis.overrideMax;
  }
  if(d3.keys(colorAxis).length > 0) {
    myChart[colorAxis.type](colorAxis.colorSeries,colorAxis.palette) ;
  }
  
  //here need think I need to evaluate group and if missing do null
  //as the first argument
  //if provided need to use groups from opts
  if(opts.hasOwnProperty("groups")) {
    var s = myChart.addSeries( opts.groups, dimple.plot[opts.type] );
    //series offers an aggregate method that we will also need to check if available
    //options available are avg, count, max, min, sum
    if (!(typeof(opts.aggregate) === 'undefined')) {
      s.aggregate = eval(opts.aggregate);
    }
    if (!(typeof(opts.lineWeight) === 'undefined')) {
      s.lineWeight = eval(opts.lineWeight);
    }
    if (!(typeof(opts.barGap) === 'undefined')) {
      s.barGap = eval(opts.barGap);
    }    
  } else var s = myChart.addSeries( null, dimple.plot[opts.type] );
  //unsure if this is best but if legend is provided (not empty) then evaluate
  if(d3.keys(legend).length > 0) {
    var l =myChart.addLegend();
    d3.keys(legend).forEach(function(d){
      l[d] = legend[d];
    });
  }
  //quick way to get this going but need to make this cleaner
  if(opts.storyboard) {
    myChart.setStoryboard(opts.storyboard);
  };
  myChart.draw();

</script>



## Example 2 - Add Color Ramp Type Scale
Now if pull request accepted, we will have the ability to not have to explicitly define colors for value ranges.


```r
d1$set(id = "chart2")
d1$colorAxis(
  type = "addColorAxis",
  colorSeries = "Zscore",
  palette = c("red","yellow","green") )
d1$print(d1$params$id)
```


<div id='chart2' class='rChart dimple'></div>
<script type="text/javascript">
  var opts = {
 "dom": "chart2",
"width":   1000,
"height":    600,
"x": "Cell",
"y": "Zscore",
"groups": "Colour",
"type": "bubble",
"bounds": {
 "x":     90,
"y":     30,
"height":    500,
"width":    850 
},
"id": "chart2" 
},
    data = [
 {
 "Zscore":  1.594,
"Cell": "HTR8svn",
"Tissue": "Blastula",
"Colour":      2 
},
{
 "Zscore":  0.024,
"Cell": "Adult_CD4+",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  5.231,
"Cell": "CD14+",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  3.933,
"Cell": "CD20+",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  6.222,
"Cell": "CD34+",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  0.164,
"Cell": "CLL",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  3.324,
"Cell": "CMK",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  2.913,
"Cell": "GM06990",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  3.357,
"Cell": "GM12864",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  4.041,
"Cell": "GM12865",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  5.082,
"Cell": "GM12878",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  2.727,
"Cell": "GM12891",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  2.739,
"Cell": "GM12892",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  3.042,
"Cell": "GM18507",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  2.308,
"Cell": "GM19238",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  0.286,
"Cell": "GM19239",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  1.965,
"Cell": "GM19240",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  3.534,
"Cell": "HL-60",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  1.518,
"Cell": "Jurkat",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  4.553,
"Cell": "K562",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  0.937,
"Cell": "NB4",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  5.124,
"Cell": "Th1",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":    0.4,
"Cell": "Th2",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  2.467,
"Cell": "AoAF",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  1.475,
"Cell": "AoSMC",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  1.591,
"Cell": "HBMEC",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  2.943,
"Cell": "HMVEC-dAd",
"Tissue": "Blood vessel",
"Colour":      1 
},
{
 "Zscore":  2.081,
"Cell": "HMVEC-dBl-Ad",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  3.083,
"Cell": "HMVEC-dBl-Neo",
"Tissue": "Blood vessel",
"Colour":      1 
},
{
 "Zscore":  4.252,
"Cell": "HMVEC-dLy-Ad",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  3.951,
"Cell": "HMVEC-dLy-Neo",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  3.006,
"Cell": "HMVEC-dNeo",
"Tissue": "Blood vessel",
"Colour":      1 
},
{
 "Zscore":  3.578,
"Cell": "HMVEC-LBl",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  3.332,
"Cell": "HMVEC-LLy",
"Tissue": "Blood vessel",
"Colour":      1 
},
{
 "Zscore":  3.641,
"Cell": "HPAEC",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  1.918,
"Cell": "HPAF",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  4.157,
"Cell": "HUVEC",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  1.074,
"Cell": "Osteobl",
"Tissue": "Bone",
"Colour":      2 
},
{
 "Zscore":  3.416,
"Cell": "BE2_C",
"Tissue": "Brain",
"Colour":      0 
},
{
 "Zscore":  1.729,
"Cell": "Gliobla",
"Tissue": "Brain",
"Colour":      2 
},
{
 "Zscore": -0.229,
"Cell": "Medullo",
"Tissue": "Brain",
"Colour":      2 
},
{
 "Zscore":  2.765,
"Cell": "SK-N-MC",
"Tissue": "Brain",
"Colour":      1 
},
{
 "Zscore": -0.071,
"Cell": "SK-N-SH",
"Tissue": "Brain",
"Colour":      2 
},
{
 "Zscore":  0.321,
"Cell": "HA-h",
"Tissue": "Brain hippocampus",
"Colour":      2 
},
{
 "Zscore":  4.151,
"Cell": "HMEC",
"Tissue": "Breast",
"Colour":      0 
},
{
 "Zscore":  2.497,
"Cell": "HMF",
"Tissue": "Breast",
"Colour":      2 
},
{
 "Zscore":  2.295,
"Cell": "MCF-7",
"Tissue": "Breast",
"Colour":      2 
},
{
 "Zscore":  0.911,
"Cell": "MCF-7",
"Tissue": "Breast",
"Colour":      2 
},
{
 "Zscore":  1.949,
"Cell": "T-47D",
"Tissue": "Breast",
"Colour":      2 
},
{
 "Zscore":  3.285,
"Cell": "HAc",
"Tissue": "Cerebellar",
"Colour":      1 
},
{
 "Zscore":      3,
"Cell": "HeLa-S3",
"Tissue": "Cervix",
"Colour":      1 
},
{
 "Zscore":  -1.23,
"Cell": "HeLa-S3",
"Tissue": "Cervix",
"Colour":      2 
},
{
 "Zscore": -0.894,
"Cell": "Caco-2",
"Tissue": "Colon",
"Colour":      2 
},
{
 "Zscore":  0.853,
"Cell": "HCT-116",
"Tissue": "Colon",
"Colour":      2 
},
{
 "Zscore":   3.59,
"Cell": "HVMF",
"Tissue": "Connective",
"Colour":      0 
},
{
 "Zscore":  3.643,
"Cell": "WI-38",
"Tissue": "Embryonic lung",
"Colour":      0 
},
{
 "Zscore":  1.772,
"Cell": "WI-38",
"Tissue": "Embryonic lung",
"Colour":      2 
},
{
 "Zscore":  2.276,
"Cell": "A549",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  2.301,
"Cell": "HAEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  3.088,
"Cell": "HCPEpiC",
"Tissue": "Epithelium",
"Colour":      1 
},
{
 "Zscore":   0.07,
"Cell": "HEEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  2.422,
"Cell": "HIPEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  1.572,
"Cell": "HNPCEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  1.864,
"Cell": "HPdLF",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  0.408,
"Cell": "HRCEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  0.838,
"Cell": "HRE",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  1.202,
"Cell": "HRPEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore": -0.645,
"Cell": "pHTE",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  0.794,
"Cell": "RPTEC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  0.866,
"Cell": "SAEC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  1.978,
"Cell": "HESC",
"Tissue": "ES cell",
"Colour":      2 
},
{
 "Zscore":   1.14,
"Cell": "hESCT0",
"Tissue": "ES cell",
"Colour":      2 
},
{
 "Zscore":  0.603,
"Cell": "H9ES",
"Tissue": "ES cell",
"Colour":      2 
},
{
 "Zscore":  3.268,
"Cell": "HConF",
"Tissue": "Eye",
"Colour":      1 
},
{
 "Zscore": -1.378,
"Cell": "WERI-Rb-1",
"Tissue": "Eye",
"Colour":      2 
},
{
 "Zscore":  2.304,
"Cell": "Chorion",
"Tissue": "Fetal membrane",
"Colour":      2 
},
{
 "Zscore":  2.038,
"Cell": "HFF",
"Tissue": "Foreskin",
"Colour":      2 
},
{
 "Zscore":  1.275,
"Cell": "HFF-Myc",
"Tissue": "Foreskin",
"Colour":      2 
},
{
 "Zscore":  1.486,
"Cell": "AG09319",
"Tissue": "Gingival",
"Colour":      2 
},
{
 "Zscore":  2.979,
"Cell": "HGF",
"Tissue": "Gingival",
"Colour":      1 
},
{
 "Zscore":  1.657,
"Cell": "HCFaa",
"Tissue": "Heart",
"Colour":      2 
},
{
 "Zscore":  1.726,
"Cell": "HCF",
"Tissue": "Heart",
"Colour":      2 
},
{
 "Zscore":  3.169,
"Cell": "HCM",
"Tissue": "Heart",
"Colour":      1 
},
{
 "Zscore":  0.607,
"Cell": "iPS",
"Tissue": "IPS",
"Colour":      2 
},
{
 "Zscore":  4.511,
"Cell": "HRGEC",
"Tissue": "Kidney",
"Colour":      0 
},
{
 "Zscore":  1.238,
"Cell": "8988T",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore":   0.71,
"Cell": "Hepatocytes",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore":  2.314,
"Cell": "HepG2",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore":   0.68,
"Cell": "Huh-7.5",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore": -0.239,
"Cell": "Huh-7",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore":  2.588,
"Cell": "Stellate",
"Tissue": "Liver",
"Colour":      1 
},
{
 "Zscore":  2.258,
"Cell": "AG04450",
"Tissue": "Lung",
"Colour":      2 
},
{
 "Zscore":  0.951,
"Cell": "HPF",
"Tissue": "Lung",
"Colour":      2 
},
{
 "Zscore":  0.723,
"Cell": "NHLF",
"Tissue": "Lung",
"Colour":      2 
},
{
 "Zscore":  1.665,
"Cell": "E_myoblast",
"Tissue": "Muscle",
"Colour":      2 
},
{
 "Zscore":  3.637,
"Cell": "HSMM",
"Tissue": "Muscle",
"Colour":      0 
},
{
 "Zscore":  3.317,
"Cell": "HSMM",
"Tissue": "Muscle",
"Colour":      1 
},
{
 "Zscore":  1.984,
"Cell": "SKMC",
"Tissue": "Muscle",
"Colour":      2 
},
{
 "Zscore":  1.638,
"Cell": "Myometr",
"Tissue": "Myometrium",
"Colour":      2 
},
{
 "Zscore":  2.151,
"Cell": "NH-A",
"Tissue": "Nervous",
"Colour":      2 
},
{
 "Zscore":   2.29,
"Cell": "PANC-1",
"Tissue": "Pancreas",
"Colour":      2 
},
{
 "Zscore":  1.535,
"Cell": "PanIsletD",
"Tissue": "Pancreas",
"Colour":      2 
},
{
 "Zscore":  0.732,
"Cell": "PanIslets",
"Tissue": "Pancreas",
"Colour":      2 
},
{
 "Zscore":  0.833,
"Cell": "HPDE6-E6E7",
"Tissue": "Pancreatic duct",
"Colour":      2 
},
{
 "Zscore":  2.519,
"Cell": "LNCaP",
"Tissue": "Prostate",
"Colour":      2 
},
{
 "Zscore":  0.929,
"Cell": "LNCaP",
"Tissue": "Prostate",
"Colour":      2 
},
{
 "Zscore":   2.12,
"Cell": "PrEC",
"Tissue": "Prostate",
"Colour":      2 
},
{
 "Zscore":  0.301,
"Cell": "RWPE1",
"Tissue": "Prostate",
"Colour":      2 
},
{
 "Zscore":  0.817,
"Cell": "AG04449",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":   1.95,
"Cell": "AG09309",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  2.226,
"Cell": "AG10803",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  1.785,
"Cell": "BJ",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":   1.66,
"Cell": "Fibrobl",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  1.131,
"Cell": "FibroP",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  0.883,
"Cell": "Melano",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  1.529,
"Cell": "NHDF-Ad",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  2.457,
"Cell": "NHDF-neo",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  5.625,
"Cell": "NHEK",
"Tissue": "Skin",
"Colour":      0 
},
{
 "Zscore":  1.475,
"Cell": "ProgFib",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  1.422,
"Cell": "HA-sp",
"Tissue": "Spinal cord",
"Colour":      2 
},
{
 "Zscore":  2.935,
"Cell": "NT2-D1",
"Tissue": "Testis",
"Colour":      1 
},
{
 "Zscore":  3.513,
"Cell": "Urothelia",
"Tissue": "Urothelium",
"Colour":      0 
},
{
 "Zscore":  2.931,
"Cell": "Urothelia",
"Tissue": "Urothelium",
"Colour":      1 
},
{
 "Zscore":  0.927,
"Cell": "Ishikawa",
"Tissue": "Uterus",
"Colour":      2 
},
{
 "Zscore": -0.246,
"Cell": "Ishikawa",
"Tissue": "Uterus",
"Colour":      2 
} 
],
    xAxis = {
 "type": "addCategoryAxis",
"showPercent": false,
"orderRule": "Cell" 
},
    yAxis = {
 "type": "addMeasureAxis",
"showPercent": false 
},
    zAxis = [],
    colorAxis = {
 "type": "addColorAxis",
"colorSeries": "Zscore",
"palette": [ "red", "yellow", "green" ] 
},
    legend = [];
  var svg = dimple.newSvg("#" + opts.id, opts.width, opts.height);

  //data = dimple.filterData(data, "Owner", ["Aperture", "Black Mesa"])
  var myChart = new dimple.chart(svg, data);
  if (opts.bounds) {
    myChart.setBounds(opts.bounds.x, opts.bounds.y, opts.bounds.width, opts.bounds.height);//myChart.setBounds(80, 30, 480, 330);
  }
  //dimple allows use of custom CSS with noFormats
  if(opts.noFormats) { myChart.noFormats = opts.noFormats; };
  //for markimekko and addAxis also have third parameter measure
  //so need to evaluate if measure provided
  //x axis
  var x;
  if(xAxis.measure) {
    x = myChart[xAxis.type]("x",opts.x,xAxis.measure);
  } else {
    x = myChart[xAxis.type]("x", opts.x);
  };
  if(!(xAxis.type === "addPctAxis")) x.showPercent = xAxis.showPercent;
  if (xAxis.orderRule) x.addOrderRule(xAxis.orderRule);
  if (xAxis.grouporderRule) x.addGroupOrderRule(xAxis.grouporderRule);  
  if (xAxis.overrideMin) x.overrideMin = xAxis.overrideMin;
  if (xAxis.overrideMax) x.overrideMax = xAxis.overrideMax;
  if (xAxis.overrideMax) x.overrideMax = xAxis.overrideMax;
  if (xAxis.inputFormat) x.dateParseFormat = xAxis.inputFormat;
  if (xAxis.outputFormat) x.tickFormat = xAxis.outputFormat;
  //y axis
  var y;
  if(yAxis.measure) {
    y = myChart[yAxis.type]("y",opts.y,yAxis.measure);
  } else {
    y = myChart[yAxis.type]("y", opts.y);
  };
  if(!(yAxis.type === "addPctAxis")) y.showPercent = yAxis.showPercent;
  if (yAxis.orderRule) y.addOrderRule(yAxis.orderRule);
  if (yAxis.grouporderRule) y.addGroupOrderRule(yAxis.grouporderRule);
  if (yAxis.overrideMin) y.overrideMin = yAxis.overrideMin;
  if (yAxis.overrideMax) y.overrideMax = yAxis.overrideMax;
  if (yAxis.inputFormat) y.dateParseFormat = yAxis.inputFormat;
  if (yAxis.outputFormat) y.tickFormat = yAxis.outputFormat;
//z for bubbles
    var z;
  if (!(typeof(zAxis) === 'undefined') && zAxis.type){
    if(zAxis.measure) {
      z = myChart[zAxis.type]("z",opts.z,zAxis.measure);
    } else {
      z = myChart[zAxis.type]("z", opts.z);
    };
    if(!(zAxis.type === "addPctAxis")) z.showPercent = zAxis.showPercent;
    if (zAxis.orderRule) z.addOrderRule(zAxis.orderRule);
    if (zAxis.overrideMin) z.overrideMin = zAxis.overrideMin;
    if (zAxis.overrideMax) z.overrideMax = zAxis.overrideMax;
  }
  if(d3.keys(colorAxis).length > 0) {
    myChart[colorAxis.type](colorAxis.colorSeries,colorAxis.palette) ;
  }
  
  //here need think I need to evaluate group and if missing do null
  //as the first argument
  //if provided need to use groups from opts
  if(opts.hasOwnProperty("groups")) {
    var s = myChart.addSeries( opts.groups, dimple.plot[opts.type] );
    //series offers an aggregate method that we will also need to check if available
    //options available are avg, count, max, min, sum
    if (!(typeof(opts.aggregate) === 'undefined')) {
      s.aggregate = eval(opts.aggregate);
    }
    if (!(typeof(opts.lineWeight) === 'undefined')) {
      s.lineWeight = eval(opts.lineWeight);
    }
    if (!(typeof(opts.barGap) === 'undefined')) {
      s.barGap = eval(opts.barGap);
    }    
  } else var s = myChart.addSeries( null, dimple.plot[opts.type] );
  //unsure if this is best but if legend is provided (not empty) then evaluate
  if(d3.keys(legend).length > 0) {
    var l =myChart.addLegend();
    d3.keys(legend).forEach(function(d){
      l[d] = legend[d];
    });
  }
  //quick way to get this going but need to make this cleaner
  if(opts.storyboard) {
    myChart.setStoryboard(opts.storyboard);
  };
  myChart.draw();

</script>


## Example 3 - Add Tissue on x


```r
d1 <- dPlot(
  y = "Zscore",
  x = c("Tissue","Cell"),
  data = data,
  type = "bubble",
  width = 1000,
  height = 600,
  bounds = list(x=90,y=50,height=450,width=850),
  id = "chart3"
)
d1$xAxis( type = "addCategoryAxis", grouporderRule = "Tissue",orderRule = "Cell" )
d1$yAxis( type = "addMeasureAxis" )
d1$colorAxis(
  type = "addColorAxis",
  colorSeries = "Zscore",
  palette = c("red","yellow","green") )
d1$print(d1$params$id)
```


<div id='chart3' class='rChart dimple'></div>
<script type="text/javascript">
  var opts = {
 "dom": "chart3",
"width":   1000,
"height":    600,
"x": [ "Tissue", "Cell" ],
"y": "Zscore",
"type": "bubble",
"bounds": {
 "x":     90,
"y":     50,
"height":    450,
"width":    850 
},
"id": "chart3" 
},
    data = [
 {
 "Zscore":  1.594,
"Cell": "HTR8svn",
"Tissue": "Blastula",
"Colour":      2 
},
{
 "Zscore":  0.024,
"Cell": "Adult_CD4+",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  5.231,
"Cell": "CD14+",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  3.933,
"Cell": "CD20+",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  6.222,
"Cell": "CD34+",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  0.164,
"Cell": "CLL",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  3.324,
"Cell": "CMK",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  2.913,
"Cell": "GM06990",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  3.357,
"Cell": "GM12864",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  4.041,
"Cell": "GM12865",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  5.082,
"Cell": "GM12878",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  2.727,
"Cell": "GM12891",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  2.739,
"Cell": "GM12892",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  3.042,
"Cell": "GM18507",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  2.308,
"Cell": "GM19238",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  0.286,
"Cell": "GM19239",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  1.965,
"Cell": "GM19240",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  3.534,
"Cell": "HL-60",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  1.518,
"Cell": "Jurkat",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  4.553,
"Cell": "K562",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  0.937,
"Cell": "NB4",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  5.124,
"Cell": "Th1",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":    0.4,
"Cell": "Th2",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  2.467,
"Cell": "AoAF",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  1.475,
"Cell": "AoSMC",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  1.591,
"Cell": "HBMEC",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  2.943,
"Cell": "HMVEC-dAd",
"Tissue": "Blood vessel",
"Colour":      1 
},
{
 "Zscore":  2.081,
"Cell": "HMVEC-dBl-Ad",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  3.083,
"Cell": "HMVEC-dBl-Neo",
"Tissue": "Blood vessel",
"Colour":      1 
},
{
 "Zscore":  4.252,
"Cell": "HMVEC-dLy-Ad",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  3.951,
"Cell": "HMVEC-dLy-Neo",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  3.006,
"Cell": "HMVEC-dNeo",
"Tissue": "Blood vessel",
"Colour":      1 
},
{
 "Zscore":  3.578,
"Cell": "HMVEC-LBl",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  3.332,
"Cell": "HMVEC-LLy",
"Tissue": "Blood vessel",
"Colour":      1 
},
{
 "Zscore":  3.641,
"Cell": "HPAEC",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  1.918,
"Cell": "HPAF",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  4.157,
"Cell": "HUVEC",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  1.074,
"Cell": "Osteobl",
"Tissue": "Bone",
"Colour":      2 
},
{
 "Zscore":  3.416,
"Cell": "BE2_C",
"Tissue": "Brain",
"Colour":      0 
},
{
 "Zscore":  1.729,
"Cell": "Gliobla",
"Tissue": "Brain",
"Colour":      2 
},
{
 "Zscore": -0.229,
"Cell": "Medullo",
"Tissue": "Brain",
"Colour":      2 
},
{
 "Zscore":  2.765,
"Cell": "SK-N-MC",
"Tissue": "Brain",
"Colour":      1 
},
{
 "Zscore": -0.071,
"Cell": "SK-N-SH",
"Tissue": "Brain",
"Colour":      2 
},
{
 "Zscore":  0.321,
"Cell": "HA-h",
"Tissue": "Brain hippocampus",
"Colour":      2 
},
{
 "Zscore":  4.151,
"Cell": "HMEC",
"Tissue": "Breast",
"Colour":      0 
},
{
 "Zscore":  2.497,
"Cell": "HMF",
"Tissue": "Breast",
"Colour":      2 
},
{
 "Zscore":  2.295,
"Cell": "MCF-7",
"Tissue": "Breast",
"Colour":      2 
},
{
 "Zscore":  0.911,
"Cell": "MCF-7",
"Tissue": "Breast",
"Colour":      2 
},
{
 "Zscore":  1.949,
"Cell": "T-47D",
"Tissue": "Breast",
"Colour":      2 
},
{
 "Zscore":  3.285,
"Cell": "HAc",
"Tissue": "Cerebellar",
"Colour":      1 
},
{
 "Zscore":      3,
"Cell": "HeLa-S3",
"Tissue": "Cervix",
"Colour":      1 
},
{
 "Zscore":  -1.23,
"Cell": "HeLa-S3",
"Tissue": "Cervix",
"Colour":      2 
},
{
 "Zscore": -0.894,
"Cell": "Caco-2",
"Tissue": "Colon",
"Colour":      2 
},
{
 "Zscore":  0.853,
"Cell": "HCT-116",
"Tissue": "Colon",
"Colour":      2 
},
{
 "Zscore":   3.59,
"Cell": "HVMF",
"Tissue": "Connective",
"Colour":      0 
},
{
 "Zscore":  3.643,
"Cell": "WI-38",
"Tissue": "Embryonic lung",
"Colour":      0 
},
{
 "Zscore":  1.772,
"Cell": "WI-38",
"Tissue": "Embryonic lung",
"Colour":      2 
},
{
 "Zscore":  2.276,
"Cell": "A549",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  2.301,
"Cell": "HAEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  3.088,
"Cell": "HCPEpiC",
"Tissue": "Epithelium",
"Colour":      1 
},
{
 "Zscore":   0.07,
"Cell": "HEEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  2.422,
"Cell": "HIPEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  1.572,
"Cell": "HNPCEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  1.864,
"Cell": "HPdLF",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  0.408,
"Cell": "HRCEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  0.838,
"Cell": "HRE",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  1.202,
"Cell": "HRPEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore": -0.645,
"Cell": "pHTE",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  0.794,
"Cell": "RPTEC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  0.866,
"Cell": "SAEC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  1.978,
"Cell": "HESC",
"Tissue": "ES cell",
"Colour":      2 
},
{
 "Zscore":   1.14,
"Cell": "hESCT0",
"Tissue": "ES cell",
"Colour":      2 
},
{
 "Zscore":  0.603,
"Cell": "H9ES",
"Tissue": "ES cell",
"Colour":      2 
},
{
 "Zscore":  3.268,
"Cell": "HConF",
"Tissue": "Eye",
"Colour":      1 
},
{
 "Zscore": -1.378,
"Cell": "WERI-Rb-1",
"Tissue": "Eye",
"Colour":      2 
},
{
 "Zscore":  2.304,
"Cell": "Chorion",
"Tissue": "Fetal membrane",
"Colour":      2 
},
{
 "Zscore":  2.038,
"Cell": "HFF",
"Tissue": "Foreskin",
"Colour":      2 
},
{
 "Zscore":  1.275,
"Cell": "HFF-Myc",
"Tissue": "Foreskin",
"Colour":      2 
},
{
 "Zscore":  1.486,
"Cell": "AG09319",
"Tissue": "Gingival",
"Colour":      2 
},
{
 "Zscore":  2.979,
"Cell": "HGF",
"Tissue": "Gingival",
"Colour":      1 
},
{
 "Zscore":  1.657,
"Cell": "HCFaa",
"Tissue": "Heart",
"Colour":      2 
},
{
 "Zscore":  1.726,
"Cell": "HCF",
"Tissue": "Heart",
"Colour":      2 
},
{
 "Zscore":  3.169,
"Cell": "HCM",
"Tissue": "Heart",
"Colour":      1 
},
{
 "Zscore":  0.607,
"Cell": "iPS",
"Tissue": "IPS",
"Colour":      2 
},
{
 "Zscore":  4.511,
"Cell": "HRGEC",
"Tissue": "Kidney",
"Colour":      0 
},
{
 "Zscore":  1.238,
"Cell": "8988T",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore":   0.71,
"Cell": "Hepatocytes",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore":  2.314,
"Cell": "HepG2",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore":   0.68,
"Cell": "Huh-7.5",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore": -0.239,
"Cell": "Huh-7",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore":  2.588,
"Cell": "Stellate",
"Tissue": "Liver",
"Colour":      1 
},
{
 "Zscore":  2.258,
"Cell": "AG04450",
"Tissue": "Lung",
"Colour":      2 
},
{
 "Zscore":  0.951,
"Cell": "HPF",
"Tissue": "Lung",
"Colour":      2 
},
{
 "Zscore":  0.723,
"Cell": "NHLF",
"Tissue": "Lung",
"Colour":      2 
},
{
 "Zscore":  1.665,
"Cell": "E_myoblast",
"Tissue": "Muscle",
"Colour":      2 
},
{
 "Zscore":  3.637,
"Cell": "HSMM",
"Tissue": "Muscle",
"Colour":      0 
},
{
 "Zscore":  3.317,
"Cell": "HSMM",
"Tissue": "Muscle",
"Colour":      1 
},
{
 "Zscore":  1.984,
"Cell": "SKMC",
"Tissue": "Muscle",
"Colour":      2 
},
{
 "Zscore":  1.638,
"Cell": "Myometr",
"Tissue": "Myometrium",
"Colour":      2 
},
{
 "Zscore":  2.151,
"Cell": "NH-A",
"Tissue": "Nervous",
"Colour":      2 
},
{
 "Zscore":   2.29,
"Cell": "PANC-1",
"Tissue": "Pancreas",
"Colour":      2 
},
{
 "Zscore":  1.535,
"Cell": "PanIsletD",
"Tissue": "Pancreas",
"Colour":      2 
},
{
 "Zscore":  0.732,
"Cell": "PanIslets",
"Tissue": "Pancreas",
"Colour":      2 
},
{
 "Zscore":  0.833,
"Cell": "HPDE6-E6E7",
"Tissue": "Pancreatic duct",
"Colour":      2 
},
{
 "Zscore":  2.519,
"Cell": "LNCaP",
"Tissue": "Prostate",
"Colour":      2 
},
{
 "Zscore":  0.929,
"Cell": "LNCaP",
"Tissue": "Prostate",
"Colour":      2 
},
{
 "Zscore":   2.12,
"Cell": "PrEC",
"Tissue": "Prostate",
"Colour":      2 
},
{
 "Zscore":  0.301,
"Cell": "RWPE1",
"Tissue": "Prostate",
"Colour":      2 
},
{
 "Zscore":  0.817,
"Cell": "AG04449",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":   1.95,
"Cell": "AG09309",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  2.226,
"Cell": "AG10803",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  1.785,
"Cell": "BJ",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":   1.66,
"Cell": "Fibrobl",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  1.131,
"Cell": "FibroP",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  0.883,
"Cell": "Melano",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  1.529,
"Cell": "NHDF-Ad",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  2.457,
"Cell": "NHDF-neo",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  5.625,
"Cell": "NHEK",
"Tissue": "Skin",
"Colour":      0 
},
{
 "Zscore":  1.475,
"Cell": "ProgFib",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  1.422,
"Cell": "HA-sp",
"Tissue": "Spinal cord",
"Colour":      2 
},
{
 "Zscore":  2.935,
"Cell": "NT2-D1",
"Tissue": "Testis",
"Colour":      1 
},
{
 "Zscore":  3.513,
"Cell": "Urothelia",
"Tissue": "Urothelium",
"Colour":      0 
},
{
 "Zscore":  2.931,
"Cell": "Urothelia",
"Tissue": "Urothelium",
"Colour":      1 
},
{
 "Zscore":  0.927,
"Cell": "Ishikawa",
"Tissue": "Uterus",
"Colour":      2 
},
{
 "Zscore": -0.246,
"Cell": "Ishikawa",
"Tissue": "Uterus",
"Colour":      2 
} 
],
    xAxis = {
 "type": "addCategoryAxis",
"showPercent": false,
"grouporderRule": "Tissue",
"orderRule": "Cell" 
},
    yAxis = {
 "type": "addMeasureAxis",
"showPercent": false 
},
    zAxis = [],
    colorAxis = {
 "type": "addColorAxis",
"colorSeries": "Zscore",
"palette": [ "red", "yellow", "green" ] 
},
    legend = [];
  var svg = dimple.newSvg("#" + opts.id, opts.width, opts.height);

  //data = dimple.filterData(data, "Owner", ["Aperture", "Black Mesa"])
  var myChart = new dimple.chart(svg, data);
  if (opts.bounds) {
    myChart.setBounds(opts.bounds.x, opts.bounds.y, opts.bounds.width, opts.bounds.height);//myChart.setBounds(80, 30, 480, 330);
  }
  //dimple allows use of custom CSS with noFormats
  if(opts.noFormats) { myChart.noFormats = opts.noFormats; };
  //for markimekko and addAxis also have third parameter measure
  //so need to evaluate if measure provided
  //x axis
  var x;
  if(xAxis.measure) {
    x = myChart[xAxis.type]("x",opts.x,xAxis.measure);
  } else {
    x = myChart[xAxis.type]("x", opts.x);
  };
  if(!(xAxis.type === "addPctAxis")) x.showPercent = xAxis.showPercent;
  if (xAxis.orderRule) x.addOrderRule(xAxis.orderRule);
  if (xAxis.grouporderRule) x.addGroupOrderRule(xAxis.grouporderRule);  
  if (xAxis.overrideMin) x.overrideMin = xAxis.overrideMin;
  if (xAxis.overrideMax) x.overrideMax = xAxis.overrideMax;
  if (xAxis.overrideMax) x.overrideMax = xAxis.overrideMax;
  if (xAxis.inputFormat) x.dateParseFormat = xAxis.inputFormat;
  if (xAxis.outputFormat) x.tickFormat = xAxis.outputFormat;
  //y axis
  var y;
  if(yAxis.measure) {
    y = myChart[yAxis.type]("y",opts.y,yAxis.measure);
  } else {
    y = myChart[yAxis.type]("y", opts.y);
  };
  if(!(yAxis.type === "addPctAxis")) y.showPercent = yAxis.showPercent;
  if (yAxis.orderRule) y.addOrderRule(yAxis.orderRule);
  if (yAxis.grouporderRule) y.addGroupOrderRule(yAxis.grouporderRule);
  if (yAxis.overrideMin) y.overrideMin = yAxis.overrideMin;
  if (yAxis.overrideMax) y.overrideMax = yAxis.overrideMax;
  if (yAxis.inputFormat) y.dateParseFormat = yAxis.inputFormat;
  if (yAxis.outputFormat) y.tickFormat = yAxis.outputFormat;
//z for bubbles
    var z;
  if (!(typeof(zAxis) === 'undefined') && zAxis.type){
    if(zAxis.measure) {
      z = myChart[zAxis.type]("z",opts.z,zAxis.measure);
    } else {
      z = myChart[zAxis.type]("z", opts.z);
    };
    if(!(zAxis.type === "addPctAxis")) z.showPercent = zAxis.showPercent;
    if (zAxis.orderRule) z.addOrderRule(zAxis.orderRule);
    if (zAxis.overrideMin) z.overrideMin = zAxis.overrideMin;
    if (zAxis.overrideMax) z.overrideMax = zAxis.overrideMax;
  }
  if(d3.keys(colorAxis).length > 0) {
    myChart[colorAxis.type](colorAxis.colorSeries,colorAxis.palette) ;
  }
  
  //here need think I need to evaluate group and if missing do null
  //as the first argument
  //if provided need to use groups from opts
  if(opts.hasOwnProperty("groups")) {
    var s = myChart.addSeries( opts.groups, dimple.plot[opts.type] );
    //series offers an aggregate method that we will also need to check if available
    //options available are avg, count, max, min, sum
    if (!(typeof(opts.aggregate) === 'undefined')) {
      s.aggregate = eval(opts.aggregate);
    }
    if (!(typeof(opts.lineWeight) === 'undefined')) {
      s.lineWeight = eval(opts.lineWeight);
    }
    if (!(typeof(opts.barGap) === 'undefined')) {
      s.barGap = eval(opts.barGap);
    }    
  } else var s = myChart.addSeries( null, dimple.plot[opts.type] );
  //unsure if this is best but if legend is provided (not empty) then evaluate
  if(d3.keys(legend).length > 0) {
    var l =myChart.addLegend();
    d3.keys(legend).forEach(function(d){
      l[d] = legend[d];
    });
  }
  //quick way to get this going but need to make this cleaner
  if(opts.storyboard) {
    myChart.setStoryboard(opts.storyboard);
  };
  myChart.draw();

</script>


## Example 4 - Color and Sort by Tissue


```r
d1 <- dPlot(
  y = "Zscore",
  x = "Cell",
  groups = "Tissue",
  data = data,
  type = "bubble",
  width = 1000,
  height = 600,
  bounds = list(x=90,y=50,height=450,width=850),
  id = "chart4"
)
d1$xAxis( type = "addCategoryAxis", orderRule = "Tissue" )
d1$yAxis( type = "addMeasureAxis" )
d1$legend( x = 90, y = 10, width = 850, height = 20,
  horizontalAlign = "right")
d1$print(d1$params$id)
```


<div id='chart4' class='rChart dimple'></div>
<script type="text/javascript">
  var opts = {
 "dom": "chart4",
"width":   1000,
"height":    600,
"x": "Cell",
"y": "Zscore",
"groups": "Tissue",
"type": "bubble",
"bounds": {
 "x":     90,
"y":     50,
"height":    450,
"width":    850 
},
"id": "chart4" 
},
    data = [
 {
 "Zscore":  1.594,
"Cell": "HTR8svn",
"Tissue": "Blastula",
"Colour":      2 
},
{
 "Zscore":  0.024,
"Cell": "Adult_CD4+",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  5.231,
"Cell": "CD14+",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  3.933,
"Cell": "CD20+",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  6.222,
"Cell": "CD34+",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  0.164,
"Cell": "CLL",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  3.324,
"Cell": "CMK",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  2.913,
"Cell": "GM06990",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  3.357,
"Cell": "GM12864",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  4.041,
"Cell": "GM12865",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  5.082,
"Cell": "GM12878",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  2.727,
"Cell": "GM12891",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  2.739,
"Cell": "GM12892",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  3.042,
"Cell": "GM18507",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  2.308,
"Cell": "GM19238",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  0.286,
"Cell": "GM19239",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  1.965,
"Cell": "GM19240",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  3.534,
"Cell": "HL-60",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  1.518,
"Cell": "Jurkat",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  4.553,
"Cell": "K562",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  0.937,
"Cell": "NB4",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  5.124,
"Cell": "Th1",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":    0.4,
"Cell": "Th2",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  2.467,
"Cell": "AoAF",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  1.475,
"Cell": "AoSMC",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  1.591,
"Cell": "HBMEC",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  2.943,
"Cell": "HMVEC-dAd",
"Tissue": "Blood vessel",
"Colour":      1 
},
{
 "Zscore":  2.081,
"Cell": "HMVEC-dBl-Ad",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  3.083,
"Cell": "HMVEC-dBl-Neo",
"Tissue": "Blood vessel",
"Colour":      1 
},
{
 "Zscore":  4.252,
"Cell": "HMVEC-dLy-Ad",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  3.951,
"Cell": "HMVEC-dLy-Neo",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  3.006,
"Cell": "HMVEC-dNeo",
"Tissue": "Blood vessel",
"Colour":      1 
},
{
 "Zscore":  3.578,
"Cell": "HMVEC-LBl",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  3.332,
"Cell": "HMVEC-LLy",
"Tissue": "Blood vessel",
"Colour":      1 
},
{
 "Zscore":  3.641,
"Cell": "HPAEC",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  1.918,
"Cell": "HPAF",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  4.157,
"Cell": "HUVEC",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  1.074,
"Cell": "Osteobl",
"Tissue": "Bone",
"Colour":      2 
},
{
 "Zscore":  3.416,
"Cell": "BE2_C",
"Tissue": "Brain",
"Colour":      0 
},
{
 "Zscore":  1.729,
"Cell": "Gliobla",
"Tissue": "Brain",
"Colour":      2 
},
{
 "Zscore": -0.229,
"Cell": "Medullo",
"Tissue": "Brain",
"Colour":      2 
},
{
 "Zscore":  2.765,
"Cell": "SK-N-MC",
"Tissue": "Brain",
"Colour":      1 
},
{
 "Zscore": -0.071,
"Cell": "SK-N-SH",
"Tissue": "Brain",
"Colour":      2 
},
{
 "Zscore":  0.321,
"Cell": "HA-h",
"Tissue": "Brain hippocampus",
"Colour":      2 
},
{
 "Zscore":  4.151,
"Cell": "HMEC",
"Tissue": "Breast",
"Colour":      0 
},
{
 "Zscore":  2.497,
"Cell": "HMF",
"Tissue": "Breast",
"Colour":      2 
},
{
 "Zscore":  2.295,
"Cell": "MCF-7",
"Tissue": "Breast",
"Colour":      2 
},
{
 "Zscore":  0.911,
"Cell": "MCF-7",
"Tissue": "Breast",
"Colour":      2 
},
{
 "Zscore":  1.949,
"Cell": "T-47D",
"Tissue": "Breast",
"Colour":      2 
},
{
 "Zscore":  3.285,
"Cell": "HAc",
"Tissue": "Cerebellar",
"Colour":      1 
},
{
 "Zscore":      3,
"Cell": "HeLa-S3",
"Tissue": "Cervix",
"Colour":      1 
},
{
 "Zscore":  -1.23,
"Cell": "HeLa-S3",
"Tissue": "Cervix",
"Colour":      2 
},
{
 "Zscore": -0.894,
"Cell": "Caco-2",
"Tissue": "Colon",
"Colour":      2 
},
{
 "Zscore":  0.853,
"Cell": "HCT-116",
"Tissue": "Colon",
"Colour":      2 
},
{
 "Zscore":   3.59,
"Cell": "HVMF",
"Tissue": "Connective",
"Colour":      0 
},
{
 "Zscore":  3.643,
"Cell": "WI-38",
"Tissue": "Embryonic lung",
"Colour":      0 
},
{
 "Zscore":  1.772,
"Cell": "WI-38",
"Tissue": "Embryonic lung",
"Colour":      2 
},
{
 "Zscore":  2.276,
"Cell": "A549",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  2.301,
"Cell": "HAEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  3.088,
"Cell": "HCPEpiC",
"Tissue": "Epithelium",
"Colour":      1 
},
{
 "Zscore":   0.07,
"Cell": "HEEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  2.422,
"Cell": "HIPEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  1.572,
"Cell": "HNPCEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  1.864,
"Cell": "HPdLF",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  0.408,
"Cell": "HRCEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  0.838,
"Cell": "HRE",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  1.202,
"Cell": "HRPEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore": -0.645,
"Cell": "pHTE",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  0.794,
"Cell": "RPTEC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  0.866,
"Cell": "SAEC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  1.978,
"Cell": "HESC",
"Tissue": "ES cell",
"Colour":      2 
},
{
 "Zscore":   1.14,
"Cell": "hESCT0",
"Tissue": "ES cell",
"Colour":      2 
},
{
 "Zscore":  0.603,
"Cell": "H9ES",
"Tissue": "ES cell",
"Colour":      2 
},
{
 "Zscore":  3.268,
"Cell": "HConF",
"Tissue": "Eye",
"Colour":      1 
},
{
 "Zscore": -1.378,
"Cell": "WERI-Rb-1",
"Tissue": "Eye",
"Colour":      2 
},
{
 "Zscore":  2.304,
"Cell": "Chorion",
"Tissue": "Fetal membrane",
"Colour":      2 
},
{
 "Zscore":  2.038,
"Cell": "HFF",
"Tissue": "Foreskin",
"Colour":      2 
},
{
 "Zscore":  1.275,
"Cell": "HFF-Myc",
"Tissue": "Foreskin",
"Colour":      2 
},
{
 "Zscore":  1.486,
"Cell": "AG09319",
"Tissue": "Gingival",
"Colour":      2 
},
{
 "Zscore":  2.979,
"Cell": "HGF",
"Tissue": "Gingival",
"Colour":      1 
},
{
 "Zscore":  1.657,
"Cell": "HCFaa",
"Tissue": "Heart",
"Colour":      2 
},
{
 "Zscore":  1.726,
"Cell": "HCF",
"Tissue": "Heart",
"Colour":      2 
},
{
 "Zscore":  3.169,
"Cell": "HCM",
"Tissue": "Heart",
"Colour":      1 
},
{
 "Zscore":  0.607,
"Cell": "iPS",
"Tissue": "IPS",
"Colour":      2 
},
{
 "Zscore":  4.511,
"Cell": "HRGEC",
"Tissue": "Kidney",
"Colour":      0 
},
{
 "Zscore":  1.238,
"Cell": "8988T",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore":   0.71,
"Cell": "Hepatocytes",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore":  2.314,
"Cell": "HepG2",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore":   0.68,
"Cell": "Huh-7.5",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore": -0.239,
"Cell": "Huh-7",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore":  2.588,
"Cell": "Stellate",
"Tissue": "Liver",
"Colour":      1 
},
{
 "Zscore":  2.258,
"Cell": "AG04450",
"Tissue": "Lung",
"Colour":      2 
},
{
 "Zscore":  0.951,
"Cell": "HPF",
"Tissue": "Lung",
"Colour":      2 
},
{
 "Zscore":  0.723,
"Cell": "NHLF",
"Tissue": "Lung",
"Colour":      2 
},
{
 "Zscore":  1.665,
"Cell": "E_myoblast",
"Tissue": "Muscle",
"Colour":      2 
},
{
 "Zscore":  3.637,
"Cell": "HSMM",
"Tissue": "Muscle",
"Colour":      0 
},
{
 "Zscore":  3.317,
"Cell": "HSMM",
"Tissue": "Muscle",
"Colour":      1 
},
{
 "Zscore":  1.984,
"Cell": "SKMC",
"Tissue": "Muscle",
"Colour":      2 
},
{
 "Zscore":  1.638,
"Cell": "Myometr",
"Tissue": "Myometrium",
"Colour":      2 
},
{
 "Zscore":  2.151,
"Cell": "NH-A",
"Tissue": "Nervous",
"Colour":      2 
},
{
 "Zscore":   2.29,
"Cell": "PANC-1",
"Tissue": "Pancreas",
"Colour":      2 
},
{
 "Zscore":  1.535,
"Cell": "PanIsletD",
"Tissue": "Pancreas",
"Colour":      2 
},
{
 "Zscore":  0.732,
"Cell": "PanIslets",
"Tissue": "Pancreas",
"Colour":      2 
},
{
 "Zscore":  0.833,
"Cell": "HPDE6-E6E7",
"Tissue": "Pancreatic duct",
"Colour":      2 
},
{
 "Zscore":  2.519,
"Cell": "LNCaP",
"Tissue": "Prostate",
"Colour":      2 
},
{
 "Zscore":  0.929,
"Cell": "LNCaP",
"Tissue": "Prostate",
"Colour":      2 
},
{
 "Zscore":   2.12,
"Cell": "PrEC",
"Tissue": "Prostate",
"Colour":      2 
},
{
 "Zscore":  0.301,
"Cell": "RWPE1",
"Tissue": "Prostate",
"Colour":      2 
},
{
 "Zscore":  0.817,
"Cell": "AG04449",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":   1.95,
"Cell": "AG09309",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  2.226,
"Cell": "AG10803",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  1.785,
"Cell": "BJ",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":   1.66,
"Cell": "Fibrobl",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  1.131,
"Cell": "FibroP",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  0.883,
"Cell": "Melano",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  1.529,
"Cell": "NHDF-Ad",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  2.457,
"Cell": "NHDF-neo",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  5.625,
"Cell": "NHEK",
"Tissue": "Skin",
"Colour":      0 
},
{
 "Zscore":  1.475,
"Cell": "ProgFib",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  1.422,
"Cell": "HA-sp",
"Tissue": "Spinal cord",
"Colour":      2 
},
{
 "Zscore":  2.935,
"Cell": "NT2-D1",
"Tissue": "Testis",
"Colour":      1 
},
{
 "Zscore":  3.513,
"Cell": "Urothelia",
"Tissue": "Urothelium",
"Colour":      0 
},
{
 "Zscore":  2.931,
"Cell": "Urothelia",
"Tissue": "Urothelium",
"Colour":      1 
},
{
 "Zscore":  0.927,
"Cell": "Ishikawa",
"Tissue": "Uterus",
"Colour":      2 
},
{
 "Zscore": -0.246,
"Cell": "Ishikawa",
"Tissue": "Uterus",
"Colour":      2 
} 
],
    xAxis = {
 "type": "addCategoryAxis",
"showPercent": false,
"orderRule": "Tissue" 
},
    yAxis = {
 "type": "addMeasureAxis",
"showPercent": false 
},
    zAxis = [],
    colorAxis = [],
    legend = {
 "x":     90,
"y":     10,
"width":    850,
"height":     20,
"horizontalAlign": "right" 
};
  var svg = dimple.newSvg("#" + opts.id, opts.width, opts.height);

  //data = dimple.filterData(data, "Owner", ["Aperture", "Black Mesa"])
  var myChart = new dimple.chart(svg, data);
  if (opts.bounds) {
    myChart.setBounds(opts.bounds.x, opts.bounds.y, opts.bounds.width, opts.bounds.height);//myChart.setBounds(80, 30, 480, 330);
  }
  //dimple allows use of custom CSS with noFormats
  if(opts.noFormats) { myChart.noFormats = opts.noFormats; };
  //for markimekko and addAxis also have third parameter measure
  //so need to evaluate if measure provided
  //x axis
  var x;
  if(xAxis.measure) {
    x = myChart[xAxis.type]("x",opts.x,xAxis.measure);
  } else {
    x = myChart[xAxis.type]("x", opts.x);
  };
  if(!(xAxis.type === "addPctAxis")) x.showPercent = xAxis.showPercent;
  if (xAxis.orderRule) x.addOrderRule(xAxis.orderRule);
  if (xAxis.grouporderRule) x.addGroupOrderRule(xAxis.grouporderRule);  
  if (xAxis.overrideMin) x.overrideMin = xAxis.overrideMin;
  if (xAxis.overrideMax) x.overrideMax = xAxis.overrideMax;
  if (xAxis.overrideMax) x.overrideMax = xAxis.overrideMax;
  if (xAxis.inputFormat) x.dateParseFormat = xAxis.inputFormat;
  if (xAxis.outputFormat) x.tickFormat = xAxis.outputFormat;
  //y axis
  var y;
  if(yAxis.measure) {
    y = myChart[yAxis.type]("y",opts.y,yAxis.measure);
  } else {
    y = myChart[yAxis.type]("y", opts.y);
  };
  if(!(yAxis.type === "addPctAxis")) y.showPercent = yAxis.showPercent;
  if (yAxis.orderRule) y.addOrderRule(yAxis.orderRule);
  if (yAxis.grouporderRule) y.addGroupOrderRule(yAxis.grouporderRule);
  if (yAxis.overrideMin) y.overrideMin = yAxis.overrideMin;
  if (yAxis.overrideMax) y.overrideMax = yAxis.overrideMax;
  if (yAxis.inputFormat) y.dateParseFormat = yAxis.inputFormat;
  if (yAxis.outputFormat) y.tickFormat = yAxis.outputFormat;
//z for bubbles
    var z;
  if (!(typeof(zAxis) === 'undefined') && zAxis.type){
    if(zAxis.measure) {
      z = myChart[zAxis.type]("z",opts.z,zAxis.measure);
    } else {
      z = myChart[zAxis.type]("z", opts.z);
    };
    if(!(zAxis.type === "addPctAxis")) z.showPercent = zAxis.showPercent;
    if (zAxis.orderRule) z.addOrderRule(zAxis.orderRule);
    if (zAxis.overrideMin) z.overrideMin = zAxis.overrideMin;
    if (zAxis.overrideMax) z.overrideMax = zAxis.overrideMax;
  }
  if(d3.keys(colorAxis).length > 0) {
    myChart[colorAxis.type](colorAxis.colorSeries,colorAxis.palette) ;
  }
  
  //here need think I need to evaluate group and if missing do null
  //as the first argument
  //if provided need to use groups from opts
  if(opts.hasOwnProperty("groups")) {
    var s = myChart.addSeries( opts.groups, dimple.plot[opts.type] );
    //series offers an aggregate method that we will also need to check if available
    //options available are avg, count, max, min, sum
    if (!(typeof(opts.aggregate) === 'undefined')) {
      s.aggregate = eval(opts.aggregate);
    }
    if (!(typeof(opts.lineWeight) === 'undefined')) {
      s.lineWeight = eval(opts.lineWeight);
    }
    if (!(typeof(opts.barGap) === 'undefined')) {
      s.barGap = eval(opts.barGap);
    }    
  } else var s = myChart.addSeries( null, dimple.plot[opts.type] );
  //unsure if this is best but if legend is provided (not empty) then evaluate
  if(d3.keys(legend).length > 0) {
    var l =myChart.addLegend();
    d3.keys(legend).forEach(function(d){
      l[d] = legend[d];
    });
  }
  //quick way to get this going but need to make this cleaner
  if(opts.storyboard) {
    myChart.setStoryboard(opts.storyboard);
  };
  myChart.draw();

</script>


## Example 5 - Tissue on X, Cell on Y, and Zscore as Size


```r
d1 <- dPlot(
  y = "Cell",
  x = "Tissue",
  z = "Zscore",
  data = data,
  type = "bubble",
  width = 1000,
  height = 600,
  bounds = list(x=90,y=50,height=450,width=850),
  id = "chart5"
)
d1$xAxis( type = "addCategoryAxis", orderRule = "Tissue" )
d1$yAxis( type = "addCategoryAxis", orderRule = "Zscore" )
d1$zAxis( type = "addMeasureAxis", overrideMax = 30 )
d1$colorAxis(
  type = "addColorAxis",
  colorSeries = "Zscore",
  palette = c("red","yellow","green") )
d1$print(d1$params$id)
```


<div id='chart5' class='rChart dimple'></div>
<script type="text/javascript">
  var opts = {
 "dom": "chart5",
"width":   1000,
"height":    600,
"x": "Tissue",
"y": "Cell",
"z": "Zscore",
"type": "bubble",
"bounds": {
 "x":     90,
"y":     50,
"height":    450,
"width":    850 
},
"id": "chart5" 
},
    data = [
 {
 "Zscore":  1.594,
"Cell": "HTR8svn",
"Tissue": "Blastula",
"Colour":      2 
},
{
 "Zscore":  0.024,
"Cell": "Adult_CD4+",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  5.231,
"Cell": "CD14+",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  3.933,
"Cell": "CD20+",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  6.222,
"Cell": "CD34+",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  0.164,
"Cell": "CLL",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  3.324,
"Cell": "CMK",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  2.913,
"Cell": "GM06990",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  3.357,
"Cell": "GM12864",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  4.041,
"Cell": "GM12865",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  5.082,
"Cell": "GM12878",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  2.727,
"Cell": "GM12891",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  2.739,
"Cell": "GM12892",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  3.042,
"Cell": "GM18507",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  2.308,
"Cell": "GM19238",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  0.286,
"Cell": "GM19239",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  1.965,
"Cell": "GM19240",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  3.534,
"Cell": "HL-60",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  1.518,
"Cell": "Jurkat",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  4.553,
"Cell": "K562",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  0.937,
"Cell": "NB4",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  5.124,
"Cell": "Th1",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":    0.4,
"Cell": "Th2",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  2.467,
"Cell": "AoAF",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  1.475,
"Cell": "AoSMC",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  1.591,
"Cell": "HBMEC",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  2.943,
"Cell": "HMVEC-dAd",
"Tissue": "Blood vessel",
"Colour":      1 
},
{
 "Zscore":  2.081,
"Cell": "HMVEC-dBl-Ad",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  3.083,
"Cell": "HMVEC-dBl-Neo",
"Tissue": "Blood vessel",
"Colour":      1 
},
{
 "Zscore":  4.252,
"Cell": "HMVEC-dLy-Ad",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  3.951,
"Cell": "HMVEC-dLy-Neo",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  3.006,
"Cell": "HMVEC-dNeo",
"Tissue": "Blood vessel",
"Colour":      1 
},
{
 "Zscore":  3.578,
"Cell": "HMVEC-LBl",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  3.332,
"Cell": "HMVEC-LLy",
"Tissue": "Blood vessel",
"Colour":      1 
},
{
 "Zscore":  3.641,
"Cell": "HPAEC",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  1.918,
"Cell": "HPAF",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  4.157,
"Cell": "HUVEC",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  1.074,
"Cell": "Osteobl",
"Tissue": "Bone",
"Colour":      2 
},
{
 "Zscore":  3.416,
"Cell": "BE2_C",
"Tissue": "Brain",
"Colour":      0 
},
{
 "Zscore":  1.729,
"Cell": "Gliobla",
"Tissue": "Brain",
"Colour":      2 
},
{
 "Zscore": -0.229,
"Cell": "Medullo",
"Tissue": "Brain",
"Colour":      2 
},
{
 "Zscore":  2.765,
"Cell": "SK-N-MC",
"Tissue": "Brain",
"Colour":      1 
},
{
 "Zscore": -0.071,
"Cell": "SK-N-SH",
"Tissue": "Brain",
"Colour":      2 
},
{
 "Zscore":  0.321,
"Cell": "HA-h",
"Tissue": "Brain hippocampus",
"Colour":      2 
},
{
 "Zscore":  4.151,
"Cell": "HMEC",
"Tissue": "Breast",
"Colour":      0 
},
{
 "Zscore":  2.497,
"Cell": "HMF",
"Tissue": "Breast",
"Colour":      2 
},
{
 "Zscore":  2.295,
"Cell": "MCF-7",
"Tissue": "Breast",
"Colour":      2 
},
{
 "Zscore":  0.911,
"Cell": "MCF-7",
"Tissue": "Breast",
"Colour":      2 
},
{
 "Zscore":  1.949,
"Cell": "T-47D",
"Tissue": "Breast",
"Colour":      2 
},
{
 "Zscore":  3.285,
"Cell": "HAc",
"Tissue": "Cerebellar",
"Colour":      1 
},
{
 "Zscore":      3,
"Cell": "HeLa-S3",
"Tissue": "Cervix",
"Colour":      1 
},
{
 "Zscore":  -1.23,
"Cell": "HeLa-S3",
"Tissue": "Cervix",
"Colour":      2 
},
{
 "Zscore": -0.894,
"Cell": "Caco-2",
"Tissue": "Colon",
"Colour":      2 
},
{
 "Zscore":  0.853,
"Cell": "HCT-116",
"Tissue": "Colon",
"Colour":      2 
},
{
 "Zscore":   3.59,
"Cell": "HVMF",
"Tissue": "Connective",
"Colour":      0 
},
{
 "Zscore":  3.643,
"Cell": "WI-38",
"Tissue": "Embryonic lung",
"Colour":      0 
},
{
 "Zscore":  1.772,
"Cell": "WI-38",
"Tissue": "Embryonic lung",
"Colour":      2 
},
{
 "Zscore":  2.276,
"Cell": "A549",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  2.301,
"Cell": "HAEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  3.088,
"Cell": "HCPEpiC",
"Tissue": "Epithelium",
"Colour":      1 
},
{
 "Zscore":   0.07,
"Cell": "HEEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  2.422,
"Cell": "HIPEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  1.572,
"Cell": "HNPCEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  1.864,
"Cell": "HPdLF",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  0.408,
"Cell": "HRCEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  0.838,
"Cell": "HRE",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  1.202,
"Cell": "HRPEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore": -0.645,
"Cell": "pHTE",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  0.794,
"Cell": "RPTEC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  0.866,
"Cell": "SAEC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  1.978,
"Cell": "HESC",
"Tissue": "ES cell",
"Colour":      2 
},
{
 "Zscore":   1.14,
"Cell": "hESCT0",
"Tissue": "ES cell",
"Colour":      2 
},
{
 "Zscore":  0.603,
"Cell": "H9ES",
"Tissue": "ES cell",
"Colour":      2 
},
{
 "Zscore":  3.268,
"Cell": "HConF",
"Tissue": "Eye",
"Colour":      1 
},
{
 "Zscore": -1.378,
"Cell": "WERI-Rb-1",
"Tissue": "Eye",
"Colour":      2 
},
{
 "Zscore":  2.304,
"Cell": "Chorion",
"Tissue": "Fetal membrane",
"Colour":      2 
},
{
 "Zscore":  2.038,
"Cell": "HFF",
"Tissue": "Foreskin",
"Colour":      2 
},
{
 "Zscore":  1.275,
"Cell": "HFF-Myc",
"Tissue": "Foreskin",
"Colour":      2 
},
{
 "Zscore":  1.486,
"Cell": "AG09319",
"Tissue": "Gingival",
"Colour":      2 
},
{
 "Zscore":  2.979,
"Cell": "HGF",
"Tissue": "Gingival",
"Colour":      1 
},
{
 "Zscore":  1.657,
"Cell": "HCFaa",
"Tissue": "Heart",
"Colour":      2 
},
{
 "Zscore":  1.726,
"Cell": "HCF",
"Tissue": "Heart",
"Colour":      2 
},
{
 "Zscore":  3.169,
"Cell": "HCM",
"Tissue": "Heart",
"Colour":      1 
},
{
 "Zscore":  0.607,
"Cell": "iPS",
"Tissue": "IPS",
"Colour":      2 
},
{
 "Zscore":  4.511,
"Cell": "HRGEC",
"Tissue": "Kidney",
"Colour":      0 
},
{
 "Zscore":  1.238,
"Cell": "8988T",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore":   0.71,
"Cell": "Hepatocytes",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore":  2.314,
"Cell": "HepG2",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore":   0.68,
"Cell": "Huh-7.5",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore": -0.239,
"Cell": "Huh-7",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore":  2.588,
"Cell": "Stellate",
"Tissue": "Liver",
"Colour":      1 
},
{
 "Zscore":  2.258,
"Cell": "AG04450",
"Tissue": "Lung",
"Colour":      2 
},
{
 "Zscore":  0.951,
"Cell": "HPF",
"Tissue": "Lung",
"Colour":      2 
},
{
 "Zscore":  0.723,
"Cell": "NHLF",
"Tissue": "Lung",
"Colour":      2 
},
{
 "Zscore":  1.665,
"Cell": "E_myoblast",
"Tissue": "Muscle",
"Colour":      2 
},
{
 "Zscore":  3.637,
"Cell": "HSMM",
"Tissue": "Muscle",
"Colour":      0 
},
{
 "Zscore":  3.317,
"Cell": "HSMM",
"Tissue": "Muscle",
"Colour":      1 
},
{
 "Zscore":  1.984,
"Cell": "SKMC",
"Tissue": "Muscle",
"Colour":      2 
},
{
 "Zscore":  1.638,
"Cell": "Myometr",
"Tissue": "Myometrium",
"Colour":      2 
},
{
 "Zscore":  2.151,
"Cell": "NH-A",
"Tissue": "Nervous",
"Colour":      2 
},
{
 "Zscore":   2.29,
"Cell": "PANC-1",
"Tissue": "Pancreas",
"Colour":      2 
},
{
 "Zscore":  1.535,
"Cell": "PanIsletD",
"Tissue": "Pancreas",
"Colour":      2 
},
{
 "Zscore":  0.732,
"Cell": "PanIslets",
"Tissue": "Pancreas",
"Colour":      2 
},
{
 "Zscore":  0.833,
"Cell": "HPDE6-E6E7",
"Tissue": "Pancreatic duct",
"Colour":      2 
},
{
 "Zscore":  2.519,
"Cell": "LNCaP",
"Tissue": "Prostate",
"Colour":      2 
},
{
 "Zscore":  0.929,
"Cell": "LNCaP",
"Tissue": "Prostate",
"Colour":      2 
},
{
 "Zscore":   2.12,
"Cell": "PrEC",
"Tissue": "Prostate",
"Colour":      2 
},
{
 "Zscore":  0.301,
"Cell": "RWPE1",
"Tissue": "Prostate",
"Colour":      2 
},
{
 "Zscore":  0.817,
"Cell": "AG04449",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":   1.95,
"Cell": "AG09309",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  2.226,
"Cell": "AG10803",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  1.785,
"Cell": "BJ",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":   1.66,
"Cell": "Fibrobl",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  1.131,
"Cell": "FibroP",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  0.883,
"Cell": "Melano",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  1.529,
"Cell": "NHDF-Ad",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  2.457,
"Cell": "NHDF-neo",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  5.625,
"Cell": "NHEK",
"Tissue": "Skin",
"Colour":      0 
},
{
 "Zscore":  1.475,
"Cell": "ProgFib",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  1.422,
"Cell": "HA-sp",
"Tissue": "Spinal cord",
"Colour":      2 
},
{
 "Zscore":  2.935,
"Cell": "NT2-D1",
"Tissue": "Testis",
"Colour":      1 
},
{
 "Zscore":  3.513,
"Cell": "Urothelia",
"Tissue": "Urothelium",
"Colour":      0 
},
{
 "Zscore":  2.931,
"Cell": "Urothelia",
"Tissue": "Urothelium",
"Colour":      1 
},
{
 "Zscore":  0.927,
"Cell": "Ishikawa",
"Tissue": "Uterus",
"Colour":      2 
},
{
 "Zscore": -0.246,
"Cell": "Ishikawa",
"Tissue": "Uterus",
"Colour":      2 
} 
],
    xAxis = {
 "type": "addCategoryAxis",
"showPercent": false,
"orderRule": "Tissue" 
},
    yAxis = {
 "type": "addCategoryAxis",
"showPercent": false,
"orderRule": "Zscore" 
},
    zAxis = {
 "type": "addMeasureAxis",
"overrideMax":     30 
},
    colorAxis = {
 "type": "addColorAxis",
"colorSeries": "Zscore",
"palette": [ "red", "yellow", "green" ] 
},
    legend = [];
  var svg = dimple.newSvg("#" + opts.id, opts.width, opts.height);

  //data = dimple.filterData(data, "Owner", ["Aperture", "Black Mesa"])
  var myChart = new dimple.chart(svg, data);
  if (opts.bounds) {
    myChart.setBounds(opts.bounds.x, opts.bounds.y, opts.bounds.width, opts.bounds.height);//myChart.setBounds(80, 30, 480, 330);
  }
  //dimple allows use of custom CSS with noFormats
  if(opts.noFormats) { myChart.noFormats = opts.noFormats; };
  //for markimekko and addAxis also have third parameter measure
  //so need to evaluate if measure provided
  //x axis
  var x;
  if(xAxis.measure) {
    x = myChart[xAxis.type]("x",opts.x,xAxis.measure);
  } else {
    x = myChart[xAxis.type]("x", opts.x);
  };
  if(!(xAxis.type === "addPctAxis")) x.showPercent = xAxis.showPercent;
  if (xAxis.orderRule) x.addOrderRule(xAxis.orderRule);
  if (xAxis.grouporderRule) x.addGroupOrderRule(xAxis.grouporderRule);  
  if (xAxis.overrideMin) x.overrideMin = xAxis.overrideMin;
  if (xAxis.overrideMax) x.overrideMax = xAxis.overrideMax;
  if (xAxis.overrideMax) x.overrideMax = xAxis.overrideMax;
  if (xAxis.inputFormat) x.dateParseFormat = xAxis.inputFormat;
  if (xAxis.outputFormat) x.tickFormat = xAxis.outputFormat;
  //y axis
  var y;
  if(yAxis.measure) {
    y = myChart[yAxis.type]("y",opts.y,yAxis.measure);
  } else {
    y = myChart[yAxis.type]("y", opts.y);
  };
  if(!(yAxis.type === "addPctAxis")) y.showPercent = yAxis.showPercent;
  if (yAxis.orderRule) y.addOrderRule(yAxis.orderRule);
  if (yAxis.grouporderRule) y.addGroupOrderRule(yAxis.grouporderRule);
  if (yAxis.overrideMin) y.overrideMin = yAxis.overrideMin;
  if (yAxis.overrideMax) y.overrideMax = yAxis.overrideMax;
  if (yAxis.inputFormat) y.dateParseFormat = yAxis.inputFormat;
  if (yAxis.outputFormat) y.tickFormat = yAxis.outputFormat;
//z for bubbles
    var z;
  if (!(typeof(zAxis) === 'undefined') && zAxis.type){
    if(zAxis.measure) {
      z = myChart[zAxis.type]("z",opts.z,zAxis.measure);
    } else {
      z = myChart[zAxis.type]("z", opts.z);
    };
    if(!(zAxis.type === "addPctAxis")) z.showPercent = zAxis.showPercent;
    if (zAxis.orderRule) z.addOrderRule(zAxis.orderRule);
    if (zAxis.overrideMin) z.overrideMin = zAxis.overrideMin;
    if (zAxis.overrideMax) z.overrideMax = zAxis.overrideMax;
  }
  if(d3.keys(colorAxis).length > 0) {
    myChart[colorAxis.type](colorAxis.colorSeries,colorAxis.palette) ;
  }
  
  //here need think I need to evaluate group and if missing do null
  //as the first argument
  //if provided need to use groups from opts
  if(opts.hasOwnProperty("groups")) {
    var s = myChart.addSeries( opts.groups, dimple.plot[opts.type] );
    //series offers an aggregate method that we will also need to check if available
    //options available are avg, count, max, min, sum
    if (!(typeof(opts.aggregate) === 'undefined')) {
      s.aggregate = eval(opts.aggregate);
    }
    if (!(typeof(opts.lineWeight) === 'undefined')) {
      s.lineWeight = eval(opts.lineWeight);
    }
    if (!(typeof(opts.barGap) === 'undefined')) {
      s.barGap = eval(opts.barGap);
    }    
  } else var s = myChart.addSeries( null, dimple.plot[opts.type] );
  //unsure if this is best but if legend is provided (not empty) then evaluate
  if(d3.keys(legend).length > 0) {
    var l =myChart.addLegend();
    d3.keys(legend).forEach(function(d){
      l[d] = legend[d];
    });
  }
  //quick way to get this going but need to make this cleaner
  if(opts.storyboard) {
    myChart.setStoryboard(opts.storyboard);
  };
  myChart.draw();

</script>


## Example 6 - Flip 5 and Colour by Tissue


```r
d1 <- dPlot(
  x = "Cell",
  y = "Tissue",
  z = "Zscore",
  groups = "Tissue",
  data = data,
  type = "bubble",
  width = 1000,
  height = 600,
  bounds = list(x=90,y=50,height=450,width=800),
  id = "chart6"
)
d1$yAxis( type = "addCategoryAxis", orderRule = "Tissue" )
d1$zAxis( type = "addCategoryAxis", orderRule = "Zscore" )
d1$zAxis( type = "addMeasureAxis", overrideMax = 30 )
d1$print(d1$params$id)
```


<div id='chart6' class='rChart dimple'></div>
<script type="text/javascript">
  var opts = {
 "dom": "chart6",
"width":   1000,
"height":    600,
"x": "Cell",
"y": "Tissue",
"z": "Zscore",
"groups": "Tissue",
"type": "bubble",
"bounds": {
 "x":     90,
"y":     50,
"height":    450,
"width":    800 
},
"id": "chart6" 
},
    data = [
 {
 "Zscore":  1.594,
"Cell": "HTR8svn",
"Tissue": "Blastula",
"Colour":      2 
},
{
 "Zscore":  0.024,
"Cell": "Adult_CD4+",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  5.231,
"Cell": "CD14+",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  3.933,
"Cell": "CD20+",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  6.222,
"Cell": "CD34+",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  0.164,
"Cell": "CLL",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  3.324,
"Cell": "CMK",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  2.913,
"Cell": "GM06990",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  3.357,
"Cell": "GM12864",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  4.041,
"Cell": "GM12865",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  5.082,
"Cell": "GM12878",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  2.727,
"Cell": "GM12891",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  2.739,
"Cell": "GM12892",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  3.042,
"Cell": "GM18507",
"Tissue": "Blood",
"Colour":      1 
},
{
 "Zscore":  2.308,
"Cell": "GM19238",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  0.286,
"Cell": "GM19239",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  1.965,
"Cell": "GM19240",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  3.534,
"Cell": "HL-60",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  1.518,
"Cell": "Jurkat",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  4.553,
"Cell": "K562",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":  0.937,
"Cell": "NB4",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  5.124,
"Cell": "Th1",
"Tissue": "Blood",
"Colour":      0 
},
{
 "Zscore":    0.4,
"Cell": "Th2",
"Tissue": "Blood",
"Colour":      2 
},
{
 "Zscore":  2.467,
"Cell": "AoAF",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  1.475,
"Cell": "AoSMC",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  1.591,
"Cell": "HBMEC",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  2.943,
"Cell": "HMVEC-dAd",
"Tissue": "Blood vessel",
"Colour":      1 
},
{
 "Zscore":  2.081,
"Cell": "HMVEC-dBl-Ad",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  3.083,
"Cell": "HMVEC-dBl-Neo",
"Tissue": "Blood vessel",
"Colour":      1 
},
{
 "Zscore":  4.252,
"Cell": "HMVEC-dLy-Ad",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  3.951,
"Cell": "HMVEC-dLy-Neo",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  3.006,
"Cell": "HMVEC-dNeo",
"Tissue": "Blood vessel",
"Colour":      1 
},
{
 "Zscore":  3.578,
"Cell": "HMVEC-LBl",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  3.332,
"Cell": "HMVEC-LLy",
"Tissue": "Blood vessel",
"Colour":      1 
},
{
 "Zscore":  3.641,
"Cell": "HPAEC",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  1.918,
"Cell": "HPAF",
"Tissue": "Blood vessel",
"Colour":      2 
},
{
 "Zscore":  4.157,
"Cell": "HUVEC",
"Tissue": "Blood vessel",
"Colour":      0 
},
{
 "Zscore":  1.074,
"Cell": "Osteobl",
"Tissue": "Bone",
"Colour":      2 
},
{
 "Zscore":  3.416,
"Cell": "BE2_C",
"Tissue": "Brain",
"Colour":      0 
},
{
 "Zscore":  1.729,
"Cell": "Gliobla",
"Tissue": "Brain",
"Colour":      2 
},
{
 "Zscore": -0.229,
"Cell": "Medullo",
"Tissue": "Brain",
"Colour":      2 
},
{
 "Zscore":  2.765,
"Cell": "SK-N-MC",
"Tissue": "Brain",
"Colour":      1 
},
{
 "Zscore": -0.071,
"Cell": "SK-N-SH",
"Tissue": "Brain",
"Colour":      2 
},
{
 "Zscore":  0.321,
"Cell": "HA-h",
"Tissue": "Brain hippocampus",
"Colour":      2 
},
{
 "Zscore":  4.151,
"Cell": "HMEC",
"Tissue": "Breast",
"Colour":      0 
},
{
 "Zscore":  2.497,
"Cell": "HMF",
"Tissue": "Breast",
"Colour":      2 
},
{
 "Zscore":  2.295,
"Cell": "MCF-7",
"Tissue": "Breast",
"Colour":      2 
},
{
 "Zscore":  0.911,
"Cell": "MCF-7",
"Tissue": "Breast",
"Colour":      2 
},
{
 "Zscore":  1.949,
"Cell": "T-47D",
"Tissue": "Breast",
"Colour":      2 
},
{
 "Zscore":  3.285,
"Cell": "HAc",
"Tissue": "Cerebellar",
"Colour":      1 
},
{
 "Zscore":      3,
"Cell": "HeLa-S3",
"Tissue": "Cervix",
"Colour":      1 
},
{
 "Zscore":  -1.23,
"Cell": "HeLa-S3",
"Tissue": "Cervix",
"Colour":      2 
},
{
 "Zscore": -0.894,
"Cell": "Caco-2",
"Tissue": "Colon",
"Colour":      2 
},
{
 "Zscore":  0.853,
"Cell": "HCT-116",
"Tissue": "Colon",
"Colour":      2 
},
{
 "Zscore":   3.59,
"Cell": "HVMF",
"Tissue": "Connective",
"Colour":      0 
},
{
 "Zscore":  3.643,
"Cell": "WI-38",
"Tissue": "Embryonic lung",
"Colour":      0 
},
{
 "Zscore":  1.772,
"Cell": "WI-38",
"Tissue": "Embryonic lung",
"Colour":      2 
},
{
 "Zscore":  2.276,
"Cell": "A549",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  2.301,
"Cell": "HAEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  3.088,
"Cell": "HCPEpiC",
"Tissue": "Epithelium",
"Colour":      1 
},
{
 "Zscore":   0.07,
"Cell": "HEEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  2.422,
"Cell": "HIPEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  1.572,
"Cell": "HNPCEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  1.864,
"Cell": "HPdLF",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  0.408,
"Cell": "HRCEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  0.838,
"Cell": "HRE",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  1.202,
"Cell": "HRPEpiC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore": -0.645,
"Cell": "pHTE",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  0.794,
"Cell": "RPTEC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  0.866,
"Cell": "SAEC",
"Tissue": "Epithelium",
"Colour":      2 
},
{
 "Zscore":  1.978,
"Cell": "HESC",
"Tissue": "ES cell",
"Colour":      2 
},
{
 "Zscore":   1.14,
"Cell": "hESCT0",
"Tissue": "ES cell",
"Colour":      2 
},
{
 "Zscore":  0.603,
"Cell": "H9ES",
"Tissue": "ES cell",
"Colour":      2 
},
{
 "Zscore":  3.268,
"Cell": "HConF",
"Tissue": "Eye",
"Colour":      1 
},
{
 "Zscore": -1.378,
"Cell": "WERI-Rb-1",
"Tissue": "Eye",
"Colour":      2 
},
{
 "Zscore":  2.304,
"Cell": "Chorion",
"Tissue": "Fetal membrane",
"Colour":      2 
},
{
 "Zscore":  2.038,
"Cell": "HFF",
"Tissue": "Foreskin",
"Colour":      2 
},
{
 "Zscore":  1.275,
"Cell": "HFF-Myc",
"Tissue": "Foreskin",
"Colour":      2 
},
{
 "Zscore":  1.486,
"Cell": "AG09319",
"Tissue": "Gingival",
"Colour":      2 
},
{
 "Zscore":  2.979,
"Cell": "HGF",
"Tissue": "Gingival",
"Colour":      1 
},
{
 "Zscore":  1.657,
"Cell": "HCFaa",
"Tissue": "Heart",
"Colour":      2 
},
{
 "Zscore":  1.726,
"Cell": "HCF",
"Tissue": "Heart",
"Colour":      2 
},
{
 "Zscore":  3.169,
"Cell": "HCM",
"Tissue": "Heart",
"Colour":      1 
},
{
 "Zscore":  0.607,
"Cell": "iPS",
"Tissue": "IPS",
"Colour":      2 
},
{
 "Zscore":  4.511,
"Cell": "HRGEC",
"Tissue": "Kidney",
"Colour":      0 
},
{
 "Zscore":  1.238,
"Cell": "8988T",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore":   0.71,
"Cell": "Hepatocytes",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore":  2.314,
"Cell": "HepG2",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore":   0.68,
"Cell": "Huh-7.5",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore": -0.239,
"Cell": "Huh-7",
"Tissue": "Liver",
"Colour":      2 
},
{
 "Zscore":  2.588,
"Cell": "Stellate",
"Tissue": "Liver",
"Colour":      1 
},
{
 "Zscore":  2.258,
"Cell": "AG04450",
"Tissue": "Lung",
"Colour":      2 
},
{
 "Zscore":  0.951,
"Cell": "HPF",
"Tissue": "Lung",
"Colour":      2 
},
{
 "Zscore":  0.723,
"Cell": "NHLF",
"Tissue": "Lung",
"Colour":      2 
},
{
 "Zscore":  1.665,
"Cell": "E_myoblast",
"Tissue": "Muscle",
"Colour":      2 
},
{
 "Zscore":  3.637,
"Cell": "HSMM",
"Tissue": "Muscle",
"Colour":      0 
},
{
 "Zscore":  3.317,
"Cell": "HSMM",
"Tissue": "Muscle",
"Colour":      1 
},
{
 "Zscore":  1.984,
"Cell": "SKMC",
"Tissue": "Muscle",
"Colour":      2 
},
{
 "Zscore":  1.638,
"Cell": "Myometr",
"Tissue": "Myometrium",
"Colour":      2 
},
{
 "Zscore":  2.151,
"Cell": "NH-A",
"Tissue": "Nervous",
"Colour":      2 
},
{
 "Zscore":   2.29,
"Cell": "PANC-1",
"Tissue": "Pancreas",
"Colour":      2 
},
{
 "Zscore":  1.535,
"Cell": "PanIsletD",
"Tissue": "Pancreas",
"Colour":      2 
},
{
 "Zscore":  0.732,
"Cell": "PanIslets",
"Tissue": "Pancreas",
"Colour":      2 
},
{
 "Zscore":  0.833,
"Cell": "HPDE6-E6E7",
"Tissue": "Pancreatic duct",
"Colour":      2 
},
{
 "Zscore":  2.519,
"Cell": "LNCaP",
"Tissue": "Prostate",
"Colour":      2 
},
{
 "Zscore":  0.929,
"Cell": "LNCaP",
"Tissue": "Prostate",
"Colour":      2 
},
{
 "Zscore":   2.12,
"Cell": "PrEC",
"Tissue": "Prostate",
"Colour":      2 
},
{
 "Zscore":  0.301,
"Cell": "RWPE1",
"Tissue": "Prostate",
"Colour":      2 
},
{
 "Zscore":  0.817,
"Cell": "AG04449",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":   1.95,
"Cell": "AG09309",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  2.226,
"Cell": "AG10803",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  1.785,
"Cell": "BJ",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":   1.66,
"Cell": "Fibrobl",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  1.131,
"Cell": "FibroP",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  0.883,
"Cell": "Melano",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  1.529,
"Cell": "NHDF-Ad",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  2.457,
"Cell": "NHDF-neo",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  5.625,
"Cell": "NHEK",
"Tissue": "Skin",
"Colour":      0 
},
{
 "Zscore":  1.475,
"Cell": "ProgFib",
"Tissue": "Skin",
"Colour":      2 
},
{
 "Zscore":  1.422,
"Cell": "HA-sp",
"Tissue": "Spinal cord",
"Colour":      2 
},
{
 "Zscore":  2.935,
"Cell": "NT2-D1",
"Tissue": "Testis",
"Colour":      1 
},
{
 "Zscore":  3.513,
"Cell": "Urothelia",
"Tissue": "Urothelium",
"Colour":      0 
},
{
 "Zscore":  2.931,
"Cell": "Urothelia",
"Tissue": "Urothelium",
"Colour":      1 
},
{
 "Zscore":  0.927,
"Cell": "Ishikawa",
"Tissue": "Uterus",
"Colour":      2 
},
{
 "Zscore": -0.246,
"Cell": "Ishikawa",
"Tissue": "Uterus",
"Colour":      2 
} 
],
    xAxis = {
 "type": "addCategoryAxis",
"showPercent": false 
},
    yAxis = {
 "type": "addCategoryAxis",
"showPercent": false,
"orderRule": "Tissue" 
},
    zAxis = {
 "type": "addMeasureAxis",
"orderRule": "Zscore",
"overrideMax":     30 
},
    colorAxis = [],
    legend = [];
  var svg = dimple.newSvg("#" + opts.id, opts.width, opts.height);

  //data = dimple.filterData(data, "Owner", ["Aperture", "Black Mesa"])
  var myChart = new dimple.chart(svg, data);
  if (opts.bounds) {
    myChart.setBounds(opts.bounds.x, opts.bounds.y, opts.bounds.width, opts.bounds.height);//myChart.setBounds(80, 30, 480, 330);
  }
  //dimple allows use of custom CSS with noFormats
  if(opts.noFormats) { myChart.noFormats = opts.noFormats; };
  //for markimekko and addAxis also have third parameter measure
  //so need to evaluate if measure provided
  //x axis
  var x;
  if(xAxis.measure) {
    x = myChart[xAxis.type]("x",opts.x,xAxis.measure);
  } else {
    x = myChart[xAxis.type]("x", opts.x);
  };
  if(!(xAxis.type === "addPctAxis")) x.showPercent = xAxis.showPercent;
  if (xAxis.orderRule) x.addOrderRule(xAxis.orderRule);
  if (xAxis.grouporderRule) x.addGroupOrderRule(xAxis.grouporderRule);  
  if (xAxis.overrideMin) x.overrideMin = xAxis.overrideMin;
  if (xAxis.overrideMax) x.overrideMax = xAxis.overrideMax;
  if (xAxis.overrideMax) x.overrideMax = xAxis.overrideMax;
  if (xAxis.inputFormat) x.dateParseFormat = xAxis.inputFormat;
  if (xAxis.outputFormat) x.tickFormat = xAxis.outputFormat;
  //y axis
  var y;
  if(yAxis.measure) {
    y = myChart[yAxis.type]("y",opts.y,yAxis.measure);
  } else {
    y = myChart[yAxis.type]("y", opts.y);
  };
  if(!(yAxis.type === "addPctAxis")) y.showPercent = yAxis.showPercent;
  if (yAxis.orderRule) y.addOrderRule(yAxis.orderRule);
  if (yAxis.grouporderRule) y.addGroupOrderRule(yAxis.grouporderRule);
  if (yAxis.overrideMin) y.overrideMin = yAxis.overrideMin;
  if (yAxis.overrideMax) y.overrideMax = yAxis.overrideMax;
  if (yAxis.inputFormat) y.dateParseFormat = yAxis.inputFormat;
  if (yAxis.outputFormat) y.tickFormat = yAxis.outputFormat;
//z for bubbles
    var z;
  if (!(typeof(zAxis) === 'undefined') && zAxis.type){
    if(zAxis.measure) {
      z = myChart[zAxis.type]("z",opts.z,zAxis.measure);
    } else {
      z = myChart[zAxis.type]("z", opts.z);
    };
    if(!(zAxis.type === "addPctAxis")) z.showPercent = zAxis.showPercent;
    if (zAxis.orderRule) z.addOrderRule(zAxis.orderRule);
    if (zAxis.overrideMin) z.overrideMin = zAxis.overrideMin;
    if (zAxis.overrideMax) z.overrideMax = zAxis.overrideMax;
  }
  if(d3.keys(colorAxis).length > 0) {
    myChart[colorAxis.type](colorAxis.colorSeries,colorAxis.palette) ;
  }
  
  //here need think I need to evaluate group and if missing do null
  //as the first argument
  //if provided need to use groups from opts
  if(opts.hasOwnProperty("groups")) {
    var s = myChart.addSeries( opts.groups, dimple.plot[opts.type] );
    //series offers an aggregate method that we will also need to check if available
    //options available are avg, count, max, min, sum
    if (!(typeof(opts.aggregate) === 'undefined')) {
      s.aggregate = eval(opts.aggregate);
    }
    if (!(typeof(opts.lineWeight) === 'undefined')) {
      s.lineWeight = eval(opts.lineWeight);
    }
    if (!(typeof(opts.barGap) === 'undefined')) {
      s.barGap = eval(opts.barGap);
    }    
  } else var s = myChart.addSeries( null, dimple.plot[opts.type] );
  //unsure if this is best but if legend is provided (not empty) then evaluate
  if(d3.keys(legend).length > 0) {
    var l =myChart.addLegend();
    d3.keys(legend).forEach(function(d){
      l[d] = legend[d];
    });
  }
  //quick way to get this going but need to make this cleaner
  if(opts.storyboard) {
    myChart.setStoryboard(opts.storyboard);
  };
  myChart.draw();

</script>

<script>
d3.selectAll('text').style("font-size","10")
</script>
