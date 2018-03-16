proc print a3D;
run;

Data a3;
INPUT brand$ scent$ soft$ oz$ pr$ s1 s2 s3 s4 s5;
Cards;
complete fresh n 48 4.99 1 3 3 2 2
complete fresh y 32 2.99 1 3 3 5 5
complete lemon n 32 2.99 1 2 7 5 1
complete lemon y 64 3.99 1 9 5 8 1
complete U n 64 3.99 1 9 7 8 7
complete U y 48 4.99 1 3 3 2 3
Smile fresh n 64 2.99 1 9 9 9 6
Smile fresh y 48 3.99 1 7 7 6 5
Smile lemon n 48 3.99 1 7 7 6 1
Smile lemon y 32 4.99 1 1 1 1 1
Smile U n 32 4.99 1 1 3 1 2
Smile U y 64 2.99 1 9 3 9 9
Wave fresh n 32 3.99 7 1 7 4 5
Wave fresh y 64 4.99 5 5 3 3 2
Wave lemon n 64 4.99 5 5 5 3 1
Wave lemon y 48 2.99 9 9 5 7 1
Wave U n 48 2.99 9 9 5 7 7
Wave U y 32 3.99 7 1 5 4 5
Wave lemon n 64 2.99 8 9 6 9 3
Smile lemon n 32 4.99 2 1 3 2 1
Smile fresh y 48 2.99 2 8 4 5 5
complete U y 32 2.99 2 4 2 5 6
complete lemon y 48 3.99 2 6 6 6 1
;

Data a3D; set a3;
if brand = 'complete' then br1 = 1; else br1 = 0;
if brand = 'Smile' then br2 = 1; else br2 = 0;
if scent = 'fresh' then sc1 = 1; else sc1 = 0;
if scent = 'lemon' then sc2 = 1; else sc2 = 0;
if soft = 'y' then sf1 = 1; else sf1 = 0;
if oz = '48' then oz1 = 1; else oz1 = 0;
if oz = '64' then oz2 = 1; else oz2 = 0;
if pr = '3.99' then pr1 = 1; else pr1 = 0;
if pr = '4.99' then pr2 = 1; else pr2 = 0;

/* Getting the coefficients */
PROC REG OUTEST= coeffs1  ;
MODEL s1-s5 = br1 br2 sc1 sc2 sf1 oz1 oz2 pr1 pr2;
RUN;

proc print data=coeffs1;
run;

data test;


proc iml; 
a =  { 1 0 -1, 0 1 -1, 1 1 1 };
brs = {};
use coeffs1; 
	do i = 1 to 5;
	if i = 1 then s = {"s1"}; 
	if i = 2 then s = {"s2"};
	if i = 3 then s = {"s3"};
	if i = 4 then s = {"s4"};
	if i = 5 then s = {"s5"};
	read all var {br1 br2} where (_DEPVAR_ = s) INTO ct;
	c = ct`;
	c = insert(c,{0},3,0);
	b1 = inv(a)*c;
	brs = brs || b1; 
	end;
close coeffs1;

end;
third = brs[,3];
max = max(of third[*]);
print max;
print brs;

proc iml;

end;

proc iml; 
a =  { 1 0 -1, 0 1 -1, 1 1 1 };
brs = {};
use coeffs1; 
	do i = 1 to 5;
	if i = 1 then s = {"s1"}; 
	if i = 2 then s = {"s2"};
	if i = 3 then s = {"s3"};
	if i = 4 then s = {"s4"};
	if i = 5 then s = {"s5"};
	read all var {sc1 sc2} where (_DEPVAR_ = 's1') INTO ct;
	c = ct`;
	c = insert(c,{0},3,0);
	scs1=inv(a)*c;
close coeffs1;

print scs1;

proc iml; 
a =  { 1 0 -1, 0 1 -1, 1 1 1 };
use coeffs1; 
read all var {oz1 oz2} where (_DEPVAR_ = 's1') INTO ct;
close coeffs1;
c = ct`;
c = insert(c,{0},3,0);
ozs1=inv(a)*c;
print ozs1;

proc iml; 
a =  { 1 0 -1, 0 1 -1, 1 1 1 };
use coeffs1; 
read all var {pr1 pr2} where (_DEPVAR_ = 's1') INTO ct;
close coeffs1;
c = ct`;
c = insert(c,{0},3,0);
prs1=inv(a)*c;
print prs1;

proc iml; 
a =  { 1 -1, 1 1 };
use coeffs1; 
read all var {sf1} where (_DEPVAR_ = 's1') INTO ct;
close coeffs1;
c = ct`;
c = insert(c,{0},2,0);
sfs1=inv(a)*c;
print sfs1;

