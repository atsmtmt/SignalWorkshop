%% 音声信号のハウリングキャンセル
% このプログラムでは、音声信号から固定フィルタを用いて
% ハウリングノイズを除去します。
% 初期化
clear; close all

%% ハウリングを含むWAVファイルの読み込み
% WAVファイルをロードして時間軸応答を表示します。
[n_sig,Fs] = audioread('voice_howling.wav');
t = (0:length(n_sig)-1)/Fs;
figure(1)
plot(t,n_sig),grid on
xlim([0 t(end)]),ylim([-1 1])
title('音声信号+ハウリングの時間軸応答'),xlabel('時間（sec）'),ylabel('振幅')

%% 音声ファイルの再生(音量に注意）
sound(n_sig,Fs)

%% ノイズ信号の周波数応答の表示
% いくつかのスペクトル解析手法を用いて周波数スペクトルを表示します。
% 修正共分散法でのピークとスペクトログラムで一定周波数の信号が
% ハウリングノイズだと判断できる。
figure(2)
subplot(3,1,1)
[s1, f1] = periodogram(n_sig, hamming(length(n_sig)), length(n_sig), Fs);
plot(f1, 20*log10(s1),'b'),grid
xlim([0 f1(end)])
title('Periodogram'),xlabel('周波数（Hz）'),ylabel('パワー/周波数（dB/Hz）')

subplot(3,1,2)
[s2, f1] = ****(n_sig, ****, ****, ****);
plot(f1, 20*log10(s2),'b'),grid
xlim([0 f1(end)])
title(''),xlabel('周波数（Hz）'),ylabel('パワー（dB）')

subplot(3,1,3)
spectrogram(n_sig,hamming(512),256,512,Fs);
title('スペクトログラム'),xlabel('周波数（Hz）'),ylabel('時間（sec）')
set(gcf,'Position',[10 180 560 800])

