

/*SET UP DATE AND UPDATE VERSION */

%LET DATE=031521_pan;

%let IQVIA_VERSION= V2.12;


/*check date*/

proc freq data=redivis_export;
tables MONTH_YEAR_CODE;
run;
