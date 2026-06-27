Create Table Daily_Activity (
Id Bigint,
ActivityDate Date,
TotalSteps int,
TotalDistance Numeric,
TrackerDistance Numeric,
LoggedActivitiesDistance Numeric,
VeryActiveDistance Numeric,
ModeratelyActiveDistance Numeric,
LightActiveDistance Numeric,
SedentaryActiveDistance Numeric,
VeryActiveMinutes int,
FairlyActiveMinutes int,
LightlyActiveMinutes int,
SedentaryMinutes int,
Calories int
);

Select * from daily_activity;

Create Table heart_rate (
Id Bigint,
Time Timestamp,
Value int
);

Select * from heart_rate;

Create Table hour_calories (
Id Bigint,
ActivityHour Timestamp,
Calories int
);

Select * from hour_calories;

Create Table hour_intensity (
Id Bigint,
ActivityHour Timestamp,
TotalIntensity int,
AverageIntensity Numeric
);

Select * from hour_intensity;

Create Table hourly_steps (
ID Bigint,
ActivityHour Timestamp,
StepTotal int
);

Select * from hourly_steps;

Create Table Mets (
Id Bigint,
ActivityMinute Timestamp,
METs int
);

Select * from Mets;

Create Table sleep(
Id Bigint,
SleepDay Timestamp,
TotalSleepRecords int,
TotalMinutesAsleep int,
TotalTimeInBed int
);

Select * from sleep;

Create Table weight (
Id Bigint,
Date Timestamp,
WeightKg Numeric,
WeightPounds Numeric,
Fat int,
BMI Numeric,
IsManualReport varchar(50),
LogId Bigint
);

Select * from weight;

  ---- Average Total Steps of all Users in 30 Days (33 Users) ----
Select Round(Avg(totalsteps), 2) as Average_total_steps_per_day
from daily_activity;

   ---- Average Total Distance of all Users in 30 days  ----
Select Round(Avg(TotalDistance), 2) as Average_distance_miles
from daily_activity;

   ---- Average Calories Burn of all Users in 30 Days ----
Select Round(Avg(Calories), 2) as Average_Calories_Burn
from daily_activity;

 ---- Average Total Steps, Average_Distance, Average Calories Per User in 30 Days ----
Select id, Round(Avg(totalsteps), 2) as Average_steps_per_day,
       Round(Avg(totaldistance), 2) as Average_distance_per_day_miles,
	   Round(Avg(calories), 2) as Average_calories_burned_per_day
from daily_activity
Group by id;
 
 ---- Average Distance Type covered of all Users in 30 days ----
Select Round(Avg(veryactivedistance), 2) as Average_very_active_distance_miles,
       Round(Avg(moderatelyactivedistance), 2) as Moderately_active_distance_miles,
	   Round(Avg(lightactivedistance), 2) as light_active_distance_miles,
	   Round(Avg(sedentaryactivedistance), 5) as Sedantary_active_distance_miles
from daily_activity;

  ---- Average Total Minutes Activity of all Users in 30 Days ----
Select Round(Avg(veryactiveminutes), 2) as Average_very_active_minutes,
       Round(Avg(fairlyactiveminutes), 2) as Average_fairly_active_minutes,
	   Round(Avg(lightlyactiveminutes), 2) as Average_light_active_minutes,
	   Round(Avg(sedentaryminutes), 2) as Average_sedentary_minutes
from daily_activity;

 ---- Average Distance type and Minutes Type Per User in 30 Days ----
Select id, Round(Avg(veryactivedistance), 2) as Average_very_active_distance_miles,
       Round(Avg(moderatelyactivedistance), 2) as Moderately_active_distance_miles,
	   Round(Avg(lightactivedistance), 2) as light_active_distance_miles,
	   Round(Avg(sedentaryactivedistance), 5) as Sedantary_active_distance_miles,
	   Round(Avg(veryactiveminutes), 2) as Average_very_active_minutes,
       Round(Avg(fairlyactiveminutes), 2) as Average_fairly_active_minutes,
	   Round(Avg(lightlyactiveminutes), 2) as Average_light_active_minutes,
	   Round(Avg(sedentaryminutes), 2) as Average_sedentary_minutes
