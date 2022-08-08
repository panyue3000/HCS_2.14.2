

/*SET UP DATE AND UPDATE VERSION */

%LET DATE=080822;
%let IQVIA_VERSION= V2.31;


/*check date*/

proc freq data=redivis_export;
tables MONTH_YEAR_CODE;
run;
