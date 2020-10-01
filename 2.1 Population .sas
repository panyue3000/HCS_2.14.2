
/*************************Option 3 Dan's Poppulation where age <18*/
/*the populatoin of full county needs to deduct the partial county, so it reflects the  */
/*From Dan 05142020 we would need to subtract the partial from the full to get the outer area*/

/*I have attached the updated common data model and the population size estimates 
for our HCS counties.  These are the population that is 18 and older in our communities.  
Recall that in HCS we have 3 counties (ERIE (Buffalo), Monroe(Rochester) and Suffolk (Brookhaven Township)) 
where we are only intervening in the major town in the county.   
We also want to calculate this data for these full counties.   
The exel has populations for 2014-2018  for our 16 communities.  
Note for our 3-full (ERIE, SUFFOLK and MONROE) counties we only have the 
2017 and 2018 because I had to do this from the original ACAS and I only downloaded 
those 2 years (we really don’t need the earlier years).  
We will not send these versions to RTI but we will need to build the Measure 3.3. table 
for these full counties to send to NY DOH to calculate whether they are actually prescribing.*/



PROC FREQ DATA=LAYLA.POP_EST_v2;
TABLES YEAR*COUNTY county group;
RUN;

/*sum pop > 18*/
PROC SQL;
   CREATE TABLE POPEST_LAYLA_0 AS 
   SELECT DISTINCT 
		  *,
		  sum(sumest) as pop18
      FROM LAYLA.POP_EST_v2 (where=((race="all_races") and group not in ("Female 0-4", "Female 5-9", "Female 10-14", "Female 15-17", 
																		"Male 0-4", "Male 5-9", "Male 10-14", "Male 15-17")))
	  group by county,
	  	       year
      ORDER BY COUNTY,
		  YEAR,
		  group,
		  POP
;
QUIT;


/*check for three partial counties  */
PROC SQL;
   CREATE TABLE POPEST_LAYLA_partial AS 
   SELECT DISTINCT 
		  year,
		  sum(sumest) as sum_all
      FROM POPEST_LAYLA_0 (where=((county in ("Brookhaven", "Rochester", "Buffalo") and year=2018))) 
	  group by year
      ORDER BY year
;
QUIT;

/*check for removing three full counties  */
PROC SQL;
   CREATE TABLE POPEST_LAYLA_rest AS 
   SELECT DISTINCT 
		  year,
		  sum(sumest) as sum_all
      FROM POPEST_LAYLA_0 (where=((county not in ("Suffolk", "Monroe", "Erie") and year=2018))) 
	  group by year
      ORDER BY year
;
QUIT;

PROC SQL;
   CREATE TABLE POPEST_LAYLA_1 AS 
   SELECT DISTINCT 
		  COUNTY,
		  YEAR,
		  pop18 as pop
      FROM POPEST_LAYLA_0
      ORDER BY COUNTY,
		  YEAR,
		  POP
;
QUIT;

DATA POPEST_2019;
SET POPEST_LAYLA_1;
YEAR=YEAR+1;
IF YEAR NE 2019 THEN DELETE;
RUN;

DATA POPEST_2020;
SET POPEST_LAYLA_1;
YEAR=YEAR+2;
IF YEAR NE 2020 THEN DELETE;
RUN;

DATA POPEST_0;
SET POPEST_LAYLA_1 POPEST_2019 POPEST_2020;
RUN;

/***********************************************************************************************************************/


/*From Dan 05142020 we would need to subtract the partial from the full to get the outer area*/
/*(ERIE (Buffalo), Monroe(Rochester) and Suffolk (Brookhaven Township)*/
PROC SQL;
   CREATE TABLE POPEST_1 AS 
   SELECT DISTINCT 
		  t1.COUNTY,
		  t1.YEAR,
		  t1.pop,
		  case when t1.county="Suffolk" then t2.pop 
		       when t1.county="Monroe" then t3.pop 
		       when t1.county="Erie" then t4.pop 
			   else 0	end as poppart,

		  t1.pop - calculated poppart as popnew,
		  t5.ReporterId
      FROM POPEST_0 AS T1 LEFT JOIN POPEST_0(WHERE=(COUNTY IN ("Brookhaven"))) as t2 on t1.year=t2.year
	   					  LEFT JOIN POPEST_0(WHERE=(COUNTY IN ("Rochester"))) as t3 on t1.year=t3.year
	   				      LEFT JOIN POPEST_0(WHERE=(COUNTY IN ("Buffalo"))) as t4 on t1.year=t4.year
						  LEFT JOIN MAP.REPORTER_LIST t5 ON (propcase(t1.COUNTY) = propcase(t5.county)) 
	  ORDER BY t1.COUNTY,
		       t2.YEAR
;
QUIT;


/*CREATE POPULATION FOR FULL COUNTIES*/
PROC SQL;
   CREATE TABLE POPEST_2 (WHERE=(ReporterId IN ('0371', '0372', '0373'))) AS 
   SELECT DISTINCT 
		  COUNTY,
		  YEAR,
		  pop AS POPNEW,
		  ReporterId,
		  case when county="Suffolk" then '0370' 
		       when county="Monroe" then '0369' 
		       when county="Erie" then '0368'
			   ELSE REPORTERID END AS REPORTERID_NEW,
		  case when county="Suffolk" then "Suffolk-FULL" 
		       when county="Monroe" then "Monroe-FULL"  
		       when county="Erie" then "Erie-FULL" 
			   ELSE county END AS county_NEW

      FROM POPEST_1
      ORDER BY COUNTY,
		  YEAR
;
QUIT;

DATA POPEST_3;
SET POPEST_2 (KEEP=county_NEW  YEAR POPNEW REPORTERID_NEW);
RENAME REPORTERID_NEW=REPORTERID;
RENAME COUNTY_NEW=county;
RUN;


/*COMBNIE BOTH*/
DATA POPEST (RENAME=(POPNEW=POP));
LENGTH COUNTY $ 50;
FORMAT COUNTY $50.;
SET POPEST_3 POPEST_1;
DROP POP;
RUN;