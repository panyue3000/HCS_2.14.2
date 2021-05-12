

/*SET UP DATE AND UPDATE VERSION */

%LET DATE=051221;
%let IQVIA_VERSION= V2.16;


/*check date*/

proc freq data=redivis_export;
tables MONTH_YEAR_CODE;
run;
