# UBCF vs IBCF Collaborative Filtering in R
# Author: Joe Domaleski
# Agency: Country Fried Creative / Country Fried Labs
# Date: 2025-04-04

# === Step 0: Load Libraries ===
library(recommenderlab)  # Recommendation algorithms
library(ggplot2)         # Data visualization
library(reshape2)        # Reshaping data
library(ggrepel)         # Labeling scatterplots
library(proxy)           # Similarity calculations

# === Step 1: Set Parameters ===
n_recs <- 2  # Number of recommendations per client

# === Step 2: Load and Prepare Data ===
cust_pref <- read.csv("customer_marketing_preferences.csv", stringsAsFactors = FALSE)
clients <- cust_pref$Client
pref_matrix <- as.matrix(cust_pref[, -1])
pref_matrix <- apply(pref_matrix, 2, as.numeric)
rownames(pref_matrix) <- clients
services <- colnames(pref_matrix)
binary_data <- as(pref_matrix, "binaryRatingMatrix")
service_usage_totals <- colSums(pref_matrix)

# === Step 3: Train and Display UBCF and IBCF Recommendations ===

# Train UBCF
ubcf_model <- Recommender(binary_data, method = "UBCF")
ubcf_recs <- predict(ubcf_model, binary_data, n = n_recs)
ubcf_list <- as(ubcf_recs, "list")
names(ubcf_list) <- rownames(pref_matrix)

# Train IBCF
ibcf_model <- Recommender(binary_data, method = "IBCF")
ibcf_recs <- predict(ibcf_model, binary_data, n = n_recs)
ibcf_list <- as(ibcf_recs, "list")
names(ibcf_list) <- rownames(pref_matrix)

cat("\n--- UBCF Recommendations ---\n\n")
for (user in names(ubcf_list)) {
  recs <- ubcf_list[[user]]
  cat(paste0(user, ": ", ifelse(length(recs) == 0, "No recommendations\n", paste(recs, collapse = ", ")), "\n"))
}

cat("\n--- IBCF Recommendations ---\n\n")
for (user in names(ibcf_list)) {
  recs <- ibcf_list[[user]]
  cat(paste0(user, ": ", ifelse(length(recs) == 0, "No recommendations\n", paste(recs, collapse = ", ")), "\n"))
}

# === Step 4: Bar Charts – UBCF and IBCF ===

flat_ubcf <- unlist(ubcf_list)
flat_ibcf <- unlist(ibcf_list)

ubcf_counts <- table(factor(flat_ubcf, levels = services))
ibcf_counts <- table(factor(flat_ibcf, levels = services))

# UBCF Bar Chart
ubcf_bar_df <- data.frame(Service = names(ubcf_counts), Count = as.integer(ubcf_counts))
ubcf_bar_plot <- ggplot(ubcf_bar_df, aes(x = reorder(Service, Count), y = Count, fill = Service)) +
  geom_col(show.legend = FALSE) +
  geom_text(aes(label = Count), hjust = -0.2, size = 4) +
  coord_flip() +
  labs(title = "Most Recommended Services by UBCF", x = "Service", y = "Number of Recommendations") +
  theme_minimal(base_size = 12)
ggsave("ubcf_recommendation_counts_bar_chart.png", ubcf_bar_plot, width = 8, height = 6)
print(ubcf_bar_plot)

# IBCF Bar Chart
ibcf_bar_df <- data.frame(Service = names(ibcf_counts), Count = as.integer(ibcf_counts))
ibcf_bar_plot <- ggplot(ibcf_bar_df, aes(x = reorder(Service, Count), y = Count, fill = Service)) +
  geom_col(show.legend = FALSE) +
  geom_text(aes(label = Count), hjust = -0.2, size = 4) +
  coord_flip() +
  labs(title = "Most Recommended Services by IBCF", x = "Service", y = "Number of Recommendations") +
  theme_minimal(base_size = 12)
ggsave("ibcf_recommendation_counts_bar_chart.png", ibcf_bar_plot, width = 8, height = 6)
print(ibcf_bar_plot)

# === Step 5: Heatmaps – UBCF and IBCF ===

