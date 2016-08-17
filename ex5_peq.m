%% System Objectsによるシミュレーション
clear all, close all
audioFile = 'RockDrums-44p1-stereo-11secs.mp3';

%% UIの作成
screenSize = get(0,'ScreenSize');
figSize = [130 130];        % [X Y]
fg1 = figure('MenuBar','none','Toolbar','none',...
    'Name', 'Parametric EQ',...
    'Position',[10 screenSize(4)-figSize(2)-40 figSize(1) figSize(2)]);
% Stop Botton
stpBtn = true;
uicontrol('Style', 'pushbutton', 'String', 'Stop',...
    'Position', [20 20 100 40],'Callback', 'stpBtn = false;');

%% Objectの定義
hfr = dsp.AudioFileReader(audioFile, 'SamplesPerFrame', 128);	% Audio File Reader
hap = audioDeviceWriter('SampleRate', hfr.SampleRate);	% Audio Out
% hap.Driver = 'ASIO'
% hap.Device = 'UA-25EX'
hts = dsp.TimeScope('SampleRate',hfr.SampleRate, 'YLimits',[-1.5 1.5],...
    'TimeSpan', 0.2, 'ShowGrid', true);	% Time Scope
hts.LayoutDimensions = [2 1];   % 2軸表示
hts.NumInputPorts = 2;          % 2入力

%% Parametric EQの定義
heq = multibandParametricEQ(...
    'NumEQBands',3,...
    'SampleRate',hfr.SampleRate);

heq.Frequencies = [100,800,2.8e3]
heq.QualityFactors = [0.7,1,1]
heq.PeakGains = [4,-2,8]

visualize(heq)

%% ストリーミング処理
while ~isDone(hfr)&&(stpBtn)
	[tmp, eof]      = step(hfr);	% Read from audio file
	tmp = step(heq, 0.25*tmp);			% Param EQ
	step(hap, tmp);					% Player
    step(hts, tmp(:,1), tmp(:,2));  % 2ch Input
end
stpBtn = 1;

%% EQ特性の変更
heq.Frequencies = [20,800,6.2e3]
heq.QualityFactors = [0.2,1,1]
heq.PeakGains = [16,-2,2]

visualize(heq)
% 変更したら処理を実行して下さい。

%% オブジェクトのリリース
release(hfr);
release(hap);
