
LIBNAME MAP 'C:\Users\panyue\Box\Yue Pan from old laptop 2015\DR FEASTER\Healing Communities\2.14.2 IQVIA';

LIBNAME POP 'C:\Users\panyue\Box\Yue Pan from old laptop 2015\DR FEASTER\Healing Communities\HCS Denominator';

libname prod 'C:\Users\panyue\Box\1 Healing Communities\DATA_NYS\Christmas Eve\Ongoing Production';

libname dan 'C:\Users\panyue\Box\1 Healing Communities\DATA_NYS\Christmas Eve\Ongoing Production';

/*libname layla 'C:\Users\panyue\Box\Yue Pan from old laptop 2015\DR FEASTER\Healing Communities\HCS Denominator\Layla';*/
libname partial "C:\Users\panyue\Box\1 Healing Communities\DATA_NYS\PAN\Denominators\Layla";
libname wonder "C:\Users\panyue\Box\1 Healing Communities\DATA_NYS\PAN\Denominators\CDC\Output Data";



PROC FREQ DATA=redivis_export;
TABLES COUNTY_TERRITORY;
RUN;

/*DATA REPORTER_LIST_0;*/
/*SET MAP.REPORTER_LIST;*/
/*If county in ('ERIE','MONROE','SUFFOLK') then delete;*/
/*RUN;*/
/*Data REPORTER_LIST;*/
/*set REPORTER_LIST_0;*/
/*if county eq 'ROCHESTER' then county='MONROE';*/
/*if county eq 'BUFFALO' then county='ERIE';*/
/*if county eq 'BROOKHAVEN' then county='SUFFOLK';*/
/*run;*/