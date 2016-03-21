function [p,e,t,u,l,c,a,f,d,b,g] = getpetuc
%GETPETUC Get p,e,t,u, and c.

pde_fig=findobj(allchild(0),'flat','Tag','PDETool');

if isempty(pde_fig)
error('PDE Toolbox GUI not active.')
end

u = get(findobj(pde_fig,'Tag','PDEPlotMenu'),'UserData');
l =get(findobj(pde_fig,'Tag','winmenu'),'UserData');
h=findobj(get(pde_fig,'Children'),'flat','Tag','PDEMeshMenu');
hp=findobj(get(h,'Children'),'flat','Tag','PDEInitMesh');
he=findobj(get(h,'Children'),'flat','Tag','PDERefine');
ht=findobj(get(h,'Children'),'flat','Tag','PDEMeshParam');
p=get(hp,'UserData');
e=get(he,'UserData');
t=get(ht,'UserData');

params=get(findobj(get(pde_fig,'Children'),'flat','Tag','PDEPDEMenu'),...
'UserData');
ns=getuprop(pde_fig,'ncafd');
nc=ns(1); na=ns(2); nf=ns(3); nd=ns(4);
idxstart = 1;
idxstop = nc;
c=params(idxstart:idxstop,:);
idxstart = idxstart+nc;
idxstop = idxstop + na;
a=params(idxstart:idxstop,:);
idxstart = idxstart+nc;
idxstop = idxstop + nf;
f=params(idxstart:idxstop, :);
idxstart = idxstart+nf;
idxstop = idxstop + nd;
d=params(idxstart:idxstop,:);

hbound = findobj(get(pde_fig,'Children'),'flat','Tag','PDEBoundMenu');
g = get(hbound, 'userdata');
hb_cld = get(hbound, 'children');
b = get(hb_cld(7), 'userdata');

savefile = 'p.mat';
save(savefile, 'p');
savefile = 'u.mat';
save(savefile, 'u');