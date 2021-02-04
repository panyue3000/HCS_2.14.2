

/*SET UP DATE AND UPDATE VERSION */

%LET DATE=020421_pan;

%let IQVIA_VERSION= V2.10;


/*check date*/

proc freq data=redivis_export;
tables MONTH_YEAR_CODE;
run;