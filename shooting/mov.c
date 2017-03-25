#include <math.h>
#include "mex.h"


double constrainAngle(double x)
{
    x = fmod(x + 180,360);
    if (x < 0)
        x += 360;
    return x - 180;
}

void mover(double dt, double Pr[], double Pt[], double Pb[], double Vcxr,double Vcyr, double Vtheta, double Vxrmax, double Vyrmax, double Vthetamax, double Vb, double dirbi, double Fr, double ran[], double Pro[], double Ptr[], double Pbr[], double alfa[], double fi[], double gama[], double ro[], double Vbo[], double dirbo[], double Pbo[])
{ 
	double pii=3.14159265358979323846;
	double Vxr;
	double Vyr;
	double bet;
	double mp;
	double dp1;
    double beta;
    
	mp=dirbi*pii/180;
	Pb[0]=Pb[0]+cos(dirbi*pii/180)*Vb*dt;
	Pb[1]=Pb[1]+sin(dirbi*pii/180)*Vb*dt;
	if (pow(Vb,2)-(Vb*2*Fr*dt)>0){
	Vbo[0]=pow((pow(Vb,2)-(Vb*2*Fr*dt)),0.5);}
	else
	{Vbo[0]=0;}
	dirbo[0]=dirbi;
	
	if (fabs(Vcyr)>1000)
	{Vxr=(fabs(Vcxr)/Vcxr)* ( fabs(Vcxr) + 0.1459*fabs(Vcyr) + 0.0669*(fabs(Vcxr)/fabs(Vcyr)) - 0.0028*(fabs(Vcxr)*fabs(Vcyr)) );}
	else
	{Vxr=Vcxr;}
	if (fabs(Vcxr)>1000)
	{Vyr=(fabs(Vcyr)/Vcyr)* ( 0.5686*fabs(Vcyr) + 5.2228*(fabs(Vcyr)/fabs(Vcxr)) - 0.0005*pow(Vcxr,2) );}
	else
	{Vyr=Vcyr;}
	
	Pro[0]=Pr[0] + cos(Pr[2]*pii/180)*(Vxr*Vxrmax/100)*dt + cos( (Pr[2]+90)*pii/180 )*(Vyr*Vyrmax/100)*dt;
	Pro[1]=Pr[1] + sin(Pr[2]*pii/180)*(Vxr*Vxrmax/100)*dt + sin( (Pr[2]+90)*pii/180 )*(Vyr*Vyrmax/100)*dt;
	Pro[2]=Pr[2] + (Vtheta*Vthetamax/100)*dt;
	Ptr[0]=((Pt[0]-Pro[0])*cos(Pro[2]*pii/180)) + ((Pt[1]-Pro[1])*sin(Pro[2]*pii/180));
	Ptr[1]=((Pt[0]-Pro[0])*cos((Pro[2]+90)*pii/180)) + ((Pt[1]-Pro[1])*sin((Pro[2]+90)*pii/180));
	Pbr[0]=((Pb[0]-Pro[0])*cos(Pro[2]*pii/180)) + ((Pb[1]-Pro[1])*sin(Pro[2]*pii/180));
	Pbr[1]=((Pb[0]-Pro[0])*cos((Pro[2]+90)*pii/180)) + ((Pb[1]-Pro[1])*sin((Pro[2]+90)*pii/180));
	alfa[0]=atan2(Ptr[1],Ptr[0])*180/pii;
	bet= (Ptr[0]*(Ptr[0]-Pbr[0]) + Ptr[1]*(Ptr[1]-Pbr[1]))/( (pow(pow(Ptr[0],2) + pow(Ptr[1],2),0.5)) * (pow(pow((Pbr[0]-Ptr[0]),2) + pow((Pbr[1]-Ptr[1]),2),0.5)) );
	if (bet>1)
	{bet=1;}
	if (bet<-1)
	{bet=-1;}

	beta=acos(bet)*180/pii;
	gama[0]=atan2(Pbr[1],Pbr[0])*180/pii;
	if (atan2(Pbr[1],Pbr[0]) < atan2(Ptr[1],Ptr[0]))
	{beta=-beta;}
	ro[0]=pow((pow(Pbr[0],2)+pow(Pbr[1],2) ),0.5);
    fi[0] = alfa[0]-beta-gama[0];

	if (ro[0]<50)	{
        //dirbo[0]=20*ran[0] + atan2((Pb[1]-Pro[1]),(Pb[0]-Pro[0]))*180/pii;
        //Vbo[0]=                                 (570.46+78.24*ran[1])   *cos( (dirbi*pii/180-(atan2(Vyr*Vyrmax,Vxr*Vxrmax) + Pr[2]*pii/180)) ) *( pow(( pow(Vxr*Vxrmax/100,2) + pow(Vyr*Vyrmax/100,2)),0.5) )/Vxrmax;
        //Vbo[0]=( 10*(pow(pow(Vyr,2) +pow(Vxr,2) ,0.5)) +78.24*ran[1])   *cos( (dirbi*pii/180-(atan2(Vyr*Vyrmax,Vxr*Vxrmax) + Pr[2]*pii/180)) ) *( pow(( pow(Vxr*Vxrmax/100,2) + pow(Vyr*Vyrmax/100,2)),0.5) )/Vxrmax;
        dirbo[0] = 20*ran[0] + atan2((Pb[1]-Pro[1]),(Pb[0]-Pro[0]))*180/pii;
        Vbo[0] = ( 5 *(pow(pow(Vyr,2) +pow(Vxr,2) ,0.5)) +78.24*ran[1])   *cos( (dirbi*pii/180-(atan2(Vyr*Vyrmax,Vxr*Vxrmax) + Pr[2]*pii/180)) ) *( pow(( pow(Vxr*Vxrmax/100,2) + pow(Vyr*Vyrmax/100,2)),0.5) )/Vxrmax;
        if (Vbo[0]<0)
        {Vbo[0]=0;}
    }

	Pbo[0]=Pb[0];
	Pbo[1]=Pb[1];
    
    fi[0]=constrainAngle(fi[0]);
    gama[0]=constrainAngle(gama[0]);
    alfa[0]=constrainAngle(alfa[0]);
    //constrainAngle(dirbo[0]);
    //constrainAngle(Pr[2]);
    

}



