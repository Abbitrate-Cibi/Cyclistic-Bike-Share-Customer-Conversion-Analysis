# Cyclistic-Bike-Share-Customer-Conversion-Analysis

## Introduction to Business Task 

- **Company Background and Scenario:** Cyclistic is a Chicago based bike-share service company which offers the following bike pricing plans: single-ride passes, full-day passes and annual memberships. The service features over 5800 bicycles and 600 docking stations, all bike users are required to return bikes to any docking station within 24 hours regardless of the pricing plan selected by a user.

- **Core Objective:** The Director of Marketing, Lily Moreno aims to maximize annual memberships by converting existing casual riders(Users that do not have annual memberships) into annual members. This is because finance analysts concluded that annual members are more profitable than casual riders. The main goal is to analyze how casual riders and annual members use bikes differently, the insights are then used to design marketing strategies that convert casual riders to annual members.

- **A sample of the Historical Bike Trips Data**

This table shows a sample of the raw Chicago Bike Trips data in the first quarter(January, February and March) of 2019. Data Source : The raw data is from Motivate International Inc.

![Uncleaned Bike Trips Data Preview](./images/raw_bike_trips_data_preview.png)
- For additional information about the business scenario read [Cyclistic Case Study ](./documents/Case_Study.pdf)
- The raw data set can be accessed here : [Raw Bike trips Data 2019 Q1 ](https://docs.google.com/spreadsheets/d/1AYa1EMxdi2xoXapZ2dC8yKQ2-lzfg43HKzLI5_iwypE/edit?usp=sharing)

## Data Cleaning and Preparation
- A preview of the data set cleaned using **Google Sheets:**

![Cleaned Bike Trips Data Preview](./images/cleaned_bike_trips_data_preview.png)

- **Data Cleaning Steps:**
  
    - Dropped `tripduration` column due to unclear time units , it is replaced by a new `ride_length_in_minutes` column which is calculated using        the difference between the `start_time` and `end_time` columns.
    - Standardized station column names by renaming `from_station_id`, `to_station_id`, `from_station_name`, and `to_station_name` to                    `start_station_id`, `end_station_id`, `start_station_name`, and `end_station_name` respectively.
    - **Handled Missing Values:** Retained rows with missing `gender` and `birthyear` entries, this is because demographic analysis is outside the       primary project scope, and  dropping these rows would unnecessarily reduce sample size and compromise overall data integrity.
    - Removed the special trailing characters (*) that appear at the end of the `start_station_name` and `end_station_name` column entries , this        will make the searching of station names accurate.
    - **Excluded Outliers:** Filtered out 192 trips exceeding the 24-hour maximum usage policy (1,440 minutes), this is because Cyclistic requires       bikes to be returned within 24 hours, these extreme outliers represent stolen or unreturned bikes and fall outside standard bike trip  patterns.


