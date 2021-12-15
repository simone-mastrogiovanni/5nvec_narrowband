/* project Doppler_e (driver module)
   usa routines di JPL e di Novas */ 

 
 
#include <stdio.h>
#include <stdlib.h>
#include "novas.h"

#define N_STARS 1
#define N_TIMES 1

#ifndef PI
#define PI 3.1415926535      /* define PI */
#endif

 

 
void main()
{
	int       year=0,day=0,ic,iquanti=0;   
	short int error = 0;
	double    latitude=0,longitude=0,height=0/*(height,m)*/;
	double    ra=0 /*(alpha,hours)*/,dec=0 /*(delta,deg)*/;
    double    tsam=0,dotu=0,inday=0,zero=0.0;
	double    fmark=0,*fmark_e=&zero,*posid=&zero,*velod=&zero;

	 
		


/*  FK5 pseudocatalog data for the selected source. */
  
	fk5_entry stars = {"Examp SOU",0,ra,dec,0.0,0.0,0.0,1.0e-4,2.0};

 
/*
	The observer's terrestrial coordinates 
	( longitude,latitude, height of Virgo ).
*/

	site_info location = {latitude,longitude,height};

    

 			
//	printf("\nDoppler Effect correction for the Virgo detector\n: ");
//	printf("\nlambda = 43.67 deg, theta = 71 deg\n\n: ");
//	printf("\nStarting date (in days since 12pm 31st Dec 1899)? \n ");
///	printf("\n1 JAN 2000=36516? \n "); 
//	scanf("%d",&dotini); 
day=36516;
year  =1900 + (int) (day/365);				//useful to compute n. leap seconds
tsam=60;									//sampling time [s]
iquanti=(int) (86400 * 100 /tsam);			//n. of samples 100 days
tsam=tsam/86400.0;
inday=inday/86400.0;

stars.ra = 0.4;								//SOURCE ra  [h]
stars.dec =71.993;							//SOURCE dec [deg]

location.latitude= 71.0 ;					//DETECTOR geographic
location.longitude=43.76;
location.height=0.0;
 

fmark=50.;									//SOURCE marked frequency
 

	for(ic=1;ic<=iquanti;ic++){		
		dotu = day + inday +  tsam *ic ;  /*[days] */ 

 		Dopplerem(&stars,&location,dotu,year,fmark,fmark_e,posid,velod);
		printf("\n%15.9lf",*fmark_e);
    };

	exit (0);
	return;
}
///////////////////////////////////////////////

/*  C FUNCTIONS AND ROUTINES  */

