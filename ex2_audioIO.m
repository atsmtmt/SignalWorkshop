% MATLAB基本機能でのオーディオI/O
% サンプルファイルのパス（パスの定義は不要）
% cd(fullfile([matlabroot '\toolbox\audio\samples']))
% C:\MATLAB\R2016a\toolbox\audio\samples
% MATLAB標準機能では2ch Stereoまで再生可能、ドライバは選択不可
[data, Fs] = audioread('RockDrums-44p1-stereo-11secs.mp3');
hap = audioplayer(data, Fs)      % オブジェクトの定義
play(hap)                        % 実行
% メソッドはmethods(hap)で取得できる

%% audioplayerの停止
stop(hap)
% stio(hap)
%% 録音
Nbit = 16;
Nch = 2;
har = audiorecorder(Fs, Nbit, Nch)
record(har)

%% audiorecorderの停止とデータの取得
stop(har)

%% 所望の時間の録音
recordblocking(har, 2)
rdata = getaudiodata(har);
t = (0:length(rdata)-1)/Fs;
plot(t, rdata)
shg
audiowrite('recordedData.wav', rdata, Fs)

%% Audio System Toolbox機能による録音
Fs = 44100;
Nch = 2;
rTime = 5;

%% 再生とストリーミングで可視化
hfR = dsp.AudioFileReader('RockGuitar-16-44p1-stereo-72secs.wav');
haOut = audioDeviceWriter('SampleRate', Fs);
htS = dsp.TimeScope('SampleRate', Fs, 'TimeSpan', 0.1, 'BufferLength', 50e4,...
    'YLimits', [-1 1], 'ShowGrid', 1)
tic;
while toc < rTime   % Stream
    temp2 = step(hfR);
    step(haOut, temp2);
    step(htS, temp2);
end
%% デバイスのリリース
release(hfR)
release(haOut)
release(htS)

%% 録音と可視化
% オーディオデバイスオブジェクトの定義
haIn = audioDeviceReader('SampleRate', Fs, 'NumChannels', Nch);
% haIn = audioDeviceReader('SampleRate', 44100, 'NumChannels', 2, 'Driver', 'ASIO')
hfW = dsp.AudioFileWriter('recordedData2.wav');
htS = dsp.TimeScope('SampleRate', Fs, 'TimeSpan', 0.1, 'BufferLength', 50e4,...
    'YLimits', [-0.5 0.5], 'ShowGrid', 1)
hlog = dsp.SignalSink;
%% 録音と表示
tic;
while toc < rTime   % Stream
    temp = step(haIn);
    step(hfW, temp);
    step(hlog, temp);
    step(htS, temp);
end
logdata = hlog.Buffer;
t = (0:length(logdata)-1)/haIn.SampleRate;
plot(t, logdata)

%% デバイスのリリース
release(haIn)
release(hfW)
release(htS)


