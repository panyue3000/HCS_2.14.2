

/*SET UP DATE AND UPDATE VERSION */

%LET DATE=1223;
%let IQVIA_VERSION= V4.11;


/*check date*/

proc freq data=redivis_export;
tables MONTH_YEAR_CODE;
run;
