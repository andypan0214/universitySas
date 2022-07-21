data enjoyUMD;
	/*for this data we collected 51 data sets
	to estimate do experience of school life affect by age in UMD  */
	/*input variables
	age: age of each sample in year
	grade: grade in umd =>freshman, sophomore, junior or senior
	credit: how many credit each sample take this smester
	enjoy: do each sample enojoy life in UMD
	improve: what field could improve to help each sample enojoy more
	*/
	input age 1-3 grade	$	4-13 credit 14-16 study 16-18 enjoy	$	19-22 
		improve	$	23-38;

	/*datalines: samples details
	there are 51 samples with 3 numeric values and 3 charateristic values
	*/
	datalines;
21    junior 15  3 ok pendamic
20 sophomore 20 20yes food_option
21    senior 20  5 ok activity
23    senior 12  5yes transportation
22    senior 12 50yes food_option
20 sophomore 12  6yes greenfield
18  freshman 16 20yes less_retrict
20 sophomore 12 35 no on_campus
21    senior  6 10yes class_size
19 sophomore 18  6 no on_campus
21    junior 15 20 no less_work
19 sophomore 19 20 no on_campus
27    senior 12 20 ok no_idea
19 sophomore 16  2yes transportation
23    senior  6 20yes transportation
21    junior 11 20yes less_retrict
22    junior 16  4 no on_campus
20 sophomore 16 30 no on_campus
21    senior 18 10yes transportation
19 sophomore 18  6 no on_campus
19  freshman 16  8yes activity
21    junior 15 20 no less_work
20 sophomore 15  8 no on_campus
19  freshman 15 24yes activity
20    junior 15  3yes less_contruction
19 sophomore 17 15yes less_contruction
22    senior 10 15yes less_retrict
20 sophomore 19  4yes on_campus
22    junior 12  8 no on_campus
22 sophomore  0 40yes food_option
20 sophomore 13 15 no activity
19    junior 15 40yes less_retrict
22    senior 15  4yes activity
21    senior 12  5 ok no_idea
21    junior 12 10yes less_retrict
22    senior 15 15 no transportation
21    senior 16 20yes pendamic
21    junior 16 30 no class_size
20 sophomore 17 20yes greenfield
22    senior 15  4yes activity
18  freshman 17 15yes on_campus
19 sophomore 16 20yes transportation
21    junior 18 25 no pendamic
25    senior 15 20yes transportation
18  freshman 18 20 ok greenfield
22    senior 16 10yes food_option
22    senior 16 15yes transportation
21    junior 12 10yes activity
21    junior 18 20 no less_work
20 sophomore 18 25 no less_work
22    senior 15 20yes less_contruction
;
	/*updated data for regression calcuation  */
	/* there are 32 samples after deleted several outlier*/
data newEnjoy;
	/*input datas variable are the same as orignal datas*/
	/*input variables
	age: age of each sample in year
	grade: grade in umd =>freshman, sophomore, junior or senior
	credit: how many credit each sample take this smester
	enjoy: do each sample enojoy life in UMD
	improve: what field could improve to help each sample enojoy more
	*/
	input age 1-3 grade	$	4-13 credit 14-16 study 16-18 enjoy	$	19-22 
		improve	$	23-38;

	/*datalines: samples details
	there are 32 samples with 3 numeric values and 3 charateristic values
	*/
	datalines;
21    junior 15  3 ok pendamic
20 sophomore 20 20yes food_option
22    senior 12 50yes food_option
20 sophomore 12 35 no on_campus
19 sophomore 18  6 no on_campus
21    junior 15 20 no less_work
19 sophomore 19 20 no on_campus
19 sophomore 16  2yes transportation
23    senior  6 20yes transportation
21    junior 11 20yes less_retrict
20 sophomore 16 30 no on_campus
21    senior 18 10yes transportation
19 sophomore 18  6 no on_campus
19  freshman 16  8yes activity
21    junior 15 20 no less_work
20 sophomore 15  8 no on_campus
20    junior 15  3yes less_contruction
19 sophomore 17 15yes less_contruction
22    senior 10 15yes less_retrict
20 sophomore 19  4yes on_campus
22    junior 12  8 no on_campus
20 sophomore 13 15 no activity
21    senior 12  5 ok no_idea
21    junior 12 10yes less_retrict
21    senior 16 20yes pendamic
21    junior 16 30 no class_size
20 sophomore 17 20yes greenfield
19 sophomore 16 20yes transportation
21    junior 18 25 no pendamic
21    junior 12 10yes activity
21    junior 18 20 no less_work
20 sophomore 18 25 no less_work
;
run;

/*proc print generate datas in result window for view  */
proc print data=newEnjoy;
run;

/*proc freq generate frequency table for charateristic variables  */
proc freq data=newEnjoy;
	tables grade enjoy improve /nocum;
run;

/*proc univariate generate histogram for numeric varibals  */
proc univariate data=newEnjoy noprint;
	histogram age credit study;
run;


/* proc means generate mean median standard deviation
Interquartile Range maximum and minimum of 2 decimal place
for each numerical varibals*/
proc means data=newEnjoy mean median std Qrange max min maxdec=2;
	var age credit study;
run;

/*create new data for creating dummy variables  */
data charaterToNumeric;
	set newEnjoy;
/*set freshman as reference variable 	 */
	if grade = 'freshman' then do;
	g1=0; g2=0; g3=0;
	end;
	else if grade= 'sophomore' then do;
	g1=1; g2=0; g3=0;
	end;
	else if grade= 'junior' then do;
	g1=0; g2=1; g3=0;
	end;
	else if grade= 'senior' then do;
	g1=0; g2=0; g3=1;
	end;
run;

/*proc corr testify the corraltion of each numeric variable */
proc corr data=newEnjoy;
	var age credit study;
run;

/*proc sgplot provided scatter plot and regression line  */
/*this sgplot focused on relationship between age and credit */
proc sgplot data=newEnjoy;
	reg y=age x=credit;
run;

/*proc sgplot provided scatter plot and regression line  */
/*this sgplot focused on relationship between age and hours of study */
proc sgplot data=newEnjoy;
	reg y=age x=study;
run;

/*proc reg help generate regression equation and observe anova result  */
proc reg data=charaterToNumeric;
	model age=credit study;
	model age= credit g1 g2 g3 ;
run;
