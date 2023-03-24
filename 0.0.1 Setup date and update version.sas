

/*SET UP DATE AND UPDATE VERSION */

%LET DATE=0323;
%let IQVIA_VERSION= V4.2;


/*check date*/

proc freq data=redivis_export;
tables MONTH_YEAR_CODE;
run;
