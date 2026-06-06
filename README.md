# Netflix Movies and TV Shows Data Analysis using SQL

📊 **Project Type:** Exploratory Data Analysis  
🛠️ **Database Engine:** PostgreSQL (pgAdmin 4)  
💾 **Dataset:** Netflix Catalog (Movies & TV Shows)

---

## Project Overview
This project delivers a complete data analysis solution using a raw dataset of Netflix titles. The primary focus is to ingest the data into a structured PostgreSQL database, resolve real-world data format quirks, and extract strategic business insights by solving 15 distinct analytical problems.

This repository serves as a practical portfolio demonstrating string manipulation, data type casting (`::INT` and `::NUMERIC`), data cleaning with wildcards, and advanced analytical grouping.

---

## Core Objectives
1. **Database Schema Design:** Build a structured table layout utilizing optimized `VARCHAR` and `INT` data types to match the raw catalog structure.
2. **Data Cleaning & Resilience:** Address data parsing challenges during runtime, including missing metadata fields, column formatting variations, and string extraction boundaries.
3. **Exploratory Data Analysis (EDA):** Answer 15 specific business queries to evaluate content distribution, regional production metrics (focusing on India), and content categorization patterns.

---

## Practical Data Challenges Solved

During the implementation phase, the alphanumeric structure of the raw data required careful querying to prevent syntax and type errors:

### 1. Handling Alphanumeric Values in Numeric Fields
* **The Problem:** The `duration` column stores values as text strings (e.g., `'5 Seasons'`, `'2 Seasons'`). Attempting to filter these directly using numerical math (like `> 5`) throws severe syntax crashes because the database engine cannot compare text strings to numbers.
* **The Solution:** Used the `SPLIT_PART()` function to strip away the trailing text characters, isolated the raw digit, and cast the resulting value into a functional database number (`::INT` or `::NUMERIC`).

### 2. Safeguarding Against Broken Records
* **The Problem:** Web-scraped datasets often contain formatting drift or missing entries. If a row lacks a clean space separation, executing a string split directly can return text instead of a digit, breaking the calculation layer.
* **The Solution:** Embedded a pre-filtering validation layer using `LIKE '% %'` and `IS NOT NULL`. This acts as a logical shield, ensuring the database only attempts text splitting on rows that contain valid structural spacing.

---

## Database Architecture (SQL Schema)

```sql
DROP TABLE IF EXISTS netflix;

CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
