clc;clear;close all;
format = {'*.txt','TXT(*.txt)';'*.*','All Files(*.*)'};
[fileName, filePath] = uigetfile(format,'�����ⲿ����','*.txt','MultiSelect','on');
if ~isequal([fileName, filePath],[0, 0]);
    fileFullName = strcat(filePath, fileName);
else 
    return;
end
if iscell(fileFullName)
    N = length(fileFullName);  %�ļ�����
else
    N = 1;
    fileFullName = {fileFullName}; 
end
%--------- initialize ----------%
amac = '00-02-2A-00-2C-D2';
bmac = '00-02-2A-03-C2-28';
cmac = '00-02-2A-03-C2-58';
a_Area_ap_a_rawdata = cell(1,1);
a_Area_ap_b_rawdata = cell(1,1);
a_Area_ap_c_rawdata = cell(1,1);
%matFullName = fullfile(filePath, 'radiomapdata.mat'); 
%fidtemp = fopen(matFullName,'w'); %���������ļ�

for i = 1:N
    [pathstr, name, ext] = fileparts(fileFullName{i});
    y = str2double(cell2mat(regexp(name, '(?<=[a-z])\d', 'match')));
    x = str2double(cell2mat(regexp(name, '(?<=[a-z][0-9])\d{1,2}', 'match')));
    %tempmatFullName = fullfile(pathstr, strcat(name, '.mat'));
    fidin = fopen(fileFullName{i}, 'r'); %��ȡԭʼ�����ļ�
    a = 0; b = 0; c = 0; invalid = 0; arss = []; brss = []; crss = [];
    while ~feof(fidin) % �ж��Ƿ�Ϊ�ļ�ĩβ
        tline = fgetl(fidin); % ���ļ�����һ���ı��������س�����
        if ~isempty(tline) % �ж��Ƿ����
            mac = cell2mat(regexp(tline, '00-02-2A-00-2C-D2|00-02-2A-03-C2-28|00-02-2A-03-C2-58', 'match'));
            if ~isempty(mac)
                rss = str2double(cell2mat(regexp(tline, ',-[0-9][0-9],', 'match')));
                switch mac
                    case amac
                        a = a + 1;
                        arss = [arss rss];
                    case bmac
                        b = b + 1;
                        brss = [brss rss];
                    case cmac
                        c = c + 1;
                        crss = [crss rss];
                    otherwise
                        invalid = invalid + 1;
                end
            end
        end
    end
    a_Area_ap_a_rawdata{y + 1, x + 1} = arss; 
    a_Area_ap_b_rawdata{y + 1, x + 1} = brss; 
    a_Area_ap_c_rawdata{y + 1, x + 1} = crss; 
end
save(cell2mat(strcat(regexp(name, '[a-z]', 'match'), '_Area_ap_a_rawdata.mat')), 'a_Area_ap_a_rawdata');
save(cell2mat(strcat(regexp(name, '[a-z]', 'match'), '_Area_ap_b_rawdata.mat')), 'a_Area_ap_b_rawdata');
save(cell2mat(strcat(regexp(name, '[a-z]', 'match'), '_Area_ap_c_rawdata.mat')), 'a_Area_ap_c_rawdata');