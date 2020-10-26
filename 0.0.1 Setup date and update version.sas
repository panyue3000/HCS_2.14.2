

/*SET UP DATE AND UPDATE VERSION */

%LET DATE=102620_pan;

%let IQVIA_VERSION= V2.7;


/*check date*/

proc freq data=redivis_export;
tables MONTH_YEAR_CODE;
run;