from daily_activity
Group by id;

 ---- Total Daily Activity Record Per User in 30 Days ----
Select id, sum(totalsteps) as Total_steps,
           sum(calories) as Total_calories_burned,
           Round(sum(Totaldistance), 2) as Total_Distance,
           Round(sum(veryactivedistance), 2) as Total_very_active_distance,
		   Round(sum(moderatelyactivedistance), 2) as Total_moderately_active_distance,
		   Round(sum(lightactivedistance), 2) as Total_light_active_distance,
		   Round(sum(sedentaryactivedistance), 2) as Total_sedentary_active_distance,
		   sum(veryactiveminutes) as Total_very_active_minutes,
		   sum(fairlyactiveminutes) as Total_fairly_active_minutes,
		   sum(lightlyactiveminutes) as Total_lightly_active_minutes,
		   sum(sedentaryminutes) as Total_sedentary_minutes
from daily_activity
Group by id;

 ---- Activity level Per User in 30 days ----
Select id, sum(totalsteps) as Total_steps_30days, 
       Round(Avg(totalsteps), 2) as Average_steps_per_day,
	   Round(Avg(Calories), 2) as Average_Calories_burned_Per_day,
       Case
	   When Avg(totalsteps) < 5000 Then 'Sedentary'
	   When Avg(totalsteps) < 7500 Then 'Low Active'
	   When Avg(totalsteps) <10000 Then 'Somewhat Active'
	   When Avg(totalsteps) <12500 Then 'Active'
	   Else 'Higly Active'
	   End As Activity_level
from daily_activity
Group by id;

 ---- Top 10 Highest Calories Burned in 30 Days ----
Select id, activitydate, calories
from daily_activity
order by calories desc
Limit 10;

 ---- Top Calorie Burn Per User in 30 days -----
With cte1 as (
Select id, activitydate, calories,
       dense_rank() Over(Partition by id Order by calories desc) as Top_calorie_burn
from daily_activity)
Select id, activitydate, calories from cte1
Where Top_calorie_burn = 1;

 ---- Most Distanced Travelled By Each User in 30 Days ----
With cte1 as (
Select id, activitydate, Round(totaldistance, 2) as totaldistance,
       dense_rank() Over (Partition by id Order by totaldistance desc) as Most_distance_travelled
from daily_activity)
Select id, activitydate, totaldistance from cte1
Where most_distance_travelled = 1;

 ---- Most Sedentary Users in 30 Days ----
Select id, Round(Avg(sedentaryminutes), 2) as Avg_sedentary
from daily_activity
group by id
Order by Avg_sedentary desc;
		 
 ---- Most Active Users in 30 Days ----
Select id, 
       Round(Avg(veryactiveminutes), 2) As Avg_very_active_minutes,
	   Round(Avg(fairlyactiveminutes), 2) As Avg_Fairly_active_minutes,
	   Round(Avg(lightlyactiveminutes), 2) As Avg_lightly_active_minutes
from daily_activity
Group by id
Order by Avg_very_active_minutes desc;
		   		   
 ---- Most Active Hour Per day By Each User in 30 Days ----
With cte1 as (
Select id, Date(activityhour) as date, 
           Extract(hour from activityhour) as most_active_hour,
		   totalintensity
from hour_intensity),
cte2 as (
Select *, 
       dense_rank() Over (Partition by id, date Order by totalintensity desc) as Most_active_hour1
from cte1)
Select id, date,  
           Case When totalintensity = 0 Then 'No Activity Today'
		   Else most_active_hour :: Text
		   End as most_active_hour,
	 totalintensity
