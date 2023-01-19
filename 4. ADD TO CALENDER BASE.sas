

/*CREATE BASE FILE WITH ID AND TIME*/
PROC SQL;
   CREATE TABLE WORK.IQVIA_3_id AS 
   SELECT DISTINCT 
		  t1.ReporterId,
		  t1.MEASUREID
/*		  t1.COUNTY_TERRITORY*/
/*		  t1.DENOMINATOR,*/
/*		  t1.year*/
      FROM WORK.IQVIA_3 t1;
QUIT;


PROC SQL;
CREATE TABLE BASE AS 
SELECT * FROM IQVIA_3_ID, CAL_1
order by reporterid, year, quarter, month
;
Quit;

PROC FREQ DATA=BASE;
TABLES REPORTERID YEAR QUARTER MONTH REPORTERID*( YEAR QUARTER MONTH);
RUN;








PROC SQL;
   CREATE TABLE IQVIA_FINAL_EXCEL_&DATE._0 AS 
   SELECT  
/*		  '2.14.2' as MEASUREID,*/
		  t1.ReporterId,
		  T4.COMMUNITY AS COUNTY,
		  CASE WHEN T2.NUMERATOR EQ . THEN 0
		       ELSE T2.NUMERATOR END AS NUMERATOR,
		  T3.POP AS DENOMINATOR,
		  T1.MONTH,
		  T1.QUARTER,
		  T1.YEAR,
		  CASE WHEN T2.NUMERATOR EQ . THEN 0
		       ELSE 0 END AS IsSuppressed,
		  "This data is from IQVIA DATASET_&IQVIA_VERSION." AS NOTES,
		  '' AS STRATIFICATION
      FROM WORK.BASE t1 LEFT JOIN IQVIA_3 T2 ON 
	  	  T1.REPORTERID=T2.REPORTERID AND
	  	  T1.YEAR=T2.YEAR AND
		  T1.QUARTER=T2.QUARTER AND
	  	  T1.MONTH=T2.MONTH LEFT JOIN POPEST T3 ON t1.REPORTERID=T3.REPORTERID AND T1.YEAR=T3.YEAR
		  				    LEFT JOIN MAP.REPORTER_LIST T4 ON t1.REPORTERID=T4.REPORTERID 
	  ORDER BY t1.ReporterId,
			   T1.YEAR,
			   T1.QUARTER,
			   T1.MONTH
;
QUIT;


PROC SQL;
   CREATE TABLE IQVIA_FINAL_&DATE._00 AS 
   SELECT  
		  '2.14.2' as MEASUREID,
		  t1.ReporterId,
/*		  T1.COUNTY_TERRITORY,*/
/*		  T2.NUMERATOR,*/
		  CASE WHEN T2.NUMERATOR EQ . THEN 0
		       ELSE T2.NUMERATOR END AS NUMERATOR,
		  T3.POP AS DENOMINATOR,
		  T1.MONTH,
		  T1.QUARTER,
		  T1.YEAR,
		  CASE WHEN T2.NUMERATOR EQ . THEN 0
		       ELSE 0 END AS IsSuppressed,
		  "This data is from IQVIA DATASET_&IQVIA_VERSION." AS NOTES,
		  '' AS STRATIFICATION
      FROM WORK.BASE t1 LEFT JOIN IQVIA_3 T2 ON 
	  	  T1.REPORTERID=T2.REPORTERID AND
	  	  T1.YEAR=T2.YEAR AND
		  T1.QUARTER=T2.QUARTER AND
	  	  T1.MONTH=T2.MONTH LEFT JOIN POPEST T3 ON t1.REPORTERID=T3.REPORTERID AND T1.YEAR=T3.YEAR
	  ORDER BY t1.ReporterId,
			   T1.YEAR,
			   T1.QUARTER,
			   T1.MONTH
;
QUIT;

