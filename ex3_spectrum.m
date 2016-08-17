%% �����M���̃n�E�����O�L�����Z��
% ���̃v���O�����ł́A�����M������Œ�t�B���^��p����
% �n�E�����O�m�C�Y���������܂��B
% ������
clear; close all

%% �n�E�����O���܂�WAV�t�@�C���̓ǂݍ���
% WAV�t�@�C�������[�h���Ď��Ԏ�������\�����܂��B
[n_sig,Fs] = audioread('voice_howling.wav');
t = (0:length(n_sig)-1)/Fs;
figure(1)
plot(t,n_sig),grid on
xlim([0 t(end)]),ylim([-1 1])
title('�����M��+�n�E�����O�̎��Ԏ�����'),xlabel('���ԁisec�j'),ylabel('�U��')

%% �����t�@�C���̍Đ�(���ʂɒ��Ӂj
sound(n_sig,Fs)

%% �m�C�Y�M���̎��g�������̕\��
% �������̃X�y�N�g����͎�@��p���Ď��g���X�y�N�g����\�����܂��B
% �C�������U�@�ł̃s�[�N�ƃX�y�N�g���O�����ň����g���̐M����
% �n�E�����O�m�C�Y���Ɣ��f�ł���B
figure(2)
subplot(3,1,1)
[s1, f1] = periodogram(n_sig, hamming(length(n_sig)), length(n_sig), Fs);
plot(f1, 20*log10(s1),'b'),grid
xlim([0 f1(end)])
title('Periodogram'),xlabel('���g���iHz�j'),ylabel('�p���[/���g���idB/Hz�j')

subplot(3,1,2)
[s2, f1] = ****(n_sig, ****, ****, ****);
plot(f1, 20*log10(s2),'b'),grid
xlim([0 f1(end)])
title(''),xlabel('���g���iHz�j'),ylabel('�p���[�idB�j')

subplot(3,1,3)
spectrogram(n_sig,hamming(512),256,512,Fs);
title('�X�y�N�g���O����'),xlabel('���g���iHz�j'),ylabel('���ԁisec�j')
set(gcf,'Position',[10 180 560 800])