from cte2
Where most_active_hour1 = 1; 

  ---- Most Active Day Per User in 30 Days ----
With cte1 as (
Select id, Date(activityhour) as date,
       sum(totalintensity) as Total_intensity,
	   Round(Avg(totalintensity), 2) as Average_intensity_per_hour
from hour_intensity
Group by id, date),
cte2 as (
Select *, dense_rank() Over (Partition by id Order by total_intensity desc) as Peak_day
from cte1)
Select id, date, total_intensity, Average_intensity_per_hour from cte2
Where Peak_day = 1;

---- Average Sleep Time Per User in 30 Days (24 Users) ----
Select id, 
       Round(Avg(totalminutesasleep), 2) as Average_sleep_minutes
from sleep
Group by id;

 ----- Average Heart Rate Per Day of Users in 30 days (14 Users) ----
Select id, Date(time) as date, Round(Avg(value), 2) as heart_beat
from heart_rate
Group by id, date
Order by id, date;

 ---- Average Heart Rate of Users in 30 Days (14 Users) -----
With cte1 as (
Select id, Date(time) as date, Avg(value) as heart_beat
from heart_rate
Group by id, date
Order by id, date
)
Select id, Round(Avg(heart_beat), 2) as Average_heart_beat
from cte1
Group by id;

 ---- Weight and BMI Analysis of Users (8 Users) -----
With cte1 as (
Select id, Round(Avg(weightkg), 2) as weight_kg,
           Round(Avg(weightpounds), 2) as weight_pounds,
		   Round(Avg(bmi), 2) as Bmi
from weight
Group by id)
Select *, Case When bmi < 18.5 Then 'Underweight'
               When bmi < 25 Then 'Normal'
			   When bmi < 30 Then 'Overweight'
			   Else 'Obese'
			   End as Bmi_Category
from cte1;

 ---- Activity vs Calories Burned in Last 30 Days ----
Select id, sum(totalsteps) as total_steps_30days,
           Round(Avg(totalsteps), 2) as Average_steps_Per_day,
		   Round(sum(totaldistance), 2) as total_distance_miles_30days,
           Round(Avg(totaldistance), 2) as Average_distance_miles_Per_day,
		   sum(calories) as total_calories_burned_30days,
		   Round(Avg(calories), 2) as Average_calories_burned_per_day
from daily_activity
Group by id
Order by total_calories_burned_30days desc, 
         Average_calories_burned_per_day desc;

 ----  Intensity Vs Calories Burned Per Hour in 30 Days ----
Select i.id, i.activityhour, i.totalintensity, i.averageintensity, c.calories
from hour_intensity i
join
hour_calories c
on i.id = c.id
and i.activityhour = c.activityhour

 ----  Intensity Vs Calories Burned Per Day in 30 Days ----
With cte1 as (
Select id, Date(activityhour) as date,
           sum(totalintensity) as Total_intensity
from hour_intensity
Group by id, date),
cte2 as (
Select id, activitydate, calories 
from daily_activity)
Select h.id, h.date, h.total_intensity, d.calories
from cte1 as h
join
cte2 as d
on h.id = d.id
And h.date = d.activitydate
Order by h.total_intensity desc;

 ----  Intensity Vs Calories Burned in 30 Days ----
With cte1 as (
Select id, sum(totalintensity) as Total_intensity, 
       Round(Avg(totalintensity), 2) as Average_intensity
from hour_intensity
Group by id),
cte2 as (
Select id, sum(calories) as Total_calories_burned,
       Round(Avg(calories), 2) as Average_calories_burned
from daily_activity
Group by id)
Select h.id, h.total_intensity, h.average_intensity, c.total_calories_burned,
       c.average_calories_burned
from cte1 as h
join
cte2 as c
on h.id = c.id
Order by c.total_calories_burned desc;

 ---- Mets vs Intensity Per Hour of Each User in 30 Days ----