/////////////////////////////////////////////////

   void Dopplerem(fk5_entry *stars,
	              site_info *location,
                  double dotu,
                  int year,
				  double fmark,
                  double *fmark_e,
				  double *posid,
				  double *velod)
   {
 
/* ==========================================================================
    The array 'JTDB' contains selected Julian date at which the
    star position will be evaluated, in the Solar System Barycenter.
    
now, since:  JUT1I = IJT+ (n leap_second)/86400  
             IJT   = initial Julian time [days]
             JUT1I = Julian UT1, initial [days], not defined in the code
then:        JTDT  = JUT1I + 32.184/86400


The list of leap_second is given in http://tycho.usno.navy.mil/leapsec.html 

=========================================================================== */
 
    double  local=0.0;
    double  pose[3],vele[3],poss[3],vels[3],posl[3],vell[3],posd[3],veld[3];
	double  rmod=0,posmod=0;
    double  IJT=0.0,JTDT=0.0,JTDB=0.0,g_bary=0.0,gst=0.0,lmst=0.0,scalar=0.0;
    double  agiorni=0;
    int i;
    short int body = 3; //Earth

    short int origin=0,nleap_sec=0;

    for(i=0;i<3;i++){
		posd[i]=0.0;
		veld[i]=0.0;
		posl[i]=0.0;
		vell[i]=0.0;
		pose[i]=0.0;
		vele[i]=0.0;
		poss[i]=0.0;
		vels[i]=0.0;

	};


    IJT=dotu+2415020.50; /* Julian Date corresponding to dotu, [days] */
	

 

	if(year==1991)agiorni=33236.0 ;

//	between 1 Jan 1988 and 1 Jan 1990  
	if((IJT>=2447161.5) && (IJT<2447892.5))nleap_sec=24;
 
//	between 1 Jan 1990 and 1 Jan 1991
	if((IJT>=2447892.5)&&(IJT<2448257.5)) nleap_sec=25;
 
//	between 1 Jan 1991 and 1 Jul 1992
	if((IJT>=2448257.5)&&(IJT<2448804.5)) nleap_sec=26;
	
//	between 1 Jul 1992 and 1 Jul 1993
	if((IJT>=2448804.5)&&(IJT<2449169.5)) nleap_sec=27;

//	between 1 Jul 1993 and 1 Jul 1994
	if((IJT>=2449169.5)&&(IJT<2449534.5)) nleap_sec=28;

//	between 1 Jul 1994 and 1 Jan 1996
	if((IJT>=2449534.5)&&(IJT<2450083.5)) nleap_sec=29;
 
//	between 1 Jul 1996 and 1 Jul 1997
	if((IJT>=2450083.5)&&(IJT<2450630.5))nleap_sec=30;

//	between 1 Jul 1997 and 1 Jan 1999
	if((IJT>=2450630.5)&&(IJT<2451179.5)) nleap_sec=31;

//	FROM 1 Jan 1999 on
	if(IJT>=2451179.5) nleap_sec=32;

// now time discontinuity reduction !!!!!!!!

	JTDT = IJT + (32.1840+ nleap_sec)/86400.0 ;
	
// !!!in realta' si dovrebbe passare da TDT a TJD, assunti qui uguali 
		                                      

// now JTDT => JTDB

	g_bary = (357.530 + 0.9856003*(JTDT-IJT/*2451545.0*/))*PI/180;
	JTDB    = JTDT +(0.0016580 * sin(g_bary) +
		        0.0000140 * sin(2*g_bary))/86400.0;

 
//now let's use solsysd2.c
//pos e vel passed by reference
 
	solarsystem(JTDB, body, origin, pose, vele) ; 

// pos[3] in AU
// vel[3] in AU/day


	for (i=0;i<=2;i++) {
		pose[i]=pose[i]*KMAU;		        // Center of Earth's pose[3] in km 
		vele[i]=vele[i]*KMAU/86400.0;	    // Center of Earth's vele[3] in km/s
		                                    // with respect co the SSB
	};
	
// printf("\n%12.5lf %12.5lf %12.5lf",pos[0],pos[1],pos[2]);
// printf("\n%12.5lf %12.5lf %12.5lf",vel[0],vel[1],vel[2]);

 	


/*
	calculation of distance and velocity of Virgo with respect 
	to the Earth's center 
*/

// IJT  approximates UT1, required by sideral_time() with 0.9 s/year (400m error) CHECK!!!!

	sidereal_time(IJT,0.0,1.0,&gst);

	lmst = gst + (location->longitude) * (PI/180)/(PI/12); // hours !
 
	if (lmst<0.0)lmst=lmst+24.0;
	if (lmst>24.0)lmst=lmst-24.0;

	
	terra (location,lmst,posl,vell);        //computes vector pos&vel 
	                                 

	for (i=0;i<=2;i++){
		posl[i]=posl[i]*KMAU;		    // Detector's posl[3] in km
		vell[i]=vell[i]*KMAU/86400.0;	// Detector's vell[3] in km/s
						                // with respect to the Earth's center		 
	};
 
	for (i=0;i<=2;i++){
		posd[i]   =pose[i]+posl[i];     // Detector's posd[3] in km
		*(posid+i)=	posd[i];            // position output pointer
		veld[i]=vele[i]+vell[i];        // Detector's veld[3] in km/s
		                 	            // with respect to the SSB
		*(velod+i)=	veld[i]/(C *KMAU/86400);// velocity output pointer
		                                    // expressed in units of C
			                            
	};
	

        
 /* calculation of the unit vector 
	pointing from the detector to the source */

	starvectors (stars,poss,vels);	


 	rmod    = sqrt(pow(poss[0],2)+pow(poss[1],2)+pow(poss[2],2));

	posmod  = sqrt(pow(posd[0],2) +pow(posd[1],2) +pow(posd[2],2));
	
	scalar = 1/rmod * (veld[0]*poss[0]+
	                   veld[1]*poss[1]+
	                   veld[2]*poss[2]);


 
	local  =  scalar / (C *KMAU/86400) ;
    *fmark_e = (fmark * (1+local));

}

