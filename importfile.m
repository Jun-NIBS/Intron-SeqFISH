function barcodekey = importfile(filename,hyb, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   TF1KBARCODES = IMPORTFILE(FILENAME) Reads data from text file FILENAME
%   for the default selection.
%
%   TF1KBARCODES = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from
%   rows STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   TF1kbarcodes = importfile('TF_1k_barcodes.csv', 2, 1001);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2017/01/28 15:30:26

%% Initialize variables.
if isempty(filename) 
    [filename,PathName,FilterIndex] = uigetfile;
    filename = [PathName '\' filename];
end

delimiter = ',';
if nargin<=3
    startRow = 2;
    endRow = inf;
end

%% Format string for each line of text:
%   column1: text (%s)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
% For more information, see the TEXTSCAN documentation.
strs = '%s';
for i = 1:hyb;
    strs = [strs '%f'];
end

formatSpec = [strs '%[^\n\r]'];

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
dataArray(2:hyb+1) = cellfun(@(x) num2cell(x), dataArray(2:hyb+1), 'UniformOutput', false);
TF1kbarcodes = [dataArray{1:end-1}];
barcodekey.names = TF1kbarcodes(:,1);
barcodekey.barcode = cell2mat(TF1kbarcodes(:,2:end));

