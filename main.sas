%web_drop_table(WORK.WINE);


FILENAME REFFILE '/home/u62791186/ATM_System/WhiteWineAnalysis/winequality_white.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.WINE;
	GETNAMES=YES;
	DELIMITER=';';
	DATAROW=2;
RUN;

proc sort data=wine out=no_dups_data nodupkey;
    by _all_;
run;

proc means data=work.wine nmiss n;
run;

title ' ';
proc sgplot data=WORK.WINE;
	vbar quality / datalabel stat=percent
	categoryorder=respdesc nostatlabel;
	yaxis grid;
run;

proc corr data=WORK.WINE pearson nosimple noprob plots=none;
	var 'residual sugar'n 'volatile acidity'n alcohol sulphates 'fixed acidity'n 
	    'citric acid'n chlorides 'free sulfur dioxide'n 'total sulfur dioxide'n
	    pH density;
	with quality;
run;


DATA WORK.WINE;
 ATTRIB quality_label LENGTH=$5;
 SET WORK.WINE;
 SELECT;
 WHEN (quality <= 5) quality_label = 'Bad';
 OTHERWISE quality_label = 'Good';
 END;


title ' ';
proc sgplot data=WORK.WINE;
	vbar quality_label / datalabel stat=percent
	categoryorder=respdesc nostatlabel;
	yaxis grid;
run;


title 'Relationship between quality label and alcohol';
proc sgplot data=WORK.WINE;
	vbox alcohol / category=quality_label;
	yaxis grid;
run;


title 'Relationship between quality label and sulphates';
proc sgplot data=WORK.WINE;
	vbox sulphates / category=quality_label;
	yaxis grid;
run;

title 'Relationship between quality label and pH';
proc sgplot data=WORK.WINE;
	vbox pH / category=quality_label;
	yaxis grid;
run;

title 'Quality label and density correlation';
proc sgplot data=WORK.WINE;
	vbox density / category=quality_label;
	yaxis grid;
run;


title 'Fixed acidity vs pH';
proc sgplot data=WORK.WINE;
	vbar quality_label / response=alcohol datalabel
	categoryorder=respdesc nostatlabel;
	yaxis grid;
run;

title 'Quality label vs sulphates';
proc sgplot data=WORK.WINE;
	vbar quality_label / response=sulphates datalabel
	categoryorder=respdesc nostatlabel;
	yaxis grid;
run;

title 'Quality label vs alcohol';
proc sgplot data=WORK.WINE;
	vbar quality_label / response=alcohol datalabel
	categoryorder=respdesc nostatlabel;
	yaxis grid;
run;

title 'Fixed acidity vs pH';
proc sgplot data=WORK.WINE;
	vbar quality_label / response='residual sugar'n datalabel
	categoryorder=respdesc nostatlabel;
	yaxis grid;
run;

title 'Relationship between alcohol and quality label';
proc sgplot data=WORK.WINE;
	scatter x=alcohol y=density / group=quality_label;
	xaxis grid;
	yaxis grid;
run;

title 'Relationship between alcohol and quality label';
proc sgplot data=WORK.WINE;
	scatter x=pH y='citric acid'n / group=quality_label;
	xaxis grid;
	yaxis grid;
run;

title 'Relationship between alcohol and pH';
proc sgplot data=WORK.WINE;
	scatter x=pH y=alcohol / group=quality_label;
	xaxis grid;
	yaxis grid;
run;

title 'Relationship between alcohol and sulphates';
proc sgplot data=WORK.WINE;
	scatter x=sulphates y=alcohol / group=quality_label;
	xaxis grid;
	yaxis grid;
run;
