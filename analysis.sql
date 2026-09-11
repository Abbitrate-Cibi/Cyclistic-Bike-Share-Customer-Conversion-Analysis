/*
In the following query query we calculate the average ride length,longest bike trip and we display the name of the day of the week that has the most bike trips for all users.
NB: We only consider bike users who have returned bikes within 24 hours(1440 minutes) in all the analysis from queries done below

In the query results we see that on average a normal bike trip lasts 12.83 minutes and all users use bikes the most number of times on Thursdays, and the longest bike trip to return a bike is 1433.07 minutes which is still within 24 hours(1440 minutes).
*/

SELECT 
       ROUND(AVG(ride_length_in_minutes),2) AS average_ride_length,
       MAX(ride_length_in_minutes) AS longest_bike_trip,
       (
          SELECT 
                 start_ride_day_of_week
          FROM
             (SELECT 
                     COUNT(*) AS number_of_trips_per_day_of_week,
                     start_ride_day_of_week
              FROM `cyclistic-project-507412.cyclistic_info.bike_trips` 
              WHERE ride_length_in_minutes < 1440
              GROUP BY start_ride_day_of_week
              ORDER BY number_of_trips_per_day_of_week DESC
              LIMIT 1) AS day_with_most_bike_trips 
              
         ) AS start_ride_day_of_week,
         'Thursday' AS name_of_day_with_most_bike_trips
FROM `cyclistic-project-507412.cyclistic_info.bike_trips` 
WHERE ride_length_in_minutes < 1440;

/* We then compare the average ride length between Subscribers and Customers.
We also display the number of users that make up each average.

From the query result we see that on average a normal bike trip for Subscribers(11.31 minutes) is closer to the normal bike trip duration for every bike user(12.83 minutes from the previous query), however Customers on average spend 35.29 minutes per bike trip.

The first two values are closer to each other since there are more subscribers (341782 users) than there are customers(23095 users).Customers usually spend more time per bike trip on average than subscribers , this suggests that the company can generate extra revenue from Customers if they become annual members because  they may likely use the bikes even more if they become annual members.

NB: The more time spent per trip the higher the revenue since it is assumed that extra charges are applied when the trip is longer.

Check and Verify the numbers results from the following query.  */

SELECT 
      usertype,
      ROUND(AVG(ride_length_in_minutes),2) AS average_ride_length,
      COUNT(*) AS Number_of_users
FROM `cyclistic-project-507412.cyclistic_info.bike_trips`
WHERE ride_length_in_minutes <1440
GROUP BY usertype;

/* Next we consider the the average ride length for both groups by each day of the week.
We also display the number of bike rides for each day of the week per user group.

Note that: Sunday is represented by the value 1 and we continue until the final day Sartuday which will be represented by the last value 7.

In the query results we have discovered that for both groups, Sartuday(day 7) is the day of the week where on average a user will spend the most time for each bike trip.Customers usually spend around 37.57 minutes and subscribers spend 12.74 minutes for that day.

Once again the data shows that on average a customer will likely spend more time on each bike trip than subscribers even when we look at bike usage on Sartudays.
The difference is that Subscribers and customers have the highest number of trips on  Thursdays(day 5)(with 63962 trips) and Sartudays(day 7)(with 5971 trips) respectively.

*/


SELECT 
      usertype,
      start_ride_day_of_week,
      ROUND(AVG(ride_length_in_minutes),2) AS average_ride_length,
      COUNT(*) AS number_of_bike_trips
FROM `cyclistic-project-507412.cyclistic_info.bike_trips`
WHERE ride_length_in_minutes <1440
GROUP BY usertype,start_ride_day_of_week
ORDER BY usertype,start_ride_day_of_week;

/* We now consider how commute hours 7:00 AM to 9:00 AM differ between subscribers and customers.This is the period where we expect a lot of users to use the bike service.

Note: The commute time period considered here is when users travel to school,work etc, the hours are not intended for using bikes for personal reasons such as :for fun ,relaxation or personal enjoyment.

The query results below show that there are more subscribers bike trips(64191) which are likely used to commute to work,school,or personal reasons such as leisure for example than customers bike trips(951).This suggest that customers goup does not prefer using bikes in the normal commute time period in the morning.

Limitation: Here we consider the general commuting hours  for each day , we observe the number of users for each group , however we cannot say with certainty that all the users are using the bikes for commuting to work or school only.During the normal commute hours , the users can use the bikes for either  commuting or leisure.
*/

