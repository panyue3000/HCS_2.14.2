

/*SET UP DATE AND UPDATE VERSION */

%LET DATE=033122;
%let IQVIA_VERSION= V2.26;


/*check date*/

proc freq data=redivis_export;
tables MONTH_YEAR_CODE;
run;
