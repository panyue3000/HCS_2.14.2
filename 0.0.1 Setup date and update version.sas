

/*SET UP DATE AND UPDATE VERSION */

%LET DATE=121620_pan;

%let IQVIA_VERSION= V2.9;


/*check date*/

proc freq data=redivis_export;
tables MONTH_YEAR_CODE;
run;