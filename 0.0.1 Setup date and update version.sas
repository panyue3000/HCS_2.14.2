

/*SET UP DATE AND UPDATE VERSION */

%LET DATE=062021;
%let IQVIA_VERSION= V2.17;


/*check date*/

proc freq data=redivis_export;
tables MONTH_YEAR_CODE;
run;
