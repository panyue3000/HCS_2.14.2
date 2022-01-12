

/*SET UP DATE AND UPDATE VERSION */

%LET DATE=011222;
%let IQVIA_VERSION= V2.24;


/*check date*/

proc freq data=redivis_export;
tables MONTH_YEAR_CODE;
run;
