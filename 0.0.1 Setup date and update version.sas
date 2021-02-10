

/*SET UP DATE AND UPDATE VERSION */

%LET DATE=021021_pan;

%let IQVIA_VERSION= V2.11;


/*check date*/

proc freq data=redivis_export;
tables MONTH_YEAR_CODE;
run;