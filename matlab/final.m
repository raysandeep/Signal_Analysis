clc
clear all
%cd database

datafiles = dir('database')
filename='hi.wav';
[aud,fs] = audioread(filename);
recObj=audiorecorder(fs,8,2);
%record user's voice for 5 secs
disp('start speaking');
pause(1);
recordblocking(recObj,5);
disp('end of recording');
play(recObj);
y=getaudiodata(recObj);
y = y(:,1);
figure(30)
plot(y)
title('input voice signal');
audiowrite(filename,y,8000);

for i = 3:26
    %database files
    temp_file=datafiles(i).name
    %create a recorder object
    figure(i-1)
    cd database
    [aud0,fs0] = audioread(temp_file);
    recObj0=audiorecorder(fs0,8,2)
    y0=getaudiodata(recObj);
    y0 = y0(:,1);
    subplot(331)
    plot(y0)
    %use a butterworth filter of order 7 to reduce the noise of the input
    %voice.
    %reeading the audio file
    cd ..
    [f2,fs2]=audioread('hi.wav');
    %determine total number of samples in audiofile 
    N2=size(f2,1);
    %buiding a butterworth bandpass filter for removing noise components
    n2=7;
    beginFreq2=2000/(fs2/2);
    endFreq2=3000/(fs2/2);
    [b2,a2]=butter(n2,[beginFreq2,endFreq2],'bandpass');
    fout2=filter(b2,a2,f2);
    subplot(332)
    plot(fout2)
    title('noise rejected input signal');

    %use a butterworth filter of order 7 to reduce the noise of the template
    %voice
    %reading the audio file 
    cd database
    [f1,fs1]=audioread(temp_file);
    cd ..
    %determine total number of samples in audio file
    N1=size(f1,1);
    %building a butterworth andpass filter for removing noise components 
    n1=7;
    beginFreq1=2000/(fs1/2);
    endFreq1=2500/(fs1/2);
    [b1,a1]=butter(n1,[beginFreq1,endFreq1],'bandpass');
    fout1=filter(b1,a1,f1);
    subplot(333)
    plot(fout1)
    title('noise rejected template signal');

    %determining the leg and allinging the signals 
    del=finddelay(fout1,fout2);
    if (del>0)
        fout1=alignsignals(fout1,fout2(:,1));
        subplot(334)
    else
        fout2=alignsignals(fout2(:,1),fout1);
        subplot(335)
        plot(fout1);
    end


    %determine the FFT of the template signal
    x=fft(fout1,N1);
    axis_x1=(fs1/N1).*(0:N1-1);
    x=abs(x(1:N1)./(N1/2));
    %determine the FFT of the input signal
    y=fft(fout2);
    axis_x2=(fs2/N2).*(0:N2-1);
    y=abs(y(1:N2)./(N2/2));
    %ploltting the FFT of the signals
    subplot(336)
    plot(axis_x1,x)
    title('FFT of the template signals')
    subplot(337)
    plot(axis_x2,y)
    title('FFT of the input')

    %Correlation of the signals
    y=y';
    y=y(1,:);
    y=y';
    x=x';
    x=x(1,:);
    x=x';
    %cross correlation
    z=xcorr(x,y);
    m=max(z);
    l=length(z);
    t=-((l-1)/2):1:((l-1)/2);
    t=t';

    %auto correlation

    p = xcorr(x);
    m1=max(p);
    l1=length(p);
    t1=-((l1-1)/2):1:((l1-1)/2);
    t1=t1';
    %plotting the Correlation of the signals
    
    subplot(338)
    plot(t,z);
    title('Cross Correlaton of signals')
    subplot(339)
    plot(t1,p);
    title('Auto Correlation of Template ')
end