/*add Fiscal year data*/
PROC SQL;
   CREATE TABLE IQVIA_FINAL_&DATE._01 AS 
   SELECT DISTINCT 
   		  '2.14.2' as MEASUREID,
		  t1.ReporterId,
		  (SUM(t1.numerator)) FORMAT=BEST32. AS sum_numerator,
		  t1.denominator,
		  month(intnx('month', mdy(t1.month, 01, t1.year), 7)) as month,
		  . as quarter,
		  year(intnx('month', mdy(t1.month, 01, t1.year), 7)) as year,
		  intnx('month', mdy(t1.month, 01, t1.year), 7) as date format=mmddyy10.,
          /* SUM_of_PROJECTED_TRX */
		  		  CASE WHEN T1.NUMERATOR EQ . THEN 0
		       ELSE 0 END AS IsSuppressed,
		  "This data is from IQVIA DATASET_&IQVIA_VERSION." AS NOTES,
		  '' AS STRATIFICATION

      FROM IQVIA_FINAL_&DATE._00 t1
      GROUP BY t1.ReporterId,
	  	       calculated YEAR
	  order by t1.ReporterId,
	  	       calculated YEAR

	;
QUIT;

DATA IQVIA_FINAL_&DATE._02;
SET IQVIA_FINAL_&DATE._01;

/*0 remove year 2023 if we are still in 2022*/
if year =. then delete;
month=.;
rename sum_numerator=numerator;
IF YEAR=2023 THEN DELETE;

/*1.)	for the Fiscal year we need to put the year in a 2 year format: */
if Year eq 2023 then year=20222023;
if Year eq 2022 then year=20212022;
if Year eq 2021 then year=20202021;
if Year eq 2020 then year=20192020;
if Year eq 2019 then year=20182019;
if Year eq 2018 then year=20172018;
if Year eq 2017 then year=20162017;

/*2.)	RTI does not recognize our additional areas, so for RTI we need to skip those recordids*/
/*if reporterid in ('0368','0369','0370','0371','0372','0373') then delete;*/

drop date;
RUN;

data IQVIA_FY;
set IQVIA_FINAL_&DATE._02;
by reporterid year;
if first.year;
run;


data IQVIA_FINAL_&DATE._0;
set IQVIA_FY IQVIA_FINAL_&DATE._00;
if reporterid in ('0368','0369','0370','0371','0372','0373') then delete;

run;




/*DELETE QUARTER IF MONTH NOT REACH TO THE LAST MONTH OF THE QUARTER*/


DATA IQVIA_FINAL_EXCEL_&DATE.;
SET IQVIA_FINAL_EXCEL_&DATE._0;
IF YEAR=2022 AND QUARTER=4 THEN DELETE;
IF YEAR=2022 AND QUARTER=. AND MONTH=. THEN DELETE;
RUN;

DATA IQVIA_FINAL_&DATE.;
SET IQVIA_FINAL_&DATE._0;
IF YEAR=2022 AND QUARTER=4 THEN DELETE;
IF YEAR=2022 AND QUARTER=. AND MONTH=. THEN DELETE;

/*for fiscal year check*/
IF YEAR=20212022 THEN DELETE;


RUN;

/*CHECK FOR EVEN NUMBERS ACROSS COUNTIES*/
PROC FREQ DATA=IQVIA_FINAL_&DATE.;
RUN;


/*1 DELIVERY FILES TO HCS DELIVERIES*/

/*IQVIA_FINAL_&DATE.*/
%macro csv_export (DATA);

proc export data=&DATA. dbms=CSV
outfile= %TSLIT (C:\Users\panyue\Box\1 Healing Communities\DATA_NYS\PAN\2.14.2 IQVIA\HCS deliveries\&DATA..CSV)
replace;
run;

%mend csv_export;
%csv_export(IQVIA_FINAL_&DATE.);


/*1 DELIVERY FILES TO INTERNVAL REVIEW FOR EXCEL VISUALIZATION */

/*IQVIA_FINAL_EXCEL_&DATE.*/
%macro csv_export (DATA);

proc export data=&DATA. dbms=CSV
outfile= %TSLIT (C:\Users\panyue\Box\1 Healing Communities\DATA_NYS\PAN\2.14.2 IQVIA\Export\&DATA..CSV)
replace;
run;

%MEND CSV_EXPORT;
%CSV_EXPORT(IQVIA_FINAL_EXCEL_&DATE.);

