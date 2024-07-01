/* COVER PAGE */
options nodate nonumber; 
ods escapechar='^';
proc odstext;
p '^{newline 15}';
p '^{newline 15}';
p "STAT40840 - Assignment 1" /
style=[font_size= 30pt fontweight=bold just= c color=midnightblue background=mistyrose ];
p "Gargi - 23200711" /
style=[font_size= 20pt just= c background=midnightblue color=mistyrose];
p '^{newline 35}';
p "I have read and understood the Honesty Code and 
have neither received nor given assistance in any way 
with the work contained in this submission." /
style=[font_size= 14pt font_style= italic just= c];
footnote 'Gargi | 23200711 | SAS | Assignment_1';
run;

/* Import the CSV file */
proc odstext;
p '^{newline 1}';
%web_drop_table(s40840.weather);
libname s40840 '/home/u63919326/sasuser.v94/s40840';
proc import datafile='/home/u63919326/my_shared_file_links/u63819461/datasets/valentia.csv'
    out=s40840.weather
    dbms=csv
    replace;
    getnames=yes;
run;

/* Question 1: Print contents of the table */
proc odstext;
title c=stb height=15pt font=Helvetica color= midnightblue 'Question 1: How many variables are there? In what format is the month variable stored?';
PROC CONTENTS DATA=s40840.weather ORDER=VARNUM;
RUN;
proc odstext;
P 'Answer: As we can see, there are 27 variables and the month variable is stored in the character format'
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};


/* Question 2: Print first 15 rows with chosen variables */
p '^{newline 5}';
proc odstext;
title c=stb height=15pt font=Helvetica color= midnightblue 'Question 2: Print first 15 rows. What is the value of rain in the 10th row?';
PROC PRINT DATA=s40840.weather(obs=15);
    VAR date month year maxtp mintp rain;
RUN;
proc odstext;
P 'Answer: The value of rain in the 10th row is 6.1'
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};
    

/* Question 3: scatterplot matrix */
p '^{newline 5}';
proc odstext;
title1 c=stb height=15pt font=Helvetica color= midnightblue 'Question 3: Comment on the relationships between the variables: maximum temperature, minimum temperature, rain, and wind speed';
p '^{newline 5}';
title2 'Scatterplot Matrix of Weather Variables of year 2021';
proc sgscatter data=s40840.weather(where=(year = 2021));
  label maxtp ='Max Temperature';
  label mintp ='Min Temperature';
  label rain ='Rain';
  label wdsp ='Wind Speed';
  matrix maxtp mintp rain wdsp /
     transparency=0.6
     markerattrs=graphdata3(symbol=circlefilled color=blue);
  run;
proc odstext;
P 'Overall, the most significant relationship observed is between maximum temperature (Maxtp) and minimum temperature (Mintp), which shows a positive correlation. The other pairs of variables do not exhibit clear correlations based on the scatter plots.'
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};


/* Question 4: Change column names */
p '^{newline 5}';

%web_drop_table(S40840.weather_edited);

proc odstext;
title c=stb height=15pt font=Helvetica color= midnightblue  'Question 4: Rename and Print the first 10 rows';
DATA s40840.weather_edited;
	set s40840.weather;
	rename maxtp = max_temp
		mintp = min_temp
		wdsp = wind_speed;
run;

/* Let's check if we are successful */
PROC PRINT DATA=s40840.weather_edited(obs=10);
    VAR date month year max_temp min_temp wind_speed;
run;

proc odstext;
P 'Success!'
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};

proc odstext;
p '^{newline 5}';


/* Question 5: new variable */

proc odstext;
title c=stb height=15pt font=Helvetica color= midnightblue  'Question 5: Append new variable: wind_speed1 = winds peed divided by 2 and round the record to 1 decimal';
DATA s40840.weather_edited;
	set s40840.weather_edited;
		wind_speed1 = round(wind_speed/2, 0.1);
run;

/* Let's check if we are successful */
PROC PRINT DATA=s40840.weather_edited(obs=10);
    VAR year wind_speed wind_speed1 ;
run;
proc odstext;
P 'Done!'
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};


/* Question 6: Conditional Print */
proc odstext;
title c=stb height=15pt font=Helvetica color= midnightblue  'Question 6: Print a table containing only those observations where the maximum temperature was greater than 25 C. On how many of these days was rain recorded?';
PROC PRINT DATA=s40840.weather_edited;
	WHERE max_temp > 25;
	VAR date month year max_temp min_temp rain;
run;

PROC PRINT DATA=s40840.weather_edited;
	WHERE max_temp > 25 and rain>0;
	VAR date month year max_temp min_temp rain;
run;
proc odstext;
P 'Answer: As we can see, there are 3 days where rain was recorded!'
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};


/* Question 7: Means procedure */
proc odstext;
title c=stb height=15pt font=Helvetica color= midnightblue   'Question 7: What was the mean rain recorded? What was the maximum of the minimum temperature?';
proc means DATA=s40840.weather_edited chartype mean std max median vardef=df qmethod=os maxdec= 2;
	var max_temp min_temp rain;
run;

proc odstext;
P 'Answer: The mean rain recorded is 4.58 and the maximum of the minimum temperature is 20.50'
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};

/* Question 8: Plot */
proc odstext;
title1 c=stb height=15pt font=Helvetica color= midnightblue   'Question 8: plot of your choice';
title2 'Scatterplot of rain and windspeed with max_temp';
ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=s40840.weather_edited;
	heatmap x=wind_speed y=rain / name='HeatMap' colormodel=(CX9bdf27 CXebe427 
		CXff9100 CXeb1717) colorresponse=max_temp colorstat=mean;
	gradlegend 'HeatMap';
run;

ods graphics / reset;
proc odstext;
P 'The scatter plot indicates a low moderate positive correlation among wind speed, rain, and the heatmap/gradient colors of the points indicate the average maximum temperature. Regions experiencing higher wind speeds exhibit greater rainfall. The decrease (as the color gradient seems to cool) in average maximum temperature seems to show a more noticeable trend with increasing wind speed compared to increasing rainfall.'
/ Style={font_size= 12pt font_face='Helvetica' leftmargin =.75in rightmargin =.25in just= l};

