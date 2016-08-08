% nearazero.m
%
% $Id: nearzero.m,v 1.2 2006/04/22 15:48:38 jdlope Exp $

% Devuelve el valor normalizado si es lo suficientemente cercano a 0

function ret = nearzero(x)

  if abs(x) < 1e-8
    ret = 0;
  else
    ret = x;
  end
