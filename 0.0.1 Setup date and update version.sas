

/*SET UP DATE AND UPDATE VERSION */

%LET DATE=041122;
%let IQVIA_VERSION= V2.27;


/*check date*/

proc freq data=redivis_export;
tables MONTH_YEAR_CODE;
run;