# UBCF Heatmap
ubcf_df <- data.frame(Client = rep(names(ubcf_list), each = n_recs), Service = unlist(ubcf_list))
ubcf_df$Used <- 1
ubcf_heat_matrix <- dcast(ubcf_df, Client ~ Service, value.var = "Used", fill = 0)
rownames(ubcf_heat_matrix) <- ubcf_heat_matrix$Client
ubcf_heatmap_long <- melt(as.matrix(ubcf_heat_matrix[, -1]))
colnames(ubcf_heatmap_long) <- c("Client", "Service", "Used")

ubcf_heatmap <- ggplot(ubcf_heatmap_long, aes(x = Service, y = Client, fill = factor(Used))) +
  geom_tile(color = "white") +
  scale_fill_manual(values = c("0" = "#f7f7f7", "1" = "#3182bd")) +
  labs(title = "UBCF Recommendations Heatmap", fill = "Recommended") +
  theme_minimal(base_size = 11) +
  theme(axis.text.x = element_text(angle = 30, hjust = 1),
        axis.text.y = element_text(size = 7))
ggsave("ubcf_recommendation_heatmap.png", ubcf_heatmap, width = 10, height = 10)
print(ubcf_heatmap)

# IBCF Heatmap
ibcf_df <- data.frame(Client = rep(names(ibcf_list), each = n_recs), Service = unlist(ibcf_list))
ibcf_df$Used <- 1
ibcf_heat_matrix <- dcast(ibcf_df, Client ~ Service, value.var = "Used", fill = 0)
rownames(ibcf_heat_matrix) <- ibcf_heat_matrix$Client
ibcf_heatmap_long <- melt(as.matrix(ibcf_heat_matrix[, -1]))
colnames(ibcf_heatmap_long) <- c("Client", "Service", "Used")

ibcf_heatmap <- ggplot(ibcf_heatmap_long, aes(x = Service, y = Client, fill = factor(Used))) +
  geom_tile(color = "white") +
  scale_fill_manual(values = c("0" = "#f7f7f7", "1" = "#e6550d")) +
  labs(title = "IBCF Recommendations Heatmap", fill = "Recommended") +
  theme_minimal(base_size = 11) +
  theme(axis.text.x = element_text(angle = 30, hjust = 1),
        axis.text.y = element_text(size = 7))
ggsave("ibcf_recommendation_heatmap.png", ibcf_heatmap, width = 10, height = 10)
print(ibcf_heatmap)

# === Step 6: Scatterplots – UBCF and IBCF ===

# UBCF Scatter
ubcf_bar_df$UsedCount <- service_usage_totals[ubcf_bar_df$Service]
ubcf_scatter <- ggplot(ubcf_bar_df, aes(x = UsedCount, y = Count, label = Service)) +
  geom_point(color = "#3182bd", size = 4) +
  geom_text_repel(size = 3.5) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "gray50") +
  labs(title = "UBCF: Do We Recommend What’s Already Popular?",
       x = "Times Used", y = "Times Recommended") +
  theme_minimal(base_size = 12)
ggsave("ubcf_usage_vs_recommendation_scatter.png", ubcf_scatter, width = 8, height = 6)
print(ubcf_scatter)

# IBCF Scatter
ibcf_bar_df$UsedCount <- service_usage_totals[ibcf_bar_df$Service]
ibcf_scatter <- ggplot(ibcf_bar_df, aes(x = UsedCount, y = Count, label = Service)) +
  geom_point(color = "#e6550d", size = 4) +
  geom_text_repel(size = 3.5) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "gray50") +
  labs(title = "IBCF: Do We Recommend What’s Already Popular?",
       x = "Times Used", y = "Times Recommended") +
  theme_minimal(base_size = 12)
ggsave("ibcf_usage_vs_recommendation_scatter.png", ibcf_scatter, width = 8, height = 6)
print(ibcf_scatter)

# === Step 7: Comparison Bar Chart (UBCF vs IBCF) ===

comparison_df <- data.frame(Service = services,
                            UBCF = as.integer(ubcf_counts),
                            IBCF = as.integer(ibcf_counts))

comp_melt <- melt(comparison_df, id.vars = "Service", variable.name = "Method", value.name = "Count")

comparison_plot <- ggplot(comp_melt, aes(x = Service, y = Count, fill = Method)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "UBCF vs. IBCF: Number of Recommendations per Service",
       x = "Service", y = "Number of Recommendations") +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_text(angle = 30, hjust = 1))
ggsave("ubcf_vs_ibcf_recommendations.png", comparison_plot, width = 10, height = 6)
print(comparison_plot)