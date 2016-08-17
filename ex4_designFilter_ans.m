%%
edit ex3_spectrum_ans
ex3_spectrum_ans

%%

%% ピーク検出
% ハウリングノイズの周波数を測定するためにスペクトルのピークを
% 検出してプロットする。スペクトル解析における周波数分解能は、FFT点数に
% 依存するので、ここで測定されたピーク周波数はある程度の誤差を含む。
figure(2)
[Pks,Locs]=findpeaks(20*log10(s2),'NPeaks',10,'Sortstr','descend'); % dB
peak_freq = f1(Locs)
subplot(3,1,2)
hold on
plot(peak_freq,Pks,'ro')
hold off

%% GUIでフィルタ設計
% 次のパラメータでフィルタ設計
% 応答タイプ ノッチ 2次
% Fs: 22050
% Fnotch: peak_freq(1) = 2842.4
% Q: 2
filterbuilder

%% ファンクションMATLABファイルでフィルタ設計
% filterbuilderからフィルタ設計用MATLABファイルをエクスポートして使用します。
Hd1 = getFilter_ans1
Hd2 = getFilter_ans2
Hd = cascade(Hd1, Hd2)   % カスケード接続
hfv = fvtool(Hd,'Fs',Fs)

%% 設計したフィルタを適用
% ノッチフィルタをノイズ信号に適用し、ハウリングノイズを除去します。
denoise_sig = filter(Hd, n_sig);

%% ノイズを除去した信号の周波数応答
% ノイズが除去されたことを周波数スペクトルを表示して確認します。
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
title('スペクトログラム'),xlabel('周波数（Hz）'),ylabel('時間（sec）')

%% 音声ファイルの再生
sound(denoise_sig,Fs)

%% 音声ファイルの保存
audiowrite('denoise.wav', denoise_sig,Fs)
dlmwrite('denoise.txt',denoise_sig,'precision','%.10f','delimiter','\n')

