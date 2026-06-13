# Ecommerce-Funnel-Analysis
# 🛒 E-commerce Website Funnel Analysis

## 📌 Project Overview
This project analyzes the conversion funnel of an e-commerce website to understand how users move through different stages — from visiting the home page to completing a purchase. The goal is to identify drop-off points and deliver actionable business recommendations.

---

## 🗂️ Dataset
- **Source:** [Kaggle — E-commerce Website Funnel Analysis](https://www.kaggle.com/datasets/aerodinamicc/ecommerce-website-funnel-analysis)
- **Total Users:** 90,400
- **Date Range:** January 2015 — April 2015
- **Files Used:**
  - `home_page_table.csv`
  - `search_page_table.csv`
  - `payment_page_table.csv`
  - `payment_confirmation_table.csv`
  - `user_table.csv`

---

## 🛠️ Tools & Technologies
| Tool | Purpose |
|---|---|
| Python (Pandas) | Data loading, merging, EDA |
| Plotly | Interactive visualizations |
| PostgreSQL | Business queries and analysis |
| Jupyter Notebook | Development environment |

---

## 🔄 Project Workflow

```
Load 5 CSV Files → Merge into One DataFrame → Data Validation
→ Exploratory Data Analysis → Visualizations → SQL Business Queries
```

---

## 🧹 Data Preparation (Python)

- Loaded all 5 CSV files using Pandas
- Merged into a single DataFrame using `user_id` as the key
- Added binary columns (1/0) for each funnel stage per user
- Converted `date` column to datetime format
- Validated across all tables: **zero null values, zero duplicates**

---

## 📊 Funnel Analysis Results

| Stage | Users | Conversion Rate | Drop-off Rate |
|---|---|---|---|
| 🏠 Home Page | 90,400 | 100% | — |
| 🔍 Search Page | 45,200 | 50.00% | 50.00% |
| 💳 Payment Page | 6,030 | 6.67% | 86.66% |
| ✅ Confirmation | 452 | 0.50% | 92.50% |

**Overall Conversion Rate: 0.50%** — only 1 in 200 visitors completes a purchase.

---

## 📈 Key Insights

### 1. 🔴 Biggest Drop-off: Search → Payment (86.66%)
The most critical problem in the funnel. Users are browsing but not proceeding to payment. This suggests issues with pricing, trust, or product relevance.

### 2. 📱 Mobile Converts 4x Better Than Desktop
- Mobile conversion rate: **1.00%**
- Desktop conversion rate: **0.25%**
- The business should prioritize mobile experience and mobile-first marketing.

### 3. 👩 Females Convert Slightly Better
- Female conversion rate: **0.53%**
- Male conversion rate: **0.47%**
- Targeted campaigns for female users could further improve conversions.

### 4. 📅 January Had the Highest Conversions (189)
- January: 189 confirmations
- February: 173 confirmations
- March: 44 confirmations (lowest)
- April: 46 confirmations
- Seasonal promotions in Q1 appear to drive the most conversions.

### 5. 👩 Females Are More Engaged at Search Stage
- Female search users: 22,676
- Male search users: 22,524
- Females explore products more actively.

---

## 💡 Business Recommendations

1. **Improve the Search → Payment experience** — simplify the checkout process, add trust badges, and show clear pricing to reduce the 86.66% drop-off
2. **Invest in mobile optimization** — mobile users convert 4x better; prioritize mobile UI/UX and mobile ads
3. **Run Q1 seasonal campaigns** — January performs best; plan major promotions around this period
4. **Target female users** — they convert better and are more engaged; personalized campaigns could boost revenue
5. **A/B test the payment page** — the 92.50% drop-off at payment suggests friction; test simpler checkout flows

---

## 📁 Repository Structure

```
📦 E-commerce-Funnel-Analysis
 ┣ 📂 data
 ┃ ┣ 📄 home_page_table.csv
 ┃ ┣ 📄 search_page_table.csv
 ┃ ┣ 📄 payment_page_table.csv
 ┃ ┣ 📄 payment_confirmation_table.csv
 ┃ ┣ 📄 user_table.csv
 ┃ ┗ 📄 funnel_merged.csv
 ┣ 📂 charts
 ┃ ┣ 📄 funnel_chart.html
 ┃ ┣ 📄 dropoff_chart.html
 ┃ ┣ 📄 gender_chart.html
 ┃ ┗ 📄 device_chart.html
 ┣ 📄 funnel_analysis.ipynb
 ┣ 📄 queries.sql
 ┗ 📄 README.md
```

---

## 🗄️ SQL Queries

### Q1. Total Users at Each Funnel Stage
```sql
SELECT
    SUM(home)         AS home_users,
    SUM(search)       AS search_users,
    SUM(payment)      AS payment_users,
    SUM(confirmation) AS confirmation_users
FROM ecommerce_funnel;
```

### Q2. Overall Conversion Rate
```sql
SELECT
    ROUND(SUM(confirmation) * 100.0 / SUM(home), 2) AS overall_conversion_rate
FROM ecommerce_funnel;
```

### Q3. Conversion Rate by Gender
```sql
SELECT
    sex,
    SUM(home)         AS total_users,
    SUM(confirmation) AS total_conversions,
    ROUND(SUM(confirmation) * 100.0 / SUM(home), 2) AS conversion_rate
FROM ecommerce_funnel
GROUP BY sex;
```

### Q4. Conversion Rate by Device
```sql
SELECT
    device,
    SUM(home)         AS total_users,
    SUM(confirmation) AS total_conversions,
    ROUND(SUM(confirmation) * 100.0 / SUM(home), 2) AS conversion_rate
FROM ecommerce_funnel
GROUP BY device
ORDER BY conversion_rate DESC;
```

### Q5. Conversions by Month
```sql
SELECT
    EXTRACT(MONTH FROM date)  AS month,
    SUM(confirmation)         AS number_of_confirmations,
    ROUND(SUM(confirmation) * 100.0 / SUM(home), 2) AS conversion_rate
FROM ecommerce_funnel
GROUP BY month
ORDER BY number_of_confirmations DESC;
```

### Q6. Drop-off Rate Between Each Stage
```sql
SELECT
    ROUND((1 - SUM(search)::NUMERIC       / SUM(home))    * 100, 2) AS home_to_search_dropoff,
    ROUND((1 - SUM(payment)::NUMERIC      / SUM(search))  * 100, 2) AS search_to_payment_dropoff,
    ROUND((1 - SUM(confirmation)::NUMERIC / SUM(payment)) * 100, 2) AS payment_to_confirmation_dropoff
FROM ecommerce_funnel;
```

### Q7. Female Mobile Users Who Completed a Purchase
```sql
SELECT
    COUNT(*) AS female_mobile_conversions
FROM ecommerce_funnel
WHERE sex    = 'Female'
  AND device = 'Mobile'
  AND confirmation = 1;
```

### Q8. Which Gender Reached the Search Page More
```sql
SELECT
    sex,
    SUM(search) AS search_users
FROM ecommerce_funnel
GROUP BY sex
ORDER BY search_users DESC;
```