With cte1 as (
Select id, Date_trunc('hour', activityminute) as date_hour,
           sum(mets) as total_mets,
		   Round(Avg(mets), 2) as Average_mets
from mets
Group by id, date_hour)
Select m.id, m.date_hour, (m.total_mets/10) as Totalmets_perhour, 
       Round((m.Average_mets/10), 2) as Averagemets_perminute, 
	   h.totalintensity as totalintensity_perhour, 
	   h.averageintensity as averageintensity_perminute
from cte1 m
join
hour_intensity h
on m.id = h.id
and m.date_hour = h.activityhour;
	   
 ---- Mets vs Intensity Per Day of Each User in 30 Days ----
With cte1 as (
Select id, Date(activityminute) as date, 
        sum(mets) as total_mets,
		Round(Avg(mets), 2) as Average_mets
from mets
Group by id, date),
cte2 as (
Select id, Date(activityhour) as Date,
       sum(totalintensity) as total_intensity,
	   Round(Avg(totalintensity), 2) as Average_intensity
from hour_intensity
Group by id, date)
Select m.id, m.date, i.total_intensity, (m.total_mets)/10 as mets,
       i.Average_intensity, Round((m.Average_mets)/10, 2) as Averagemets
from cte1 as m
join
cte2 as i
on m.id = i.id
and m.date = i.date;

 ---- Mets vs Intensity of Each User in 30 days ----
With cte1 as (
Select id, Date(activityminute) as date, 
		Round(Avg(mets), 2) as Average_mets
from mets
Group by id, date),
cte2 as (
Select id, Date(activityhour) as Date,
       sum(totalintensity) as total_intensity,
	   Round(Avg(totalintensity), 2) as Average_intensity
from hour_intensity
Group by id, date)
Select m.id, sum(i.total_intensity) as totalintensity,
      Round(Avg(i.Average_intensity), 2) as Average_intensity, 
	  Round(Avg(m.Average_mets)/10, 2) as Average_mets
from cte1 as m
join
cte2 as i
on m.id = i.id
and m.date = i.date
Group by m.id, i.id
Order by Average_mets desc;

 ---- Activity vs Sleep Per Day of Each User in 30 Days (24 Users) ----
Select d.id, d.activitydate, d.totalsteps, Round(d.totaldistance, 2) as total_distance_miles,
       s.totalsleeprecords, s.totalminutesasleep,
       s.totaltimeinbed
from daily_activity d
join
sleep s
on d.id = s.id
and d.activitydate = Date(s.sleepday)
Order by d.totalsteps desc;

 ---- Activity vs Sleep Average of Last 30 days of Each User (24 Users) ----
Select d.id, Round(Avg(d.totalsteps), 2) as Avg_total_steps,
       Round(Avg(d.totaldistance), 2) as Average_distance_miles,
	   Round(Avg(s.totalsleeprecords), 2) as Average_sleep_record,
	   Round(Avg(s.totalminutesasleep), 2) as Average_minutes_sleep,
	   Round(Avg(s.totaltimeinbed), 2) as Average_time_in_bed
from daily_activity d
join
sleep s
on d.id = s.id
and
d.activitydate = Date(s.sleepday)
Group by d.id
Order by average_minutes_sleep desc;

 ---- BMI vs Activity of Users in 30 Days (8 Users) ----
Select d.id, Round(Avg(d.totalsteps), 2) as Average_steps,
      Round(Avg(d.totaldistance), 2) as Average_distance,
	  Round(Avg(d.calories), 2) as Average_calories,
	  Round(Avg(w.bmi), 2) as bmi,
	  Case When Avg(w.bmi) < 18.5 Then 'Underweight'
               When Avg(w.bmi) < 25 Then 'Normal'
			   When Avg(w.bmi) < 30 Then 'Overweight'
			   Else 'Obese'
			   End as Bmi_Category
from daily_activity d
join
weight w
on d.id = w.id
and d.activitydate = Date(w.date)
Group by d.id
Order by bmi;

 ---- Heart Rate Vs Calories of Each User Per Hour in 30 Days ---
