å%web_drop_table(WORK.Bikes);
FILENAME REFFILE '/home/u62791191/Bikes/day.csv';

PROC IMPORT DATAFILE=REFFILE DBMS=CSV OUT=WORK.Bikes;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.Bikes;
RUN;

%web_open_table(WORK.Bikes);

/* check for  nulls*/
proc means data=work.Bikes nmiss n;
run;

/* check for duplicates*/
proc sort data=work.Bikes out=new_Bikes nodupkey;
	by _all_;
run;

proc means data=work.Bikes;
run;
DATA work.Bikes;
 ATTRIB weather LENGTH=$14;

 SET WORK.Bikes;
 SELECT;
 WHEN (weathersit <= 1) weather = 'Clear';
WHEN (weathersit = 2) weather = 'Mist + Cloudy';
WHEN (weathersit = 3) weather = 'Light Snow';
 OTHERWISE weather = 'Heavy Rain';
 END; 
run;




DATA work.Bikes;
 ATTRIB year LENGTH=$14;

 SET WORK.Bikes;
 SELECT;
 WHEN (yr < 1) year = '2018';

 OTHERWISE year = '2019';
 END; 
run;
/*
proc print data=work.Bikes;
run;
*/
proc corr data=WORK.Bikes pearson nosimple noprob plots=none;
	var instant dteday season year mnth holiday weekday workingday weathersit temp 
		atemp hum windspeed casual registered;
	with cnt;
run;


data work.Bikes;
	set work.Bikes;
	drop instant dteday yr weathersit ;
run;

ods graphics / reset;
title 'Year By Rental Count'; 
ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.BIKES;
	vbar year / response=cnt ;
	yaxis grid;
run;



ods graphics / reset;

ods graphics / reset;
title 'Month By Rental Count'; 
ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.BIKES;
	vbar mnth / response=cnt ;
	yaxis grid;
run;

ods graphics / reset;



ods graphics / reset;
title 'Season By Rental Count'; 
ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.BIKES;
	vbar season / response=cnt group=year groupdisplay=cluster;
	yaxis grid;
run;

ods graphics / reset;


/*.       
title 'Rental Count By Regular Custtomers over the  Year'; 
ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.BIKES;
	vbar mnth / response=registered group=year groupdisplay=cluster;
	yaxis grid;
run;

ods graphics / reset;

title 'Rental Count By Casual Custtomers over the  Year'; 
ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.BIKES;
	vbar mnth / response=casual group=year groupdisplay=cluster;
	yaxis grid;
run;

ods graphics / reset;

*/
title 'Working Day By Rental ';
ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.BIKES;
	vbar workingday / response=cnt group=year groupdisplay=cluster ;
	yaxis grid;
run;

title 'HolyDay By Rental ';
ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.BIKES;
	vbar holiday / response=cnt group=year groupdisplay=cluster;
	yaxis grid;
run;

title'Average of Rentals By Working Day';
ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.BIKES;
	vbar weekday / response=cnt stat=mean;
	xaxis grid;
run;

ods graphics / reset;





title 'Growth of Rentals By Month';
 

/* Compute axis ranges */
proc means data=WORK.BIKES noprint;
	class mnth / order=data;
	var registered casual;
	output out=_BarLine_(where=(_type_ > 0)) sum(registered casual)=resp1 resp2;
run;

/* Compute response min and max values (include 0 in computations) */
data _null_;
	retain respmin 0 respmax 0;
	retain respmin1 0 respmax1 0 respmin2 0 respmax2 0;
	set _BarLine_ end=last;
	respmin1=min(respmin1, resp1);
	respmin2=min(respmin2, resp2);
	respmax1=max(respmax1, resp1);
	respmax2=max(respmax2, resp2);

	if last then
		do;
			call symputx ("respmin1", respmin1);
			call symputx ("respmax1", respmax1);
			call symputx ("respmin2", respmin2);
			call symputx ("respmax2", respmax2);
			call symputx ("respmin", min(respmin1, respmin2));
			call symputx ("respmax", max(respmax1, respmax2));
		end;
run;

/* Define a macro for offset */
%macro offset ();
	%if %sysevalf(&respmin eq 0) %then
		%do;
			offsetmin=0 %end;

	%if %sysevalf(&respmax eq 0) %then
		%do;
			offsetmax=0 %end;
%mend offset;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.BIKES nocycleattrs;
	vbar mnth / response=registered stat=sum;
	vline mnth / response=casual stat=sum y2axis;
	yaxis grid min=&respmin1 max=&respmax1 %offset();
	y2axis min=&respmin2 max=&respmax2 %offset();
	keylegend / location=outside;
run;

ods graphics / reset;

proc datasets library=WORK noprint;
	delete _BarLine_;
	run;

title 'Temperature by REntal Count';
ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.BIKES;
	scatter x=temp y=cnt /  group=year;;
	xaxis grid;
	yaxis grid;
run;

ods graphics / reset;
title 'Windspeed By Rental Count';
ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.BIKES;
	scatter x=windspeed y=cnt / group=year;;
	xaxis grid;
	yaxis grid;
run;

ods graphics / reset;

title 'Humidity by REntal Count';
ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.BIKES;
	scatter x=hum y=cnt  / group=year;;
	xaxis grid;
	yaxis grid;
run;

ods graphics / reset;

title 'weather By Rentals';
/* Compute axis ranges */
proc means data=WORK.BIKES noprint;
	class weather / order=data;
	var registered casual;
	output out=_BarLine_(where=(_type_ > 0)) sum(registered casual)=resp1 resp2;
run;

/* Compute response min and max values (include 0 in computations) */
data _null_;
	retain respmin 0 respmax 0;
	retain respmin1 0 respmax1 0 respmin2 0 respmax2 0;
	set _BarLine_ end=last;
	respmin1=min(respmin1, resp1);
	respmin2=min(respmin2, resp2);
	respmax1=max(respmax1, resp1);
	respmax2=max(respmax2, resp2);

	if last then
		do;
			call symputx ("respmin1", respmin1);
			call symputx ("respmax1", respmax1);
			call symputx ("respmin2", respmin2);
			call symputx ("respmax2", respmax2);
			call symputx ("respmin", min(respmin1, respmin2));
			call symputx ("respmax", max(respmax1, respmax2));
		end;
run;

/* Define a macro for offset */
%macro offset ();
	%if %sysevalf(&respmin eq 0) %then
		%do;
			offsetmin=0 %end;

	%if %sysevalf(&respmax eq 0) %then
		%do;
			offsetmax=0 %end;
%mend offset;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgplot data=WORK.BIKES nocycleattrs;
	vbar weather / response=registered stat=sum;
	vline weather / response=casual stat=sum y2axis;
	yaxis grid min=&respmin1 max=&respmax1 %offset();
	y2axis min=&respmin2 max=&respmax2 %offset();
	keylegend / location=outside;
run;

ods graphics / reset;

proc datasets library=WORK noprint;
	delete _BarLine_;
	run;
/*.    start here please*/



