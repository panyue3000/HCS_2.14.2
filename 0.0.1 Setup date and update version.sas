

/*SET UP DATE AND UPDATE VERSION */

<<<<<<< HEAD
%LET DATE=041421_pan;
=======
%LET DATE=031521_pan;
>>>>>>> master

%let IQVIA_VERSION= V2.15;


/*check date*/

proc freq data=redivis_export;
tables MONTH_YEAR_CODE;
run;
