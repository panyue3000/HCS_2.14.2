

/*SET UP DATE AND UPDATE VERSION */

%LET DATE=041421_pan;
%let IQVIA_VERSION= V2.15;


/*check date*/

proc freq data=redivis_export;
tables MONTH_YEAR_CODE;
run;
