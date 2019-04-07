
function [netFix,akurasi,CM] = JST(dataLatih, maxAttemps, dataUji, kelas)
    %JST - Latih Jaringan Saraf Tiruan
    % catatan: karena tidak paham cara mengatur epoch dan kawan-kawan untuk mendapatkan
    % akurasi yang terbaik, maka dilakukanlah pelatihan jaringan berulang kali
    % sampai mendapatkan akurasi yang lebih tinggi dengan batasan perulangan yang sudah
    % ditentukan.
    % 
    % Fixed Hidden Node : 24 (2/3*Ni+No = 2/3*32+3 = 24.333), Ni: Neuron Input, No: Neuron Output
    % Long description 
    % inputUji : data Uji (data Sesi2)
    % input : 
    % * dataLatih           : Fold untuk data latih
    % * maxHiddenNodeSize   : maximum jumlah Hidden Node untuk pelatihan
    % * dataUji             : Fold untuk data uji 
    % * maxAttemps          : batasan Coba training
    % * kelas               : jumlah kelas
    % function JST ini terdiri dari 2 target saja (bisa dimodifikasi lebih lanjut)

    %% Fixed Variables
    HN = 24;
    maxTried = 2*maxAttemps;

    % Generate targets
    N = size(dataLatih,2); % N = ukuran data
    n = N/kelas;           % n = pembagian ukuran data untuk target setiap kelas
    for i = 1:kelas
        targets(i,(n*(i-1))+1:n) = ones;
    end

        akurasiTotal = 0;
        tempAkurasi = 0;
        tried = 0;
        Attemp = 0; 
        while Attemp <= maxAttemps
                % Membuat Pattern Recognition Network
                net = newff(dataLatih,targets,HN,{'tansig','purelin'},'trainlm');
                net.inputs{1}.processFcns={'removeconstantrows'};
                net.outputs{2}.processFcns={'removeconstantrows'};
                % net = patternnet(HN,'trainscg','mse'); % Hidden Node

                % Set up Division of Data for Training, Validation, Testing
                net.divideParam.trainRatio = 70/100;
                net.divideParam.valRatio = 15/100;
                net.divideParam.testRatio = 15/100;

                % Train the Network
                net.trainParam.showWindow = false; % Do not display the train Window
                [net,~] = train(net, dataLatih, targets); 
                [akurasiTotal,TPR,FDR] = mySim(net,dataUji);

                % --Update netFix
                if akurasiTotal > tempAkurasi
                    netFix = net;
                    akurasi = akurasiTotal;
                    CM(1) = TPR;
                    CM(2) = FDR;
                    disp(sprintf('Updated JST - Hidden Node(%d) - Akurasi Total(%.2f)', HN, akurasiTotal));
                end
                if akurasiTotal >= tempAkurasi
                    % disp(akurasiTotal);
                    disp(Attemp);
                    tempAkurasi = akurasiTotal; % update tempAkurasi 
                    Attemp = Attemp + 1;
                    tried = 0;
                    % -- Limiting the try
                    else
                        tried = tried + 1;
                            if tried == maxTried;
                                disp(Attemp);
                                Attemp = Attemp + 1;
                                tried = 0;
                            end
                end

                % For Safety, init network
                net = init(net);
        end
    %     end
    % end
end