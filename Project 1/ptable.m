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

% define constants in MeV
mp = 938.28;
mn = 939.57;

% define coefficients in MeV
av = 15.8;
as = 18.3;
ac = .714;
aa = 23.3;
ap = 12;

% allow for variable number of inputs and outputs
if nargin == 0
    % define variable locations
    ant = pt(2:end , 1);
    nuct = pt(2:end , 1);
    awt = pt(2:end , 4);
    % convert tables to arrays for use in function
    an = table2array(ant);
    nuc = table2array(nuct);
    aw = table2array(awt);
    % find mass using atomic weight
    mw = aw;
    varargout = 0;
    [eb,ms] = semiemp(av,nuc,as,ac,an,aa,ap,mp,mn);
    figure(1)
    plot(an,ms)
    title('mass vs. atomic number')
    xlabel('atomic number')
    ylabel('mass from equation (MeV)')
    hold on
    plot(an,mw)
    yyaxis right
    ylabel('mass from atomic weight (MeV)')
    legend('equation','atomic weight')
    hold off
    figure(3)
    plot(an,eb)
    title('binding energy per nucleon vs. atomic number')
    xlabel('atomic number')
    ylabel('binding energy (MeV)')
elseif nargin == 1
    an = varargin{1};
    nuc = an;
    [~,ms] = semiemp(av,nuc,as,ac,an,aa,ap,mp,mn);
    varargout{1} = ms;
    info = s(an);
    varargout{2} = info;
elseif nargin == 2 && isnumeric(varargin{2})
    an = varargin{1};
    nuc = varargin{2};
    [eb,ms] = semiemp(av,nuc,as,ac,an,aa,ap,mp,mn);
    varargout{1} = ms;
    [stable] = stability(eb);
    varargout{2} = stable;
elseif nargin == 2 && ischar(varargin{2})
    an = varargin{1};
    nuc = an;
    field = varargin{2};
    [~,ms] = semiemp(av,nuc,as,ac,an,aa,ap,mp,mn);
    varargout{1} = ms;
    value = s(an).field;
    varargout{2} = value;
end

% calculate binding energy per nucleon and mass using semi-empirical
% formula
%%% big thanks to Tyler's code for help with this
    function[eb,ms] = semiemp(av,nuc,as,ac,an,aa,ap,mp,mn)
    % takes constants, number of nucleons, atomic number, proton mass,
    % neutron mass, and delta and returns binding energy and mass
    eb = (av.*nuc)-(as.*nuc.^(2/3))-((ac.*(an.*(an-1)))./nuc.^(1/3))-((aa.*((nuc-2.*an).^2)./nuc))+((ap./nuc.^(1/2)));
    for an = 1:112 %%% unfortunately still can't figure this part out
        %[~,R1] = quorem(an,2);
        %[~,R2] = quorem(nuc,2);
    % calculate delta term   
    if mod(an, 2) == 0
    if mod(nuc, 2) == 0
        eb = eb + ap/sqrt(an);
    else
        eb = eb - ap/sqrt(an);
    end
    end
    %if R1 == 0 & R2 == 0 %rem(an,2) == 0 & rem(nuc,2) == 0
    %d = 1;
    %elseif R2 ~= 0 %rem(nuc,2) ~= 0
    %d = 0;
    %elseif R1 ~= 0 & R2== 0 %rem(an,2) ~= 0 & rem(nuc,2) == 0
    %d = -1;
    %end
    % calculate binding energy per nucleon
    %eb = (av.*nuc)-(as.*nuc.^(2/3))-((ac.*(an.*(an-1)))./nuc.^(1/3))-((aa.*((nuc-2.*an).^2)./nuc))+((ap./nuc.^(1/2)));
    % calculate mass
    ms = (nuc.*mp)+((nuc-an).*mn)-(eb/1^2);
    end
    end

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
end   