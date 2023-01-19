

/*SET UP DATE AND UPDATE VERSION */

%LET DATE=0123;
%let IQVIA_VERSION= V3.3;


/*check date*/

proc freq data=redivis_export;
tables MONTH_YEAR_CODE;
run;
