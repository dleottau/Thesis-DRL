<<<<<<< HEAD
function [f,b,rul] = efbd(x,q,cores)

%funci�n para calcular una EBDF de M t�rminos
% x vector de n entradas
% y vector de m centros
% med matriz con medias de las funciones de base difusas gaussianas
% dev matriz con desviaciones est�ndar de las funciones de base difusa gaussianas

m1=cores.mean.x;
m2=cores.mean.xp;
s1=cores.std.x;
s2=cores.std.xp;

D1=length(m1);
D2=length(m2);
%ND=length(x);
%R=length(q);


rul=zeros(D1*D2,1);
index=1;
for i=1:D1    
for j=1:D2
    f1 = exp((-0.5*(x(1)-m1(i))^2)/(s1(i)^2));
    f2 = exp((-0.5*(x(2)-m2(j))^2)/(s2(j)^2));
    rul(index,1)=f1*f2;
    index=index+1;
end
end

b=sum(rul);
a=sum(rul.*q);
f=a/b;
=======
function [f,b,rul] = efbd(x,q,cores)

%funci�n para calcular una EBDF de M t�rminos
% x vector de n entradas
% y vector de m centros
% med matriz con medias de las funciones de base difusas gaussianas
% dev matriz con desviaciones est�ndar de las funciones de base difusa gaussianas

m1=cores.mean.x;
m2=cores.mean.xp;
s1=cores.std.x;
s2=cores.std.xp;

D1=length(m1);
D2=length(m2);
%ND=length(x);
%R=length(q);


rul=zeros(D1*D2,1);
index=1;
for i=1:D1    
for j=1:D2
    f1 = exp((-0.5*(x(1)-m1(i))^2)/(s1(i)^2));
    f2 = exp((-0.5*(x(2)-m2(j))^2)/(s2(j)^2));
    rul(index,1)=f1*f2;
    index=index+1;
end
end

b=sum(rul);
a=sum(rul.*q);
f=a/b;
>>>>>>> origin/thesis
