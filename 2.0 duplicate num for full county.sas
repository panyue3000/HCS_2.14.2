PROC SQL;
   CREATE TABLE IQVIA_0_full_0 AS 
   SELECT DISTINCT 
		  *, 
		  case when reporterid in ('0371' '0338') then "0368" 
		       when reporterid in ('0372' '0342') then "0369"  
		       when reporterid in ('0373' '0345') then "0370" 
			   ELSE reporterid END AS reporterid_NEW

      FROM IQVIA_00 (WHERE=(REPORTERID IN ('0371' '0338' '0372' '0342' '0373' '0345')))
;
QUIT;

DATA IQVIA_0_full_1 (DROP=REPORTERID_NEW);
SET IQVIA_0_full_0 (DROP=REPORTERID );
REPORTERID=REPORTERID_NEW;
RUN;

DATA IQVIA_0;
SET IQVIA_00 IQVIA_0_full_1;
RUN;