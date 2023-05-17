

/*SET UP DATE AND UPDATE VERSION */

%LET DATE=0523;
%let IQVIA_VERSION= V4.4;


/*check date*/

proc freq data=redivis_export;
tables MONTH_YEAR_CODE;
run;
