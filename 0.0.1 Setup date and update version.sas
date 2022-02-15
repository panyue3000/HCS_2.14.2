

/*SET UP DATE AND UPDATE VERSION */

%LET DATE=021522;
%let IQVIA_VERSION= V2.25;


/*check date*/

proc freq data=redivis_export;
tables MONTH_YEAR_CODE;
run;
