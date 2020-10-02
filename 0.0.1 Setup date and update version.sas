

/*SET UP DATE AND UPDATE VERSION */

%LET DATE=081320;

%let IQVIA_VERSION= V2.6;


/*check date*/

proc freq data=redivis_export;
tables MONTH_YEAR_CODE;
run;