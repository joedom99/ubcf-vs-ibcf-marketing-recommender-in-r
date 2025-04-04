# UBCF vs IBCF Recommender System in R

A practical, side-by-side implementation of **User-Based Collaborative Filtering (UBCF)** and **Item-Based Collaborative Filtering (IBCF)** using R and `recommenderlab`. This project demonstrates how each algorithm generates service recommendations from binary usage data—perfect for marketers, educators, and data science learners.

🔍 Built as a companion to our blog article:  
👉 [Understanding UBCF: A Practical Guide to User-Based Collaborative Filtering in R](https://blog.marketingdatascience.ai/) *(Link to come)*

---

## 💡 What It Does

This R script:
- Loads sample marketing service usage data
- Trains both UBCF and IBCF models using `recommenderlab`
- Generates two recommendations per client
- Visualizes the results:
  - Bar charts of most recommended services
  - Client-service recommendation heatmaps
  - Scatterplots showing usage vs. recommendation
  - A final comparison chart of UBCF vs. IBCF performance

---

## 📁 File Structure
- customer_marketing_preferences.csv   # Input dataset
- ubcf-vs-ibcf-recommender-system.R    # Main R script

## 🧪 How to Use

1. Clone the repo or download the script.
2. Make sure your working directory contains `customer_marketing_preferences.csv`.
3. Run the script in RStudio or your preferred R environment.
4. The script will print recommendations and save 7 visualizations.

**Requirements:**
- R ≥ 4.1
- Packages: `recommenderlab`, `ggplot2`, `reshape2`, `ggrepel`, `proxy`

To install any missing packages:
```r
install.packages(c("recommenderlab", "ggplot2", "reshape2", "ggrepel", "proxy"))
```
## 📚 Learning Goals
	•	Understand how collaborative filtering works in practice
	•	Compare UBCF (based on user similarity) vs IBCF (based on item similarity)
	•	Visualize recommender output using tidy tools in R
	•	Adapt the script for your own data and use cases
 
## 📄 License

MIT License. See LICENSE file for details.

## ✍️ Author

Joe Domaleski
Country Fried Creative / Country Fried Labs
https://blog.marketingdatascience.ai
https://countryfriedcreative.com
https://countryfriedlabs.com

## 🙌 Acknowledgments

This project follows up on our HOLLIE Bot April Fool’s article (https://blog.marketingdatascience.ai/we-replaced-our-marketing-team-with-ai-heres-what-happened-bf86f114a90b) and expands the serious technical foundation behind it.