With cte1 as (
Select id, Date_Trunc('hour', time) as date_hour, Round(Avg(value), 2) as Average_heart_rate
from heart_rate
Group by id, date_hour)
Select h.id, h.date_hour, h.Average_heart_rate, c.calories 
from cte1 h
join 
hour_calories c
on h.id = c.id
and h.date_hour = c.activityhour
Order by c.calories desc;

 ---- Heart Rate vs Activity of Each User Per Hour in 30 Days ----
With cte1 as (
Select id, Date_trunc('hour', time) as date_hour, Round(Avg(value), 2) as Average_heart_rate
from heart_rate
Group by id, date_hour)
Select h.id, h.date_hour, h.Average_heart_rate, s.steptotal
from cte1 h
join
hourly_steps s
on h.id = s.id
and h.date_hour = activityhour
Order by s.steptotal desc;

 ---- Sleep vs Bmi of Users in 30 days (Only 5 Users) -----
Select s.id, Round(Avg(s.totalsleeprecords), 2) as total_sleep_records,
           Round(Avg(s.totalminutesasleep), 2) as total_minutes_sleep,
		   Round(Avg(s.totaltimeinbed), 2) as total_time_in_bed,
		   Round(Avg(w.bmi), 2) as bmi
from sleep s
join 
weight w
on s.id = w.id
and Date(s.sleepday) = Date(w.date)
group by s.id
Order by bmi desc;

 ---- Mets vs Calories Per Hour of Each User in 30 Days ----
With cte1 as (
Select id, Date_trunc('hour', activityminute) as date_hour, Round(Avg(mets)/10, 2) as Average_mets
from mets
Group by id, date_hour)
Select m.id, m.date_hour, m.average_mets, c.calories
from cte1 m
join
hour_calories c
on m.id = c.id
and m.date_hour = c.activityhour;

 ---- Total Record of All Users in 30 Days ----
With cte1 as (
Select id, Round(Avg(totalsteps), 2) as Average_Total_steps,
           Round(Avg(calories), 2) as Average_Total_calories_burned,
		   Round(Avg(Totaldistance), 2) as Total_Distance_miles
from daily_activity
Group by id),
cte2 as (
Select id, date_trunc('hour', time) as date_hour,
        Round(Avg(value), 2) as heartrate
from heart_rate
Group by id, date_hour), 
cte3 as (
Select id, date(date_hour) as hdate,
       Round(Avg(heartrate), 2) as heart_rate
from cte2
group by id, hdate),
cte4 as (
Select id, Round(Avg(heart_rate), 2) as Average_heart_rate
from cte3
Group by id),
cte5 as (
Select id, Round(Avg(mets)/10, 2) as mets
from mets
Group by id), 
cte6 as (
Select id, Round(Avg(totalsleeprecords), 2) as Average_sleep_record,
       Round(Avg(totalminutesasleep), 2) as Average_minutes_sleep,
	   Round(Avg(totaltimeinbed), 2) as Average_time_in_bed
from sleep
Group by id),
cte7 as (
Select id, Round(Avg(weightkg), 2) as weight_kg,
       Round(Avg(bmi), 2) as bmi
from weight
Group by id),
cte8 as (
Select id, Round(Avg(totalintensity), 2) as Average_intensity
from hour_intensity
Group by id)
Select d.id, d.Average_Total_steps, Total_Distance_miles, i.average_intensity, 
       d.Average_Total_calories_burned, h.Average_heart_rate, m.mets, s.Average_sleep_record, 
	   s.Average_minutes_sleep, s.Average_time_in_bed, w.weight_kg, w.bmi
from cte1 d
left join cte4 h
on d.id = h.id
left join cte5 m
on d.id = m.id
left join cte6 s
on d.id = s.id
left join cte7 w
on d.id = w.id
left join cte8 i
on d.id = i.id;
	  

