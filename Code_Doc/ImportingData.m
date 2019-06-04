%% Import data from spreadsheet
% David Li 

%% Setup the Import Options
opts = spreadsheetImportOptions("NumVariables", 6);

% Specify sheet and range
opts.Sheet = "Sheet1";
opts.DataRange = "A2:F398";

% Specify column names and types
opts.VariableNames = ["Propofol", "Remifentanil", "Algometry", "Tetany", "Sedation", "Laryingoscopy"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double"];

% Import the data
tbl = readtable("B:\ResponseData.xls", opts, "UseExcel", false);

%% Convert to output type
Propofol = tbl.Propofol;
Remifentanil = tbl.Remifentanil;
Algometry = tbl.Algometry;
Tetany = tbl.Tetany;
Sedation = tbl.Sedation;
Laryingoscopy = tbl.Laryingoscopy;

%% Clear temporary variables
clear opts tbl
