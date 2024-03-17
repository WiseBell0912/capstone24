function t = fun_eq2latex(f,copyOpt)
%EQ2LATEX Convert an equation to latex form.
%  t = eq2latex(f,copyOpt) converts a matlab symbolic equation to latex form
%  and write it on a figure window to aid visual inspection of syntax or 
%  user errors of a matlab equation.
%
%  t returns a text object.
%  f should be a symbolic expression defined correctly using sym or syms.
%  If copyOpt=='copy', the latex string is copied to clipboard and you can
%  paste an external app such as mathtype.
%
%  Developer: lazymatlabber
%       https://www.facebook.com/lazymatlabber/
%       https://lazymatlab.tistory.com/
%
%  2018.12.27. First release
%  2019.12.01. Copy option added
%
%  Refs.
%  https://kr.mathworks.com/help/symbolic/sym.latex.html
%  https://kr.mathworks.com/help/matlab/ref/text.html
%  https://lazymatlab.tistory.com/30

narginchk(0,2);

if nargin==0
    % for test
    syms a b x
    f = 4*a*b*tan(x/2)/(a-1)/(a+1)^2/((a+1)*(tan(x/2))^2+a-1);
end

if nargin>0
    if ~isa(f,'sym'), error('Invalid type of input expression'); end
end

figure, axis off, axis([-1 1 -1 1])
t = text(0,0,['$' latex(f) '$'],'fontsize',32,'Interpreter','latex');
width = t.Extent(3);
t.Position(1) = -width/2;

if nargin==2
    clipboard(copyOpt,t.String);
end

return