Data redivis_export_0;
set redivis_export;
/*If COUNTY_TERRITORY in ('ERIE','MONROE','SUFFOLK') then delete;*/
RUN;

Data redivis_export_1;
set redivis_export_0;
if COUNTY eq 'ROCHESTER_NY' then COUNTY='ROCHESTER';
if COUNTY eq 'BUFFALO_NY' then COUNTY='BUFFALO';
if COUNTY eq 'BROOKHAVEN TOWNSHIP_NY' then COUNTY='BROOKHAVEN';

run;

PROC FREQ DATA=REDIVIS_EXPORT;
TABLES COUNTY;
RUN;

PROC FREQ DATA=REDIVIS_EXPORT_1;
TABLES COUNTY;
RUN;