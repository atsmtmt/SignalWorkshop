% MATLAB��{�@�\�ł̃I�[�f�B�II/O
% �T���v���t�@�C���̃p�X�i�p�X�̒�`�͕s�v�j
% cd(fullfile([matlabroot '\toolbox\audio\samples']))
% C:\MATLAB\R2016a\toolbox\audio\samples
% MATLAB�W���@�\�ł�2ch Stereo�܂ōĐ��\�A�h���C�o�͑I��s��
[data, Fs] = audioread('RockDrums-44p1-stereo-11secs.mp3');
hap = audioplayer(data, Fs)      % �I�u�W�F�N�g�̒�`
play(hap)                        % ���s
% ���\�b�h��methods(hap)�Ŏ擾�ł���

%% audioplayer�̒�~
stop(hap)
% stio(hap)
%% �^��
Nbit = 16;
Nch = 2;
har = audiorecorder(Fs, Nbit, Nch)
record(har)

%% audiorecorder�̒�~�ƃf�[�^�̎擾
stop(har)

%% ���]�̎��Ԃ̘^��
recordblocking(har, 2)
rdata = getaudiodata(har);
t = (0:length(rdata)-1)/Fs;
plot(t, rdata)
shg
audiowrite('recordedData.wav', rdata, Fs)

%% Audio System Toolbox�@�\�ɂ��^��
Fs = 44100;
Nch = 2;
rTime = 5;

%% �Đ��ƃX�g���[�~���O�ŉ���
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
%% �f�o�C�X�̃����[�X
release(hfR)
release(haOut)
release(htS)

%% �^���Ɖ���
% �I�[�f�B�I�f�o�C�X�I�u�W�F�N�g�̒�`
haIn = audioDeviceReader('SampleRate', Fs, 'NumChannels', Nch);
% haIn = audioDeviceReader('SampleRate', 44100, 'NumChannels', 2, 'Driver', 'ASIO')
hfW = dsp.AudioFileWriter('recordedData2.wav');
htS = dsp.TimeScope('SampleRate', Fs, 'TimeSpan', 0.1, 'BufferLength', 50e4,...
    'YLimits', [-0.5 0.5], 'ShowGrid', 1)
hlog = dsp.SignalSink;
%% �^���ƕ\��
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

%% �f�o�C�X�̃����[�X
release(haIn)
release(hfW)
release(htS)


