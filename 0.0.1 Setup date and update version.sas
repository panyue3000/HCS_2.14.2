

/*SET UP DATE AND UPDATE VERSION */

%LET DATE=121222;
%let IQVIA_VERSION= V3.2;


/*check date*/

proc freq data=redivis_export;
tables MONTH_YEAR_CODE;
run;
