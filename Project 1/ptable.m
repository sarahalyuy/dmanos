function[varargout] = ptable(varargin)
% When taking no arguments, produces 2 outputs: a graph of mass calculated
% by the semi-empirical formula and mass calculated by atomic weight vs.
% atomic number, and a graph of binding energy per nucleon vs. atomic
% number. When taking 1 numeric argument, produces 2 outputs: the mass of
% the element given by the formula, and a structure containing the
% element's information. When taking 2 numeric arguments, produces 2
% outputs: the mass of the isotope given by the formula, and whether it is
% stable. When taking 1 numeric argument and 1 character argument, produces
% 2 outputs: the mass of the element given by the formula, and the value
% within the field.

% import data and convert to table
pt = readtable('periodictabledata.csv');
% convert to structure
s = table2struct(pt);

% allow for variable number of inputs
if nargin == 0
    % define variable locations
    an = pt(2:end , 1);
    nuc = pt(2:end , 1);
    aw = pt(2:end , 4);
elseif nargin == 1
    an = varargin{1};
    nuc = an;
elseif nargin == 2 && isnumeric(varargin{2}) 
    an = varargin{1};
    nuc = varargin{2};
elseif nargin == 2 && ischar(varargin{2})
    an = varargin{1};
    field = varargin{2};
end

% define constants in MeV
mp = 938.28;
mn = 939.57;

% define coefficients in MeV
av = 15.8;
as = 18.3;
ac = .714;
aa = 23.3;
ap = 12;

% define variable delta
if rem(an,2) == 0 && rem(nuc,2) == 0
    d = 1;
elseif rem(nuc,2) ~= 0
    d = 0;
elseif rem(an,2) ~= 0 && rem(nuc,2) == 0
    d = -1;
end

% calculate binding energy per nucleon using semi-empirical formula
    function[eb] = semiempeng(av,nuc,as,ac,an,aa,ap,d)
    % takes constants, number of nucleons, atomic number, and variable
    % delta and returns binding energy
    eb = (av*nuc)-(as*nuc^(2/3))-((ac*(an(an-1)))/nuc^(1/3))-((aa*((nuc-2*an)^2)/nuc))+((ap/nuc^(1/2))*d);
    end
    
% calculate mass using semi-empirical formula
    function[ms] = semiempmass(nuc,mp,an,mn,eb)
    % takes number of nucleons, proton mass, atomic number, neutron mass,
    % and binding energy and returns mass
    ms = (nuc*mp)+((nuc-an)*mn)-(eb/1^2);
    end

% calculate mass using atomic weight
mw = aw;

% determine stablility of isotope
    function[stable] = stability(eb)
    % determines whether or not a function is stable using its binding
    % energy
    if eb > 0
        stable = 1;
    else
        stable = 0;
    end
    end
    
% allow for variable number of outputs
if nargin == 0
    varargout = 0;
    [eb] = semiempeng(av,nuc,as,ac,an,aa,ap,d);
    [ms] = semiempmass(nuc,mp,an,mn,eb);
    figure(1)
    plot(an,ms)
    title('mass vs. atomic number')
    xlabel('atomic number')
    ylabel('mass from equation (MeV)')
    hold on
    plot(an,mw)
    yylabel('mass from atomic weight (MeV)')
    legend('equation','atomic weight')
    hold off
    figure(3)
    plot(an,eb)
    title('binding energy per nucleon vs. atomic number')
    xlabel('atomic number')
    ylabel('binding energy (MeV)')
elseif nargin == 1
    [eb] = semiempeng(av,nuc,as,ac,an,aa,ap,d);
    [ms] = semiempmass(nuc,mp,an,mn,eb);
    varargout{1} = ms;
    info = s(an);
    varargout{2} = info;
elseif nargin == 2 && isnumeric(varargin{2})
    [eb] = semiempeng(av,nuc,as,ac,an,aa,ap,d);
    [ms] = semiempmass(nuc,mp,an,mn,eb);
    varargout{1} = ms;
    [eb] = semiempeng(av,nuc,as,ac,an,aa,ap,d);
    [stable] = stability(eb);
    varargout{2} = stable;
elseif nargin == 2 && ischar(varargin{2})
    [eb] = semiempeng(av,nuc,as,ac,an,aa,ap,d);
    [ms] = semiempmass(nuc,mp,an,mn,eb);
    varargout{1} = ms;
    value = s(an).field;
    varargout{2} = value;
end
end   