

/*SET UP DATE AND UPDATE VERSION */

%LET DATE=101722;
%let IQVIA_VERSION= V2.34;


/*check date*/

proc freq data=redivis_export;
tables MONTH_YEAR_CODE;
run;
