

/*SET UP DATE AND UPDATE VERSION */

%LET DATE=1023;
%let IQVIA_VERSION= V4.8;


/*check date*/

proc freq data=redivis_export;
tables MONTH_YEAR_CODE;
run;
