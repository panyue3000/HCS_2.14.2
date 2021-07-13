

/*SET UP DATE AND UPDATE VERSION */

%LET DATE=071321;
%let IQVIA_VERSION= V2.18;


/*check date*/

proc freq data=redivis_export;
tables MONTH_YEAR_CODE;
run;
