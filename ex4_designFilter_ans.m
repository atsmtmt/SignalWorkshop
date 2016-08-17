%%
edit ex3_spectrum_ans
ex3_spectrum_ans

%%

%% �s�[�N���o
% �n�E�����O�m�C�Y�̎��g���𑪒肷�邽�߂ɃX�y�N�g���̃s�[�N��
% ���o���ăv���b�g����B�X�y�N�g����͂ɂ�������g������\�́AFFT�_����
% �ˑ�����̂ŁA�����ő��肳�ꂽ�s�[�N���g���͂�����x�̌덷���܂ށB
figure(2)
[Pks,Locs]=findpeaks(20*log10(s2),'NPeaks',10,'Sortstr','descend'); % dB
peak_freq = f1(Locs)
subplot(3,1,2)
hold on
plot(peak_freq,Pks,'ro')
hold off

%% GUI�Ńt�B���^�݌v
% ���̃p�����[�^�Ńt�B���^�݌v
% �����^�C�v �m�b�` 2��
% Fs: 22050
% Fnotch: peak_freq(1) = 2842.4
% Q: 2
filterbuilder

%% �t�@���N�V����MATLAB�t�@�C���Ńt�B���^�݌v
% filterbuilder����t�B���^�݌v�pMATLAB�t�@�C�����G�N�X�|�[�g���Ďg�p���܂��B
Hd1 = getFilter_ans1
Hd2 = getFilter_ans2
Hd = cascade(Hd1, Hd2)   % �J�X�P�[�h�ڑ�
hfv = fvtool(Hd,'Fs',Fs)

%% �݌v�����t�B���^��K�p
% �m�b�`�t�B���^���m�C�Y�M���ɓK�p���A�n�E�����O�m�C�Y���������܂��B
denoise_sig = filter(Hd, n_sig);

%% �m�C�Y�����������M���̎��g������
% �m�C�Y���������ꂽ���Ƃ����g���X�y�N�g����\�����Ċm�F���܂��B
figure(2)
subplot(3,1,1)
hold on
[s1, f1] = periodogram(denoise_sig, hamming(length(denoise_sig)), length(denoise_sig), Fs);
plot(f1, 20*log10(s1), 'm')

subplot(3,1,2)
hold on
[s2, f1] = pmcov(denoise_sig, 16, 512, Fs);
plot(f1, 20*log10(s2), 'm')

subplot(3,1,3)
hold off
spectrogram(denoise_sig,hamming(512),256,512,Fs);
title('�X�y�N�g���O����'),xlabel('���g���iHz�j'),ylabel('���ԁisec�j')

%% �����t�@�C���̍Đ�
sound(denoise_sig,Fs)

%% �����t�@�C���̕ۑ�
audiowrite('denoise.wav', denoise_sig,Fs)
dlmwrite('denoise.txt',denoise_sig,'precision','%.10f','delimiter','\n')