SELECT 
       '07:00 AM  to 9:00 AM ' AS commute_time_period,
       usertype,
       COUNT(*) AS number_of_bike_trips
FROM `cyclistic-project-507412.cyclistic_info.bike_trips`
WHERE ride_length_in_minutes < 1440
        AND
      ( EXTRACT(TIME FROM start_time) BETWEEN '07:00:00' AND '09:00:00')
GROUP BY usertype;


/* We now consider how commute hours 16:00 PM to 18:00 PM differ between subscribers and customers.This is the period where we expect a lot of users to use the bike service as well.

Note: The commute time period in this case is the period when users travel back from school,work etc, the hours are not intended for using bikes for personal reasons such as :for fun ,relaxation or personal enjoyment.

The results show that there are more subscribers bike trips(84320)  use to commute back from work,school,or personal reasons such as leisure for example than customers bike trips(4883).
Comparison between morning and evening commute hours for each user group:

The data shows that there are substantially more customer bike trips in the evening(4883 trips) than in the morning(951 trips),this suggests that customers are likely to prefer using bikes the most number of times in the evening commute hours(16:00 PM to 18:00 PM).
Subscribers are also likely to prefer using bikes the mist number of times in the evening commute hours as well.

However Subscribers are substantially more likely to use bikes more times than customers in both commute time periods.

Limitation: Here we consider the general commuting hours  for each day , we observe the number of users for each group , however we cannot say with certainty that all the users are using the bikes for commuting back from  work or school only.During the normal commute hours , the users can use the bikes for either  commuting or leisure.
*/

SELECT 
       '16:00 PM  to 18:00 PM ' AS time_period,
       usertype,
       COUNT(*) AS number_of_bike_trips
FROM `cyclistic-project-507412.cyclistic_info.bike_trips`
WHERE ride_length_in_minutes < 1440
        AND
      ( EXTRACT(TIME FROM start_time) BETWEEN '16:00:00' AND '18:00:00')
GROUP BY usertype;

/* We finally look at the top 5 most used routes by subscribers and customers

The query results show that both groups  use different routes for  bike trips when considering the top 5 most used routes by each group.

The number of trips in all 10 most used routes range between 130 and 511.The values are very close for both groups despite the fact that the are more subscribers than customers in the data, we expected to see substantially more subscriber trips than customer trips amongst the top 5 most used routes for each group.
Due to the low comperable numbers for both groups , this suggests that both groups use routes randomly and that there are no preferred routes .

*/

(SELECT
       usertype,
       CONCAT(start_station_name,'   To   ',end_station_name) AS route,
       COUNT(*) AS number_of_bike_trips
FROM `cyclistic-project-507412.cyclistic_info.bike_trips`
WHERE ride_length_in_minutes < 1440 AND usertype= "Subscriber"
GROUP BY start_station_name,
         end_station_name,
         usertype
ORDER BY number_of_bike_trips DESC 
LIMIT 5)

UNION ALL

(SELECT
       usertype,
       CONCAT(start_station_name,'   To   ',end_station_name) AS route,
       COUNT(*) AS number_of_bike_trips
FROM `cyclistic-project-507412.cyclistic_info.bike_trips`
WHERE ride_length_in_minutes < 1440 AND usertype= "Customer"
GROUP BY start_station_name,
         end_station_name,
         usertype
ORDER BY number_of_bike_trips DESC 
LIMIT 5);

/* 
We consider the bike usage for the two groups for a particlar month and day of the week 
This is mainly done to understand the trend of bike usage in each month
*/

SELECT 
       EXTRACT(MONTH FROM start_time) AS month_number,
       usertype,
       start_ride_day_of_week,
       COUNT(*) AS number_of_trips
FROM `cyclistic-project-507412.cyclistic_info.bike_trips`
WHERE ride_length_in_minutes < 1440
GROUP BY month_number,usertype,start_ride_day_of_week
ORDER BY month_number,usertype,start_ride_day_of_week;                  