void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	double dt, *Pr, *Pt, *Pb, Vcxr, Vcyr, Vtheta, Vxrmax, Vyrmax, Vthetamax, Vb, dirbi, Fr, *ran;
	int  nd, ni, nr;
	double *Pro, *Ptr, *Pbr, *alfa, *fi, *gama, *ro, *Vbo, *dirbo, *Pbo;


	plhs[0] = mxCreateDoubleMatrix ( 3, 1, mxREAL );
	plhs[1] = mxCreateDoubleMatrix ( 2, 1, mxREAL );
	plhs[2] = mxCreateDoubleMatrix ( 2, 1, mxREAL );
	plhs[3] = mxCreateDoubleMatrix ( 1, 1, mxREAL );
	plhs[4] = mxCreateDoubleMatrix ( 1, 1, mxREAL );
	plhs[5] = mxCreateDoubleMatrix ( 1, 1, mxREAL );
	plhs[6] = mxCreateDoubleMatrix ( 1, 1, mxREAL );
	plhs[7] = mxCreateDoubleMatrix ( 1, 1, mxREAL );
	plhs[8] = mxCreateDoubleMatrix ( 1, 1, mxREAL );
	plhs[9] = mxCreateDoubleMatrix ( 2, 1, mxREAL );	

	dt=mxGetScalar ( prhs[0] );
	Pr=mxGetPr(prhs[1]);
	Pt=mxGetPr(prhs[2]);
	Pb=mxGetPr(prhs[3]);
	Vcxr=mxGetScalar ( prhs[4] );
	Vcyr=mxGetScalar ( prhs[5] );
	Vtheta=mxGetScalar ( prhs[6] );
	Vxrmax=mxGetScalar ( prhs[7] );
	Vyrmax=mxGetScalar ( prhs[8] );
	Vthetamax=mxGetScalar ( prhs[9] );
	Vb=mxGetScalar ( prhs[10] );
	dirbi=mxGetScalar ( prhs[11] );
	Fr=mxGetScalar ( prhs[12] );
	ran=mxGetPr(prhs[13]);

	Pro=mxGetPr(plhs[0]);
	Ptr=mxGetPr(plhs[1]);
	Pbr=mxGetPr(plhs[2]);	
	alfa=mxGetPr(plhs[3]);
	fi=mxGetPr(plhs[4]);
	gama=mxGetPr(plhs[5]);
	ro=mxGetPr(plhs[6]);
	Vbo=mxGetPr(plhs[7]);
	dirbo=mxGetPr(plhs[8]);
	Pbo=mxGetPr(plhs[9]);

	mover(dt,Pr,Pt,Pb,Vcxr,Vcyr,Vtheta,Vxrmax,Vyrmax,Vthetamax,Vb,dirbi,Fr,ran,Pro,Ptr,Pbr,alfa,fi,gama,ro,Vbo,dirbo,Pbo);

}
