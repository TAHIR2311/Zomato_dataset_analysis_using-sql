# 🍽️ Zomato Data Exploration and Analysis Using SQL Server

## 📌 Project Overview

This project involves exploratory data analysis (EDA) and insights generation using the **Zomato dataset** in **SQL Server**. Zomato is a global restaurant aggregator and food delivery service. The dataset contains over **9,000 records** with attributes such as restaurant ID, name, location, cuisines, ratings, delivery options, and more.

The primary goal is to understand business patterns, identify user preferences, and uncover regional and service-based insights through structured SQL queries.

---

## 🔍 Data Exploration

The following data exploration tasks were performed:

- Reviewed the table schema (column names, data types, constraints).
- Identified and removed duplicate entries using `[RestaurantId]`.
- Dropped irrelevant columns to streamline analysis.
- Merged datasets using `[CountryCode]` as a foreign key to add `Country_Name`.
- Corrected inconsistent/misspelled city names.
- Applied **window functions** for rolling counts of restaurants by location.
- Evaluated min, max, and average values for `Votes`, `AggregateRating`, and `AverageCostForTwo`.
- Created a derived `RatingCategory` column based on rating values.

---

## 📊 Key Insights

- **Geographic Distribution**:
  - **90.67%** of the restaurants are located in **India**, followed by the **USA (4.45%)**.
  - Out of 15 countries, only **India (28.01%)** and **UAE (46.67%)** offer **online delivery** options.

- **Focus on Indian Restaurants**:
  - **Connaught Place (New Delhi)** has the highest number of listed restaurants (**122**), followed by:
    - Rajouri Garden (99)
    - Shahdara (87)
  - The most popular cuisine in Connaught Place is **North Indian**.
  - Among the 122 restaurants in Connaught Place:
    - **54** offer **table booking**.
    - Average rating for:
      - Restaurants **with** table booking: **3.9/5**
      - Restaurants **without** table booking: **3.7/5**

- **Top Restaurant Based on Filters**:
  - **Location**: Kolkata, India  
  - **Name**: *India Restaurant*  
  - **Restaurant ID**: `20747`  
  - **Criteria**:
    - Average cost for two < ₹1000
    - Rating > 4
    - Votes > 4
    - Offers both **table booking** and **online delivery**
    - Serves **Indian cuisine**

---

## 🛠️ Tools & Technologies

- **SQL Server**  
- **SQL Window Functions**  
- **Data Cleaning & Transformation**  
- **Exploratory Data Analysis (EDA)**

---

## 📁 Dataset Summary

- **Total Records**: ~9,000  
- **Key Columns**:
  - `RestaurantId`
  - `RestaurantName`
  - `City`
  - `Location`
  - `Cuisines`
  - `AverageCostForTwo`
  - `HasTableBooking`
  - `HasOnlineDelivery`
  - `AggregateRating`
  - `Votes`
  - `Currency`
  - `CountryCode`

---

## 💡 Conclusion

This analysis provides a comprehensive overview of Zomato's data with a strong focus on Indian restaurants. It highlights patterns in customer preferences, service offerings, and location-based trends. These insights can support strategic business decisions related to market targeting, service optimization, and customer experience.

---
