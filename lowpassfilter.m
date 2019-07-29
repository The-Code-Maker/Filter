function [time,dataf] = lowpassfilter(time,data,options)
%

%%
%���봦��
if nargin == 2
    options.wpn = 5;
    options.wsn = 10;
    options.rp = 2;
    options.rs = 40;
elseif nargin == 3
    allfields = {'wpn';'wsn';'rp';'rs'};
        fieldsvalue = {5;10;2;40};
        fields = fieldnames(options);
        for k = 1:length(allfields)
            flag = 1;
            for l = 1:length(fields)
                if strcmp(allfields{k},fields{l})
                    flag = 0;
                end
            end
            if flag
                options.(allfields{k}) = fieldsvalue{k};
            end
        end
else
    disp('! �����������, �����˳�...')
end

%%
dtime = diff(time);             %��ʱ��ȡ΢��
dt = sum(dtime)/length(dtime);  %ƽ��ʱ�䲽��
fs = round(1/dt);               %����Ƶ��
wp = options.wpn/(fs/2);                  %ͨ����ֹƵ��, �ɵ���
ws = options.wsn/(fs/2);                 %�����ֹƵ��, �ɵ���
rp = options.rp;                         %ͨ���ڵ�˥��������rp, �ɵ���
rs = options.rs;                        %����ڵ�˥��������rs, �ɵ���
[n,wn] = buttord(wp,ws,rp,rs);  %������˹�����˲�����С����ѡ����
[b,a] = butter(n,wn);           %������˹�����˲���
%[h,w] = freqz(b,a,512,fs);      %�����˲�����Ƶ����Ӧ
% plot(w,abs(h));                 %�����˲����ķ�Ƶ��Ӧͼ

%��������źŽ����˲�
dataf = filtfilt(b,a,data);
% figure; hold on; grid on;
% plot(time,data,'LineWidth',1.2)
% plot(time,dataf,'LineWidth',1.2);
% legend('�˲�ǰ','�˲���')

end