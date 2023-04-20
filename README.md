# Altmetric Attention Score Extractor (R)

This code use the package rAltmetric from ropensci: https://github.com/ropensci/rAltmetric
Reference: Karthik Ram (2017). rAltmetric: Retrieves altmerics data for any published paper from altmetrics.com. R package version 0.7. http://CRAN.R-project.org/package=rAltmetric

The new part of the code extract the score total of the Altmetric Attention Score (altmetric.com)

You need a API key to run the code.

The code requests a list in .txt format containing the DOI to be processed organized in a single column without a header (you can use the test file)

The code saves the "Score List.txt" in your dir containing the DOI and the respective Altmetric Attention Score values

The command "aas" shows the Altmetric Attention Scores' values from each DOI

contact: rafael.castanha@unesp.br // r.castanha@gmail.com
