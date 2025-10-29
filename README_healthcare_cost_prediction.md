# 🏥 Healthcare Cost Prediction

This repository contains a complete end‑to‑end machine learning pipeline for predicting **high‑cost healthcare patients** using de‑identified claims and encounters data (e.g., Synthea). The workflow includes data ingestion, feature/label engineering with PySpark, model training with XGBoost, LightGBM and Logestic Regression and experiment tracking with MLflow.


---

## 🚀 Workflow Overview

### **1️⃣ Ingestion & EDA (01_ingest_eda.ipynb)**
- Loads Synthea‑style patient and encounter tables.  
- Inspects schema consistency and missing values.  
- Creates `patient_summary` parquet with demographics and basic statistics.  

### **2️⃣ Label & Feature Engineering (02_label_features.ipynb)**
- Uses PySpark to compute **historical (past)** and **future (lookahead)** cost windows per patient.  
- Generates the `label` column based on cost threshold (top‑30% or a custom percentile).  
- Supports configurable `LOOKAHEAD_DAYS` and dynamic cutoff date for flexible windowing.  
- Saves clean feature parquet (`processed/features_parquet/`).  

### **3️⃣ Model Training (03_train_xgb.ipynb)**
- Loads feature parquet into Pandas.  
- Performs categorical encoding and splits by index date (time‑based).  
- Computes `scale_pos_weight` for class imbalance.  
- Trains and evaluates **XGBoost** with MLflow experiment tracking.  
- Logs metrics: precision, recall, F1, accuracy, ROC‑AUC, PR‑AUC.  

### **4️⃣ Additional Models**
- **04_train_logreg.ipynb**: Logistic Regression baseline.  
- **05_train_lightgbm.ipynb**: LightGBM gradient boosting comparison.  

### **5️⃣ Evaluation (04_eval_visualize.ipynb)**  
- Visualizes performance: confusion matrix, feature importances, and calibration plots.  
- Aggregates results into `/reports/summary_metrics.csv`.  

---

## 🧠 Key Features

- **Dynamic Label Window:** Customize lookahead period (e.g., 90, 180, 365 days).  
- **Time‑based Split:** Ensures future data isn't used to predict the past.  
- **MLflow Tracking:** All experiments stored under `/mlruns_clean`.  
- **Feature Engineering:** Adds ratios, densities, and log transforms for skewed variables.  
- **Model Calibration:** Option to apply sigmoid calibration and threshold tuning for precision/recall balance.  

---

## ⚙️ Setup

### 1. Clone the repository
```bash
git clone https://github.com/MoMalmir/Healthcare_Cost_Prediction.git
cd Healthcare_Cost_Prediction
```

### 2. Create environment
```bash
conda env create -f environment.yml
conda activate healthcare-cost-prediction
```

### 3. Configure environment variables
Create a `.env` file (based on `.env.example`):
```bash
DATA_DIR=/path/to/data/raw
```

### 4. Run notebooks sequentially
```bash
jupyter lab
```
Execute notebooks `01_ingest_eda` → `02_label_features` → `03_train_xgb`.

---

## 🧩 Example MLflow Metrics

| Model | Test F1 | ROC‑AUC | PR‑AUC | Precision | Recall | Accuracy |
|--------|----------|----------|----------|------------|---------|-----------|
| XGBoost (calibrated) | **0.69** | 0.77 | 0.61 | 0.57 | 0.86 | 0.70 |
| Logistic Regression | 0.63 | 0.72 | 0.56 | 0.54 | 0.80 | 0.66 |
| LightGBM | 0.68 | 0.76 | 0.60 | 0.56 | 0.84 | 0.69 |

---

## 📊 Example Visualization
```python
from sklearn.metrics import ConfusionMatrixDisplay
ConfusionMatrixDisplay.from_estimator(model, X_test, y_test)
```

---

## 📄 License
This project is released under the [MIT License](LICENSE).

---

## 👤 Author
**Mostafa Malmir**  
[GitHub](https://github.com/MoMalmir) 
