# Altmetric Attention Score Extractor (R)

This code use the package rAltmetric from ropensci: https://github.com/ropensci/rAltmetric
Reference: Karthik Ram (2017). rAltmetric: Retrieves altmerics data for any published paper from altmetrics.com. R package version 0.7. http://CRAN.R-project.org/package=rAltmetric

The new part of the code extract the score total of the Altmetric Attention Score (altmetric.com)

You need a API key to run the code.

The code requests a list in .txt format containing the DOI to be processed organized in a single column without a header (you can use the test file)

The code saves the "Score List.txt" in your dir containing the DOI and the respective Altmetric Attention Score values

The command "aas" shows the Altmetric Attention Scores' values from each DOI

contact: rafael.castanha@unesp.br // r.castanha@gmail.com

This code was used in the article: Gutierres Castanha, R. ., Savegnago de Mira, B., & Rodrigues Delbianco, N. (2024). Atención en línea de artículos no citados en Ciencia de la Información. Investigación Bibliotecológica: Archivonomía, bibliotecología E información, 38(98), 145–163. https://doi.org/10.22201/iibi.24488321xe.2024.98.58854
