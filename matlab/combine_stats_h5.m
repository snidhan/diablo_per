clear
dir1='../run1/';
dir2='../run2/';
fname1=[dir1 'stats.h5'];
fname2=[dir2 'stats.h5'];
F={'/U1rms','/U2rms','/U3rms','/THrms','/THflux','/epsilon','/chi'};
nk1=h5readatt(fname1,F{1},'Samples');
nk2=h5readatt(fname2,F{1},'Samples');

f = waitbar(0,'Initializing...','Name','Combining bulk statistics');

for n=1:(nk2-1)
    for i=1:length(F)
        if n<10
            dname=[F{i} '/000' int2str(n)];
        elseif n<100
            dname=[F{i} '/00' int2str(n)];
        elseif n<1000
            dname=[F{i} '/0' int2str(n)];
        else
            dname=[F{i} '/' int2str(n)];
        end
        G=h5read(fname2,dname);
        Time=h5readatt(fname2,dname,'Time');
        Timestep=h5readatt(fname2,dname,'Timestep');
        k=n+nk1-1;
        if i==1
            waitbar(double(n)/double(nk2-1),f,['Writing data entry ' int2str(k)]);
        end
        if k<10
            dname=[F{i} '/000' int2str(k)];
        elseif k<100
            dname=[F{i} '/00' int2str(k)];
        elseif k<1000
            dname=[F{i} '/0' int2str(k)];
        else
            dname=[F{i} '/' int2str(k)];
        end
        h5create(fname1,dname,[1 1]);
        h5write(fname1,dname,G);
        h5writeatt(fname1,dname,'Time',Time);
        h5writeatt(fname1,dname,'Timestep',Timestep);
        if n==nk2-1
            h5writeatt(fname1,dname(1:end-5),'Samples',k+1);
        end
    end
end
delete(f);