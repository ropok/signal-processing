function [dataLatih, dataUji] = KFOLD(data,k,kelas)
% KFold - Description
%  Splitting data berdasarkan K-Fold
% Syntax: [dataLatih, dataUji] = KFold(data,k, kelas)
%
% Long description


    [M,N] = size(data); % e.g [32,150] [baris,kolom]
    n = N/kelas; % e.g 150 / 3 = 50 (jumlah data per kelas)
    nk = n/k; % e.g 50 / 5 = 10 (jumlah data per kelas tiap fold)

    dataPre = [];
    for j = 1:kelas
        awal = (n*(j-1))+1;
        akhir = n*j;
        dataPre = vertcat(dataPre, data(:,awal:akhir));
    end

    %% Setiap fold
    for i = 1:k
        awal = (nk + (i-1)) + 1;
        akhir = nk * i;
        dataUjiPre = dataPre(:, awal:akhir);
        dataLatihPre = dataPre;
        dataLatihPre(:,awal:akhir) = [];

        dataLatih{i} = [];
        dataUji{i} = [];
        for k = 1:kelas
            awal = (M * (k-1)) + 1;
            akhir = M*k;
            dataUji{i} = horzcat(dataUji{i}, dataUjiPre(awal:akhir,:));
            dataLatih{i} = horzcat(dataLatih{i}, dataLatihPre(awal:akhir,:));
        end

    end 


end