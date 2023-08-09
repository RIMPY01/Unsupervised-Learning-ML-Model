# Projects
Projects on Real-Datasets
The project aimed to develop an Unsupervised ML model for categorizing university applicants into clusters based on their demographic and behavioral traits. This optimization aimed to bolster the efficiency of the application process and empower UB's Strategic Marketing Department to better engage potential Management Program candidates.

To achieve this, I initially collected relevant data from different University at Buffalo databases and store it into an **SQLite** database. This streamlined data processing and storage. SQL views were then employed to aggregate data, create new columns, and select pertinent features. Multiple datasets were merged to form an optimized dataset for model training.

Managing missing data was a challenge that we addressed by removal or imputation. Numerical fields were normalized for consistency across features. Correlation analysis unveiled interdependencies, aiding in the identification of redundant features.

The data underwent classification into four distinct clusters through Unsupervised Learning, specifically employing the K-means clustering algorithm. This technique effectively grouped similar data points, revealing inherent dataset patterns.

To determine the optimal cluster count, two methods were applied: the elbow method and the silhouette visualizer. The elbow method plots cluster variance explained against cluster count, identifying the "elbow" point where variance change stabilizes. The silhouette visualizer utilizes silhouette coefficients to assess data point fit within their clusters.

Cluster quality was assessed with the Calinski-Harabasz score, gauging inter-cluster separation. This metric confirmed the meaningful distinctiveness of the clusters.

In tandem with clustering, the dataset's feature importance was analyzed via the Random Forest classifier. This facilitated the identification of key features for predicting different clusters' important characteristics.
