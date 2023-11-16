

/*SET UP DATE AND UPDATE VERSION */

%LET DATE=1123;
%let IQVIA_VERSION= V4.10;


/*check date*/

proc freq data=redivis_export;
tables MONTH_YEAR_CODE;
run;
