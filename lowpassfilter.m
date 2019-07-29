function [time,dataf] = lowpassfilter(time,data,options)
%

%%
%输入处理
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
    disp('! 输入参数错误, 程序退出...')
end

%%
dtime = diff(time);             %对时间取微分
dt = sum(dtime)/length(dtime);  %平均时间步长
fs = round(1/dt);               %采样频率
wp = options.wpn/(fs/2);                  %通带截止频率, 可调整
ws = options.wsn/(fs/2);                 %阻带截止频率, 可调整
rp = options.rp;                         %通带内的衰减不超过rp, 可调整
rs = options.rs;                        %阻带内的衰减不超过rs, 可调整
[n,wn] = buttord(wp,ws,rp,rs);  %巴特沃斯数字滤波器最小阶数选择函数
[b,a] = butter(n,wn);           %巴特沃斯数字滤波器
%[h,w] = freqz(b,a,512,fs);      %计算滤波器的频率响应
% plot(w,abs(h));                 %绘制滤波器的幅频响应图

%对输入的信号进行滤波
dataf = filtfilt(b,a,data);
% figure; hold on; grid on;
% plot(time,data,'LineWidth',1.2)
% plot(time,dataf,'LineWidth',1.2);
% legend('滤波前','滤波后')

end